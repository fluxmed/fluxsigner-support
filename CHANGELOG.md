# 📋 **CHANGELOG - FLUXSIGNER**

## **🐛 Versão 2.1.1** - **(2025-10-13)**

### **🔥 Correções Críticas**

#### **🌐 Correção de Codificação UTF-8**
- 🐛 **CORRIGIDO**: Caracteres especiais (ç, á, é, ã, etc.) eram corrompidos na comunicação
- 🐛 **CORRIGIDO**: Mensagens do host nativo não chegavam ao Chrome (timeout)
- ✅ **Adicionado**: Flag `-Dfile.encoding=UTF-8` no start.cmd
- ✅ **Configuração UTF-8**: Garantida em ambiente Windows (chcp 65001)

#### **📦 Correção do Instalador**
- 🐛 **CORRIGIDO**: Instalador de produção apontava diretamente para JAR (sem UTF-8)
- ✅ **ALTERADO**: Manifest agora aponta para start.cmd (garante configuração correta)
- ✅ **CRIADO**: start.cmd específico para produção (sem logs de debug)

#### **🔍 Melhorias de Diagnóstico**
- ✅ **Adicionado**: Logs detalhados no background.js para debugging
- ✅ **Adicionado**: Sistema de timeout (30s) para requisições ao host nativo
- ✅ **Adicionado**: Tracking de requisições pendentes
- ✅ **Melhorado**: Mensagens de erro mais descritivas

### **📚 Documentação**
- ✅ **CRIADO**: Documentação Dev vs Produção (`docs/development/DEV_VS_PRODUCTION.md`)
- ✅ **ADICIONADO**: Script de monitoramento de logs (`Host/monitor-log.ps1`)
- ✅ **ADICIONADO**: Guia de troubleshooting para problemas de comunicação

### **⚠️ Importante**
Se você instalou a versão 2.1.0, **recomendamos atualizar para 2.1.1** para garantir funcionamento correto com caracteres acentuados.

---

## **🆕 Versão 2.1.0** - **(2024-09-25)**

### **✨ Novas Funcionalidades**

#### **⏰ TIMESTAMP CONFIÁVEL (TSA)**
- ✅ **Implementação completa de timestamp** para assinaturas A1 ICP-Brasil
- ✅ **Suporte a múltiplas TSAs** com failover automático:
  - ITI (Instituto Nacional de Tecnologia da Informação)
  - SERPRO (Serviço Federal de Processamento de Dados)
  - Receita Federal (Secretaria da Receita Federal)
  - Certisign (Autoridade Certificadora)
- ✅ **Validação robusta de timestamp** em assinaturas existentes
- ✅ **API atualizada** com parâmetro `useTimestamp`
- ✅ **Documentação completa** com exemplos de uso

#### **📋 API Melhorada**
- ✅ **Novo parâmetro**: `useTimestamp` na ação `SIGN_PDF`
- ✅ **Novos campos de resposta**: `timestampUsed` e `timestampValidation`
- ✅ **Verificação aprimorada**: Validação automática de timestamp em `VERIFY_PDF_SIGNATURES`

### **🔧 Melhorias Técnicas**
- ✅ **Classe TSAService**: Gerenciamento completo de comunicação TSA
- ✅ **Validação RFC 3161**: Implementação conforme padrão internacional
- ✅ **Cache inteligente**: Otimização de performance para tokens de timestamp
- ✅ **Logs detalhados**: Rastreamento completo para auditoria e debug

### **📚 Documentação**
- ✅ **API Documentation atualizada** com seção completa sobre timestamp
- ✅ **Exemplos práticos** de uso da funcionalidade
- ✅ **Códigos de erro** específicos para timestamp (TSA_ERROR, TSA_TIMEOUT, etc.)

### **🛡️ Segurança e Conformidade**
- ✅ **Conformidade ICP-Brasil** para certificados A1
- ✅ **Validação criptográfica** de tokens de timestamp
- ✅ **Verificação de integridade** de hash SHA-256
- ✅ **Proteção contra replay** com nonce único

---

## **🔄 Versão 2.0.0** - **(2024-01-15)**

### **✨ Principais Melhorias**

#### **🔧 Correções de Concorrência**
- ✅ **Sistema de fila de mensagens** para evitar conflitos
- ✅ **Processamento sequencial** garantido
- ✅ **Retry automático** em falhas temporárias
- ✅ **Timeout configurável** (60s para PDFs)

#### **🔧 Correções de Serialização**
- ✅ **@JsonIgnore** para campos não serializáveis
- ✅ **Limpeza de certificados** antes da serialização
- ✅ **Formatação segura** de informações como strings JSON
- ✅ **Tratamento robusto** de erros de serialização

#### **🔧 Modo de Desenvolvimento**
- ✅ **Certificados de teste** aceitos automaticamente
- ✅ **Validação relaxada** para desenvolvimento
- ✅ **Configuração via propriedade** `fluxsigner.development`
- ✅ **Scripts PowerShell** para gerenciamento

### **🏗️ Arquitetura**
- ✅ **Refatoração completa** do sistema de mensagens
- ✅ **Descoberta unificada** de certificados
- ✅ **Gerenciamento aprimorado** de keystores Windows
- ✅ **Validação ICP-Brasil** otimizada

### **📊 Performance**
- ✅ **Cache de validação** ICP-Brasil (TTL: 1 hora)
- ✅ **Processamento assíncrono** de descoberta
- ✅ **Timeouts configuráveis** por operação
- ✅ **Logs estruturados** para análise

---

## **📋 Versão 1.0.0** - **(2023-12-01)**

### **🎯 Funcionalidades Iniciais**
- ✅ **Assinatura digital** de documentos PDF
- ✅ **Suporte ICP-Brasil** (A1 e A3)
- ✅ **Integração Chrome** via Native Messaging
- ✅ **Gerenciamento de certificados** Windows Store
- ✅ **Interface web** para seleção de certificados
- ✅ **Validação de assinaturas** digitais

### **🔐 Segurança**
- ✅ **Validação de cadeia** de certificação
- ✅ **Verificação OCSP** e CRL
- ✅ **Sanitização** de entrada
- ✅ **Logs de auditoria** completos

### **📚 Documentação**
- ✅ **API Documentation** completa
- ✅ **Guias de instalação** e configuração
- ✅ **Exemplos de uso** e testes
- ✅ **Troubleshooting** detalhado

---

## **🔮 Roadmap Futuro**

### **Versão 2.2** *(Planejado)*
- [ ] **Assinatura em lote** de múltiplos documentos
- [ ] **Suporte XML** (XAdES) para NF-e
- [ ] **Interface gráfica** standalone
- [ ] **Backup automático** de certificados

### **Versão 3.0** *(Futuro)*
- [ ] **Suporte multiplataforma** (Linux/Mac)
- [ ] **API REST** para integração externa
- [ ] **Assinatura em nuvem** (HSM remoto)
- [ ] **Mobile app** para validação

---

<div align="center">

**📋 FluxSigner Changelog**

*Mantendo você informado sobre todas as novidades e melhorias*

</div>