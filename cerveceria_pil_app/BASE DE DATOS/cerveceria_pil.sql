-- ============================================================
-- SISTEMA DE INVENTARIO - CERVECERIA PIL ANDINA
-- Adaptado para XAMPP (MySQL / MariaDB)
-- Compatible con phpMyAdmin y línea de comandos XAMPP
-- Normalización 3FN | Incluye datos de prueba (10+ por tabla)
-- ============================================================

-- INSTRUCCIONES DE INSTALACIÓN EN XAMPP:
-- 1. Abrir XAMPP Control Panel → Iniciar Apache y MySQL
-- 2. Ir a http://localhost/phpmyadmin
-- 3. Click en "Importar" → seleccionar este archivo
-- 4. Click en "Continuar"
-- O desde línea de comandos:
-- C:\xampp\mysql\bin\mysql.exe -u root < cerveceria_pil_xampp.sql

SET NAMES utf8mb4;
SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL';

DROP DATABASE IF EXISTS cerveceria_pil;
CREATE DATABASE cerveceria_pil
  DEFAULT CHARACTER SET utf8mb4
  DEFAULT COLLATE utf8mb4_spanish_ci;

USE cerveceria_pil;

-- ============================================================
-- TABLAS PRINCIPALES
-- ============================================================

-- 1. Plantas productivas
CREATE TABLE planta (
    id          INT          PRIMARY KEY AUTO_INCREMENT,
    nombre      VARCHAR(50)  NOT NULL,
    ciudad      VARCHAR(30)  NOT NULL,
    ubicacion_detalle VARCHAR(100)
) ENGINE=InnoDB;

-- 2. Productos
CREATE TABLE producto (
    id                    INT           PRIMARY KEY AUTO_INCREMENT,
    codigo_unico          VARCHAR(20)   UNIQUE NOT NULL,
    nombre_comercial      VARCHAR(50)   NOT NULL,
    tipo                  VARCHAR(20)   CHECK (tipo IN ('Lager','Pilsener','Malta','Negra','Especial')),
    presentacion          VARCHAR(20)   NOT NULL,
    graduacion_alcoholica DECIMAL(3,1)  NOT NULL,
    precio_actual         DECIMAL(10,2) NOT NULL,
    stock_minimo          INT           NOT NULL DEFAULT 100,
    stock_maximo          INT           NOT NULL DEFAULT 10000,
    activo                TINYINT(1)    DEFAULT 1
) ENGINE=InnoDB;

