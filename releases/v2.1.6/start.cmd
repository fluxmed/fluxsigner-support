@echo off
rem FluxSigner Native Host Starter
rem Executa o host nativo Java para comunicacao com a extensao Chrome

rem Definir diretorio de instalacao
set "INSTALL_DIR=%~dp0"
set "LOG_FILE=%INSTALL_DIR%fluxsigner-debug.log"
set "JAR_FILE=%INSTALL_DIR%fluxsigner-pdf-icpbrasil.jar"

rem Criar log
echo ================================================ >> "%LOG_FILE%" 2>&1
echo [%date% %time%] START.CMD INICIADO >> "%LOG_FILE%" 2>&1
echo [%date% %time%] Install dir: %INSTALL_DIR% >> "%LOG_FILE%" 2>&1

rem Mudar para o diretorio de instalacao
cd /d "%INSTALL_DIR%"

rem Verificar se o JAR existe
if not exist "%JAR_FILE%" (
    echo [%date% %time%] ERRO: JAR nao encontrado em %JAR_FILE% >> "%LOG_FILE%" 2>&1
    exit /b 1
)

rem Executar o JAR
echo [%date% %time%] Iniciando FluxSigner Host... >> "%LOG_FILE%" 2>&1
java -Dfile.encoding=UTF-8 -jar "%JAR_FILE%" 2>> "%LOG_FILE%"

rem Registrar codigo de saida
echo [%date% %time%] FluxSigner Host encerrado (codigo: %errorlevel%) >> "%LOG_FILE%" 2>&1
exit /b %errorlevel%
