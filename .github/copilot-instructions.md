# GitHub Copilot Instructions - SuperApp Ecosystem (Beast Mode 5.0)

You are an expert Flutter/Dart agent working on a high-performance, modular SuperApp ecosystem. Your goal is to build scalable, monetized, and globally-ready apps following the **Beast Mode 5.0** protocol.

---

## 📋 Changelog v5.0
- ✨ **NOVO:** Fase 0 - Análise de valor obrigatória antes de codificar
- ✨ **NOVO:** Clean Architecture (Domain/Data/Presentation)
- ✨ **NOVO:** Sub-agentes para tarefas paralelas
- ✨ **NOVO:** Integration Tests para screenshots
- 🔧 **ATUALIZADO:** Stack tecnológica 2026

---

## 🎯 FASE 0: Análise de Valor (OBRIGATÓRIA)

**ANTES de escrever qualquer código**, responda:

1. **Valor:** O que o usuário ganha com essa feature?
2. **Escopo:** É MVP ou gold-plating?
3. **Dependências:** Quais arquivos/packages são afetados?
4. **Riscos:** O que pode quebrar?

Se a resposta não estiver clara, **pergunte ao usuário**.

---

## 🏗️ Architecture & Core Principles

### Clean Architecture (OBRIGATÓRIA)
```
/lib
  /domain    # Dart puro - entidades, usecases, interfaces
  /data      # Implementações, DTOs, datasources
  /presentation  # UI, providers, widgets
  /services  # Cross-cutting (AdService, ConsentService)
```

### Regras de Dependência
- `presentation → domain` ✅
- `data → domain` ✅
- `domain → NADA` ✅ (puro Dart)
- `domain → data` ❌ PROIBIDO

### Estrutura Geral
- **Modular-First:** Structure code for reuse. Monorepo com `/packages/core_ui`, `/packages/core_logic`, `/packages/feature_ads`.
- **Naming Pattern:** Use `sa.rezende.[app_name]` for package names.
- **State Management:** Use **Riverpod 2.x**. Prefer `StateNotifierProvider` for consistency.
- **Android Focus:** Specialized for Android. **Target SDK 35**, **AGP 8.6.0+**, **Kotlin 2.1.0+**.
- **16KB Page Size:** Must ensure compatibility (AGP 8.5.1+ required).

---

## 💰 Monetization & GDPR (AdMob)
- **Consent First:** Always trigger `ConsentService.gatherConsent()` (UMP) before initializing ads.
- **Smart Ads Workflow:** Use `AdService`:
    - **App Open:** Show on `AppLifecycleState.resumed` (skip first 2 starts; 4h expiration).
    - **Interstitial:** Show every 3 significant user actions.
    - **Banner:** Adaptive Banners at bottom of screens.
- **Ad IDs:** Separate debug test IDs from production IDs in `lib/services/ad_service.dart`.

---

## 🌐 Localization (i18n)
- **11-Language Rule:** Every app **must** support: `en, zh, hi, es, ar, bn, pt, ru, ja, de, fr`.
- **Workflow:** Add keys to `/lib/l10n/app_en.arb`, then `flutter gen-l10n`.
- **Config:** `synthetic-package: false` in `l10n.yaml`.
- **Batch Edit:** Use `multi_replace_string_in_file` for all 11 .arb files simultaneously.

---

## 🛠️ Critical Workflows

### Build & Release
```powershell
flutter clean; flutter pub get; flutter gen-l10n; flutter analyze; flutter test; flutter build appbundle --release
```

### Production Data
- Keystores, assets, policies: `/DadosPublicacao/[app_name]/`
- **Optimization:** `minifyEnabled true`, `shrinkResources true`, ProGuard 7 passes.

### Screenshots (Integration Tests - NOVO)
```powershell
flutter drive --driver=test_driver/integration_test.dart --target=integration_test/screenshot_test.dart
```

---

## 🤖 Sub-agentes (NOVO v5.0)

### Quando Delegar
| Tarefa | Delegável |
|--------|-----------|
| Tradução 11 idiomas | ✅ Sub-agente |
| Screenshots automáticos | ✅ Sub-agente |
| Store Listing traduções | ✅ Sub-agente |
| Lógica de negócio | ❌ Agente principal |

### Template
```
runSubagent("Traduzir i18n", "Traduza para: de, es, fr, zh, ru, ja, ar, hi, bn. Retorne JSON.")
```

---

## 📝 Code Patterns
- **Services:** Singletons ou Riverpod providers.
- **UI:** Material 3 com `ColorScheme.fromSeed()`.
- **Folders:** `/lib/domain`, `/lib/data`, `/lib/presentation`, `/lib/services`, `/lib/l10n`.

---

## 🚀 Troubleshooting
- **ADB Offline:** `adb kill-server; adb start-server; adb devices`.
- **AVD Config:** `hw.gpu.mode=host`, `hw.ramSize=4096`.
- **Checklist:** `DadosPublicacao/[app_name]/CHECKLIST_CONCLUIDO.md` (ANR < 0.47%, Crash < 1.09%).
