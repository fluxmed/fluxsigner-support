# 📋 FluxSigner API Documentation

**Documentação técnica completa da API de comunicação entre Chrome Extension e Native Host**

## 🚀 **Versão 2.0 - Melhorias Implementadas**

### ✅ **Correções de Concorrência**
- **Sistema de fila de mensagens** para evitar conflitos
- **Processamento sequencial** garantido
- **Retry automático** em falhas temporárias
- **Timeout configurável** (60s para PDFs)

### ✅ **Correções de Serialização**
- **@JsonIgnore** para campos não serializáveis
- **Limpeza de certificados** antes da serialização
- **Formatação segura** de informações como strings JSON
- **Tratamento robusto** de erros de serialização

### ✅ **Modo de Desenvolvimento**
- **Certificados de teste** aceitos automaticamente
- **Validação relaxada** para desenvolvimento
- **Configuração via propriedade** `fluxsigner.development`
- **Scripts PowerShell** para gerenciamento

---

## 🔄 Protocolo de Comunicação

### **📡 Native Messaging Protocol**

A comunicação entre a extensão Chrome e o aplicativo Java segue o protocolo Native Messaging:

```
Chrome Extension ↔ background.js ↔ Native Host (Java)
```

**Formato das mensagens:**
- ✅ **Encoding:** UTF-8
- ✅ **Format:** JSON
- ✅ **Size limit:** 1MB por mensagem
- ✅ **Timeout:** 60 segundos por operação

---

## 📨 Formato de Mensagens

### **📤 Request (Chrome → Java)**

```json
{
  "action": "AÇÃO_SOLICITADA",
  "requestId": "identificador_único", 
  "data": {
    // Dados específicos da ação
  }
}
```

### **📥 Response (Java → Chrome)**

```json
{
  "requestId": "identificador_único",
  "status": "SUCCESS|ERROR",
  "message": "mensagem_descritiva",
  "data": {
    // Dados de resposta específicos
  },
  "timestamp": "2024-01-15T14:30:25.123Z"
}
```

---

## 🎯 Ações Disponíveis

### **🏓 1. PING - Teste de Conectividade**

**Request:**
```json
{
  "action": "PING",
  "requestId": "ping_001"
}
```

**Response:**
```json
{
  "requestId": "ping_001",
  "status": "SUCCESS",
  "message": "PONG - Sistema operacional",
  "data": {
    "version": "2.0.0",
    "javaVersion": "11.0.20",
    "os": "Windows 10",
    "uptime": 12345
  },
  "timestamp": "2024-01-15T14:30:25.123Z"
}
```

---

### **📄 2. SIGN_PDF - Assinatura de PDF**

**Request:**
```json
{
  "action": "SIGN_PDF",
  "requestId": "sign_001",
  "data": {
    "pdfData": "base64_encoded_pdf_content",
    "certificateAlias": "certificado_selecionado",
    "reason": "Aprovação de contrato",
    "location": "São Paulo, Brasil",
    "contactInfo": "joao@empresa.com",
    "useTimestamp": true
  }
}
```

**Novos Parâmetros:**
- ✅ **useTimestamp** *(opcional)*: `true` para incluir timestamp confiável TSA na assinatura (recomendado para certificados A1)

**Response (Sucesso):**
```json
{
  "requestId": "sign_001", 
  "status": "SUCCESS",
  "message": "PDF assinado com sucesso",
  "data": {
    "signedPdfData": "base64_encoded_signed_pdf",
    "signatureField": "FluxSigner_1705327825123",
    "signatureDate": "2024-01-15T14:30:25.123Z",
    "timestampUsed": true,
    "certificateInfo": {
      "subject": "CN=João Silva, O=Empresa LTDA",
      "issuer": "CN=AC SERASA RFB v5, O=ICP-Brasil", 
      "serialNumber": "123456789",
      "notBefore": "2023-01-01T00:00:00Z",
      "notAfter": "2025-01-01T00:00:00Z"
    },
    "fileSize": 1048576,
    "processingTime": 2.5
  },
  "timestamp": "2024-01-15T14:30:27.623Z"
}
```

**Novos Campos de Resposta:**
- ✅ **timestampUsed**: Indica se timestamp confiável foi incluído na assinatura

