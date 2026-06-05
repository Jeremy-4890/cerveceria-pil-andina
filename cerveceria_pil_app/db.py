import mysql.connector
from mysql.connector import Error
from flask import g
import logging
from config import Config

# Configurar logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

def get_db():
    """Obtener conexión a la base de datos (por request)"""
    if 'db' not in g:
        try:
            g.db = mysql.connector.connect(
                host=Config.MYSQL_HOST,
                user=Config.MYSQL_USER,
                password=Config.MYSQL_PASSWORD,
                database=Config.MYSQL_DATABASE,
                autocommit=False,
                use_pure=True
            )
            logger.info("Conexión a BD establecida")
        except Error as e:
            logger.error(f"Error conectando a MySQL: {e}")
            raise
    return g.db

def close_db(e=None):
    """Cerrar conexión a la base de datos"""
    db = g.pop('db', None)
    if db is not None:
        db.close()
        logger.info("Conexión a BD cerrada")

def execute_query(query, params=None, commit=False, fetch_one=False, fetch_all=False):
    """Ejecutar query con manejo de transacciones"""
    db = get_db()
    cursor = db.cursor(dictionary=True)
    
    try:
        cursor.execute(query, params or ())
        
        if commit:
            db.commit()
            logger.info(f"Query ejecutada y commiteada: {query[:100]}")
        
        if fetch_one:
            result = cursor.fetchone()
        elif fetch_all:
            result = cursor.fetchall()
        else:
            result = cursor.lastrowid if commit else None
            
        return result
    except Error as e:
        if commit:
            db.rollback()
            logger.error(f"Error en query, rollback aplicado: {e}")
        raise
    finally:
        cursor.close()

def call_procedure(procedure_name, params=None):
    """Llamar a un procedimiento almacenado"""
    db = get_db()
    cursor = db.cursor(dictionary=True)
    
    try:
        cursor.callproc(procedure_name, params or ())
        # Obtener resultados
        results = []
        for result in cursor.stored_results():
            results.extend(result.fetchall())
        db.commit()
        return results
    except Error as e:
        db.rollback()
        logger.error(f"Error llamando procedimiento {procedure_name}: {e}")
        raise
    finally:
        cursor.close()

def get_cursor():
    """Obtener cursor para consultas personalizadas"""
    db = get_db()
    return db.cursor(dictionary=True)