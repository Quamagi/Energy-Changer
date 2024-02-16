@echo off

echo Este script le permite seleccionar y aplicar diferentes planes de energía
echo en su sistema, así como crear un plan personalizado optimizado para
echo alto rendimiento de audio y video.

echo. 
echo Seleccione una opción: 
echo ====================
echo 1 - Plan equilibrado
echo 2 - Plan alto rendimiento 
echo 3 - Plan ahorro de energía
echo 4 - Crear plan alto rendimiento AV
echo.

set /p option=Opción:

if "%option%"=="1" goto balanced
if "%option%"=="2" goto highperf
if "%option%"=="3" goto power saver  
if "%option%"=="4" goto avplan

echo Opción inválida 
goto end

:balanced 
call setpower balanced
goto end

:highperf
call setpower highperf  
goto end  

:power saver
call setpower saver
goto end

:avplan
call :avplanconfirm
if errorlevel 1 goto end 

call :createavplan
if errorlevel 1 echo No se pudo crear plan & goto end

echo Plan Alto Rendimiento AV creado!
goto end

:setpower
echo.
echo Cambiando plan de energía a %1
echo Es necesario elevar privilegios
set "psCommand=powershell -Command "&amp;"Start-Process -Verb runAs '%0' -ArgumentList '%1'" 
%psCommand%
EXIT /B  

:createavplan 
echo Creando plan Alto Rendimiento AV  
echo Requiere elevación de privilegios
powershell -Command "Start-Process -Verb runAs -FilePath '%0' -ArgumentList 'avplaninternal'"
EXIT /B

:avplaninternal
powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61
:: Resto de comandos para crear plan AV
EXIT /B 0

:avplanconfirm
echo El plan Alto Rendimiento AV optimiza audio y video
echo ¿Desea crear este plan? (S/N)
set /p resp= 
if /i "%resp%" EQU "S" exit /b 0
if /i "%resp%" EQU "N" exit /b 1
echo Respuesta inválida
goto avplanconfirm

:end
