# Documentação do Hook `useFluxSigner` e Comunicação com a Extensão

Este documento detalha o funcionamento do hook `useFluxSigner`, o serviço `FluxSignerService`, e o fluxo de comunicação entre a aplicação React e a extensão do Chrome via Native Messaging.

## 1. Visão Geral da Arquitetura

A integração entre a aplicação React e a extensão FluxSigner segue a seguinte arquitetura:

1.  **Componente React (`FluxSignerComponent.tsx`)**: Utiliza o hook `useFluxSigner` para acessar funcionalidades e estados.
2.  **Hook (`useFluxSigner.ts`)**: Abstrai a lógica de negócio, gerenciamento de estado (certificados, loading, erros) e interage com o `FluxSignerService`.
3.  **Serviço (`FluxSignerService.ts`)**: É a camada de comunicação. Responsável por enviar mensagens para a extensão do Chrome e tratar as respostas.
4.  **Extensão Chrome (`background.js`)**: Recebe as mensagens da aplicação web, invoca o *Native Host* para operações de criptografia e retorna os resultados.
5.  **Native Host (Java)**: Executa as operações complexas, como listar certificados do Windows Store e assinar documentos PDF.

O fluxo de dados é sempre unidirecional: React -> Extensão -> Native Host -> Extensão -> React.

## 2. `FluxSignerService.ts` - A Camada de Comunicação

O `FluxSignerService` é implementado como um Singleton, garantindo uma única instância responsável por toda a comunicação com a extensão.

### 2.1. Detecção da Extensão

-   **`checkExtensionAvailability()`**: Este método é o ponto de partida. Ele verifica se a `window.chrome.runtime` está disponível e tenta enviar uma mensagem de "PING" para a extensão usando um ID pré-definido (`hnlmoeeepnmddepiepbcdajfenoimdme`).
-   **`externally_connectable`**: A comunicação só é possível porque o `manifest.json` da extensão agora inclui a chave `externally_connectable`, que autoriza a aplicação (`localhost`) a se conectar. Sem isso, qualquer tentativa de `sendMessage` falharia com um erro de "connection refused".

### 2.2. Envio de Mensagens

-   **`sendMessage(message)`**: É o método central que envia um objeto de mensagem para a extensão. Ele usa `window.chrome.runtime.sendMessage()`, passando o ID da extensão e a mensagem.
-   **Estrutura da Mensagem**: Todas as mensagens seguem um padrão:
    ```json
    {
      "action": "NOME_DA_ACAO",
      "requestId": "ID_UNICO",
      "data": { ... }
    }
    ```
    -   `action`: Define a operação a ser executada (ex: `GET_CERTIFICATES`, `SIGN_PDF`).
    -   `requestId`: Um identificador único para rastrear a requisição.
    -   `data`: Contém os dados necessários para a operação (ex: PDF em Base64, alias do certificado).

### 2.3. Tratamento de Respostas

-   As respostas da extensão também seguem um padrão:
    ```json
    {
      "status": "SUCCESS" | "ERROR",
      "message": "...",
      "data": { ... }
    }
    ```
-   O `sendMessage` é envolvido em uma `Promise` que resolve se `response.status === "SUCCESS"` e rejeita em caso de erro ou se `window.chrome.runtime.lastError` for definido.

## 3. `useFluxSigner.ts` - O Hook React

O `useFluxSigner` é o coração da integração no lado do React. Ele gerencia o ciclo de vida da comunicação e expõe uma API simplificada para os componentes.

### 3.1. Estados Gerenciados

O hook gerencia vários estados importantes:

-   `isAvailable`: `boolean` - Indica se a extensão foi detectada.
-   `checkingExtension`: `boolean` - `true` enquanto a verificação inicial está em andamento.
-   `certificates`: `CertificateInfo[]` - Lista de certificados carregados.
-   `certificatesLoading`, `loading`: `boolean` - Indicadores de carregamento para operações.
-   `certificatesError`, `error`: `string | null` - Mensagens de erro.

### 3.2. Ciclo de Vida (Efeitos)

-   **`useEffect(() => { ... }, [])`**: No momento em que o hook é montado, ele chama `fluxSignerService.checkExtensionAvailability()` para verificar a presença da extensão. O estado `checkingExtension` é usado para mostrar um feedback de carregamento na UI durante esse processo.
-   **`useEffect(() => { ... }, [isAvailable, loadCertificates])`**: Uma vez que `isAvailable` se torna `true`, o hook automaticamente chama `loadCertificates()` para buscar a lista de certificados.

### 3.3. Funções Expostas

O hook retorna um objeto com estados e funções que os componentes podem usar:

-   **`loadCertificates()`**: Chama `fluxSignerService.getCertificates()` e atualiza os estados `certificates`, `certificatesLoading` e `certificatesError`.
-   **`signDocument(file, alias, options)`**:
    1.  Converte o arquivo PDF para Base64 usando `fluxSignerService.fileToBase64()`.
    2.  Chama `fluxSignerService.signPDF()` com os dados.
    3.  Após a assinatura bem-sucedida, invoca `fluxSignerService.downloadSignedPDF()` para iniciar o download do arquivo assinado.
    4.  Gerencia os estados `loading` and `error`.
-   **`verifyDocument(file)`**: Semelhante à assinatura, converte o arquivo e chama `fluxSignerService.verifyPDFSignatures()`. O resultado é retornado para o componente para exibição.
-   **`forceCheckExtension()`**: Permite que o usuário dispare uma nova verificação da extensão manualmente.

## 4. Fluxo de uma Operação de Assinatura

1.  **Usuário**: Clica no botão "Assinar Documento".
2.  **`FluxSignerComponent.tsx`**: Chama a função `handleSign()`.
3.  **`handleSign()`**: Invoca `signDocument(selectedFile, selectedCertificate, options)` do hook `useFluxSigner`.
4.  **`useFluxSigner.ts`**:
    -   Define `setLoading(true)`.
    -   Chama `fluxSignerService.fileToBase64(file)`.
    -   Chama `fluxSignerService.signPDF(...)` com o Base64 e as opções.
5.  **`FluxSignerService.ts`**:
    -   Envia a mensagem `{ action: "SIGN_PDF", ... }` para a extensão.
6.  **Extensão (`background.js`)**:
    -   Recebe a mensagem.
    -   Envia uma mensagem para o *Native Host* via `chrome.runtime.sendNativeMessage()`.
7.  **Native Host (Java)**:
    -   Recebe a requisição.
    -   Decodifica o PDF Base64.
    -   Localiza o certificado no Windows Store.
    -   Realiza a assinatura criptográfica.
    -   Codifica o novo PDF assinado em Base64.
    -   Envia a resposta de volta para a extensão.
8.  **Extensão (`background.js`)**:
    -   Recebe a resposta do *Native Host*.
    -   Envia a resposta de volta para a aplicação React.
9.  **`FluxSignerService.ts`**: A `Promise` de `sendMessage` é resolvida com os dados do PDF assinado.
10. **`useFluxSigner.ts`**:
    -   Recebe o resultado de `signPDF`.
    -   Chama `fluxSignerService.downloadSignedPDF()` com o Base64 do PDF assinado.
    -   Define `setLoading(false)`.
11. **`FluxSignerService.ts`**: Cria um link `<a>` com `data:application/pdf;base64,...` e simula um clique para iniciar o download.
12. **Usuário**: O download do PDF assinado começa.

Este fluxo demonstra como as camadas de abstração (hook e serviço) simplificam a complexidade da comunicação com a extensão e o *Native Messaging*, permitindo que os componentes React se concentrem apenas na interface do usuário e na lógica de apresentação.
