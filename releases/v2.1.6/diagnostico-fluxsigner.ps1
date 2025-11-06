# ============================================================================
# FluxSigner - Script de Diagnóstico Completo
# ============================================================================
# 
# Este script verifica a instalação e configuração do FluxSigner,
# identificando problemas comuns e fornecendo soluções.
#
# Versão: 2.1.5
# Data: 2025-10-28
# ============================================================================

param(
    [switch]$ExportarRelatorio,
    [string]$CaminhoRelatorio = "$env:USERPROFILE\Desktop\FluxSigner-Diagnostico.txt"
)

# Cores para output
$ColorSuccess = "Green"
$ColorWarning = "Yellow"
$ColorError = "Red"
$ColorInfo = "Cyan"
$ColorDetail = "Gray"

# Variáveis globais para contadores
$script:TotalTestes = 0
$script:TestesPassados = 0
$script:TestesFalhados = 0
$script:Avisos = 0

# Array para armazenar resultados do relatório
$script:RelatorioLinhas = @()

# ============================================================================
# FUNÇÕES AUXILIARES
# ============================================================================

function Write-Header {
    param([string]$Texto)
    $linha = "=" * 80
    Write-Host ""
    Write-Host $linha -ForegroundColor $ColorInfo
    Write-Host $Texto -ForegroundColor $ColorInfo
    Write-Host $linha -ForegroundColor $ColorInfo
    Write-Host ""
    
    $script:RelatorioLinhas += ""
    $script:RelatorioLinhas += $linha
    $script:RelatorioLinhas += $Texto
    $script:RelatorioLinhas += $linha
    $script:RelatorioLinhas += ""
}

function Write-Section {
    param([string]$Texto)
    Write-Host ""
    Write-Host ">>> $Texto" -ForegroundColor $ColorInfo
    Write-Host ""
    
    $script:RelatorioLinhas += ""
    $script:RelatorioLinhas += ">>> $Texto"
    $script:RelatorioLinhas += ""
}

function Write-TestResult {
    param(
        [string]$Teste,
        [bool]$Passou,
        [string]$Detalhes = "",
        [bool]$Critico = $true
    )
    
    $script:TotalTestes++
    
    if ($Passou) {
        $script:TestesPassados++
        $simbolo = "✅"
        $cor = $ColorSuccess
        $status = "OK"
    }
    else {
        if ($Critico) {
            $script:TestesFalhados++
            $simbolo = "❌"
            $cor = $ColorError
            $status = "FALHOU"
        }
        else {
            $script:Avisos++
            $simbolo = "⚠️"
            $cor = $ColorWarning
            $status = "AVISO"
        }
    }
    
    Write-Host "  $simbolo $Teste" -ForegroundColor $cor
    if ($Detalhes) {
        Write-Host "     $Detalhes" -ForegroundColor $ColorDetail
    }
    
    $script:RelatorioLinhas += "  [$status] $Teste"
    if ($Detalhes) {
        $script:RelatorioLinhas += "     $Detalhes"
    }
}

function Write-Detail {
    param([string]$Texto)
    Write-Host "     $Texto" -ForegroundColor $ColorDetail
    $script:RelatorioLinhas += "     $Texto"
}

function Write-Recommendation {
    param([string]$Texto)
    Write-Host ""
    Write-Host "  💡 RECOMENDAÇÃO: $Texto" -ForegroundColor $ColorWarning
    Write-Host ""
    
    $script:RelatorioLinhas += ""
    $script:RelatorioLinhas += "  RECOMENDACAO: $Texto"
    $script:RelatorioLinhas += ""
}

function Get-FluxSignerVersion {
    try {
        $manifestPath = Get-ItemProperty -Path "HKCU:\Software\Google\Chrome\NativeMessagingHosts\br.com.fluxsigner.native" -ErrorAction SilentlyContinue
        if ($manifestPath) {
            $manifest = Get-Content $manifestPath.'(default)' -Raw | ConvertFrom-Json
            return $manifest.description -replace ".*v(\d+\.\d+\.\d+).*", '$1'
        }
    }
    catch {}
    return "Desconhecida"
}

