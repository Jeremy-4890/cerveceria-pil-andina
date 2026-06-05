import schedule
import time
import subprocess
import os
from datetime import datetime

# Configuración de la base de datos
MYSQL_HOST = 'localhost'
MYSQL_USER = 'root'
MYSQL_PASSWORD = ''
MYSQL_DATABASE = 'cerveceria_pil'
BACKUP_DIR = os.path.join(os.path.dirname(__file__), 'backups')

# Ruta de mysqldump (XAMPP)
MYSQLDUMP_PATH = r'C:\xampp\mysql\bin\mysqldump.exe'

def realizar_backup_automatico():
    """Realiza backup automático de la base de datos"""
    try:
        # Crear nombre del archivo con fecha y hora
        timestamp = datetime.now().strftime('%Y%m%d_%H%M%S')
        backup_file = os.path.join(BACKUP_DIR, f'auto_backup_{timestamp}.sql')
        
        # Verificar si existe la carpeta backups
        os.makedirs(BACKUP_DIR, exist_ok=True)
        
        # Verificar si existe mysqldump
        mysqldump = MYSQLDUMP_PATH
        if not os.path.exists(mysqldump):
            # Buscar en otras rutas comunes
            rutas_posibles = [
                r'C:\xampp\mysql\bin\mysqldump.exe',
                r'D:\xampp\mysql\bin\mysqldump.exe',
                r'E:\xampp\mysql\bin\mysqldump.exe',
            ]
            for ruta in rutas_posibles:
                if os.path.exists(ruta):
                    mysqldump = ruta
                    break
            else:
                mysqldump = 'mysqldump'  # Intentar con el comando del sistema
        
        # Construir el comando
        cmd = f'"{mysqldump}" -h {MYSQL_HOST} -u {MYSQL_USER} '
        if MYSQL_PASSWORD:
            cmd += f'-p{MYSQL_PASSWORD} '
        cmd += f'{MYSQL_DATABASE} > "{backup_file}"'
        
        print(f"[{datetime.now()}] Ejecutando backup automático...")
        
        # Ejecutar el comando
        result = subprocess.run(cmd, shell=True, capture_output=True, text=True)
        
        # Verificar si el backup se creó correctamente
        if result.returncode == 0 and os.path.exists(backup_file) and os.path.getsize(backup_file) > 0:
            print(f"[{datetime.now()}] ✅ Backup automático creado: {backup_file}")
            
            # Limpiar backups antiguos (eliminar los que tengan más de 30 días)
            eliminados = 0
            for filename in os.listdir(BACKUP_DIR):
                if filename.startswith('auto_backup_') and filename.endswith('.sql'):
                    filepath = os.path.join(BACKUP_DIR, filename)
                    # Si el archivo tiene más de 30 días (2592000 segundos)
                    if os.path.getmtime(filepath) < time.time() - 30*86400:
                        os.remove(filepath)
                        eliminados += 1
            
            if eliminados > 0:
                print(f"[{datetime.now()}] 🗑️ Se eliminaron {eliminados} backups antiguos")
        else:
            print(f"[{datetime.now()}] ❌ ERROR en backup automático")
            print(f"    Comando: {cmd}")
            print(f"    Error: {result.stderr}")
            
    except Exception as e:
        print(f"[{datetime.now()}] ❌ ERROR: {e}")

def iniciar_scheduler():
    """Inicia el programador de backups"""
    print("=" * 50)
    print("🔄 PROGRAMADOR DE BACKUPS AUTOMÁTICOS")
    print("=" * 50)
    print(f"📁 Directorio de backups: {BACKUP_DIR}")
    print(f"⏰ Backup programado: TODOS LOS DÍAS a las 02:00 AM")
    print("=" * 50)
    print("Presiona CTRL+C para detener el programador")
    print("=" * 50)
    
    # Programar backup diario a las 2:00 AM
    schedule.every().day.at("02:00").do(realizar_backup_automatico)
    
    # Opcional: hacer un backup al iniciar el programa (comentar si no quieres)
    # realizar_backup_automatico()
    
    # Bucle infinito para ejecutar tareas programadas
    while True:
        schedule.run_pending()
        time.sleep(60)  # Revisar cada minuto

if __name__ == '__main__':
    iniciar_scheduler()