-- MariaDB dump 10.19  Distrib 10.4.32-MariaDB, for Win64 (AMD64)
--
-- Host: localhost    Database: cerveceria_pil
-- ------------------------------------------------------
-- Server version	10.4.32-MariaDB

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `auditoria_log`
--

DROP TABLE IF EXISTS `auditoria_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `auditoria_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `tabla_afectada` varchar(50) DEFAULT NULL,
  `accion` varchar(30) DEFAULT NULL,
  `registro_id` int(11) DEFAULT NULL,
  `usuario` varchar(50) DEFAULT NULL,
  `fecha` timestamp NOT NULL DEFAULT current_timestamp(),
  `datos_previos` text DEFAULT NULL,
  `datos_nuevos` text DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auditoria_log`
--

LOCK TABLES `auditoria_log` WRITE;
/*!40000 ALTER TABLE `auditoria_log` DISABLE KEYS */;
INSERT INTO `auditoria_log` VALUES (1,'pedido','INSERT',1,'root@localhost','2026-06-05 20:40:35',NULL,'distribuidor_id=1, estado=Entregado, monto=18750.00'),(2,'pedido','INSERT',2,'root@localhost','2026-06-05 20:40:35',NULL,'distribuidor_id=2, estado=Entregado, monto=23400.00'),(3,'pedido','INSERT',3,'root@localhost','2026-06-05 20:40:35',NULL,'distribuidor_id=3, estado=Despachado, monto=15600.00'),(4,'pedido','INSERT',4,'root@localhost','2026-06-05 20:40:35',NULL,'distribuidor_id=4, estado=Pendiente, monto=31200.00'),(5,'pedido','INSERT',5,'root@localhost','2026-06-05 20:40:35',NULL,'distribuidor_id=5, estado=Pendiente, monto=12480.00'),(6,'pedido','INSERT',6,'root@localhost','2026-06-05 20:40:35',NULL,'distribuidor_id=6, estado=Entregado, monto=9360.00'),(7,'pedido','INSERT',7,'root@localhost','2026-06-05 20:40:35',NULL,'distribuidor_id=7, estado=Cancelado, monto=17160.00'),(8,'pedido','INSERT',8,'root@localhost','2026-06-05 20:40:35',NULL,'distribuidor_id=8, estado=Pendiente, monto=24960.00'),(9,'pedido','INSERT',9,'root@localhost','2026-06-05 20:40:35',NULL,'distribuidor_id=9, estado=Despachado, monto=19500.00'),(10,'pedido','INSERT',10,'root@localhost','2026-06-05 20:40:35',NULL,'distribuidor_id=1, estado=Pendiente, monto=14040.00'),(11,'pedido','INSERT',11,'root@localhost','2026-06-05 20:40:35',NULL,'distribuidor_id=2, estado=Pendiente, monto=28080.00'),(12,'pedido','INSERT',12,'root@localhost','2026-06-05 20:40:35',NULL,'distribuidor_id=11, estado=Entregado, monto=10920.00'),(13,'login','LOGIN',NULL,'admin_pil','2026-06-05 21:09:21',NULL,'Usuario admin_pil inició sesión');
/*!40000 ALTER TABLE `auditoria_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bodega`
--

DROP TABLE IF EXISTS `bodega`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `bodega` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `planta_id` int(11) NOT NULL,
  `nombre_bodega` varchar(50) NOT NULL,
  `tipo_bodega` enum('Producto Terminado','Insumos','Refrigerado') NOT NULL,
  `capacidad_maxima` int(11) NOT NULL,
  `temperatura_almacenamiento` decimal(5,2) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_bodega_planta` (`planta_id`),
  CONSTRAINT `fk_bodega_planta` FOREIGN KEY (`planta_id`) REFERENCES `planta` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bodega`
--

LOCK TABLES `bodega` WRITE;
/*!40000 ALTER TABLE `bodega` DISABLE KEYS */;
INSERT INTO `bodega` VALUES (1,1,'Bodega Central LP','Producto Terminado',50000,18.50),(2,1,'Bodega Insumos LP','Insumos',20000,20.00),(3,1,'Bodega Fría LP','Refrigerado',5000,4.00),(4,2,'Bodega Norte CBBA','Producto Terminado',40000,18.00),(5,2,'Bodega Insumos CBBA','Insumos',15000,20.00),(6,3,'Bodega Este SC','Producto Terminado',60000,19.00),(7,3,'Bodega Insumos SC','Insumos',25000,21.00),(8,4,'Bodega Oruro PT','Producto Terminado',30000,17.50),(9,5,'Bodega Sucre PT','Producto Terminado',25000,18.00),(10,6,'Bodega Potosí PT','Producto Terminado',20000,15.00),(11,7,'Bodega Tarija PT','Producto Terminado',20000,19.50),(12,10,'Bodega El Alto PT','Producto Terminado',35000,16.00);
/*!40000 ALTER TABLE `bodega` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `distribuidor`
--

DROP TABLE IF EXISTS `distribuidor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `distribuidor` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nit` varchar(20) NOT NULL,
  `razon_social` varchar(100) NOT NULL,
  `direccion` text DEFAULT NULL,
  `ciudad` varchar(30) DEFAULT NULL,
  `zona` varchar(50) DEFAULT NULL,
  `contacto` varchar(80) DEFAULT NULL,
  `telefono` varchar(20) DEFAULT NULL,
  `correo` varchar(80) DEFAULT NULL,
  `activo` tinyint(1) DEFAULT 1,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nit` (`nit`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `distribuidor`
--

LOCK TABLES `distribuidor` WRITE;
/*!40000 ALTER TABLE `distribuidor` DISABLE KEYS */;
INSERT INTO `distribuidor` VALUES (1,'1001001','Distribuciones Norte SRL','Av. Montes 1234','La Paz','Norte','Carlos Quispe','71112233','cnorte@gmail.com',1),(2,'1002002','Bebidas del Sur SA','C. Murillo 456','La Paz','Sur','Ana Flores','71223344','bsur@mail.com',1),(3,'1003003','Distribuidora Centro CBBA','Av. Heroínas 789','Cochabamba','Centro','Luis Mamani','72334455','dcentro@mail.com',1),(4,'1004004','Comercializadora Este SC','Av. Cañoto 321','Santa Cruz','Este','Pedro Vaca','73445566','comeste@mail.com',1),(5,'1005005','Distribuciones Altiplano','C. Sucre 654','Oruro','Centro','Rosa Condori','70556677','altiplano@mail.com',1),(6,'1006006','Bebidas Chapaca','Av. La Madrid 987','Tarija','Sur','Jorge Torrez','71667788','chapaca@mail.com',1),(7,'1007007','Distribuidora Camba SA','Av. Alemana 1122','Santa Cruz','Oeste','Mario Gutiérrez','73778899','camba@mail.com',1),(8,'1008008','Norte Bebidas SRL','C. 6 de Agosto 333','La Paz','Norte','Elena Ramos','71889900','nbebidas@mail.com',1),(9,'1009009','Comercio del Valle CBBA','C. Jordán 567','Cochabamba','Valle','Fernando López','72990011','cvalle@mail.com',1),(10,'1010010','Distribuciones Potosí','Av. Villazón 890','Potosí','Centro','Sandra Mamani','70001122','dpotosi@mail.com',0),(11,'1011011','Gran Sur Distribuciones','Av. Los Sauces 441','Sucre','Norte','César Arce','71112244','gsur@mail.com',1),(12,'1012012','Boliviana de Bebidas','C. Bolivia 100','El Alto','Zona Sur','Claudia Pérez','71223355','bolibebs@mail.com',1);
/*!40000 ALTER TABLE `distribuidor` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `factura`
--

DROP TABLE IF EXISTS `factura`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `factura` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pedido_id` int(11) NOT NULL,
  `numero_factura` varchar(30) NOT NULL,
  `fecha_emision` date NOT NULL,
  `monto_total` decimal(12,2) NOT NULL,
  `estado_pago` enum('Pagado','Pendiente','Vencido') DEFAULT 'Pendiente',
  PRIMARY KEY (`id`),
  UNIQUE KEY `numero_factura` (`numero_factura`),
  KEY `fk_factura_pedido` (`pedido_id`),
  CONSTRAINT `fk_factura_pedido` FOREIGN KEY (`pedido_id`) REFERENCES `pedido` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `factura`
--

LOCK TABLES `factura` WRITE;
/*!40000 ALTER TABLE `factura` DISABLE KEYS */;
/*!40000 ALTER TABLE `factura` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `inventario`
--

DROP TABLE IF EXISTS `inventario`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `inventario` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `lote_id` int(11) NOT NULL,
  `bodega_id` int(11) NOT NULL,
  `cantidad_actual` int(11) NOT NULL DEFAULT 0,
  `ultima_actualizacion` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_lote_bodega` (`lote_id`,`bodega_id`),
  KEY `fk_inv_bodega` (`bodega_id`),
  KEY `idx_inventario_lote` (`lote_id`),
  CONSTRAINT `fk_inv_bodega` FOREIGN KEY (`bodega_id`) REFERENCES `bodega` (`id`),
  CONSTRAINT `fk_inv_lote` FOREIGN KEY (`lote_id`) REFERENCES `lote_produccion` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inventario`
--

LOCK TABLES `inventario` WRITE;
/*!40000 ALTER TABLE `inventario` DISABLE KEYS */;
INSERT INTO `inventario` VALUES (1,1,1,8500,'2026-06-05 20:40:35'),(2,2,1,6000,'2026-06-05 20:40:35'),(3,3,4,7200,'2026-06-05 20:40:35'),(4,4,4,5500,'2026-06-05 20:40:35'),(5,5,1,3800,'2026-06-05 20:40:35'),(6,6,6,7000,'2026-06-05 20:40:35'),(7,7,1,2200,'2026-06-05 20:40:35'),(8,8,4,4500,'2026-06-05 20:40:35'),(9,9,6,5800,'2026-06-05 20:40:35'),(10,10,1,3200,'2026-06-05 20:40:35'),(11,12,6,5600,'2026-06-05 20:40:35'),(12,13,1,9000,'2026-06-05 20:40:35'),(13,14,4,8500,'2026-06-05 20:40:35'),(14,15,1,5500,'2026-06-05 20:40:35'),(15,1,12,1500,'2026-06-05 20:40:35'),(16,3,8,2000,'2026-06-05 20:40:35');
/*!40000 ALTER TABLE `inventario` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,STRICT_ALL_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,TRADITIONAL,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER tr_auditoria_inventario_update
AFTER UPDATE ON inventario
FOR EACH ROW
BEGIN
    INSERT INTO auditoria_log
        (tabla_afectada, accion, registro_id, usuario, datos_previos, datos_nuevos)
    VALUES
        ('inventario', 'UPDATE', OLD.id, CURRENT_USER(),
         CONCAT('lote_id=', OLD.lote_id, ', bodega_id=', OLD.bodega_id, ', cantidad=', OLD.cantidad_actual),
         CONCAT('lote_id=', NEW.lote_id, ', bodega_id=', NEW.bodega_id, ', cantidad=', NEW.cantidad_actual));
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,STRICT_ALL_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,TRADITIONAL,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER tr_control_stock_minimo
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
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `lote_produccion`
--

DROP TABLE IF EXISTS `lote_produccion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `lote_produccion` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `numero_lote` varchar(30) NOT NULL,
  `producto_id` int(11) NOT NULL,
  `fecha_produccion` date NOT NULL,
  `fecha_vencimiento` date NOT NULL,
  `cantidad_producida` int(11) NOT NULL,
  `planta_origen_id` int(11) NOT NULL,
  `control_calidad` enum('Aprobado','Rechazado') NOT NULL,
  `tecnico_responsable` varchar(100) DEFAULT NULL,
  `observaciones` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `numero_lote` (`numero_lote`),
  KEY `fk_lote_producto` (`producto_id`),
  KEY `fk_lote_planta` (`planta_origen_id`),
  KEY `idx_lote_vencimiento` (`fecha_vencimiento`),
  CONSTRAINT `fk_lote_planta` FOREIGN KEY (`planta_origen_id`) REFERENCES `planta` (`id`),
  CONSTRAINT `fk_lote_producto` FOREIGN KEY (`producto_id`) REFERENCES `producto` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `lote_produccion`
--

LOCK TABLES `lote_produccion` WRITE;
/*!40000 ALTER TABLE `lote_produccion` DISABLE KEYS */;
INSERT INTO `lote_produccion` VALUES (1,'LP-2025-001',1,'2025-01-10','2025-07-10',12000,1,'Aprobado','Ing. Marco Salinas',NULL),(2,'LP-2025-002',2,'2025-01-15','2025-07-15',8000,1,'Aprobado','Ing. Marco Salinas',NULL),(3,'LP-2025-003',4,'2025-01-20','2025-07-20',10000,2,'Aprobado','Ing. Silvia Torres',NULL),(4,'LP-2025-004',5,'2025-01-25','2025-07-25',7500,2,'Aprobado','Ing. Silvia Torres',NULL),(5,'LP-2025-005',6,'2025-02-01','2025-08-01',5000,1,'Aprobado','Ing. Marco Salinas','Lote Malta especial'),(6,'LP-2025-006',7,'2025-02-05','2025-08-05',9000,3,'Aprobado','Ing. Carlos Vidal',NULL),(7,'LP-2025-007',9,'2025-02-10','2025-08-10',3000,1,'Aprobado','Ing. Marco Salinas','Cerveza negra temporada'),(8,'LP-2025-008',3,'2025-02-15','2025-08-15',6000,2,'Aprobado','Ing. Silvia Torres',NULL),(9,'LP-2025-009',8,'2025-02-20','2025-08-20',7000,3,'Aprobado','Ing. Carlos Vidal',NULL),(10,'LP-2025-010',10,'2025-03-01','2025-09-01',4000,1,'Aprobado','Ing. Marco Salinas','Edición especial'),(11,'LP-2025-011',11,'2025-03-05','2025-09-05',5500,2,'Rechazado','Ing. Silvia Torres','Rechazado por pH fuera de rango'),(12,'LP-2025-012',12,'2025-03-10','2025-09-10',6500,3,'Aprobado','Ing. Carlos Vidal',NULL),(13,'LP-2025-013',1,'2025-03-15','2025-09-15',11000,1,'Aprobado','Ing. Marco Salinas',NULL),(14,'LP-2025-014',4,'2025-04-01','2025-10-01',9500,2,'Aprobado','Ing. Silvia Torres',NULL),(15,'LP-2025-015',2,'2025-04-10','2025-10-10',7000,1,'Aprobado','Ing. Marco Salinas',NULL);
/*!40000 ALTER TABLE `lote_produccion` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER tr_control_calidad_lote
BEFORE INSERT ON lote_produccion
FOR EACH ROW
BEGIN
    -- Si el lote es rechazado, no puede tener inventario
    IF NEW.control_calidad = 'Rechazado' THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Los lotes rechazados no pueden ingresar a inventario';
    END IF;
    
    -- Verificar que fecha_vencimiento > fecha_produccion
    IF NEW.fecha_vencimiento <= NEW.fecha_produccion THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La fecha de vencimiento debe ser posterior a la fecha de producción';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `movimiento_inventario`
--

DROP TABLE IF EXISTS `movimiento_inventario`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `movimiento_inventario` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `lote_id` int(11) NOT NULL,
  `bodega_origen_id` int(11) DEFAULT NULL,
  `bodega_destino_id` int(11) DEFAULT NULL,
  `tipo_movimiento` enum('entrada_produccion','salida_venta','traslado') NOT NULL,
  `cantidad` int(11) NOT NULL,
  `fecha_movimiento` timestamp NOT NULL DEFAULT current_timestamp(),
  `usuario_registra` varchar(50) DEFAULT NULL,
  `pedido_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_mov_origen` (`bodega_origen_id`),
  KEY `fk_mov_destino` (`bodega_destino_id`),
  KEY `fk_mov_pedido` (`pedido_id`),
  KEY `idx_movimiento_lote_fecha` (`lote_id`,`fecha_movimiento`),
  CONSTRAINT `fk_mov_destino` FOREIGN KEY (`bodega_destino_id`) REFERENCES `bodega` (`id`),
  CONSTRAINT `fk_mov_lote` FOREIGN KEY (`lote_id`) REFERENCES `lote_produccion` (`id`),
  CONSTRAINT `fk_mov_origen` FOREIGN KEY (`bodega_origen_id`) REFERENCES `bodega` (`id`),
  CONSTRAINT `fk_mov_pedido` FOREIGN KEY (`pedido_id`) REFERENCES `pedido` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `movimiento_inventario`
--

LOCK TABLES `movimiento_inventario` WRITE;
/*!40000 ALTER TABLE `movimiento_inventario` DISABLE KEYS */;
/*!40000 ALTER TABLE `movimiento_inventario` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pedido`
--

DROP TABLE IF EXISTS `pedido`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pedido` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `distribuidor_id` int(11) NOT NULL,
  `fecha_pedido` date NOT NULL,
  `fecha_entrega_requerida` date NOT NULL,
  `estado` enum('Pendiente','Despachado','Entregado','Cancelado') DEFAULT 'Pendiente',
  `monto_total` decimal(12,2) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_pedido_dist` (`distribuidor_id`),
  KEY `idx_pedido_estado_dist` (`estado`,`distribuidor_id`),
  CONSTRAINT `fk_pedido_dist` FOREIGN KEY (`distribuidor_id`) REFERENCES `distribuidor` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pedido`
--

LOCK TABLES `pedido` WRITE;
/*!40000 ALTER TABLE `pedido` DISABLE KEYS */;
INSERT INTO `pedido` VALUES (1,1,'2025-04-01','2025-04-05','Entregado',18750.00),(2,2,'2025-04-03','2025-04-08','Entregado',23400.00),(3,3,'2025-04-05','2025-04-10','Despachado',15600.00),(4,4,'2025-04-07','2025-04-12','Pendiente',31200.00),(5,5,'2025-04-08','2025-04-13','Pendiente',12480.00),(6,6,'2025-04-09','2025-04-14','Entregado',9360.00),(7,7,'2025-04-10','2025-04-15','Cancelado',17160.00),(8,8,'2025-04-11','2025-04-16','Pendiente',24960.00),(9,9,'2025-04-12','2025-04-17','Despachado',19500.00),(10,1,'2025-04-13','2025-04-18','Pendiente',14040.00),(11,2,'2025-04-14','2025-04-19','Pendiente',28080.00),(12,11,'2025-04-15','2025-04-20','Entregado',10920.00);
/*!40000 ALTER TABLE `pedido` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,STRICT_ALL_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,TRADITIONAL,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER tr_auditoria_pedido_insert
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
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `pedido_detalle`
--

DROP TABLE IF EXISTS `pedido_detalle`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pedido_detalle` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pedido_id` int(11) NOT NULL,
  `producto_id` int(11) NOT NULL,
  `cantidad` int(11) NOT NULL,
  `precio_unitario` decimal(10,2) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_det_pedido` (`pedido_id`),
  KEY `fk_det_producto` (`producto_id`),
  CONSTRAINT `fk_det_pedido` FOREIGN KEY (`pedido_id`) REFERENCES `pedido` (`id`),
  CONSTRAINT `fk_det_producto` FOREIGN KEY (`producto_id`) REFERENCES `producto` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pedido_detalle`
--

LOCK TABLES `pedido_detalle` WRITE;
/*!40000 ALTER TABLE `pedido_detalle` DISABLE KEYS */;
/*!40000 ALTER TABLE `pedido_detalle` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `planta`
--

DROP TABLE IF EXISTS `planta`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `planta` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(50) NOT NULL,
  `ciudad` varchar(30) NOT NULL,
  `ubicacion_detalle` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `planta`
--

LOCK TABLES `planta` WRITE;
/*!40000 ALTER TABLE `planta` DISABLE KEYS */;
INSERT INTO `planta` VALUES (1,'La Paz','La Paz','Mecapaca, zona industrial'),(2,'Cochabamba','Cochabamba','Sacaba, av. principal km 5'),(3,'Santa Cruz','Santa Cruz','Palmasola, parque industrial'),(4,'Oruro','Oruro','Zona norte, carretera a La Paz'),(5,'Sucre','Sucre','Parque industrial sur'),(6,'Potosí','Potosí','Av. Universitaria 2345'),(7,'Tarija','Tarija','Barrio Aeropuerto'),(8,'Trinidad','Trinidad','Zona franca este'),(9,'Cobija','Cobija','Puerto industrial'),(10,'El Alto','El Alto','Ciudad satélite, zona industrial');
/*!40000 ALTER TABLE `planta` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `producto`
--

DROP TABLE IF EXISTS `producto`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `producto` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `codigo_unico` varchar(20) NOT NULL,
  `nombre_comercial` varchar(50) NOT NULL,
  `tipo` varchar(20) DEFAULT NULL CHECK (`tipo` in ('Lager','Pilsener','Malta','Negra','Especial')),
  `presentacion` varchar(20) NOT NULL,
  `graduacion_alcoholica` decimal(3,1) NOT NULL,
  `precio_actual` decimal(10,2) NOT NULL,
  `stock_minimo` int(11) NOT NULL DEFAULT 100,
  `stock_maximo` int(11) NOT NULL DEFAULT 10000,
  `activo` tinyint(1) DEFAULT 1,
  PRIMARY KEY (`id`),
  UNIQUE KEY `codigo_unico` (`codigo_unico`),
  KEY `idx_producto_tipo` (`tipo`,`activo`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `producto`
--

LOCK TABLES `producto` WRITE;
/*!40000 ALTER TABLE `producto` DISABLE KEYS */;
INSERT INTO `producto` VALUES (1,'PAC355','Paceña','Lager','355ml',4.5,12.50,500,10000,1),(2,'PAC620','Paceña Grande','Lager','620ml',4.5,15.90,400,8000,1),(3,'PAC1L','Paceña Litro','Lager','1000ml',4.5,20.00,300,6000,1),(4,'TAQ355','Taquiña','Pilsener','355ml',5.0,12.00,500,9000,1),(5,'TAQ620','Taquiña Grande','Pilsener','620ml',5.0,15.90,300,8000,1),(6,'HUA1L','Huari Malta','Malta','1000ml',0.0,18.00,200,5000,1),(7,'HUA355','Huari','Lager','355ml',4.7,11.00,400,9000,1),(8,'DUK355','Ducal','Pilsener','355ml',5.0,13.50,300,7000,1),(9,'NEG620','Paceña Negra','Negra','620ml',5.5,18.50,200,5000,1),(10,'ESP355','Pil Especial','Especial','355ml',4.2,14.00,150,4000,1),(11,'TAQ1L','Taquiña Litro','Pilsener','1000ml',5.0,21.00,200,4000,1),(12,'HUL355','Huari Light','Lager','355ml',3.5,9.50,200,6000,1);
/*!40000 ALTER TABLE `producto` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `usuario`
--

DROP TABLE IF EXISTS `usuario`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `usuario` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `email` varchar(100) DEFAULT NULL,
  `rol` varchar(30) NOT NULL,
  `activo` tinyint(1) DEFAULT 1,
  `fecha_creacion` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usuario`
--

LOCK TABLES `usuario` WRITE;
/*!40000 ALTER TABLE `usuario` DISABLE KEYS */;
INSERT INTO `usuario` VALUES (1,'admin_pil','pbkdf2:sha256:260000$...','admin@pilandina.com','admin_pil',1,'2026-06-05 21:15:09'),(2,'gerente_pil','pbkdf2:sha256:260000$...','gerente@pilandina.com','gerente_pil',1,'2026-06-05 21:15:09'),(3,'distribuidor_pil','pbkdf2:sha256:260000$...','distribuidor@pilandina.com','distribuidor_pil',1,'2026-06-05 21:15:09');
/*!40000 ALTER TABLE `usuario` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary table structure for view `vista_facturacion_distribuidor`
--

DROP TABLE IF EXISTS `vista_facturacion_distribuidor`;
/*!50001 DROP VIEW IF EXISTS `vista_facturacion_distribuidor`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `vista_facturacion_distribuidor` AS SELECT
 1 AS `razon_social`,
  1 AS `ciudad`,
  1 AS `total_facturas`,
  1 AS `facturacion_total`,
  1 AS `monto_pendiente`,
  1 AS `monto_vencido` */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `vista_proximos_vencer`
--

DROP TABLE IF EXISTS `vista_proximos_vencer`;
/*!50001 DROP VIEW IF EXISTS `vista_proximos_vencer`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `vista_proximos_vencer` AS SELECT
 1 AS `numero_lote`,
  1 AS `nombre_comercial`,
  1 AS `presentacion`,
  1 AS `fecha_produccion`,
  1 AS `fecha_vencimiento`,
  1 AS `dias_restantes`,
  1 AS `cantidad_actual`,
  1 AS `nombre_bodega`,
  1 AS `planta` */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `vista_rotacion_mensual`
--

DROP TABLE IF EXISTS `vista_rotacion_mensual`;
/*!50001 DROP VIEW IF EXISTS `vista_rotacion_mensual`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `vista_rotacion_mensual` AS SELECT
 1 AS `nombre_comercial`,
  1 AS `presentacion`,
  1 AS `tipo`,
  1 AS `salidas_mes_actual`,
  1 AS `salidas_mes_anterior`,
  1 AS `entradas_total` */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `vista_stock_por_planta`
--

DROP TABLE IF EXISTS `vista_stock_por_planta`;
/*!50001 DROP VIEW IF EXISTS `vista_stock_por_planta`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `vista_stock_por_planta` AS SELECT
 1 AS `codigo_unico`,
  1 AS `nombre_comercial`,
  1 AS `presentacion`,
  1 AS `tipo`,
  1 AS `planta`,
  1 AS `ciudad`,
  1 AS `nombre_bodega`,
  1 AS `stock_total` */;
SET character_set_client = @saved_cs_client;

--
-- Final view structure for view `vista_facturacion_distribuidor`
--

/*!50001 DROP VIEW IF EXISTS `vista_facturacion_distribuidor`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vista_facturacion_distribuidor` AS select `d`.`razon_social` AS `razon_social`,`d`.`ciudad` AS `ciudad`,count(`f`.`id`) AS `total_facturas`,sum(`f`.`monto_total`) AS `facturacion_total`,sum(case when `f`.`estado_pago` = 'Pendiente' then `f`.`monto_total` else 0 end) AS `monto_pendiente`,sum(case when `f`.`estado_pago` = 'Vencido' then `f`.`monto_total` else 0 end) AS `monto_vencido` from ((`factura` `f` join `pedido` `p` on(`f`.`pedido_id` = `p`.`id`)) join `distribuidor` `d` on(`p`.`distribuidor_id` = `d`.`id`)) group by `d`.`id` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vista_proximos_vencer`
--

/*!50001 DROP VIEW IF EXISTS `vista_proximos_vencer`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vista_proximos_vencer` AS select `l`.`numero_lote` AS `numero_lote`,`p`.`nombre_comercial` AS `nombre_comercial`,`p`.`presentacion` AS `presentacion`,`l`.`fecha_produccion` AS `fecha_produccion`,`l`.`fecha_vencimiento` AS `fecha_vencimiento`,to_days(`l`.`fecha_vencimiento`) - to_days(curdate()) AS `dias_restantes`,`i`.`cantidad_actual` AS `cantidad_actual`,`b`.`nombre_bodega` AS `nombre_bodega`,`pl`.`nombre` AS `planta` from ((((`lote_produccion` `l` join `producto` `p` on(`l`.`producto_id` = `p`.`id`)) join `inventario` `i` on(`l`.`id` = `i`.`lote_id`)) join `bodega` `b` on(`i`.`bodega_id` = `b`.`id`)) join `planta` `pl` on(`b`.`planta_id` = `pl`.`id`)) where `l`.`fecha_vencimiento` between curdate() and curdate() + interval 30 day and `l`.`control_calidad` = 'Aprobado' and `i`.`cantidad_actual` > 0 */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vista_rotacion_mensual`
--

/*!50001 DROP VIEW IF EXISTS `vista_rotacion_mensual`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vista_rotacion_mensual` AS select `p`.`nombre_comercial` AS `nombre_comercial`,`p`.`presentacion` AS `presentacion`,`p`.`tipo` AS `tipo`,sum(case when month(`m`.`fecha_movimiento`) = month(curdate()) and year(`m`.`fecha_movimiento`) = year(curdate()) and `m`.`tipo_movimiento` = 'salida_venta' then `m`.`cantidad` else 0 end) AS `salidas_mes_actual`,sum(case when month(`m`.`fecha_movimiento`) = month(curdate() - interval 1 month) and year(`m`.`fecha_movimiento`) = year(curdate() - interval 1 month) and `m`.`tipo_movimiento` = 'salida_venta' then `m`.`cantidad` else 0 end) AS `salidas_mes_anterior`,sum(case when `m`.`tipo_movimiento` = 'entrada_produccion' then `m`.`cantidad` else 0 end) AS `entradas_total` from ((`movimiento_inventario` `m` join `lote_produccion` `l` on(`m`.`lote_id` = `l`.`id`)) join `producto` `p` on(`l`.`producto_id` = `p`.`id`)) group by `p`.`id` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vista_stock_por_planta`
--

/*!50001 DROP VIEW IF EXISTS `vista_stock_por_planta`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vista_stock_por_planta` AS select `p`.`codigo_unico` AS `codigo_unico`,`p`.`nombre_comercial` AS `nombre_comercial`,`p`.`presentacion` AS `presentacion`,`p`.`tipo` AS `tipo`,`pl`.`nombre` AS `planta`,`pl`.`ciudad` AS `ciudad`,`b`.`nombre_bodega` AS `nombre_bodega`,sum(`i`.`cantidad_actual`) AS `stock_total` from ((((`inventario` `i` join `lote_produccion` `l` on(`i`.`lote_id` = `l`.`id`)) join `producto` `p` on(`l`.`producto_id` = `p`.`id`)) join `bodega` `b` on(`i`.`bodega_id` = `b`.`id`)) join `planta` `pl` on(`b`.`planta_id` = `pl`.`id`)) where `l`.`control_calidad` = 'Aprobado' group by `p`.`id`,`pl`.`id`,`b`.`id` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-06-05 17:48:35
