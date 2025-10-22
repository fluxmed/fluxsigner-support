# FluxSigner - Suporte e Documentação

**Software Gratuito para Assinatura Digital ICP-Brasil**

> 🆓 **Freeware** - Uso gratuito ilimitado  
> 🔐 **100% Local** - Zero coleta de dados  
> ✅ **ICP-Brasil** - Totalmente compatível

---

## 📥 Downloads

### **Última Versão: 2.1.4**

| Componente | Download | Tamanho | Plataforma |
|------------|----------|---------|------------|
| **Instalador Completo** | [FluxSignerSetup-2.1.4.exe](https://github.com/fluxmed/fluxsigner-support/releases/latest) | ~25 MB | Windows 10/11 |
| **Extensão Chrome** | [fluxsigner-extension-2.1.4.zip](https://github.com/fluxmed/fluxsigner-support/releases/latest) | ~2 MB | Chrome/Edge |
| **Native Host (JAR)** | [fluxsigner-pdf-icpbrasil.jar](https://github.com/fluxmed/fluxsigner-support/releases/latest) | ~22 MB | Java 11+ |

📋 **[Ver todas as versões →](https://github.com/fluxmed/fluxsigner-support/releases)**

---

## 🚀 Instalação Rápida

### **2 Passos Simples:**

1. **Instalar Native Host**
   ```
   1. Baixe FluxSignerSetup-2.1.4.exe
   2. Execute o instalador
   3. Siga as instruções
   ```

2. **Instalar Extensão**
   ```
   1. Baixe fluxsigner-extension-2.1.4.zip
   2. Descompacte o arquivo
   3. Abra chrome://extensions/
   4. Ative "Modo desenvolvedor"
   5. Clique "Carregar sem compactação"
   6. Selecione a pasta descompactada
   ```

✅ **Pronto!** Clique no ícone da extensão e comece a assinar.

📖 **[Guia de Instalação Detalhado →](docs/INSTALLATION.md)**

---

## 📚 Documentação

### 🎯 Primeiros Passos
- **[Instalação Completa](docs/INSTALLATION.md)** - Guia passo a passo
- **[Primeiro Uso](docs/PRIMEIRO_USO.md)** - Como assinar seu primeiro documento
- **[Configuração de Certificados](docs/CERTIFICADOS.md)** - Instalar e gerenciar certificados

### 🔧 Uso Avançado
- **[API Documentation](API_DOCUMENTATION.md)** - Referência completa da API
- **[Integração React](docs/INTEGRACAO_REACT.md)** - Hook `useFluxSigner`
- **[Native Messaging](docs/NATIVE_MESSAGING.md)** - Protocolo de comunicação

### 🐛 Solução de Problemas
- **[Troubleshooting](docs/TROUBLESHOOTING.md)** - Problemas comuns e soluções
- **[FAQ](docs/FAQ.md)** - Perguntas frequentes
- **[Diagnóstico](docs/DIAGNOSTICO.md)** - Ferramentas de diagnóstico

### 📖 Referência
- **[Changelog](CHANGELOG.md)** - Histórico de versões
- **[Privacy Policy](PRIVACY_POLICY.md)** - Política de privacidade
- **[Licença](LICENSE.md)** - Termos de uso freeware

---

## ✨ Recursos

### **Assinatura Digital**
- ✅ Padrão PAdES (PDF Advanced Electronic Signatures)
- ✅ Múltiplas assinaturas no mesmo documento
- ✅ Timestamp TSA confiável opcional
- ✅ Motivo e local personalizáveis
- ✅ Download automático

### **Certificados Suportados**
- ✅ A1 (arquivo .pfx/.p12)
- ✅ A3 (cartão/token USB)
- ✅ A4 (nuvem ICP-Brasil)
- ✅ Windows Certificate Store
- ✅ Validação automática ICP-Brasil

### **Verificação**
- ✅ Integridade do documento
- ✅ Validade do certificado
- ✅ Cadeia de certificação
- ✅ Timestamp TSA
- ✅ Status de revogação (LCR/OCSP)

---

## 🆘 Suporte

### **Reportar Problemas**
Encontrou um bug? [Abra uma issue →](https://github.com/fluxmed/fluxsigner-support/issues/new?template=bug_report.md)

### **Solicitar Funcionalidade**
Tem uma sugestão? [Solicite aqui →](https://github.com/fluxmed/fluxsigner-support/issues/new?template=feature_request.md)

### **Perguntas**
Precisa de ajuda? [GitHub Discussions →](https://github.com/fluxmed/fluxsigner-support/discussions)

### **Contato Direto**
📧 Email: contato@fluxsigner.com.br

---

## 🔐 Privacidade e Segurança

### **Privacidade Total**
- ❌ **Não coletamos** documentos ou dados pessoais
- ❌ **Não transmitimos** informações para servidores
- ❌ **Não usamos** analytics ou telemetria
- ✅ **Processamento 100% local** no seu computador

### **Como Verificar**
```powershell
# Monitorar tráfego de rede (Wireshark)
# Você verá: NENHUMA transmissão de dados

# Monitorar arquivos acessados (Process Monitor)
# Você verá: Apenas arquivos locais
```

📄 **[Política de Privacidade Completa →](PRIVACY_POLICY.md)**

### **Conformidade**
- ✅ ICP-Brasil compliant
- ✅ LGPD (Lei 13.709/2018)
- ✅ Marco Civil (Lei 12.965/2014)

---

## 💡 Casos de Uso

### **Empresas**
- Assinar contratos e documentos internos
- Conformidade legal brasileira
- Integração com workflows
- **100% gratuito para uso comercial**

### **Profissionais**
- Advogados: Petições e procurações
- Contadores: Documentos fiscais
- Médicos: Receitas digitais
- Engenheiros: ART e documentos técnicos

### **Desenvolvedores**
- Integração via API pública
- Hook React (`useFluxSigner`)
- Native Messaging protocol
- Documentação completa

---

## 📈 Roadmap

### **Em Desenvolvimento**
- [ ] Publicação na Chrome Web Store
- [ ] JRE bundled no instalador
- [ ] Assinatura em lote
- [ ] Interface web standalone

### **Planejado**
- [ ] Suporte Linux/Mac
- [ ] Assinatura XML/DOCX
- [ ] API REST
- [ ] Modo offline completo

📋 **[Roadmap Completo →](ROADMAP.md)**

---

## 📊 Estatísticas

![GitHub release (latest by date)](https://img.shields.io/github/v/release/fluxmed/fluxsigner-support?label=Vers%C3%A3o)
![GitHub all releases](https://img.shields.io/github/downloads/fluxmed/fluxsigner-support/total?label=Downloads)
![GitHub issues](https://img.shields.io/github/issues/fluxmed/fluxsigner-support?label=Issues)
![GitHub](https://img.shields.io/github/license/fluxmed/fluxsigner-support?label=Licen%C3%A7a)

---

## ⭐ Avaliações

Gostou do FluxSigner?
- ⭐ Dê uma estrela neste repositório
- 📝 Compartilhe nas redes sociais
- 💬 Recomende para colegas

---

## 📄 Licença

**FluxSigner** é um software **freeware proprietário**.

✅ Uso gratuito ilimitado (pessoal e comercial)  
❌ Código-fonte proprietário e fechado  
❌ Não pode ser redistribuído ou modificado

📋 **[Licença Completa →](LICENSE.md)**

---

## 🏆 Por que FluxSigner?

| Característica | FluxSigner | Concorrentes |
|----------------|------------|--------------|
| **Preço** | 🆓 Gratuito | 💰 Pago |
| **Privacidade** | ✅ 100% Local | ❌ Coleta dados |
| **Limite de Uso** | ✅ Ilimitado | ❌ Limitado |
| **ICP-Brasil** | ✅ Completo | ⚠️ Parcial |
| **Suporte** | ✅ Gratuito | 💰 Pago |

---

## 📞 Links Úteis

- 🌐 **Website:** https://github.com/fluxmed/fluxsigner-support
- 📥 **Downloads:** [Releases](https://github.com/fluxmed/fluxsigner-support/releases)
- 📚 **Documentação:** [Wiki](https://github.com/fluxmed/fluxsigner-support/wiki)
- 🐛 **Issues:** [Bug Tracker](https://github.com/fluxmed/fluxsigner-support/issues)
- 💬 **Discussões:** [Forum](https://github.com/fluxmed/fluxsigner-support/discussions)
- 📧 **Email:** contato@fluxsigner.com.br

---

## 🙏 Agradecimentos

Obrigado por usar o FluxSigner!

Este projeto é mantido com ❤️ pela equipe **FluxMed**.

---

**© 2025 FluxMed - Todos os direitos reservados**

*Assinatura Digital Simples, Segura e Gratuita* 🔐

