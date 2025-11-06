@echo off
rem ============================================================================
rem FluxSigner - Launcher do Script de Diagnóstico
rem ============================================================================
rem Este arquivo facilita a execução do diagnóstico para usuários finais

title FluxSigner - Diagnóstico do Sistema

echo.
echo ============================================================================
echo FluxSigner - Diagnostico Completo v2.1.5
echo ============================================================================
echo.
echo Verificando instalacao e configuracao do FluxSigner...
echo.
echo Aguarde, isto pode levar alguns segundos...
echo.

rem Executar o script PowerShell com política de execução bypass
powershell.exe -ExecutionPolicy Bypass -NoProfile -File "%~dp0diagnostico-fluxsigner.ps1"

echo.
echo ============================================================================
echo.
echo Pressione qualquer tecla para sair...
pause >nul

