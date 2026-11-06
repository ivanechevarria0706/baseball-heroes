@echo off
setlocal

call "%~dp0build\build.bat" --no-pause

if errorlevel 1 (
    echo.
    echo No se pudo iniciar porque la compilacion fallo.
    pause
    exit /b 1
)

call "%~dp0build\run-air.bat"