**Response (Erro):**
```json
{
  "requestId": "sign_001",
  "status": "ERROR", 
  "message": "Certificado não encontrado",
  "data": {
    "errorCode": "CERT_NOT_FOUND",
    "errorDetails": "Alias 'certificado_inexistente' não existe no keystore",
    "suggestions": ["Verificar lista de certificados", "Atualizar certificados"]
  },
  "timestamp": "2024-01-15T14:30:25.456Z"
}
```

---

**Novos Campos na Verificação de Assinaturas:**
- ✅ **hasTimestamp**: Indica se a assinatura possui timestamp confiável
- ✅ **timestampValidation**: Resultado detalhado da validação do timestamp

---

### **✅ 3. VERIFY_PDF_SIGNATURES - Verificação de Assinaturas**

**Request:**
```json
{
  "action": "VERIFY_PDF_SIGNATURES",
  "requestId": "verify_001",
  "data": {
    "pdfData": "base64_encoded_pdf_content"
  }
}
```

**Response:**
```json
{
  "requestId": "verify_001",
  "status": "SUCCESS",
  "message": "Verificação concluída - 2 assinaturas encontradas",
  "data": {
    "signatureCount": 2,
    "signatures": [
      {
        "fieldName": "FluxSigner_1705327825123",
        "signDate": "2024-01-15T14:30:25.123Z",
        "reason": "Aprovação de contrato",
        "location": "São Paulo, Brasil",
        "integrityValid": true,
        "signatureCoverWholeDocument": true,
        "certificate": {
          "subject": "CN=João Silva",
          "issuer": "CN=AC SERASA RFB v5",
          "serialNumber": "123456789",
          "notBefore": "2023-01-01T00:00:00Z",
          "notAfter": "2025-01-01T00:00:00Z"
        },
        "icpValidation": {
          "valid": true,
          "icpBrasilCertificate": true,
          "temporallyValid": true,
          "chainValid": true,
          "revocationStatus": "GOOD",
          "validationDate": "2024-01-15T14:30:25.123Z",
          "errors": []
        },
        "hasTimestamp": true,
        "timestampValidation": {
          "valid": true,
          "timestamp": "2024-01-15T14:30:25.123Z",
          "tsaName": "Autoridade de Carimbo de Tempo ICP-Brasil",
          "serialNumber": "123456789",
          "policy": "2.16.76.1.8.1",
          "errors": []
        }
      }
    ],
    "documentIntegrity": "VALID",
    "processingTime": 1.8
  },
  "timestamp": "2024-01-15T14:30:27.123Z"
}
```

---

### **🔐 4. GET_CERTIFICATES - Lista de Certificados**

**Request:**
```json
{
  "action": "GET_CERTIFICATES",
  "requestId": "cert_001"
}
```

**Response:**
```json
{
  "requestId": "cert_001",
  "status": "SUCCESS", 
  "message": "3 certificados encontrados",
  "data": {
    "certificates": [
      {
        "alias": "certificado_joao_2024",
        "subject": "CN=João Silva, O=Empresa LTDA, C=BR",
        "issuer": "CN=AC SERASA RFB v5, O=ICP-Brasil",
        "serialNumber": "123456789",
        "notBefore": "2023-01-01T00:00:00Z",
        "notAfter": "2025-01-01T00:00:00Z",
        "hasPrivateKey": true,
        "expired": false,
        "commonName": "João Silva"
      }
    ],
    "keystoreType": "Windows-MY",
    "totalCertificates": 3,
    "validCertificates": 2
  },
  "timestamp": "2024-01-15T14:30:25.123Z"
}
```

---

### **🇧🇷 5. VALIDATE_ICP_CERTIFICATE - Validação ICP-Brasil**

**Request:**
```json
{
  "action": "VALIDATE_ICP_CERTIFICATE",
  "requestId": "icp_001",
  "data": {
    "certificateAlias": "certificado_joao_2024"
  }
}
```