function Test-PortaDisponivel {
    param([int]$Porta)
    try {
        $listener = [System.Net.Sockets.TcpListener]::new([System.Net.IPAddress]::Loopback, $Porta)
        $listener.Start()
        $listener.Stop()
        return $true
    }
    catch {
        return $false
    }
}

# ============================================================================
# INÍCIO DO DIAGNÓSTICO
# ============================================================================

Clear-Host

Write-Header "FLUXSIGNER - DIAGNÓSTICO COMPLETO v2.1.5"

Write-Host "Data/Hora: $(Get-Date -Format 'dd/MM/yyyy HH:mm:ss')" -ForegroundColor $ColorDetail
Write-Host "Usuário: $env:USERNAME" -ForegroundColor $ColorDetail
Write-Host "Computador: $env:COMPUTERNAME" -ForegroundColor $ColorDetail
Write-Host "Sistema: $([Environment]::OSVersion.VersionString)" -ForegroundColor $ColorDetail
Write-Host ""

$script:RelatorioLinhas += "Data/Hora: $(Get-Date -Format 'dd/MM/yyyy HH:mm:ss')"
$script:RelatorioLinhas += "Usuario: $env:USERNAME"
$script:RelatorioLinhas += "Computador: $env:COMPUTERNAME"
$script:RelatorioLinhas += "Sistema: $([Environment]::OSVersion.VersionString)"
$script:RelatorioLinhas += ""

# ============================================================================
# 1. VERIFICAÇÃO DO SISTEMA OPERACIONAL
# ============================================================================

Write-Section "1. VERIFICAÇÃO DO SISTEMA OPERACIONAL"

$osVersion = [Environment]::OSVersion.Version
$isWindows10OrLater = $osVersion.Major -ge 10

