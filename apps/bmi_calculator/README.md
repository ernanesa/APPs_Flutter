# ⚖️ BMI Calculator (Beast Mode)

Um aplicativo de cálculo de IMC (Índice de Massa Corporal) desenvolvido com foco total em performance Android, monetização e suporte global.

## ✨ Diferenciais (Beast Mode)

### 🚀 Otimização Extrema
- **Android Only:** Removidos todos os arquivos desnecessários de outras plataformas para reduzir o tamanho do projeto.
- **R8 & ProGuard:** Minificação de código e remoção de recursos não utilizados (ShrinkResources) habilitados para um APK/AAB ultra compacto.
- **Performance:** Uso intensivo de `const` e rendering otimizado para manter 60/120 FPS.

### 💰 Monetização (AdMob)
- **Banner Adaptativo:** Integrado na tela principal para maximizar o CTR sem atrapalhar a experiência.
- **Interstitial Inteligente:** Exibido em pausas naturais (após salvar um resultado).
- **AdService Singleton:** Estrutura centralizada para gerenciamento de anúncios.

### 🌎 Global & Local
- **i18n:** Suporte completo para 11 idiomas (PT, EN, ES, ZH, DE, FR, AR, BN, HI, JA, RU).
- **Material 3:** Interface moderna com suporte a cores dinâmicas no Android.

## 🛠️ Funcionalidades
1. **Calculadora:** Interface intuitiva com feedback visual de cores por categoria de peso.
2. **Histórico:** Registros persistentes das medidas anteriores.
3. **Evolução:** Gráfico de linhas dinâmico para visualização de progresso.
4. **Resets:** Limpeza rápida de campos.

## 💻 Tech Stack
- **State Management:** Riverpod
- **Architecture:** Feature-based modular structure
- **Local Storage:** Shared Preferences
- **Charts:** fl_chart
- **Monetization:** google_mobile_ads

## 🚀 Como Compilar (Release)
Para gerar o App Bundle otimizado:
```bash
flutter build appbundle --release
```

---
*Faz parte do Ecossistema SuperApp Rezende.*