**Response:**
```json
{
  "requestId": "icp_001",
  "status": "SUCCESS",
  "message": "Certificado ICP-Brasil válido",
  "data": {
    "valid": true,
    "icpBrasilCertificate": true,
    "temporallyValid": true,
    "chainValid": true,
    "revocationStatus": "GOOD",
    "validationDate": "2024-01-15T14:30:25.123Z",
    "certificate": {
      "subject": "CN=João Silva, O=Empresa LTDA",
      "issuer": "CN=AC SERASA RFB v5, O=ICP-Brasil",
      "serialNumber": "123456789",
      "notBefore": "2023-01-01T00:00:00Z",
      "notAfter": "2025-01-01T00:00:00Z",
      "subjectAlternativeName": "othername:<unsupported>",
      "cpfCnpj": "123.456.789-00",
      "certificateType": "A1"
    },
    "validationDetails": {
      "ocspChecked": true,
      "crlChecked": false,
      "chainLength": 3,
      "rootCA": "AC RAIZ ICP-Brasil v10"
    },
    "errors": []
  },
  "timestamp": "2024-01-15T14:30:27.456Z"
}
```

---

### **📊 6. GET_VERSION - Informações do Sistema**

**Request:**
```json
{
  "action": "GET_VERSION",
  "requestId": "version_001"
}
```

**Response:**
```json
{
  "requestId": "version_001",
  "status": "SUCCESS",
  "message": "FluxSigner PDF + ICP-Brasil",
  "data": {
    "version": "2.0.0",
    "buildDate": "2024-01-15",
    "javaVersion": "11.0.20",
    "os": "Windows 10 (10.0)",
    "architecture": "x86_64",
    "dependencies": {
      "itext": "8.0.2",
      "bouncycastle": "1.70",
      "jackson": "2.15.2"
    },
    "features": [
      "PDF_SIGNATURE",
      "ICP_BRASIL_VALIDATION", 
      "OCSP_CHECKING",
      "CRL_CHECKING",
      "MULTI_SIGNATURE",
      "TIMESTAMP_TSA"
    ]
  },
  "timestamp": "2024-01-15T14:30:25.123Z"
}
```

---

### **🔄 7. ECHO - Teste de Dados**

**Request:**
```json
{
  "action": "ECHO",
  "requestId": "echo_001",
  "data": {
    "message": "Teste de comunicação",
    "timestamp": "2024-01-15T14:30:25.123Z"
  }
}
```

**Response:**
```json
{
  "requestId": "echo_001",
  "status": "SUCCESS",
  "message": "Echo response",
  "data": {
    "originalMessage": "Teste de comunicação",
    "receivedAt": "2024-01-15T14:30:25.123Z",
    "processedAt": "2024-01-15T14:30:25.125Z",
    "roundTripTime": "2ms"
  },
  "timestamp": "2024-01-15T14:30:25.125Z"
}
```

---

## ⏰ **TIMESTAMP CONFIÁVEL - TSA (Time Stamping Authority)**

### **🎯 Funcionalidade de Timestamp**

O FluxSigner v2.0 agora suporta **timestamp confiável** para assinaturas digitais, essencial para certificados **A1 ICP-Brasil**.

### **✅ Benefícios do Timestamp:**
- 🕐 **Prova temporal**: Comprova exatamente quando o documento foi assinado
- 🔒 **Validade jurídica**: Fortalece a validade legal da assinatura digital
- 📜 **Conformidade ICP-Brasil**: Atende aos requisitos para certificados A1
- 🛡️ **Proteção contra repúdio**: Impede contestações sobre a data da assinatura

### **🏢 Autoridades TSA Suportadas:**
O sistema utiliza automaticamente os seguintes serviços TSA credenciados pela ICP-Brasil:

- 🇧🇷 **ITI** - Instituto Nacional de Tecnologia da Informação
- 🏛️ **SERPRO** - Serviço Federal de Processamento de Dados  
- 🏦 **Receita Federal** - Secretaria da Receita Federal
- 🔐 **Certisign** - Autoridade Certificadora

### **📋 Como Usar Timestamp:**

**1. Na Assinatura:**
```json
{
  "action": "SIGN_PDF",
  "requestId": "sign_001",
  "data": {
    "pdfData": "base64_encoded_pdf_content",
    "certificateAlias": "meu_certificado_A1",
    "useTimestamp": true  // ← Habilita timestamp
  }
}
```