-- 3. Bodegas (depende de planta)
CREATE TABLE bodega (
    id                       INT           PRIMARY KEY AUTO_INCREMENT,
    planta_id                INT           NOT NULL,
    nombre_bodega            VARCHAR(50)   NOT NULL,
    tipo_bodega              ENUM('Producto Terminado','Insumos','Refrigerado') NOT NULL,
    capacidad_maxima         INT           NOT NULL,
    temperatura_almacenamiento DECIMAL(5,2),
    CONSTRAINT fk_bodega_planta FOREIGN KEY (planta_id) REFERENCES planta(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- 4. Distribuidores
CREATE TABLE distribuidor (
    id           INT          PRIMARY KEY AUTO_INCREMENT,
    nit          VARCHAR(20)  UNIQUE NOT NULL,
    razon_social VARCHAR(100) NOT NULL,
    direccion    TEXT,
    ciudad       VARCHAR(30),
    zona         VARCHAR(50),
    contacto     VARCHAR(80),
    telefono     VARCHAR(20),
    correo       VARCHAR(80),
    activo       TINYINT(1)   DEFAULT 1
) ENGINE=InnoDB;

-- 5. Lotes de producción
CREATE TABLE lote_produccion (
    id                 INT           PRIMARY KEY AUTO_INCREMENT,
    numero_lote        VARCHAR(30)   UNIQUE NOT NULL,
    producto_id        INT           NOT NULL,
    fecha_produccion   DATE          NOT NULL,
    fecha_vencimiento  DATE          NOT NULL,
    cantidad_producida INT           NOT NULL,
    planta_origen_id   INT           NOT NULL,
    control_calidad    ENUM('Aprobado','Rechazado') NOT NULL,
    tecnico_responsable VARCHAR(100),
    observaciones      TEXT,
    CONSTRAINT fk_lote_producto FOREIGN KEY (producto_id)      REFERENCES producto(id),
    CONSTRAINT fk_lote_planta   FOREIGN KEY (planta_origen_id) REFERENCES planta(id)
) ENGINE=InnoDB;

-- 6. Inventario por lote y bodega
CREATE TABLE inventario (
    id                 INT       PRIMARY KEY AUTO_INCREMENT,
    lote_id            INT       NOT NULL,
    bodega_id          INT       NOT NULL,
    cantidad_actual    INT       NOT NULL DEFAULT 0,
    ultima_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_inv_lote   FOREIGN KEY (lote_id)   REFERENCES lote_produccion(id),
    CONSTRAINT fk_inv_bodega FOREIGN KEY (bodega_id) REFERENCES bodega(id),
    CONSTRAINT uq_lote_bodega UNIQUE (lote_id, bodega_id)
) ENGINE=InnoDB;

-- 7. Pedidos
CREATE TABLE pedido (
    id                       INT           PRIMARY KEY AUTO_INCREMENT,
    distribuidor_id          INT           NOT NULL,
    fecha_pedido             DATE          NOT NULL,
    fecha_entrega_requerida  DATE          NOT NULL,
    estado                   ENUM('Pendiente','Despachado','Entregado','Cancelado') DEFAULT 'Pendiente',
    monto_total              DECIMAL(12,2),
    CONSTRAINT fk_pedido_dist FOREIGN KEY (distribuidor_id) REFERENCES distribuidor(id)
) ENGINE=InnoDB;

-- 8. Detalle de pedido
CREATE TABLE pedido_detalle (
    id             INT           PRIMARY KEY AUTO_INCREMENT,
    pedido_id      INT           NOT NULL,
    producto_id    INT           NOT NULL,
    cantidad       INT           NOT NULL,
    precio_unitario DECIMAL(10,2) NOT NULL,
    CONSTRAINT fk_det_pedido   FOREIGN KEY (pedido_id)   REFERENCES pedido(id),
    CONSTRAINT fk_det_producto FOREIGN KEY (producto_id) REFERENCES producto(id)
) ENGINE=InnoDB;

-- 9. Movimientos de inventario (trazabilidad)
CREATE TABLE movimiento_inventario (
    id                 INT       PRIMARY KEY AUTO_INCREMENT,
    lote_id            INT       NOT NULL,
    bodega_origen_id   INT       NULL,
    bodega_destino_id  INT       NULL,
    tipo_movimiento    ENUM('entrada_produccion','salida_venta','traslado') NOT NULL,
    cantidad           INT       NOT NULL,
    fecha_movimiento   TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    usuario_registra   VARCHAR(50),
    pedido_id          INT       NULL,
    CONSTRAINT fk_mov_lote    FOREIGN KEY (lote_id)           REFERENCES lote_produccion(id),
    CONSTRAINT fk_mov_origen  FOREIGN KEY (bodega_origen_id)  REFERENCES bodega(id),
    CONSTRAINT fk_mov_destino FOREIGN KEY (bodega_destino_id) REFERENCES bodega(id),
    CONSTRAINT fk_mov_pedido  FOREIGN KEY (pedido_id)         REFERENCES pedido(id)
) ENGINE=InnoDB;

-- 10. Factura
CREATE TABLE factura (
    id               INT           PRIMARY KEY AUTO_INCREMENT,
    pedido_id        INT           NOT NULL,
    numero_factura   VARCHAR(30)   UNIQUE NOT NULL,
    fecha_emision    DATE          NOT NULL,
    monto_total      DECIMAL(12,2) NOT NULL,
    estado_pago      ENUM('Pagado','Pendiente','Vencido') DEFAULT 'Pendiente',
    CONSTRAINT fk_factura_pedido FOREIGN KEY (pedido_id) REFERENCES pedido(id)
) ENGINE=InnoDB;

-- 11. Auditoría (para triggers)
CREATE TABLE auditoria_log (
    id              INT         PRIMARY KEY AUTO_INCREMENT,
    tabla_afectada  VARCHAR(50),
    accion          VARCHAR(30),
    registro_id     INT,
    usuario         VARCHAR(50),
    fecha           TIMESTAMP   DEFAULT CURRENT_TIMESTAMP,
    datos_previos   TEXT,
    datos_nuevos    TEXT
) ENGINE=InnoDB;

-- ============================================================
-- ÍNDICES ESTRATÉGICOS
-- Justificación:
--  1. idx_lote_vencimiento     → Vista de productos próximos a vencer filtra por fecha_vencimiento
--  2. idx_pedido_estado_dist   → Gerentes consultan pedidos pendientes por distribuidor frecuentemente
--  3. idx_movimiento_lote_fecha→ Rotación de inventario agrupa movimientos por lote y mes
--  4. idx_inventario_lote      → Acelera JOINs en consultas de stock actual
--  5. idx_producto_tipo        → Filtros por tipo de producto en reportes
-- ============================================================
CREATE INDEX idx_lote_vencimiento      ON lote_produccion(fecha_vencimiento);
CREATE INDEX idx_pedido_estado_dist    ON pedido(estado, distribuidor_id);
CREATE INDEX idx_movimiento_lote_fecha ON movimiento_inventario(lote_id, fecha_movimiento);
CREATE INDEX idx_inventario_lote       ON inventario(lote_id);
CREATE INDEX idx_producto_tipo         ON producto(tipo, activo);

-- ============================================================
-- VISTAS
-- ============================================================

-- Vista 1: Stock actual por producto y planta
CREATE VIEW vista_stock_por_planta AS
SELECT
    p.codigo_unico,
    p.nombre_comercial,
    p.presentacion,
    p.tipo,
    pl.nombre          AS planta,
    pl.ciudad,
    b.nombre_bodega,
    SUM(i.cantidad_actual) AS stock_total
FROM inventario i
JOIN lote_produccion l  ON i.lote_id   = l.id
JOIN producto p         ON l.producto_id = p.id
JOIN bodega b           ON i.bodega_id  = b.id
JOIN planta pl          ON b.planta_id  = pl.id
WHERE l.control_calidad = 'Aprobado'
GROUP BY p.id, pl.id, b.id;

-- Vista 2: Productos próximos a vencer (30 días)
CREATE VIEW vista_proximos_vencer AS
SELECT
    l.numero_lote,
    p.nombre_comercial,
    p.presentacion,
    l.fecha_produccion,
    l.fecha_vencimiento,
    DATEDIFF(l.fecha_vencimiento, CURDATE()) AS dias_restantes,
    i.cantidad_actual,
    b.nombre_bodega,
    pl.nombre AS planta
FROM lote_produccion l
JOIN producto p  ON l.producto_id = p.id
JOIN inventario i ON l.id = i.lote_id
JOIN bodega b    ON i.bodega_id = b.id
JOIN planta pl   ON b.planta_id = pl.id
WHERE l.fecha_vencimiento BETWEEN CURDATE() AND DATE_ADD(CURDATE(), INTERVAL 30 DAY)
  AND l.control_calidad = 'Aprobado'
  AND i.cantidad_actual > 0;

-- Vista 3: Rotación mensual de inventario
CREATE VIEW vista_rotacion_mensual AS
SELECT
    p.nombre_comercial,
    p.presentacion,
    p.tipo,
    SUM(CASE
        WHEN MONTH(m.fecha_movimiento) = MONTH(CURDATE())
          AND YEAR(m.fecha_movimiento) = YEAR(CURDATE())
          AND m.tipo_movimiento = 'salida_venta'
        THEN m.cantidad ELSE 0 END) AS salidas_mes_actual,
    SUM(CASE
        WHEN MONTH(m.fecha_movimiento) = MONTH(DATE_SUB(CURDATE(), INTERVAL 1 MONTH))
          AND YEAR(m.fecha_movimiento) = YEAR(DATE_SUB(CURDATE(), INTERVAL 1 MONTH))
          AND m.tipo_movimiento = 'salida_venta'
        THEN m.cantidad ELSE 0 END) AS salidas_mes_anterior,
    SUM(CASE WHEN m.tipo_movimiento = 'entrada_produccion' THEN m.cantidad ELSE 0 END) AS entradas_total
FROM movimiento_inventario m
JOIN lote_produccion l ON m.lote_id = l.id
JOIN producto p        ON l.producto_id = p.id
GROUP BY p.id;

-- Vista 4 (extra): Resumen de facturas por distribuidor
CREATE VIEW vista_facturacion_distribuidor AS
SELECT
    d.razon_social,
    d.ciudad,
    COUNT(f.id)       AS total_facturas,
    SUM(f.monto_total) AS facturacion_total,
    SUM(CASE WHEN f.estado_pago = 'Pendiente' THEN f.monto_total ELSE 0 END) AS monto_pendiente,
    SUM(CASE WHEN f.estado_pago = 'Vencido'   THEN f.monto_total ELSE 0 END) AS monto_vencido
FROM factura f
JOIN pedido p      ON f.pedido_id = p.id
JOIN distribuidor d ON p.distribuidor_id = d.id
GROUP BY d.id;

-- ============================================================
-- PROCEDIMIENTOS ALMACENADOS
-- ============================================================

DELIMITER //

-- Procedimiento 1: Registrar producción completa
CREATE PROCEDURE sp_registrar_produccion(
    IN p_numero_lote     VARCHAR(30),
    IN p_producto_id     INT,
    IN p_fecha_prod      DATE,
    IN p_fecha_venc      DATE,
    IN p_cantidad        INT,
    IN p_planta_id       INT,
    IN p_calidad         VARCHAR(20),
    IN p_tecnico         VARCHAR(100),
    IN p_bodega_id       INT,
    IN p_usuario         VARCHAR(50)
)
BEGIN
    DECLARE v_lote_id INT;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    INSERT INTO lote_produccion
        (numero_lote, producto_id, fecha_produccion, fecha_vencimiento,
         cantidad_producida, planta_origen_id, control_calidad, tecnico_responsable)
    VALUES
        (p_numero_lote, p_producto_id, p_fecha_prod, p_fecha_venc,
         p_cantidad, p_planta_id, p_calidad, p_tecnico);

    SET v_lote_id = LAST_INSERT_ID();

    INSERT INTO inventario (lote_id, bodega_id, cantidad_actual)
    VALUES (v_lote_id, p_bodega_id, p_cantidad)
    ON DUPLICATE KEY UPDATE cantidad_actual = cantidad_actual + p_cantidad;

    INSERT INTO movimiento_inventario
        (lote_id, bodega_destino_id, tipo_movimiento, cantidad, usuario_registra)
    VALUES
        (v_lote_id, p_bodega_id, 'entrada_produccion', p_cantidad, p_usuario);

    COMMIT;
END//

-- Procedimiento 2: Pedidos pendientes por distribuidor
CREATE PROCEDURE sp_pedidos_pendientes()
BEGIN
    SELECT
        d.razon_social,
        d.ciudad,
        d.zona,
        COUNT(p.id)        AS total_pendientes,
        SUM(p.monto_total) AS monto_pendiente
    FROM pedido p
    JOIN distribuidor d ON p.distribuidor_id = d.id
    WHERE p.estado IN ('Pendiente','Despachado')
    GROUP BY d.id
    ORDER BY monto_pendiente DESC;
END//

-- Procedimiento 3: Registrar venta / salida de inventario
CREATE PROCEDURE sp_registrar_salida(
    IN p_lote_id      INT,
    IN p_bodega_id    INT,
    IN p_cantidad     INT,
    IN p_pedido_id    INT,
    IN p_usuario      VARCHAR(50)
)
BEGIN
    DECLARE v_stock INT;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    SELECT cantidad_actual INTO v_stock
    FROM inventario
    WHERE lote_id = p_lote_id AND bodega_id = p_bodega_id
    FOR UPDATE;

    IF v_stock IS NULL OR v_stock < p_cantidad THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Stock insuficiente para realizar la salida';
    END IF;

    UPDATE inventario
    SET cantidad_actual = cantidad_actual - p_cantidad
    WHERE lote_id = p_lote_id AND bodega_id = p_bodega_id;

    INSERT INTO movimiento_inventario
        (lote_id, bodega_origen_id, tipo_movimiento, cantidad, usuario_registra, pedido_id)
    VALUES
        (p_lote_id, p_bodega_id, 'salida_venta', p_cantidad, p_usuario, p_pedido_id);

    COMMIT;
END//

DELIMITER ;

-- ============================================================
-- TRIGGERS
-- ============================================================

DELIMITER //

-- Trigger 1: Auditoría al actualizar inventario
CREATE TRIGGER tr_auditoria_inventario_update
AFTER UPDATE ON inventario
FOR EACH ROW
BEGIN
    INSERT INTO auditoria_log
        (tabla_afectada, accion, registro_id, usuario, datos_previos, datos_nuevos)
    VALUES
        ('inventario', 'UPDATE', OLD.id, CURRENT_USER(),
         CONCAT('lote_id=', OLD.lote_id, ', bodega_id=', OLD.bodega_id, ', cantidad=', OLD.cantidad_actual),
         CONCAT('lote_id=', NEW.lote_id, ', bodega_id=', NEW.bodega_id, ', cantidad=', NEW.cantidad_actual));
END//

-- Trigger 2: Control de stock mínimo al actualizar inventario
CREATE TRIGGER tr_control_stock_minimo
AFTER UPDATE ON inventario
FOR EACH ROW
BEGIN
    DECLARE v_stock_min  INT;
    DECLARE v_prod_nombre VARCHAR(50);

    SELECT p.stock_minimo, p.nombre_comercial
    INTO   v_stock_min, v_prod_nombre
    FROM producto p
    JOIN lote_produccion l ON p.id = l.producto_id
    WHERE l.id = NEW.lote_id
    LIMIT 1;

    IF NEW.cantidad_actual < v_stock_min THEN
        INSERT INTO auditoria_log
            (tabla_afectada, accion, registro_id, usuario, datos_nuevos)
        VALUES
            ('inventario', 'ALERTA_STOCK_BAJO', NEW.id, 'SYSTEM',
             CONCAT('Producto: ', v_prod_nombre,
                    ' | Stock actual: ', NEW.cantidad_actual,
                    ' | Stock mínimo: ', v_stock_min));
    END IF;
END//

-- Trigger 3: Auditoría al insertar pedido
CREATE TRIGGER tr_auditoria_pedido_insert
AFTER INSERT ON pedido
FOR EACH ROW
BEGIN
    INSERT INTO auditoria_log
        (tabla_afectada, accion, registro_id, usuario, datos_nuevos)
    VALUES
        ('pedido', 'INSERT', NEW.id, CURRENT_USER(),
         CONCAT('distribuidor_id=', NEW.distribuidor_id,
                ', estado=', NEW.estado,
                ', monto=', IFNULL(NEW.monto_total, 0)));
END//

DELIMITER ;

-- ============================================================
-- USUARIOS Y ROLES
-- (En XAMPP, ejecutar desde phpMyAdmin con usuario root)
-- ============================================================

-- Usuario Administrador: privilegios totales
CREATE USER IF NOT EXISTS 'admin_pil'@'localhost' IDENTIFIED BY 'Admin123!';
GRANT ALL PRIVILEGES ON cerveceria_pil.* TO 'admin_pil'@'localhost';

-- Usuario Gerente: solo lectura y ejecución de reportes
CREATE USER IF NOT EXISTS 'gerente_pil'@'localhost' IDENTIFIED BY 'Gerente123!';
GRANT SELECT ON cerveceria_pil.* TO 'gerente_pil'@'localhost';
GRANT EXECUTE ON PROCEDURE cerveceria_pil.sp_pedidos_pendientes       TO 'gerente_pil'@'localhost';
GRANT EXECUTE ON PROCEDURE cerveceria_pil.sp_registrar_produccion     TO 'gerente_pil'@'localhost';

-- Usuario Distribuidor: solo vistas de stock y sus propios pedidos
CREATE USER IF NOT EXISTS 'distribuidor_pil'@'localhost' IDENTIFIED BY 'Dist123!';
GRANT SELECT ON cerveceria_pil.vista_stock_por_planta   TO 'distribuidor_pil'@'localhost';
GRANT SELECT ON cerveceria_pil.vista_proximos_vencer    TO 'distribuidor_pil'@'localhost';
GRANT SELECT ON cerveceria_pil.vista_rotacion_mensual   TO 'distribuidor_pil'@'localhost';

FLUSH PRIVILEGES;

-- ============================================================
-- DATOS DE PRUEBA (mínimo 10 registros por tabla)
-- ============================================================

-- ── PLANTAS ──────────────────────────────────────────────────
INSERT INTO planta (nombre, ciudad, ubicacion_detalle) VALUES
('La Paz',         'La Paz',         'Mecapaca, zona industrial'),
('Cochabamba',     'Cochabamba',     'Sacaba, av. principal km 5'),
('Santa Cruz',     'Santa Cruz',     'Palmasola, parque industrial'),
('Oruro',          'Oruro',          'Zona norte, carretera a La Paz'),
('Sucre',          'Sucre',          'Parque industrial sur'),
('Potosí',         'Potosí',         'Av. Universitaria 2345'),
('Tarija',         'Tarija',         'Barrio Aeropuerto'),
('Trinidad',       'Trinidad',       'Zona franca este'),
('Cobija',         'Cobija',         'Puerto industrial'),
('El Alto',        'El Alto',        'Ciudad satélite, zona industrial');

-- ── PRODUCTOS ────────────────────────────────────────────────
INSERT INTO producto (codigo_unico, nombre_comercial, tipo, presentacion, graduacion_alcoholica, precio_actual, stock_minimo, stock_maximo) VALUES
('PAC355',  'Paceña',          'Lager',     '355ml',  4.5, 12.50,  500, 10000),
('PAC620',  'Paceña Grande',   'Lager',     '620ml',  4.5, 15.90,  400,  8000),
('PAC1L',   'Paceña Litro',    'Lager',     '1000ml', 4.5, 20.00,  300,  6000),
('TAQ355',  'Taquiña',         'Pilsener',  '355ml',  5.0, 12.00,  500,  9000),
('TAQ620',  'Taquiña Grande',  'Pilsener',  '620ml',  5.0, 15.90,  300,  8000),
('HUA1L',   'Huari Malta',     'Malta',     '1000ml', 0.0, 18.00,  200,  5000),
('HUA355',  'Huari',           'Lager',     '355ml',  4.7, 11.00,  400,  9000),
('DUK355',  'Ducal',           'Pilsener',  '355ml',  5.0, 13.50,  300,  7000),
('NEG620',  'Paceña Negra',    'Negra',     '620ml',  5.5, 18.50,  200,  5000),
('ESP355',  'Pil Especial',    'Especial',  '355ml',  4.2, 14.00,  150,  4000),
('TAQ1L',   'Taquiña Litro',   'Pilsener',  '1000ml', 5.0, 21.00,  200,  4000),
('HUL355',  'Huari Light',     'Lager',     '355ml',  3.5,  9.50,  200,  6000);

-- ── BODEGAS ──────────────────────────────────────────────────
INSERT INTO bodega (planta_id, nombre_bodega, tipo_bodega, capacidad_maxima, temperatura_almacenamiento) VALUES
(1, 'Bodega Central LP',       'Producto Terminado', 50000, 18.5),
(1, 'Bodega Insumos LP',       'Insumos',            20000, 20.0),
(1, 'Bodega Fría LP',          'Refrigerado',         5000,  4.0),
(2, 'Bodega Norte CBBA',       'Producto Terminado', 40000, 18.0),
(2, 'Bodega Insumos CBBA',     'Insumos',            15000, 20.0),
(3, 'Bodega Este SC',          'Producto Terminado', 60000, 19.0),
(3, 'Bodega Insumos SC',       'Insumos',            25000, 21.0),
(4, 'Bodega Oruro PT',         'Producto Terminado', 30000, 17.5),
(5, 'Bodega Sucre PT',         'Producto Terminado', 25000, 18.0),
(6, 'Bodega Potosí PT',        'Producto Terminado', 20000, 15.0),
(7, 'Bodega Tarija PT',        'Producto Terminado', 20000, 19.5),
(10,'Bodega El Alto PT',       'Producto Terminado', 35000, 16.0);

-- ── DISTRIBUIDORES ───────────────────────────────────────────
INSERT INTO distribuidor (nit, razon_social, direccion, ciudad, zona, contacto, telefono, correo, activo) VALUES
('1001001',  'Distribuciones Norte SRL',    'Av. Montes 1234',         'La Paz',     'Norte',    'Carlos Quispe',    '71112233', 'cnorte@gmail.com',    1),
('1002002',  'Bebidas del Sur SA',          'C. Murillo 456',          'La Paz',     'Sur',      'Ana Flores',       '71223344', 'bsur@mail.com',       1),
('1003003',  'Distribuidora Centro CBBA',   'Av. Heroínas 789',        'Cochabamba', 'Centro',   'Luis Mamani',      '72334455', 'dcentro@mail.com',    1),
('1004004',  'Comercializadora Este SC',    'Av. Cañoto 321',          'Santa Cruz', 'Este',     'Pedro Vaca',       '73445566', 'comeste@mail.com',    1),
('1005005',  'Distribuciones Altiplano',    'C. Sucre 654',            'Oruro',      'Centro',   'Rosa Condori',     '70556677', 'altiplano@mail.com',  1),
('1006006',  'Bebidas Chapaca',             'Av. La Madrid 987',       'Tarija',     'Sur',      'Jorge Torrez',     '71667788', 'chapaca@mail.com',    1),
('1007007',  'Distribuidora Camba SA',      'Av. Alemana 1122',        'Santa Cruz', 'Oeste',    'Mario Gutiérrez',  '73778899', 'camba@mail.com',      1),
('1008008',  'Norte Bebidas SRL',           'C. 6 de Agosto 333',      'La Paz',     'Norte',    'Elena Ramos',      '71889900', 'nbebidas@mail.com',   1),
('1009009',  'Comercio del Valle CBBA',     'C. Jordán 567',           'Cochabamba', 'Valle',    'Fernando López',   '72990011', 'cvalle@mail.com',     1),
('1010010',  'Distribuciones Potosí',       'Av. Villazón 890',        'Potosí',     'Centro',   'Sandra Mamani',    '70001122', 'dpotosi@mail.com',    0),
('1011011',  'Gran Sur Distribuciones',     'Av. Los Sauces 441',      'Sucre',      'Norte',    'César Arce',       '71112244', 'gsur@mail.com',       1),
('1012012',  'Boliviana de Bebidas',        'C. Bolivia 100',          'El Alto',    'Zona Sur',  'Claudia Pérez',   '71223355', 'bolibebs@mail.com',   1);

-- ── LOTES DE PRODUCCIÓN ──────────────────────────────────────
INSERT INTO lote_produccion (numero_lote, producto_id, fecha_produccion, fecha_vencimiento, cantidad_producida, planta_origen_id, control_calidad, tecnico_responsable, observaciones) VALUES
('LP-2025-001', 1,  '2025-01-10', '2025-07-10', 12000, 1, 'Aprobado', 'Ing. Marco Salinas',    NULL),
('LP-2025-002', 2,  '2025-01-15', '2025-07-15',  8000, 1, 'Aprobado', 'Ing. Marco Salinas',    NULL),
('LP-2025-003', 4,  '2025-01-20', '2025-07-20', 10000, 2, 'Aprobado', 'Ing. Silvia Torres',    NULL),
('LP-2025-004', 5,  '2025-01-25', '2025-07-25',  7500, 2, 'Aprobado', 'Ing. Silvia Torres',    NULL),
('LP-2025-005', 6,  '2025-02-01', '2025-08-01',  5000, 1, 'Aprobado', 'Ing. Marco Salinas',    'Lote Malta especial'),
('LP-2025-006', 7,  '2025-02-05', '2025-08-05',  9000, 3, 'Aprobado', 'Ing. Carlos Vidal',     NULL),
('LP-2025-007', 9,  '2025-02-10', '2025-08-10',  3000, 1, 'Aprobado', 'Ing. Marco Salinas',    'Cerveza negra temporada'),
('LP-2025-008', 3,  '2025-02-15', '2025-08-15',  6000, 2, 'Aprobado', 'Ing. Silvia Torres',    NULL),
('LP-2025-009', 8,  '2025-02-20', '2025-08-20',  7000, 3, 'Aprobado', 'Ing. Carlos Vidal',     NULL),
('LP-2025-010', 10, '2025-03-01', '2025-09-01',  4000, 1, 'Aprobado', 'Ing. Marco Salinas',    'Edición especial'),
('LP-2025-011', 11, '2025-03-05', '2025-09-05',  5500, 2, 'Rechazado','Ing. Silvia Torres',    'Rechazado por pH fuera de rango'),
('LP-2025-012', 12, '2025-03-10', '2025-09-10',  6500, 3, 'Aprobado', 'Ing. Carlos Vidal',     NULL),
('LP-2025-013', 1,  '2025-03-15', '2025-09-15', 11000, 1, 'Aprobado', 'Ing. Marco Salinas',    NULL),
('LP-2025-014', 4,  '2025-04-01', '2025-10-01',  9500, 2, 'Aprobado', 'Ing. Silvia Torres',    NULL),
('LP-2025-015', 2,  '2025-04-10', '2025-10-10',  7000, 1, 'Aprobado', 'Ing. Marco Salinas',    NULL);

-- ── INVENTARIO ───────────────────────────────────────────────
INSERT INTO inventario (lote_id, bodega_id, cantidad_actual) VALUES
(1,  1,  8500),
(2,  1,  6000),
(3,  4,  7200),
(4,  4,  5500),
(5,  1,  3800),
(6,  6,  7000),
(7,  1,  2200),
(8,  4,  4500),
(9,  6,  5800),
(10, 1,  3200),
(12, 6,  5600),
(13, 1,  9000),
(14, 4,  8500),
(15, 1,  5500),
(1,  12, 1500),
(3,  8,  2000);

-- ── PEDIDOS ──────────────────────────────────────────────────
INSERT INTO pedido (distribuidor_id, fecha_pedido, fecha_entrega_requerida, estado, monto_total) VALUES
(1,  '2025-04-01', '2025-04-05', 'Entregado',  18750.00),
(2,  '2025-04-03', '2025-04-08', 'Entregado',  23400.00),
(3,  '2025-04-05', '2025-04-10', 'Despachado', 15600.00),
(4,  '2025-04-07', '2025-04-12', 'Pendiente',  31200.00),
(5,  '2025-04-08', '2025-04-13', 'Pendiente',  12480.00),
(6,  '2025-04-09', '2025-04-14', 'Entregado',   9360.00),
(7,  '2025-04-10', '2025-04-15', 'Cancelado',  17160.00),
(8,  '2025-04-11', '2025-04-16', 'Pendiente',  24960.00),
(9,  '2025-04-12', '2025-04-17', 'Despachado', 19500.00),
(1,  '2025-04-13', '2025-04-18', 'Pendiente',  14040.00),
(2,  '2025-04-14', '2025-04-19', 'Pendiente',  28080.00),
(11, '2025-04-15', '2025-04-20', 'Entregado',  10920.00);

-- ── DETALLE PEDIDO ───────────────────────────────────────────
INSERT INTO pedido_detalle (pedido_id, producto_id, cantidad, precio_unitario) VALUES
(1,  1,  800, 12.50),
(1,  2,  600, 15.90),
(2,  4,  900, 12.00),
(2,  5,  500, 15.90),
(3,  7,  700, 11.00),
(3,  3,  400, 20.00),
(4,  1, 1200, 12.50),
(4,  4,  800, 12.00),
(4,  9,  200, 18.50),
(5,  6,  300, 18.00),
(5, 10,  250, 14.00),
(6,  8,  400, 13.50),
(6,  2,  200, 15.90),
(7,  1,  500, 12.50),
(7,  3,  450, 20.00),
(8,  4, 1000, 12.00),
(8,  5,  600, 15.90),
(9,  7,  800, 11.00),
(9,  6,  300, 18.00),
(10, 1,  600, 12.50),
(11, 4,  900, 12.00),
(11, 9,  300, 18.50),
(12, 8,  400, 13.50);

-- ── MOVIMIENTOS DE INVENTARIO ────────────────────────────────
INSERT INTO movimiento_inventario (lote_id, bodega_origen_id, bodega_destino_id, tipo_movimiento, cantidad, usuario_registra, pedido_id) VALUES
(1,  NULL, 1,    'entrada_produccion', 12000, 'admin',       NULL),
(2,  NULL, 1,    'entrada_produccion',  8000, 'admin',       NULL),
(3,  NULL, 4,    'entrada_produccion', 10000, 'admin',       NULL),
(4,  NULL, 4,    'entrada_produccion',  7500, 'admin',       NULL),
(5,  NULL, 1,    'entrada_produccion',  5000, 'admin',       NULL),
(6,  NULL, 6,    'entrada_produccion',  9000, 'admin',       NULL),
(7,  NULL, 1,    'entrada_produccion',  3000, 'admin',       NULL),
(1,  1,    NULL, 'salida_venta',        1500, 'op_ventas',   1),
(2,  1,    NULL, 'salida_venta',        1000, 'op_ventas',   1),
(3,  4,    NULL, 'salida_venta',        1300, 'op_ventas',   2),
(4,  4,    NULL, 'salida_venta',         800, 'op_ventas',   2),
(6,  6,    NULL, 'salida_venta',         900, 'op_ventas',   3),
(8,  4,    NULL, 'salida_venta',         800, 'op_ventas',   4),
(1,  1,    12,   'traslado',            1500, 'op_logistica',NULL),
(3,  4,    8,    'traslado',            2000, 'op_logistica',NULL);

-- ── FACTURAS ─────────────────────────────────────────────────
INSERT INTO factura (pedido_id, numero_factura, fecha_emision, monto_total, estado_pago) VALUES
(1,  'FAC-2025-0001', '2025-04-05', 18750.00, 'Pagado'),
(2,  'FAC-2025-0002', '2025-04-08', 23400.00, 'Pagado'),
(3,  'FAC-2025-0003', '2025-04-10', 15600.00, 'Pendiente'),
(4,  'FAC-2025-0004', '2025-04-12', 31200.00, 'Pendiente'),
(5,  'FAC-2025-0005', '2025-04-13', 12480.00, 'Pendiente'),
(6,  'FAC-2025-0006', '2025-04-14',  9360.00, 'Pagado'),
(8,  'FAC-2025-0007', '2025-04-16', 24960.00, 'Vencido'),
(9,  'FAC-2025-0008', '2025-04-17', 19500.00, 'Pendiente'),
(10, 'FAC-2025-0009', '2025-04-18', 14040.00, 'Pendiente'),
(11, 'FAC-2025-0010', '2025-04-19', 28080.00, 'Vencido'),
(12, 'FAC-2025-0011', '2025-04-20', 10920.00, 'Pagado');

-- ============================================================
-- RESTAURAR CONFIGURACIÓN
-- ============================================================
SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

-- ============================================================
-- VERIFICACIÓN RÁPIDA (ejecutar después de importar)
-- ============================================================
-- SELECT 'plantas'       AS tabla, COUNT(*) AS registros FROM planta
-- UNION ALL
-- SELECT 'productos',     COUNT(*) FROM producto
-- UNION ALL
-- SELECT 'bodegas',       COUNT(*) FROM bodega
-- UNION ALL
-- SELECT 'distribuidores',COUNT(*) FROM distribuidor
-- UNION ALL
-- SELECT 'lotes',         COUNT(*) FROM lote_produccion
-- UNION ALL
-- SELECT 'inventario',    COUNT(*) FROM inventario
-- UNION ALL
-- SELECT 'pedidos',       COUNT(*) FROM pedido
-- UNION ALL
-- SELECT 'detalles',      COUNT(*) FROM pedido_detalle
-- UNION ALL
-- SELECT 'movimientos',   COUNT(*) FROM movimiento_inventario
-- UNION ALL
-- SELECT 'facturas',      COUNT(*) FROM factura;
-- ============================================================
-- FIN DEL SCRIPT
-- ============================================================
