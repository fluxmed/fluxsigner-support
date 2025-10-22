# Política de Privacidade - FluxSigner

**Última atualização:** 2 de outubro de 2025  
**Versão:** 2.0.0

## 1. Introdução

O FluxSigner ("nós", "nosso" ou "extensão") respeita sua privacidade e está comprometido em proteger seus dados pessoais. Esta política de privacidade explica como coletamos, usamos e protegemos suas informações ao usar nossa extensão de navegador para assinatura digital de documentos PDF com certificados ICP-Brasil.

## 2. Informações que Coletamos

### 2.1 Dados Processados Localmente

O FluxSigner **NÃO coleta, armazena ou transmite** para servidores externos quaisquer dados. Todos os processos ocorrem localmente em seu computador:

- **Documentos PDF**: Os arquivos selecionados para assinatura são processados apenas localmente em seu computador
- **Certificados Digitais**: Os certificados são acessados diretamente do Windows Certificate Store ou keystore local
- **Dados de Assinatura**: Informações como motivo e local da assinatura são usados apenas para gerar a assinatura digital
- **Logs de Atividade**: Logs técnicos são mantidos apenas na memória da extensão durante a sessão

### 2.2 Armazenamento Local

A extensão pode armazenar localmente no navegador (usando Chrome Storage API):
- Preferências do usuário (última configuração de motivo/local de assinatura)
- Lista de certificados disponíveis (apenas aliases, sem chaves privadas)

**Importante:** Nenhum dado armazenado localmente é transmitido para servidores externos.

## 3. Como Usamos suas Informações

As informações são usadas exclusivamente para:
- Processar assinaturas digitais em documentos PDF
- Gerenciar certificados digitais instalados
- Verificar assinaturas digitais existentes
- Melhorar a experiência do usuário através de preferências salvas

## 4. Compartilhamento de Dados

**O FluxSigner NÃO compartilha dados com terceiros.** A extensão:
- ✅ Opera completamente offline (exceto para verificação de TSA se habilitada)
- ✅ Não possui servidores próprios
- ✅ Não envia dados para análise ou telemetria
- ✅ Não usa serviços de rastreamento ou analytics

### 4.1 Timestamp Authority (TSA) - Opcional

Se você optar por usar carimbos de tempo em suas assinaturas:
- A extensão pode conectar-se a servidores TSA autorizados pela ICP-Brasil
- Apenas o hash criptográfico do documento é enviado (não o documento completo)
- Esta funcionalidade é **opcional** e controlada pelo usuário

## 5. Segurança dos Dados

Implementamos medidas de segurança apropriadas:
- **Chaves privadas**: Nunca são expostas ou transmitidas. Permanecem no Windows Certificate Store
- **Documentos**: Processados apenas em memória, sem armazenamento permanente
- **Comunicação local**: Usa Native Messaging do Chrome para comunicação segura com componente nativo
- **Código-fonte**: Disponível publicamente para auditoria

## 6. Permissões da Extensão

A extensão solicita as seguintes permissões:

### 6.1 `nativeMessaging`
**Por que precisamos:** Para comunicação com o componente nativo Java que acessa certificados do Windows.  
**O que fazemos:** Enviamos e recebemos mensagens apenas entre a extensão e o componente nativo local.

### 6.2 `storage`
**Por que precisamos:** Para salvar preferências do usuário localmente.  
**O que fazemos:** Armazenamos apenas configurações não sensíveis (como último motivo/local de assinatura usado).

## 7. Retenção de Dados

- **Preferências do usuário**: Mantidas até que você desinstale a extensão ou limpe os dados
- **Dados temporários**: Apagados automaticamente quando a extensão é fechada
- **Logs**: Mantidos apenas na memória durante a sessão

## 8. Seus Direitos

Você tem o direito de:
- **Acessar**: Ver quais preferências estão armazenadas (através das configurações da extensão)
- **Deletar**: Remover todos os dados armazenados desinstalando a extensão ou limpando dados do Chrome
- **Controlar**: Decidir quais certificados usar e quais documentos assinar

## 9. Conformidade com LGPD

O FluxSigner está em conformidade com a Lei Geral de Proteção de Dados (LGPD - Lei 13.709/2018):
- Processamos apenas dados necessários para a funcionalidade
- Não compartilhamos dados com terceiros
- Você mantém controle total sobre seus dados
- Dados são processados apenas localmente

## 10. Conformidade com ICP-Brasil

