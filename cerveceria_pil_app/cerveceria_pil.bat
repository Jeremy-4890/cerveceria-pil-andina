@echo off
title Cervecería Pil Andina - Sistema de Inventario
color 0A

echo ========================================
echo  Cervecería Pil Andina
echo  Sistema de Gestión de Inventario
echo ========================================
echo.

echo Iniciando servidor web...
echo.

cd /d "C:\Users\vasusj\Desktop\cerveceria_pil_app"

:: Activar entorno virtual si existe
if exist venv\Scripts\activate.bat (
    call venv\Scripts\activate.bat
)

:: Iniciar Flask
start http://localhost:5000
python app.py

pause