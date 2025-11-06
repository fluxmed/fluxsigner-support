# 🔍 FluxSigner - Script de Diagnóstico

## Descrição

O script `diagnostico-fluxsigner.ps1` é uma ferramenta completa de diagnóstico que verifica todos os aspectos da instalação e configuração do FluxSigner, identificando problemas e sugerindo soluções.

## Funcionalidades

O script realiza as seguintes verificações:

### 1. **Sistema Operacional**
- Verifica se é Windows 10 ou superior
- Detecta arquitetura (32/64 bits)
- Verifica .NET Framework 4.6.2+

### 2. **Java Runtime**
- Verifica se o Java está instalado
- Valida versão do Java (8 ou superior)
- Verifica se o Java está no PATH
- Checa variável JAVA_HOME (opcional)

### 3. **Google Chrome**
- Verifica se o Chrome está instalado
- Detecta versão do Chrome
- Verifica se há processos do Chrome em execução

### 4. **Instalação do FluxSigner**
- Verifica registro do Native Messaging Host
- Valida arquivo manifest.json
- Verifica executável do Native Host (start.cmd)
- Valida arquivo JAR do FluxSigner
- Verifica permissões de execução

### 5. **Extensão Chrome**
- Detecta se a extensão está instalada
- Verifica versão da extensão
- Valida permissões (nativeMessaging)

### 6. **Certificados Digitais**
- Acessa Windows Certificate Store
- Lista certificados válidos com chave privada
- Mostra certificados próximos do vencimento

### 7. **Comunicação Native Host**
- Testa execução do Native Host
- Verifica logs de erro
- Analisa últimas execuções

### 8. **Rede e Firewall**
- Verifica portas disponíveis
- Checa regras de firewall para Java

### 9. **Ambiente**
- Verifica variáveis de ambiente importantes
- Checa espaço em disco
- Valida configuração regional

### 10. **Resumo e Recomendações**
- Apresenta estatísticas dos testes
- Fornece status geral (EXCELENTE/BOM/ATENÇÃO/CRÍTICO)
- Lista próximos passos para correção de problemas

## Como Usar

### Execução Básica

1. **Abra o PowerShell** (não precisa ser como Administrador)
2. **Navegue até o diretório do script:**
   ```powershell
   cd "C:\Caminho\Para\FluxSigner\Installer"
   ```
3. **Execute o script:**
   ```powershell
   .\diagnostico-fluxsigner.ps1
   ```

### Exportar Relatório

Para salvar o diagnóstico em um arquivo de texto:

```powershell
.\diagnostico-fluxsigner.ps1 -ExportarRelatorio
```

O relatório será salvo em: `%USERPROFILE%\Desktop\FluxSigner-Diagnostico.txt`

### Exportar para Caminho Personalizado

```powershell
.\diagnostico-fluxsigner.ps1 -ExportarRelatorio -CaminhoRelatorio "C:\Meus Documentos\diagnostico.txt"
```

## Interpretação dos Resultados

### Símbolos

- ✅ **OK**: Teste passou com sucesso
- ❌ **FALHOU**: Teste crítico falhou (impede funcionamento)
- ⚠️ **AVISO**: Teste não crítico falhou (pode afetar funcionalidade)

### Status Geral

- **EXCELENTE**: Todos os testes passaram. FluxSigner está perfeitamente configurado.
- **BOM**: Testes críticos passaram, mas há alguns avisos. FluxSigner deve funcionar.
- **ATENÇÃO**: Alguns problemas foram encontrados. Verificar recomendações.
- **CRÍTICO**: Múltiplos problemas detectados. FluxSigner provavelmente não funcionará.

## Solução de Problemas Comuns

### Java não encontrado
```
❌ Java instalado e no PATH
```
**Solução:**
1. Baixe o Java em: https://www.java.com/download/
2. Instale seguindo o assistente
3. Reinicie o computador
4. Execute o diagnóstico novamente

### FluxSigner não registrado
```
❌ Registro do Native Host
```
**Solução:**
1. Execute o instalador do FluxSigner
2. Certifique-se de concluir a instalação
3. Execute o diagnóstico novamente

### Extensão não instalada
```
❌ Extensão FluxSigner instalada
```
**Solução:**
1. Abra o Chrome
2. Acesse: https://chrome.google.com/webstore/detail/fluxsigner/hnlmoeeepnmddepiepbcdajfenoimdme
3. Clique em "Adicionar ao Chrome"
4. Execute o diagnóstico novamente

### Nenhum certificado encontrado
```
⚠️ Certificados válidos com chave privada
```
**Solução:**
- **Certificado A1:** Instale o arquivo .pfx no Windows
- **Certificado A3:** Conecte o token USB e instale o driver

## Distribuição com o Instalador

### Incluir no Instalador

1. Copie `diagnostico-fluxsigner.ps1` para o diretório de instalação
2. Crie um atalho no menu Iniciar:
   - Nome: "FluxSigner - Diagnóstico"
   - Destino: `powershell.exe -ExecutionPolicy Bypass -File "%LOCALAPPDATA%\FluxSigner\diagnostico-fluxsigner.ps1"`
   - Ícone: Use o ícone do FluxSigner

### Script de Instalação

Adicione ao seu instalador NSIS/Inno Setup:

```nsis
; Copiar script de diagnóstico
File "diagnostico-fluxsigner.ps1"

; Criar atalho no menu Iniciar
CreateShortcut "$SMPROGRAMS\FluxSigner\Diagnóstico.lnk" \
    "powershell.exe" \
    '-ExecutionPolicy Bypass -File "$INSTDIR\diagnostico-fluxsigner.ps1"' \
    "$INSTDIR\icon.ico"
```

## Suporte Remoto

### Para Usuários Finais

Se o FluxSigner não estiver funcionando:

1. Execute o diagnóstico:
   ```powershell
   .\diagnostico-fluxsigner.ps1 -ExportarRelatorio
   ```
2. Envie o arquivo `FluxSigner-Diagnostico.txt` para o suporte
3. A equipe de suporte poderá identificar o problema rapidamente

### Para Equipe de Suporte

O relatório exportado contém todas as informações necessárias para diagnóstico remoto:
- Versões de todos os componentes
- Status de cada verificação
- Logs de erro do Native Host
- Configuração do ambiente

## Requisitos

- Windows PowerShell 5.1 ou superior (incluso no Windows 10/11)
- Não requer privilégios de Administrador
- Alguns testes avançados podem exigir permissões elevadas (detectado automaticamente)

## Atualizações

Para atualizar o script de diagnóstico em máquinas já instaladas:

1. Baixe a versão mais recente
2. Substitua o arquivo no diretório de instalação
3. Recomende aos usuários executarem o novo diagnóstico

## Licença

Este script faz parte do FluxSigner e está sob a mesma licença do projeto principal.

---

**FluxSigner v2.1.5** - Sistema de Assinatura Digital ICP-Brasil