**2. Na Verificação:**
```json
{
  "hasTimestamp": true,
  "timestampValidation": {
    "valid": true,
    "timestamp": "2024-01-15T14:30:25.123Z",
    "tsaName": "ITI - Instituto Nacional de Tecnologia da Informação",
    "serialNumber": "987654321",
    "policy": "2.16.76.1.8.1"
  }
}
```

### **⚙️ Configuração Automática:**
- ✅ **Failover automático**: Se uma TSA falhar, tenta automaticamente a próxima
- ✅ **Cache inteligente**: Otimiza performance com cache de tokens
- ✅ **Validação robusta**: Verifica integridade e autenticidade dos timestamps
- ✅ **Logs detalhados**: Rastreamento completo para auditoria

### **🔍 Validação de Timestamp:**
O sistema valida automaticamente:
- 📋 **Integridade do hash**: Verifica se o hash do documento confere
- 🔢 **Nonce único**: Valida o número único da requisição
- 🏢 **Autoridade TSA**: Confirma se é uma TSA credenciada
- ⏰ **Validade temporal**: Verifica se o timestamp é válido
- 🔐 **Assinatura digital**: Valida a assinatura da própria TSA

---

## ⚠️ Códigos de Erro

### **📋 Categorias de Erro**

| **Código** | **Categoria** | **Descrição** |
|------------|---------------|---------------|
| `INVALID_REQUEST` | Protocolo | Request malformado ou inválido |
| `ACTION_NOT_FOUND` | Protocolo | Ação não reconhecida |
| `MISSING_DATA` | Validação | Dados obrigatórios ausentes |
| `INVALID_PDF` | PDF | Arquivo PDF corrompido ou inválido |
| `PDF_TOO_LARGE` | PDF | Arquivo excede limite de 50MB |
| `CERT_NOT_FOUND` | Certificado | Certificado não encontrado |
| `CERT_EXPIRED` | Certificado | Certificado expirado |
| `CERT_INVALID` | Certificado | Certificado inválido ou corrompido |
| `KEYSTORE_ERROR` | Sistema | Erro ao acessar keystore |
| `SIGNATURE_FAILED` | Assinatura | Falha no processo de assinatura |
| `VALIDATION_FAILED` | Validação | Falha na validação ICP-Brasil |
| `OCSP_ERROR` | Rede | Erro na consulta OCSP |
| `CRL_ERROR` | Rede | Erro na consulta CRL |
| `NETWORK_ERROR` | Rede | Problema de conectividade |
| `TIMEOUT` | Sistema | Timeout na operação |
| `TSA_ERROR` | Timestamp | Erro ao obter timestamp da TSA |
| `TSA_TIMEOUT` | Timestamp | Timeout na comunicação com TSA |
| `TIMESTAMP_INVALID` | Timestamp | Token de timestamp inválido |
| `INTERNAL_ERROR` | Sistema | Erro interno do sistema |

### **🔍 Exemplo de Resposta de Erro Detalhada**

```json
{
  "requestId": "sign_001",
  "status": "ERROR",
  "message": "Falha na assinatura do PDF",
  "data": {
    "errorCode": "SIGNATURE_FAILED",
    "errorDetails": "Não foi possível acessar a chave privada do certificado",
    "errorCategory": "CERTIFICADO",
    "suggestions": [
      "Verificar se o certificado possui chave privada",
      "Confirmar senha do certificado",
      "Verificar se o token está conectado (A3/A4)"
    ],
    "technicalDetails": {
      "exception": "java.security.UnrecoverableKeyException",
      "stackTrace": "...",
      "timestamp": "2024-01-15T14:30:25.123Z"
    }
  },
  "timestamp": "2024-01-15T14:30:25.456Z"
}
```

---

## 🔒 Segurança da API

### **🛡️ Validações Implementadas**

1. **📋 Validação de Schema:** Todos os requests são validados contra schema JSON
2. **🔍 Sanitização:** Dados de entrada são sanitizados contra injeções
3. **📏 Limites:** Tamanho máximo de 50MB para PDFs
4. **⏱️ Timeouts:** 60 segundos para operações de assinatura
5. **🔐 Encoding:** Apenas UTF-8 válido aceito
6. **📊 Logging:** Todas operações são auditadas

