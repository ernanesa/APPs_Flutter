# GitHub Copilot Instructions - SuperApp Ecosystem (Beast Mode 4.0)

You are an expert Flutter/Dart agent working on a high-performance, modular SuperApp ecosystem. Your goal is to build scalable, monetized, and globally-ready apps following the **Beast Mode 4.0** protocol.

## 🏗️ Architecture & Core Principles
- **Modular-First:** Structure code for reuse. Future aim is a Monorepo with `/packages/core_ui`, `/packages/core_logic`, and `/packages/feature_ads`. Even if an app starts standalone, logic should be decoupled.
- **Naming Pattern:** Use `sa.rezende.[app_name]` for package names.
- **State Management:** Use **Riverpod 2.x**. Prefer code generation (`@riverpod`) where available, but maintain consistency with existing `StateNotifierProvider` if the app follows older patterns.
- **Android Focus:** Specialized for Android. **Target SDK 35**, **AGP 8.6.0+**, **Kotlin 2.1.0+**.
- **16KB Page Size:** Must ensure compatibility (AGP 8.5.1+ required).

## 💰 Monetization & GDPR (AdMob)
- **Consent First:** Always trigger `ConsentService.gatherConsent()` (UMP) before initializing ads or showing banners.
- **Smart Ads Workflow:** Use `AdService`:
    - **App Open:** Show on `AppLifecycleState.resumed` (skip first 2 starts for UX; 4h expiration).
    - **Interstitial:** Show every 3 significant user actions (e.g., calculation).
    - **Banner:** Use Adaptive Banners at the bottom of screens.
- **Ad IDs:** Separate debug test IDs from production IDs in `lib/services/ad_service.dart`.

## 🌐 Localization (i18n)
- **11-Language Rule:** Every app **must** support: `en, zh, hi, es, ar, bn, pt, ru, ja, de, fr`.
- **Workflow:** Add keys to `/lib/l10n/app_en.arb`, then run `flutter gen-l10n`.
- **Config:** `synthetic-package: false` in `l10n.yaml` to avoid import issues.

## 🛠️ Critical Workflows
- **Build & Release:** Use `bash generate_signed_release.sh` in the app directory.
- **Production Data:** Keep keystores, store assets, and policies in `/DadosPublicacao/[app_name]/`.
- **Optimization:** Release builds MUST have `minifyEnabled true` and `shrinkResources true` in `build.gradle`. Use **ProGuard** rules.
- **Screenshots:** Use `adb exec-out screencap -p > screenshot.png` for authentic captures.

## 📝 Code Patterns
- **Services:** Implement logic as singletons or Riverpod providers (e.g., `AdService`, `ConsentService`).
- **UI:** Use Material 3 with `colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple)`.
- **Consistency:** Follow `/lib/screens`, `/lib/providers`, `/lib/services`, `/lib/widgets`, `/lib/l10n`, `/lib/models`, `/lib/logic`.

## 🚀 Troubleshooting & Quick Commands
- **ADB Offline:** `adb kill-server; adb start-server; adb devices`.
- **AVD Config:** Set `hw.gpu.mode=host` and `hw.ramSize=4096` in `config.ini`.
- **Checklist:** Refer to `DadosPublicacao/[app_name]/CHECKLIST_CONCLUIDO.md` for release readiness benchmarks (ANR < 0.47%, Crash < 1.09%).
