---
applyTo: '**'
---
# **Plano de Arquitetura: Do App Simples ao SuperApp (Modular)**

Versão: 4.0 | Janeiro 2026 | Inclui lições de publicação real

Para cumprir o requisito de criar apps individuais que depois serão agregados, NÃO podemos usar uma estrutura monolítica comum (lib/main.dart cheio de tudo).

Utilizaremos uma **Arquitetura Modular Baseada em Packages**.

## **1\. Estrutura de Pastas (O Segredo)**

Mesmo para o primeiro app simples, a estrutura deve ser pensada como um monorepo.

```
/root_project  
  /apps (ou diretório raiz para apps individuais)
     /bmi_calculator (sa.rezende.calculadora)  
     /todo_app (sa.rezende.todo)  
     /super_app (sa.rezende.superapp)  
  /packages (Módulos Reutilizáveis)  
     /core_ui (Design System: Cores, Tipografia, Botões Padrão)  
     /core_logic (Auth, Gerenciamento de Estado Base, Networking)  
     /feature_ads (Lógica centralizada do AdMob - MUITO IMPORTANTE)  
     /feature_i18n (Traduções compartilhadas)
  /DadosPublicacao (Chaves, certificados, assets de loja por app)
     /<app_name>/keys/
     /<app_name>/store_assets/
     /<app_name>/policies/
```

## **2\. Benefícios desta Estrutura**

1. **Uniformidade Visual:** Todos os apps consomem o pacote core\_ui. Se você mudar a cor primária no core\_ui, todos os apps atualizam. Isso garante a coesão visual exigida.  
2. **Lógica de Ads Centralizada:** O pacote feature\_ads controla os IDs dos blocos de anúncios. Você configura a lógica de "Native Ad" uma vez e replica em todos os apps.  
3. **Migração Zero:** Quando for criar o SuperApp, você apenas adiciona as dependências dos apps individuais (que estarão modularizados) dentro dele.
4. **Dados de Publicação Organizados:** Keystores, assets e políticas ficam versionados e organizados por app.

## **3\. Stack Tecnológica Recomendada (2025-2026)**

| Categoria | Tecnologia | Justificativa |
|-----------|------------|---------------|
| **Gerência de Estado** | Riverpod 2.x | Mais testável e modular que Bloc |
| **Navegação** | GoRouter | Deep Linking essencial para SuperApp |
| **Banco Local** | Isar ou Hive | NoSQL super rápido |
| **Injeção de Dependência** | get\_it + injectable | Padrão enterprise |
| **Ads** | google_mobile_ads 5.3+ | Banner, Interstitial, App Open |
| **Build** | AGP 8.5.1+ | Compatibilidade 16KB page size |

## **4\. O Agente de IA e a Geração de Código**

Quando você solicitar à IA para criar um app, use este prompt de arquitetura:

```
Crie o app [NOME] dentro da estrutura modular.

1. Use o package core_ui para os widgets visuais (se existir).  
2. Implemente a lógica de negócio isolada (sem dependência direta da UI).  
3. Configure o AdMob usando o feature_ads (ou crie lib/services/ad_service.dart).  
4. Namespace: sa.rezende.[nome].  
5. Crie os arquivos .arb para os 11 idiomas imediatamente.
6. Configure AGP 8.5.1+ no settings.gradle.
7. Remova pastas desnecessárias (/ios, /web, /linux, /macos, /windows).
```

## **5\. Cronograma de Execução (Beast Mode)**

### **Fase A: Fundação (1-2 Dias)**

* Configurar o Monorepo (Melos é recomendado para gerenciar os pacotes).  
* Criar packages/core\_ui (Tema, Cores, Componentes Básicos).  
* Criar packages/feature\_ads (Helper de AdMob).
* Configurar ambiente Android (Flutter SDK, Android SDK, Emulador com GPU).

### **Fase B: Fábrica de Apps (Contínuo)**

* Desenvolver App 1 (ex: BMI Calculator). Validar. Publicar.  
* Desenvolver App 2 (ex: Todo App). Validar. Publicar.  
* *Nota:* Graças à Fase A, o App 2 já nasce com o design e os ads do App 1 configurados.

### **Fase C: A Fusão (Futuro)**

* Criar o projeto super\_app.  
* Importar as lógicas dos Apps 1 e 2 como "Features".  
* Criar uma "Home" unificadora que navega para essas features.

## **6\. Ambiente de Desenvolvimento (NOVO)**

### **6.1. Configuração do Emulador Android**

Para desenvolvimento eficiente, configure o emulador com:

```
# AVD config.ini
hw.gpu.enabled=yes
hw.gpu.mode=host
hw.ramSize=4096
```

Comando de inicialização otimizado:
```powershell
emulator -avd <AVD_NAME> -gpu host -memory 4096
```

### **6.2. Troubleshooting de ADB (Emulador Offline)**

Se `adb devices` mostrar "offline":

```powershell
adb kill-server
adb start-server
adb devices
# Se persistir:
emulator -avd <AVD_NAME> -no-snapshot-load -gpu host
```

### **6.3. Captura de Screenshots Reais**

```powershell
# Rodar app no emulador
flutter run -d emulator-5554

# Capturar screenshot
adb exec-out screencap -p > screenshot.png
```

## **7\. Checklist Pré-Publicação**

- [ ] AGP 8.5.1+ configurado
- [ ] Target SDK 35
- [ ] IDs AdMob de produção
- [ ] Screenshots reais do app (mín. 2)
- [ ] Ícone 512x512
- [ ] Feature graphic 1024x500
- [ ] Política de privacidade hospedada
- [ ] 11 idiomas traduzidos
- [ ] AAB gerado com `flutter build appbundle --release`

**Fim do Planejamento.** Mantenha o foco. Codifique uma feature, termine, valide, commite. Não deixe pontas soltas.