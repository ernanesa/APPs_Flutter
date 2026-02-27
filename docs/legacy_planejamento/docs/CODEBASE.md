# CODEBASE.md — Flutter App Factory

> Mapa cognitivo do repositório para agentes/IA (onde está o quê + quais gates existem).

## 📌 Docs “source of truth”
- `docs/PLAYBOOK.md` — padrão obrigatório
- `docs/QA.md` — QA Factory (validação)
- `docs/PUBLISHING.md` — publicação
- `docs/KNOWLEDGE_BASE.md` — aprendizados/prevenções

## ✅ Gates de qualidade (mínimo)
- `melos run qa` (lint + tests + l10n)
- `melos run check:store_assets` (assets Play Store)
- `melos run validate:qa:full -- -AppName <app>` (pipeline completo por app)

## 📋 Quick Info

| Campo | Valor |
|-------|-------|
| Tipo | Monorepo Flutter |
| Linguagem | Dart 3.x |
| Framework | Flutter 3.x |
| Orquestração | Melos |
| State management | Riverpod 3.x (padrão do workspace) |

---

## 🗂️ Estrutura do repositório

```
APPs_Flutter_2/
├── apps/                    # apps finais (clusters)
├── packages/                # código compartilhado
├── docs/                    # documentação “processo”
├── tools/                   # scripts de QA/automação
├── automation/              # Playwright (RPA) quando aplicável
├── artifacts/               # outputs gerados (logs, goldens, relatórios)
├── melos.yaml               # tarefas do workspace
└── analysis_options.yaml    # lints compartilhados
```

---

## 🎯 Agentes (VS Code / GitHub Copilot)

Agentes do workspace ficam em `.github/agents/` e cobrem:
- status/progresso
- desenvolvimento paralelo
- validação “pronto para Play Console”
- testes matrix (device/idiomas)
- publicação (quando automatizável)

---

## 📦 Package Dependencies

```
Package Dependency Graph:

apps/*
  └── packages/core/*
  └── packages/features/*

packages/features/*
  └── packages/core/*

packages/core/*
  └── (external packages only)
```

### Import Rules

```dart
// ✅ CORRECT - Package imports
import 'package:design_system/design_system.dart';
import 'package:settings/settings.dart';
import 'package:ad_manager/ad_manager.dart';

// ❌ WRONG - Relative imports across packages
import '../../../packages/core/design_system/lib/src/theme/app_theme.dart';

// ❌ WRONG - App importing another app
import 'package:bmi_calculator/some_widget.dart';
```

---

## 🔧 Common Commands

```bash
# Workspace management
melos bootstrap          # Link all packages
melos run analyze        # Lint all packages
melos run test           # Run all tests
melos run gen:l10n       # Generate l10n in all apps
melos run check:l10n     # Validate ARB keys
melos run qa             # Lint + tests + check:l10n
melos run generate       # Code generation (freezed, riverpod, etc)
melos run clean          # Clean all packages

# Single app development
cd apps/health/bmi_calculator
flutter run              # Run on device/emulator
flutter test             # Run tests
flutter build apk        # Build APK

# Code generation
dart run build_runner build --delete-conflicting-outputs

# Publicação/status
melos run gen:publication-status
```

---

## 📱 App Clusters

| Cluster | Category | eCPM Range | Example Apps |
|---------|----------|------------|--------------|
| **A** | Finance | $25-60 | Mortgage Calc, ROI, Invoice |
| **B** | Health | $15-35 | BMI, Water Tracker, Fasting |
| **C** | Utilities | $8-20 | Unit Converter, Base Converter |
| **D** | Productivity | $8-20 | Word Counter, QR Generator |
| **E** | Media | $10-25 | Image Compressor, Voice Recorder |
| **F** | Niche | $10-30 | Moon Phases, Prayer Times |

---

## 🎨 Design System

### Theme Configuration

```dart
// Each app can customize via AppThemeConfig
AppThemeConfig(
  primaryColor: Colors.green,  // Cluster-specific
  borderRadius: 12.0,
  isDark: false,
)
```

### Cluster Color Schemes

| Cluster | Primary | Secondary |
|---------|---------|-----------|
| Finance | Green/Blue | Grey |
| Health | Blue/Teal | White |
| Utilities | Orange/Grey | Black |
| Productivity | Purple/Indigo | White |
| Media | Pink/Red | Black |
| Niche | Custom per app | - |

---

## 📊 File Dependencies

When editing these files, update dependents:

| File | Dependents |
|------|------------|
| `packages/core/design_system/lib/src/theme/app_theme.dart` | ALL apps |
| `packages/features/settings/lib/src/app_settings_notifier.dart` | ALL apps |
| `packages/features/ad_manager/lib/src/ad_service.dart` | New apps using shared ads |
| `melos.yaml` | All package configurations |
| `analysis_options.yaml` | All packages inherit rules |

---

## 🚀 Quick Start

### Create New App

```bash
/new-app mortgage_calculator finance
```

### Setup AdMob

```bash
/setup-ads mortgage_calculator
```

### Build Release

```bash
melos run build:all
```

---

## 📚 Documentos chave

| Documento | Para quê |
|----------|----------|
| `docs/README.md` | índice da documentação |
| `docs/PLAYBOOK.md` | padrão obrigatório (i18n/tema/settings/ads/arquitetura) |
| `docs/QA.md` | QA Factory (como validar) |
| `docs/MASTER_TEST_PLAN.md` | plano mestre de testes (device real) |
| `docs/PUBLISHING.md` | publicação (Play Console) |
| `docs/KNOWLEDGE_BASE.md` | aprendizados + prevenções |

---

## ⚠️ Critical Rules

1. **Never hardcode Ad Unit IDs** - Read from `assets/ad_config.json`
2. **Never use ScrollView for lists** - Use `ListView.builder`
3. **Never store tokens in SharedPreferences** - Use `flutter_secure_storage`
4. **Always use const constructors** - Performance critical
5. **Never skip platform checks** - iOS ≠ Android conventions

---

> **Remember:** This is a factory. Every change to `packages/` affects 150+ apps. Test thoroughly before committing.