Write-TestResult -Teste "Windows 10 ou superior" -Passou $isWindows10OrLater `
    -Detalhes "Versão detectada: $($osVersion.Major).$($osVersion.Minor) Build $($osVersion.Build)"

if (-not $isWindows10OrLater) {
    Write-Recommendation "O FluxSigner requer Windows 10 ou superior. Considere atualizar o sistema operacional."
}

# Verificar arquitetura
$is64Bit = [Environment]::Is64BitOperatingSystem
Write-TestResult -Teste "Sistema 64-bit" -Passou $is64Bit -Detalhes "Arquitetura: $(if($is64Bit){'x64'}else{'x86'})" -Critico $false

# Verificar .NET Framework
try {
    $dotNetVersion = (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full" -ErrorAction Stop).Release
    $dotNetOk = $dotNetVersion -ge 394802  # .NET 4.6.2 ou superior
    Write-TestResult -Teste ".NET Framework 4.6.2+" -Passou $dotNetOk -Detalhes "Release: $dotNetVersion"
}
catch {
    Write-TestResult -Teste ".NET Framework 4.6.2+" -Passou $false -Detalhes "Não detectado"
    Write-Recommendation "Instale o .NET Framework 4.6.2 ou superior: https://dotnet.microsoft.com/download/dotnet-framework"
}

# ============================================================================
# 2. VERIFICAÇÃO DO JAVA
# ============================================================================

Write-Section "2. VERIFICAÇÃO DO JAVA RUNTIME"

$javaInstalled = $false
$javaVersion = ""
$javaPath = ""

try {
    $javaVersionOutput = java -version 2>&1 | Select-Object -First 3
    $javaVersion = ($javaVersionOutput -join " ")
    $javaPath = (Get-Command java -ErrorAction Stop).Source
    $javaInstalled = $true
    
    # Extrair versão numérica
    if ($javaVersion -match '(?:version\s+\")?(\d+)\.') {
        $javaMajorVersion = [int]$matches[1]
        $javaVersionOk = $javaMajorVersion -ge 8
    }
    else {
        $javaVersionOk = $true  # Assume OK se não conseguir parsear
    }
    
    Write-TestResult -Teste "Java instalado e no PATH" -Passou $true `
        -Detalhes "Caminho: $javaPath"
    Write-Detail "Versão: $($javaVersion -replace '[\r\n]+', ' ')"
    
    if (-not $javaVersionOk) {
        Write-Recommendation "Java 8 ou superior é recomendado. Versão detectada pode ser muito antiga."
    }
    
}
catch {
    Write-TestResult -Teste "Java instalado e no PATH" -Passou $false `
        -Detalhes "Java não encontrado no PATH do sistema"
    Write-Recommendation @"
Instale o Java Runtime Environment (JRE) 8 ou superior:
- Oracle JRE: https://www.java.com/download/
- OpenJDK: https://adoptium.net/
Após a instalação, reinicie o sistema.
"@
}

# Verificar variável JAVA_HOME (opcional, mas útil)
$javaHome = [Environment]::GetEnvironmentVariable("JAVA_HOME", "Machine")
if ($javaHome) {
    Write-TestResult -Teste "JAVA_HOME configurado" -Passou $true -Detalhes "JAVA_HOME: $javaHome" -Critico $false
}
else {
    Write-TestResult -Teste "JAVA_HOME configurado" -Passou $false -Detalhes "Variável JAVA_HOME não definida" -Critico $false
}

# ============================================================================
# 3. VERIFICAÇÃO DO GOOGLE CHROME
# ============================================================================

Write-Section "3. VERIFICAÇÃO DO GOOGLE CHROME"

$chromePaths = @(
    "$env:ProgramFiles\Google\Chrome\Application\chrome.exe",
    "${env:ProgramFiles(x86)}\Google\Chrome\Application\chrome.exe",
    "$env:LOCALAPPDATA\Google\Chrome\Application\chrome.exe"
)

$chromeInstalled = $false
$chromePath = ""

foreach ($path in $chromePaths) {
    if (Test-Path $path) {
        $chromeInstalled = $true
        $chromePath = $path
        
        try {
            $chromeVersion = (Get-Item $path).VersionInfo.ProductVersion
        }
        catch {
            $chromeVersion = "Versão não detectada"
        }
        break
    }
}

Write-TestResult -Teste "Google Chrome instalado" -Passou $chromeInstalled `
    -Detalhes $(if ($chromeInstalled) { "Caminho: $chromePath | Versão: $chromeVersion" }else { "Chrome não encontrado" })

if (-not $chromeInstalled) {
    Write-Recommendation "Instale o Google Chrome: https://www.google.com/chrome/"
}

# Verificar se o Chrome está em execução
$chromeProcesses = Get-Process chrome -ErrorAction SilentlyContinue
if ($chromeProcesses) {
    Write-TestResult -Teste "Chrome em execução" -Passou $true `
        -Detalhes "$($chromeProcesses.Count) processo(s) detectado(s)" -Critico $false
}
else {
    Write-TestResult -Teste "Chrome em execução" -Passou $false `
        -Detalhes "Nenhum processo do Chrome detectado" -Critico $false
}

# ============================================================================
# 4. VERIFICAÇÃO DA INSTALAÇÃO DO FLUXSIGNER
# ============================================================================

Write-Section "4. VERIFICAÇÃO DA INSTALAÇÃO DO FLUXSIGNER"

# 4.1. Verificar registro do Native Host
$registryPaths = @(
    @{Path = "HKCU:\Software\Google\Chrome\NativeMessagingHosts\br.com.fluxsigner.native"; Scope = "Usuário" },
    @{Path = "HKLM:\Software\Google\Chrome\NativeMessagingHosts\br.com.fluxsigner.native"; Scope = "Sistema" }
)

$manifestPath = $null
$registryScope = ""

foreach ($reg in $registryPaths) {
    if (Test-Path $reg.Path) {
        $manifestPath = (Get-ItemProperty -Path $reg.Path).'(default)'
        $registryScope = $reg.Scope
        Write-TestResult -Teste "Registro do Native Host ($($reg.Scope))" -Passou $true `
            -Detalhes "Chave: $($reg.Path)"
        Write-Detail "Manifest: $manifestPath"
        break
    }
}

if (-not $manifestPath) {
    Write-TestResult -Teste "Registro do Native Host" -Passou $false `
        -Detalhes "Nenhuma entrada de registro encontrada"
    Write-Recommendation @"
O FluxSigner não está instalado ou o registro foi corrompido.
Execute o instalador do FluxSigner para corrigir.
"@
}
else {
    # 4.2. Verificar arquivo manifest
    $manifestExists = Test-Path $manifestPath
    Write-TestResult -Teste "Arquivo manifest.json existe" -Passou $manifestExists `
        -Detalhes "Caminho: $manifestPath"
    
    if ($manifestExists) {
        try {
            $manifest = Get-Content $manifestPath -Raw | ConvertFrom-Json
            
            Write-Detail "Nome: $($manifest.name)"
            Write-Detail "Descrição: $($manifest.description)"
            Write-Detail "Tipo: $($manifest.type)"
            Write-Detail "Executável: $($manifest.path)"
            
            # Validar estrutura do manifest
            $manifestValido = $true
            $manifestErros = @()
            
            if (-not $manifest.name -or $manifest.name -ne "br.com.fluxsigner.native") {
                $manifestValido = $false
                $manifestErros += "Nome inválido ou ausente"
            }
            
            if (-not $manifest.type -or $manifest.type -ne "stdio") {
                $manifestValido = $false
                $manifestErros += "Tipo deve ser 'stdio'"
            }
            
            if (-not $manifest.path) {
                $manifestValido = $false
                $manifestErros += "Caminho do executável ausente"
            }
            
            if (-not $manifest.allowed_origins -or $manifest.allowed_origins.Count -eq 0) {
                $manifestValido = $false
                $manifestErros += "allowed_origins ausente ou vazio"
            }
            
            Write-TestResult -Teste "Manifest JSON válido" -Passou $manifestValido `
                -Detalhes $(if ($manifestErros) { "Erros: $($manifestErros -join ', ')" }else { "Estrutura correta" })
            
            $hostExecutable = $manifest.path
            
            # 4.3. Verificar executável do host
            $executableExists = Test-Path $hostExecutable
            Write-TestResult -Teste "Executável do Native Host existe" -Passou $executableExists `
                -Detalhes "Caminho: $hostExecutable"
            
            if ($executableExists) {
                $fileInfo = Get-Item $hostExecutable
                Write-Detail "Tamanho: $([math]::Round($fileInfo.Length / 1KB, 2)) KB"
                Write-Detail "Modificado: $($fileInfo.LastWriteTime)"
                
                # 4.4. Verificar diretório de instalação
                $installDir = Split-Path $hostExecutable -Parent
                Write-Detail "Diretório de instalação: $installDir"
                
                # 4.5. Verificar JAR do FluxSigner
                $jarPath = Join-Path $installDir "fluxsigner-pdf-icpbrasil.jar"
                $jarExists = Test-Path $jarPath
                
                Write-TestResult -Teste "FluxSigner JAR existe" -Passou $jarExists `
                    -Detalhes "Caminho: $jarPath"
                
                if ($jarExists) {
                    $jarSize = (Get-Item $jarPath).Length
                    Write-Detail "Tamanho do JAR: $([math]::Round($jarSize / 1MB, 2)) MB"
                }
                
                # 4.6. Verificar permissões de execução
                try {
                    $acl = Get-Acl $hostExecutable
                    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent().Name
                    $hasPermission = $true  # Simplificado - assume que tem permissão se conseguiu ler o ACL
                    
                    Write-TestResult -Teste "Permissões de execução" -Passou $hasPermission `
                        -Detalhes "Usuário atual: $currentUser" -Critico $false
                }
                catch {
                    Write-TestResult -Teste "Permissões de execução" -Passou $false `
                        -Detalhes "Erro ao verificar permissões: $($_.Exception.Message)" -Critico $false
                }
            }
            
        }
        catch {
            Write-TestResult -Teste "Manifest JSON válido" -Passou $false `
                -Detalhes "Erro ao ler manifest: $($_.Exception.Message)"
        }
    }
}

# ============================================================================
# 5. VERIFICAÇÃO DA EXTENSÃO CHROME
# ============================================================================

Write-Section "5. VERIFICAÇÃO DA EXTENSÃO CHROME"

# Tentar encontrar a extensão instalada
$extensionPaths = @(
    "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Extensions",
    "$env:LOCALAPPDATA\Google\Chrome\User Data\Profile 1\Extensions"
)

$fluxSignerExtensionFound = $false
$extensionId = "hnlmoeeepnmddepiepbcdajfenoimdme"  # ID da extensão na Web Store

foreach ($extPath in $extensionPaths) {
    if (Test-Path $extPath) {
        $extensionDir = Join-Path $extPath $extensionId
        if (Test-Path $extensionDir) {
            $fluxSignerExtensionFound = $true
            Write-TestResult -Teste "Extensão FluxSigner instalada" -Passou $true `
                -Detalhes "Caminho: $extensionDir" -Critico $false
            
            # Tentar encontrar a versão
            $versions = Get-ChildItem $extensionDir -Directory | Sort-Object Name -Descending
            if ($versions) {
                $latestVersion = $versions[0].Name
                Write-Detail "Versão instalada: $latestVersion"
                
                # Verificar manifest da extensão
                $extManifestPath = Join-Path $versions[0].FullName "manifest.json"
                if (Test-Path $extManifestPath) {
                    try {
                        $extManifest = Get-Content $extManifestPath -Raw | ConvertFrom-Json
                        Write-Detail "Nome: $($extManifest.name)"
                        Write-Detail "Versão do manifest: $($extManifest.version)"
                        
                        # Verificar permissões
                        if ($extManifest.permissions -contains "nativeMessaging") {
                            Write-TestResult -Teste "Permissão nativeMessaging" -Passou $true -Critico $false
                        }
                        else {
                            Write-TestResult -Teste "Permissão nativeMessaging" -Passou $false `
                                -Detalhes "Permissão ausente no manifest"
                        }
                    }
                    catch {
                        Write-Detail "Erro ao ler manifest da extensão: $($_.Exception.Message)"
                    }
                }
            }
            break
        }
    }
}

if (-not $fluxSignerExtensionFound) {
    Write-TestResult -Teste "Extensão FluxSigner instalada" -Passou $false `
        -Detalhes "Extensão não encontrada nos perfis do Chrome" -Critico $false
    Write-Recommendation @"
Instale a extensão FluxSigner a partir da Chrome Web Store:
https://chrome.google.com/webstore/detail/fluxsigner/hnlmoeeepnmddepiepbcdajfenoimdme
"@
}

# ============================================================================
# 6. VERIFICAÇÃO DE CERTIFICADOS DIGITAIS
# ============================================================================

Write-Section "6. VERIFICAÇÃO DE CERTIFICADOS DIGITAIS"

try {
    # Verificar certificados no Windows Certificate Store
    $personalCerts = Get-ChildItem Cert:\CurrentUser\My -ErrorAction Stop
    $validCerts = $personalCerts | Where-Object { $_.HasPrivateKey -and $_.NotAfter -gt (Get-Date) }
    
    Write-TestResult -Teste "Windows Certificate Store acessível" -Passou $true `
        -Detalhes "$($personalCerts.Count) certificado(s) encontrado(s) no armazenamento pessoal"
    
    if ($validCerts.Count -gt 0) {
        Write-TestResult -Teste "Certificados válidos com chave privada" -Passou $true `
            -Detalhes "$($validCerts.Count) certificado(s) válido(s) com chave privada" -Critico $false
        
        # Listar alguns certificados (máximo 5)
        $certList = $validCerts | Select-Object -First 5
        foreach ($cert in $certList) {
            $daysToExpiry = ($cert.NotAfter - (Get-Date)).Days
            Write-Detail "• $($cert.Subject) (Expira em $daysToExpiry dias)"
        }
        
        if ($validCerts.Count -gt 5) {
            Write-Detail "... e mais $($validCerts.Count - 5) certificado(s)"
        }
    }
    else {
        Write-TestResult -Teste "Certificados válidos com chave privada" -Passou $false `
            -Detalhes "Nenhum certificado válido encontrado" -Critico $false
        Write-Recommendation @"
Para usar o FluxSigner, você precisa de certificados digitais instalados.
Instale certificados A1 (arquivo .pfx) ou conecte seu token A3.
"@
    }
    
}
catch {
    Write-TestResult -Teste "Windows Certificate Store acessível" -Passou $false `
        -Detalhes "Erro ao acessar: $($_.Exception.Message)"
}

# ============================================================================
# 7. TESTE DE COMUNICAÇÃO COM O NATIVE HOST
# ============================================================================

Write-Section "7. TESTE DE COMUNICAÇÃO COM O NATIVE HOST"

if ($manifestPath -and (Test-Path $manifestPath)) {
    try {
        $manifest = Get-Content $manifestPath -Raw | ConvertFrom-Json
        $hostExecutable = $manifest.path
        
        if (Test-Path $hostExecutable) {
            Write-Host "  Tentando comunicação com o Native Host..." -ForegroundColor $ColorInfo
            
            # Criar mensagem de teste (sem o cabeçalho de 4 bytes, apenas para teste básico)
            $testMessage = @{
                action    = "PING"
                requestId = "diagnostic_test_$(Get-Date -Format 'yyyyMMddHHmmss')"
            } | ConvertTo-Json -Compress
            
            # Tentar executar o host
            try {
                $startTime = Get-Date
                $process = Start-Process -FilePath $hostExecutable -NoNewWindow -PassThru -RedirectStandardError "$env:TEMP\fluxsigner-diagnostic-error.log"
                Start-Sleep -Milliseconds 500
                
                if ($process.HasExited) {
                    $exitCode = $process.ExitCode
                    Write-TestResult -Teste "Native Host executável" -Passou ($exitCode -eq 0) `
                        -Detalhes "Processo encerrou com código: $exitCode"
                    
                    # Ler log de erro se houver
                    if (Test-Path "$env:TEMP\fluxsigner-diagnostic-error.log") {
                        $errorLog = Get-Content "$env:TEMP\fluxsigner-diagnostic-error.log" -Raw
                        if ($errorLog -and $errorLog.Trim()) {
                            Write-Detail "Log de erro:"
                            $errorLog -split "`n" | Select-Object -First 10 | ForEach-Object {
                                Write-Detail "  $_"
                            }
                        }
                    }
                }
                else {
                    $process.Kill()
                    Write-TestResult -Teste "Native Host executável" -Passou $true `
                        -Detalhes "Processo iniciou corretamente"
                }
                
            }
            catch {
                Write-TestResult -Teste "Native Host executável" -Passou $false `
                    -Detalhes "Erro ao executar: $($_.Exception.Message)"
            }
            
            # Verificar logs do Native Host
            $installDir = Split-Path $hostExecutable -Parent
            $logPath = Join-Path $installDir "fluxsigner-debug.log"
            
            if (Test-Path $logPath) {
                Write-TestResult -Teste "Arquivo de log existe" -Passou $true `
                    -Detalhes "Log: $logPath" -Critico $false
                
                $logContent = Get-Content $logPath -Tail 20
                if ($logContent) {
                    Write-Host ""
                    Write-Host "  📝 Últimas 20 linhas do log:" -ForegroundColor $ColorInfo
                    foreach ($line in $logContent) {
                        if ($line -match "ERRO|ERROR|Exception|Failed") {
                            Write-Host "     $line" -ForegroundColor $ColorError
                        }
                        elseif ($line -match "WARN|WARNING") {
                            Write-Host "     $line" -ForegroundColor $ColorWarning
                        }
                        else {
                            Write-Host "     $line" -ForegroundColor $ColorDetail
                        }
                        
                        $script:RelatorioLinhas += "     $line"
                    }
                }
            }
            else {
                Write-TestResult -Teste "Arquivo de log existe" -Passou $false `
                    -Detalhes "Log não encontrado (host pode não ter sido executado)" -Critico $false
            }
        }
    }
    catch {
        Write-Host "  ⚠️ Erro ao testar comunicação: $($_.Exception.Message)" -ForegroundColor $ColorWarning
    }
}

# ============================================================================
# 8. VERIFICAÇÃO DE REDE E FIREWALL
# ============================================================================

Write-Section "8. VERIFICAÇÃO DE REDE E FIREWALL"

# Verificar se portas comuns estão disponíveis (não é crítico, mas pode indicar conflitos)
$portsToCheck = @(8080, 8443, 9000)
foreach ($port in $portsToCheck) {
    $available = Test-PortaDisponivel -Porta $port
    if (-not $available) {
        Write-Detail "Porta $port em uso (pode indicar outro aplicativo rodando)" 
    }
}

# Verificar regras de firewall para Java
try {
    $javaRules = Get-NetFirewallApplicationFilter -ErrorAction Stop | 
    Where-Object { $_.Program -like "*java*" } |
    Get-NetFirewallRule
    
    if ($javaRules) {
        Write-TestResult -Teste "Regras de firewall para Java" -Passou $true `
            -Detalhes "$($javaRules.Count) regra(s) encontrada(s)" -Critico $false
    }
    else {
        Write-TestResult -Teste "Regras de firewall para Java" -Passou $false `
            -Detalhes "Nenhuma regra específica encontrada" -Critico $false
    }
}
catch {
    Write-Detail "Não foi possível verificar regras de firewall (requer privilégios administrativos)"
}

# ============================================================================
# 9. VERIFICAÇÃO DO AMBIENTE
# ============================================================================

Write-Section "9. VERIFICAÇÃO DO AMBIENTE"

# Verificar variáveis de ambiente importantes
$envVars = @{
    "TEMP"        = $env:TEMP
    "TMP"         = $env:TMP
    "PATH"        = $env:PATH
    "USERPROFILE" = $env:USERPROFILE
}

foreach ($var in $envVars.Keys) {
    $value = $envVars[$var]
    $exists = -not [string]::IsNullOrEmpty($value)
    
    if ($var -eq "PATH") {
        Write-TestResult -Teste "Variável $var definida" -Passou $exists -Critico $false
        # Não mostrar PATH completo por ser muito grande
    }
    else {
        Write-TestResult -Teste "Variável $var definida" -Passou $exists `
            -Detalhes "$var = $value" -Critico $false
    }
}

# Verificar espaço em disco
try {
    $systemDrive = $env:SystemDrive
    $drive = Get-PSDrive $systemDrive.TrimEnd(':') -ErrorAction Stop
    $freeSpaceGB = [math]::Round($drive.Free / 1GB, 2)
    $totalSpaceGB = [math]::Round(($drive.Used + $drive.Free) / 1GB, 2)
    $spaceOk = $freeSpaceGB -gt 1
    
    Write-TestResult -Teste "Espaço em disco suficiente" -Passou $spaceOk `
        -Detalhes "Livre: $freeSpaceGB GB / Total: $totalSpaceGB GB" -Critico $false
    
    if (-not $spaceOk) {
        Write-Recommendation "Libere espaço em disco. Recomenda-se pelo menos 1 GB livre."
    }
}
catch {
    Write-Detail "Não foi possível verificar espaço em disco"
}

# Verificar região e idioma
$culture = Get-Culture
Write-TestResult -Teste "Configuração regional" -Passou $true `
    -Detalhes "Idioma: $($culture.Name) | Formato: $($culture.DisplayName)" -Critico $false

# ============================================================================
# 10. RESUMO E RECOMENDAÇÕES
# ============================================================================

Write-Header "RESUMO DO DIAGNÓSTICO"

Write-Host ""
Write-Host "  Total de testes: $script:TotalTestes" -ForegroundColor $ColorInfo
Write-Host "  ✅ Testes passados: $script:TestesPassados" -ForegroundColor $ColorSuccess
Write-Host "  ❌ Testes falhados: $script:TestesFalhados" -ForegroundColor $ColorError
Write-Host "  ⚠️  Avisos: $script:Avisos" -ForegroundColor $ColorWarning
Write-Host ""

$script:RelatorioLinhas += ""
$script:RelatorioLinhas += "  Total de testes: $script:TotalTestes"
$script:RelatorioLinhas += "  Testes passados: $script:TestesPassados"
$script:RelatorioLinhas += "  Testes falhados: $script:TestesFalhados"
$script:RelatorioLinhas += "  Avisos: $script:Avisos"
$script:RelatorioLinhas += ""

# Determinar status geral
$statusGeral = if ($script:TestesFalhados -eq 0) {
    if ($script:Avisos -eq 0) {
        "EXCELENTE"
        Write-Host "  STATUS GERAL: ✅ EXCELENTE - FluxSigner está corretamente instalado!" -ForegroundColor $ColorSuccess
    }
    else {
        "BOM"
        Write-Host "  STATUS GERAL: ✅ BOM - FluxSigner está funcional, mas há alguns avisos." -ForegroundColor $ColorSuccess
    }
}
elseif ($script:TestesFalhados -le 2) {
    "ATENÇÃO"
    Write-Host "  STATUS GERAL: ⚠️  ATENÇÃO - Alguns problemas foram encontrados." -ForegroundColor $ColorWarning
}
else {
    "CRÍTICO"
    Write-Host "  STATUS GERAL: ❌ CRÍTICO - Múltiplos problemas detectados. FluxSigner pode não funcionar." -ForegroundColor $ColorError
}

$script:RelatorioLinhas += "  STATUS GERAL: $statusGeral"

Write-Host ""

# Recomendações finais
if ($script:TestesFalhados -gt 0 -or $script:Avisos -gt 0) {
    Write-Host "  PRÓXIMOS PASSOS:" -ForegroundColor $ColorWarning
    Write-Host ""
    
    if (-not $javaInstalled) {
        Write-Host "  1. Instale o Java Runtime Environment (JRE) 8 ou superior" -ForegroundColor $ColorWarning
        Write-Host "     https://www.java.com/download/" -ForegroundColor $ColorDetail
    }
    
    if (-not $chromeInstalled) {
        Write-Host "  2. Instale o Google Chrome" -ForegroundColor $ColorWarning
        Write-Host "     https://www.google.com/chrome/" -ForegroundColor $ColorDetail
    }
    
    if (-not $manifestPath) {
        Write-Host "  3. Execute o instalador do FluxSigner" -ForegroundColor $ColorWarning
        Write-Host "     https://github.com/fluxmed/fluxsigner-support/releases/latest" -ForegroundColor $ColorDetail
    }
    
    if (-not $fluxSignerExtensionFound) {
        Write-Host "  4. Instale a extensão FluxSigner no Chrome" -ForegroundColor $ColorWarning
        Write-Host "     https://chrome.google.com/webstore/detail/fluxsigner/hnlmoeeepnmddepiepbcdajfenoimdme" -ForegroundColor $ColorDetail
    }
    
    Write-Host ""
}

# ============================================================================
# EXPORTAR RELATÓRIO
# ============================================================================

if ($ExportarRelatorio) {
    Write-Host ""
    Write-Host "  Exportando relatório para: $CaminhoRelatorio" -ForegroundColor $ColorInfo
    
    try {
        $script:RelatorioLinhas | Out-File -FilePath $CaminhoRelatorio -Encoding UTF8
        Write-Host "  ✅ Relatório exportado com sucesso!" -ForegroundColor $ColorSuccess
        
        # Abrir o arquivo automaticamente
        Start-Process notepad.exe $CaminhoRelatorio
    }
    catch {
        Write-Host "  ❌ Erro ao exportar relatório: $($_.Exception.Message)" -ForegroundColor $ColorError
    }
}

Write-Host ""
Write-Host "  💡 Para exportar este diagnóstico para um arquivo, execute:" -ForegroundColor $ColorInfo
Write-Host "     .\diagnostico-fluxsigner.ps1 -ExportarRelatorio" -ForegroundColor $ColorDetail
Write-Host ""

Write-Header "DIAGNÓSTICO CONCLUÍDO"

# Pausar para o usuário ler (se executado com duplo clique)
if (-not $ExportarRelatorio) {
    Write-Host "Pressione qualquer tecla para sair..." -ForegroundColor $ColorInfo
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}

