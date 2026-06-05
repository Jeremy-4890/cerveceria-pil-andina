import os
from dotenv import load_dotenv

load_dotenv()

class Config:
    SECRET_KEY = os.environ.get('SECRET_KEY') or 'dev-secret-key-cerveceria-pil-2025'
    
    # Configuración MySQL
    MYSQL_HOST = os.environ.get('MYSQL_HOST') or 'localhost'
    MYSQL_USER = os.environ.get('MYSQL_USER') or 'root'
    MYSQL_PASSWORD = os.environ.get('MYSQL_PASSWORD') or ''
    MYSQL_DATABASE = os.environ.get('MYSQL_DATABASE') or 'cerveceria_pil'
    
    # Ruta de mysqldump (XAMPP)
    # Si usas XAMPP en disco C:
    MYSQLDUMP_PATH = r'C:\xampp\mysql\bin\mysqldump.exe'
    # Si usas XAMPP en otro disco, cambia la ruta
    # MYSQLDUMP_PATH = r'D:\xampp\mysql\bin\mysqldump.exe'
    
    # Directorios
    BACKUP_DIR = os.path.join(os.path.dirname(__file__), 'backups')
    LOG_DIR = os.path.join(os.path.dirname(__file__), 'logs')
    
    # Configuración de sesión
    SESSION_PERMANENT = False
    SESSION_TYPE = 'filesystem'
    
    # Roles del sistema
    ROLES = {
        'admin_pil': 'Administrador',
        'gerente_pil': 'Gerente',
        'distribuidor_pil': 'Distribuidor'
    }