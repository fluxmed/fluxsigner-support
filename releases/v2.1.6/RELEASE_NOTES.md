# 🎉 FluxSigner v2.1.6 - Release Oficial de Produção

**Data de Lançamento:** 28 de Outubro de 2025

**Esta é a versão OFICIAL DE PRODUÇÃO aprovada pela Chrome Web Store.**

---

## ✨ Novidades

### 🆔 ID Oficial da Chrome Web Store

- ✅ **Extensão Aprovada**: ID oficial `gmioenipelgmngkedlphkofnbkjdfigk`
- ✅ **Pronta para Produção**: Extensão disponível na Chrome Web Store oficial
- ✅ **Instalação Simplificada**: Não é mais necessário informar o ID manualmente
- ✅ **Configuração Automática**: Instalador configura automaticamente o ID oficial

### 📦 Melhorias no Instalador

- ✅ **Removido**: Passo de solicitação manual do ID da extensão
- ✅ **Simplificado**: Processo de instalação mais rápido e direto
- ✅ **Inteligente**: Detecta automaticamente IDs de desenvolvimento (se presentes)
- ✅ **Dual-Mode**: Suporta tanto extensão oficial quanto desenvolvimento local

---

## 🔧 Mudanças Técnicas

### Arquivos Atualizados

1. **Host/manifest.json**
   - ID oficial `gmioenipelgmngkedlphkofnbkjdfigk` sempre incluído
   - Suporte opcional para IDs de desenvolvimento

2. **Installer/setup.iss**
   - Removida página de input do ID da extensão
   - ID oficial hardcoded no manifest gerado
   - Processo de instalação simplificado

3. **Cliente React (FluxSignerService.ts)**
   - ID oficial como padrão
   - Detecção automática de IDs alternativos
   - Fallback inteligente

4. **Extensão Chrome (manifest.json)**
   - Versão atualizada para 2.1.6
   - Todas as funcionalidades mantidas

---

## 📥 Instalação

### 1. Instalar o Native Host

```bash
# Baixe e execute o instalador
FluxSignerSetup-2.1.6.exe
```

**O instalador irá:**
- ✅ Copiar arquivos para `%LOCALAPPDATA%\FluxSigner\`
- ✅ Configurar registro do Windows com ID oficial
- ✅ Criar desinstalador
- ✅ Instalar ferramentas de diagnóstico

### 2. Instalar a Extensão Chrome

**Opção A: Chrome Web Store (Recomendado)**

1. Acesse: https://chrome.google.com/webstore
2. Busque por "FluxSigner"
3. Clique em "Adicionar ao Chrome"
4. **Pronto!** A extensão já funcionará automaticamente

**Opção B: Instalação Local (Desenvolvimento)**

1. Baixe `fluxsigner-extension-v2.1.6.zip`
2. Extraia em uma pasta
3. Abra `chrome://extensions/`
4. Ative "Modo do desenvolvedor"
5. Clique em "Carregar sem compactação"
6. Selecione a pasta extraída

### 3. Verificar Instalação

Execute o diagnóstico:

```
Menu Iniciar → FluxSigner → Diagnóstico
```

**Status esperado:** ✅ EXCELENTE ou ✅ BOM

---

## 🆕 Diferenças da v2.1.5

| Aspecto | v2.1.5 | v2.1.6 |
|---------|--------|--------|
| **ID da Extensão** | Manual/Detectado | Oficial Hardcoded |
| **Instalação** | Solicita ID | Automática |
| **Chrome Web Store** | Em aprovação | ✅ Aprovada |
| **Configuração** | Manual possível | Automática |
| **Compatibilidade** | Dev/Test | ✅ Produção |

---

## 🔄 Atualização da v2.1.5

Se você já tem a v2.1.5 instalada:

1. **Execute o novo instalador** - Atualizará automaticamente
2. **Atualize a extensão** na Chrome Web Store (automático)
3. **Reinicie o Chrome** completamente
4. **Execute o diagnóstico** para confirmar

**Observação**: O Native Host continuará funcionando com a extensão antiga até que você atualize pelo Chrome Web Store.

---

## 📊 Requisitos do Sistema

### Requisitos Mínimos
- **Sistema Operacional**: Windows 10 (64-bit) ou superior
- **Java**: JRE 8 ou superior
- **Navegador**: Google Chrome 90+ ou Microsoft Edge 90+
- **Espaço em Disco**: 50 MB livres
- **.NET Framework**: 4.6.2 ou superior

### Requisitos Recomendados
- **Sistema Operacional**: Windows 11 (64-bit)
- **Java**: OpenJDK 17 LTS
- **Navegador**: Google Chrome última versão
- **Memória RAM**: 4 GB ou mais

---

## 📦 Arquivos do Release

### Para Usuários Finais
- **`FluxSignerSetup-2.1.6.exe`** (21.4 MB) - Instalador completo
  - Inclui Native Host Java
  - Inclui script de diagnóstico
  - Configuração automática do ID oficial
  - Suporte a Windows 10/11