A extensão segue os padrões estabelecidos pela Infraestrutura de Chaves Públicas Brasileira:
- Algoritmos criptográficos homologados (SHA-256, RSA)
- Suporte a certificados A1 e A3
- Validação de cadeia de certificação ICP-Brasil
- Formato de assinatura conforme DOC-ICP-15

## 11. Crianças

O FluxSigner não é destinado a menores de 18 anos. Não coletamos intencionalmente informações de crianças.

## 12. Alterações nesta Política

Podemos atualizar esta política periodicamente. Mudanças significativas serão notificadas através:
- Atualização da versão da extensão
- Notificação na interface da extensão
- Publicação no repositório GitHub

## 13. Auditoria e Transparência

Embora o código-fonte do FluxSigner seja proprietário, garantimos
transparência e privacidade através de medidas verificáveis:

### 13.1 Certificações e Conformidade
- ✅ **ICP-Brasil**: Conformidade total com padrões da Infraestrutura de Chaves Públicas Brasileira
- ✅ **LGPD**: Processamento 100% local, sem coleta de dados pessoais
- ✅ **Testes de Segurança**: Auditorias de privacidade regulares
- ✅ **Marco Civil**: Conformidade com Lei 12.965/2014

### 13.2 Como Verificar Nossa Privacidade

Você pode verificar independentemente que não há coleta de dados:

**Monitoramento de Rede:**
- Use ferramentas como **Wireshark** ou **Fiddler**
- Monitore todo tráfego de rede durante o uso
- Verificará que NÃO há transmissões para servidores externos
- Única exceção: TSA (Timestamp Authority) quando explicitamente habilitada

**Monitoramento de Arquivos:**
- Use **Process Monitor** (Microsoft Sysinternals)
- Observe que apenas arquivos locais são acessados
- Nenhum envio de documentos ou certificados

**Firewall:**
- Configure regras de firewall restritivas
- Bloqueie todo tráfego de saída (exceto TSA se usado)
- O FluxSigner continuará funcionando normalmente

### 13.3 Compromisso Formal de Privacidade

**Declaramos formalmente e sob pena da lei que:**

- ❌ **NÃO coletamos** dados pessoais, documentos ou certificados
- ❌ **NÃO usamos** servidores próprios para processamento
- ❌ **NÃO transmitimos** informações para terceiros
- ❌ **NÃO usamos** analytics, telemetria ou rastreamento
- ❌ **NÃO armazenamos** dados em nuvem
- ✅ **TODO processamento** é 100% local no seu computador
- ✅ **Você mantém** controle total dos seus documentos

### 13.4 Código Proprietário e Segurança

O código-fonte do FluxSigner é proprietário por razões de:
- Proteção de propriedade intelectual
- Segurança através de complexidade
- Qualidade e suporte profissional

**Isso NÃO afeta sua privacidade porque:**
- Todo processamento é local (verificável)
- Não há conexões de rede (exceto TSA opcional)
- Seus dados nunca saem do seu computador

**Suporte e Reportes:** https://github.com/fluxmed/fluxsigner-support

## 14. Contato

Para questões sobre privacidade ou esta política:

- **Email:** contato@fluxsigner.com.br
- **GitHub Issues:** https://github.com/fluxmed/fluxsigner-support/issues
- **Responsável:** Equipe FluxSigner

## 15. Declaração de Transparência

**Declaramos explicitamente que:**
- ❌ NÃO coletamos dados pessoais
- ❌ NÃO usamos cookies ou rastreamento
- ❌ NÃO enviamos dados para servidores
- ❌ NÃO vendemos informações
- ❌ NÃO usamos analytics ou telemetria
- ✅ TODO processamento é local
- ✅ Você mantém controle total dos seus documentos e certificados

## 16. Jurisdição e Lei Aplicável

Esta política é regida pelas leis da República Federativa do Brasil. Questões relacionadas à privacidade serão resolvidas de acordo com:
- Lei Geral de Proteção de Dados (Lei 13.709/2018)
- Marco Civil da Internet (Lei 12.965/2014)
- Código de Defesa do Consumidor (Lei 8.078/1990)

---

**Resumo Executivo:**  
O FluxSigner é uma ferramenta de privacidade total. Não coletamos, não armazenamos e não transmitimos seus dados. Tudo acontece localmente em seu computador. Seus documentos e certificados estão seguros e sob seu controle total.

---

*Esta política está disponível em: https://github.com/fluxmed/fluxsigner-support/blob/main/PRIVACY_POLICY.md*


