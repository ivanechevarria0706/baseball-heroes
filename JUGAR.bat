@echo off
setlocal
if not defined FLEX_HOME set "FLEX_HOME=C:\Users\ivane\Downloads\FlexSDK"
if not exist "%FLEX_HOME%\bin\adl.exe" (
    echo No se encontro AIR. Define FLEX_HOME con la carpeta de tu SDK.
    pause
    exit /b 1
)
if not exist "%~dp0build\BaseballHeroesRemake.swf" (
    echo Falta la compilacion. Ejecuta build\build.bat primero.
    pause
    exit /b 1
)
cd /d "%~dp0build"
"%FLEX_HOME%\bin\adl.exe" -nodebug "BaseballHeroes-app.xml"
exit /b %errorlevel%