### Para Desenvolvedores
- **`fluxsigner-extension-v2.1.6.zip`** (745 KB) - Extensão Chrome
- **`fluxsigner-pdf-icpbrasil.jar`** (22.2 MB) - Native Host standalone
- **`start.cmd`** - Script de inicialização atualizado
- **`manifest-host-example.json`** - Exemplo de configuração

### Ferramentas de Diagnóstico
- **`diagnostico-fluxsigner.ps1`** - Script completo de diagnóstico
- **`Executar-Diagnostico.cmd`** - Launcher amigável
- **`README_DIAGNOSTICO.md`** - Documentação do diagnóstico

### Documentação
- **`FLUXSIGNER_HOOK_DOCUMENTATION.md`** - Arquitetura React + Native Messaging
- **`CHECKSUMS.txt`** - Checksums SHA-256 de todos os arquivos

---

## 🔐 Checksums SHA-256

Para verificar a integridade dos arquivos baixados, consulte o arquivo `CHECKSUMS.txt` incluído no release.

---

## 🐛 Solução de Problemas

### Extensão Não Detectada

**Solução**:
1. Certifique-se de instalar a extensão da Chrome Web Store
2. ID oficial: `gmioenipelgmngkedlphkofnbkjdfigk`
3. Execute o diagnóstico
4. Reinicie o Chrome completamente

### Erro de Comunicação com Native Host

**Solução**:
1. Execute o instalador v2.1.6
2. Certifique-se de que o Java está instalado
3. Execute: `Menu Iniciar → FluxSigner → Diagnóstico`
4. Verifique os logs em: `%LOCALAPPDATA%\FluxSigner\fluxsigner-debug.log`

### Certificados Não Aparecem

**Solução**:
1. Verifique se há certificados instalados no Windows (`certmgr.msc`)
2. Certifique-se de que os certificados têm chave privada
3. Para certificados A3: Conecte o token USB
4. Execute o diagnóstico → seção "Certificados Digitais"

---

## 🆘 Suporte

### Relatório de Bugs

1. Execute o diagnóstico e exporte:
   ```powershell
   .\diagnostico-fluxsigner.ps1 -ExportarRelatorio
   ```

2. Abra uma issue no GitHub:
   - https://github.com/fluxmed/fluxsigner-support/issues
   - Anexe o arquivo `FluxSigner-Diagnostico.txt`
   - Descreva o problema detalhadamente

### Links Úteis

- **Documentação Completa**: https://github.com/fluxmed/fluxsigner-support
- **Chrome Web Store**: https://chrome.google.com/webstore (busque "FluxSigner")
- **Releases**: https://github.com/fluxmed/fluxsigner-support/releases

---

## 📝 Changelog Completo

### ✨ Adicionado
- ✅ ID oficial da Chrome Web Store (`gmioenipelgmngkedlphkofnbkjdfigk`)
- ✅ Configuração automática do ID no instalador
- ✅ Detecção inteligente de IDs de desenvolvimento
- ✅ Suporte dual-mode (produção + desenvolvimento)

### 🔧 Melhorado
- ✅ Processo de instalação simplificado (sem input manual)
- ✅ Experiência do usuário mais fluida
- ✅ Logs mais claros sobre IDs configurados
- ✅ Compatibilidade com Chrome Web Store oficial

### ❌ Removido
- ❌ Página de solicitação manual do ID da extensão
- ❌ Validação de formato de ID durante instalação
- ❌ Necessidade de configuração manual pós-instalação

---

## 🎯 Compatibilidade

### ✅ Compatível Com:
- Extensão oficial da Chrome Web Store
- IDs de desenvolvimento local (detectados automaticamente)
- Versões anteriores do Native Host
- Certificados A1 e A3 ICP-Brasil
- Windows 10, Windows 11

### ⚠️ Requer Atualização:
- Se você usa ID de extensão manual, considere migrar para a versão oficial

---

## 📅 Próximos Passos

### Uso Recomendado

1. **Para Novos Usuários**:
   - Instale a extensão da Chrome Web Store
   - Execute o instalador v2.1.6
   - Pronto para usar!

2. **Para Usuários Existentes**:
   - Atualize para a extensão oficial (Chrome Web Store)
   - Execute o instalador v2.1.6 (sobrescreverá v2.1.5)
   - Reinicie o Chrome
   - Verifique com diagnóstico

### Roadmap v2.2.0
- Interface gráfica para diagnóstico
- Auto-update automático
- Suporte a múltiplos servidores TSA
- Telemetria opcional (opt-in)

---

## 🎉 Conclusão

**FluxSigner v2.1.6 marca a transição oficial para produção na Chrome Web Store.**

Esta versão elimina barreiras de configuração e oferece uma experiência de instalação profissional e simplificada para todos os usuários.

**Instale agora e comece a assinar documentos digitalmente com certificados ICP-Brasil!**

---

**FluxSigner v2.1.6** - Release Oficial de Produção  
*Desenvolvido com ❤️ pela equipe FluxMed*

**ID Oficial**: `gmioenipelgmngkedlphkofnbkjdfigk`

