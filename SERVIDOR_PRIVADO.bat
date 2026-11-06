@echo off
setlocal
if defined BH_PYTHON goto run
set "BH_PYTHON=%USERPROFILE%\.cache\codex-runtimes\codex-primary-runtime\dependencies\python\python.exe"
if exist "%BH_PYTHON%" goto run
where python >nul 2>nul
if errorlevel 1 (
    echo Se necesita Python 3.12 o superior. Define BH_PYTHON con la ruta a python.exe.
    pause
    exit /b 1
)
set "BH_PYTHON=python"
:run
cd /d "%~dp0"
"%BH_PYTHON%" -u "online\server.py"
if errorlevel 1 pause
exit /b %errorlevel%
