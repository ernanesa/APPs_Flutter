# 🚀 SuperApp Ecosystem (Flutter)

Este repositório contém uma coleção de aplicativos Flutter desenvolvidos sob o protocolo **Beast Mode**, focados em alta performance, monetização inteligente e alcance global.

## 🏗️ Arquitetura
Seguimos uma estrutura modular baseada em packages para permitir a futura fusão em um único **SuperApp**.
- **Apps:** Aplicativos independentes (`/bmi_calculator`).
- **Protocolo:** Foco em Android (AAB), otimização de tamanho (R8/ProGuard) e monetização (AdMob).

---

## 📱 Apps Atuais

### 1. BMI Calculator (Calculadora de IMC)
Um aplicativo completo para monitoramento de saúde.
- **Estado:** Produção (Otimizado)
- **Features:** 
    - Cálculo preciso de IMC com cores dinâmicas (Material 3).
    - Histórico persistente e Gráfico de Evolução.
    - Suporte a 11 idiomas (i18n).
    - Monetização via AdMob (Banners e Interstitials).
    - APK/AAB ultra leve (R8/ShrinkResources).

---

## 🛠️ Stack Tecnológica
- **Linguagem:** Dart
- **Framework:** Flutter (Android Specialized)
- **Gerenciamento de Estado:** Riverpod (Code Generation)
- **Banco de Dados:** Local Storage
- **Gráficos:** fl_chart
- **Anúncios:** Google Mobile Ads (AdMob)

---

## 🛠️ Como executar
1. Entre na pasta do app desejado: `cd bmi_calculator`
2. Instale as dependências: `flutter pub get`
3. Gere as traduções: `flutter gen-l10n`
4. Execute: `flutter run`

---
*Powered by Rezende Labs*