### **🚫 Proteções Contra Ataques**

- ✅ **Buffer Overflow:** Validação de tamanho
- ✅ **DoS:** Rate limiting e timeouts
- ✅ **Injection:** Sanitização de entrada
- ✅ **Path Traversal:** Validação de caminhos
- ✅ **Memory Exhaustion:** Limites de heap

---

## 📊 Performance e Limites

### **⚡ Métricas de Performance**

| **Operação** | **Tempo Médio** | **Limite** |
|--------------|-----------------|------------|
| **PING** | < 10ms | 5 segundos |
| **GET_CERTIFICATES** | 100-500ms | 10 segundos |
| **SIGN_PDF (1MB)** | 2-5 segundos | 60 segundos |
| **SIGN_PDF (10MB)** | 5-15 segundos | 60 segundos |
| **VERIFY_PDF** | 1-3 segundos | 30 segundos |
| **VALIDATE_ICP** | 2-10 segundos | 30 segundos |

### **📏 Limites do Sistema**

- **📄 PDF Size:** Máximo 50MB
- **💾 Memory:** Máximo 512MB heap
- **🔄 Concurrent:** 1 operação por vez
- **📨 Message Size:** Máximo 1MB
- **⏱️ Request Timeout:** 60 segundos
- **🗂️ Cache Size:** 100MB certificados

---

## 🧪 Exemplos de Teste

### **📋 Script de Teste Bash**

```bash
#!/bin/bash
# test_fluxsigner_api.sh

NATIVE_HOST="java -jar fluxsigner-pdf-icpbrasil.jar"

echo "=== Testando FluxSigner API ==="

# Teste 1: PING
echo '{"action":"PING","requestId":"test_ping"}' | $NATIVE_HOST

# Teste 2: GET_VERSION  
echo '{"action":"GET_VERSION","requestId":"test_version"}' | $NATIVE_HOST

# Teste 3: GET_CERTIFICATES
echo '{"action":"GET_CERTIFICATES","requestId":"test_certs"}' | $NATIVE_HOST

# Teste 4: ECHO
echo '{"action":"ECHO","requestId":"test_echo","data":{"message":"Hello World"}}' | $NATIVE_HOST
```

### **🐍 Script de Teste Python**

```python
#!/usr/bin/env python3
# test_fluxsigner_api.py

import json
import subprocess
import base64

def test_fluxsigner_api():
    native_host = ["java", "-jar", "fluxsigner-pdf-icpbrasil.jar"]
    
    # Teste PING
    request = {
        "action": "PING",
        "requestId": "test_ping_python"
    }
    
    result = subprocess.run(
        native_host,
        input=json.dumps(request),
        text=True,
        capture_output=True
    )
    
    response = json.loads(result.stdout)
    print(f"PING Response: {response['message']}")
    
    return response['status'] == 'SUCCESS'

if __name__ == "__main__":
    success = test_fluxsigner_api()
    print(f"Teste {'PASSOU' if success else 'FALHOU'}")
```

---

## 📚 Referências

### **🔗 Padrões e Especificações**

- 📋 [Native Messaging API](https://developer.chrome.com/docs/extensions/mv3/nativeMessaging/)
- 🔐 [PAdES Specification](https://www.etsi.org/standards) 
- 🇧🇷 [ICP-Brasil Standards](https://www.iti.gov.br/)
- 📄 [PDF Specification](https://www.adobe.com/content/dam/acom/en/devnet/pdf/pdfs/PDF32000_2008.pdf)
- 🔒 [PKCS#7 Standard](https://tools.ietf.org/html/rfc2315)

### **📖 Bibliotecas Utilizadas**

- 📄 [iText 8.0.2](https://itextpdf.com/resources)
- 🔐 [Bouncy Castle 1.70](https://www.bouncycastle.org/documentation.html)
- 📊 [Jackson 2.15.2](https://github.com/FasterXML/jackson-docs)
- 📋 [SLF4J + Logback](http://logback.qos.ch/documentation.html)

---

<div align="center">

**📋 FluxSigner API Documentation v2.0**

*Documentação técnica completa para desenvolvedores*

</div>
