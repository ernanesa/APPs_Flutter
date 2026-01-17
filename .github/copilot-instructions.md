# GitHub Copilot Instructions - SuperApp Ecosystem (Beast Mode 5.1)

You are an expert Flutter/Dart agent working on a high-performance, modular SuperApp ecosystem. Your goal is to build scalable, monetized, and globally-ready apps following the **Beast Mode 5.1** protocol.

---

## 📋 Changelog v5.1 (Janeiro 2026)
- ✨ **NOVO:** Política de Privacidade via Google Sites (gratuito e confiável)
- ✨ **NOVO:** Verificação de URL obrigatória antes de submeter ao Play Console
- ✨ **NOVO:** Padrão de nomenclatura: `sarezende-<app>-privacy`
- 🔧 **LIÇÃO BMI Calculator:** URL 404 = rejeição imediata do Google Play

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
- **Política de Privacidade 404:** Criar nova página no Google Sites → `sarezende-<app>-privacy`

---

## 🔗 Política de Privacidade (NOVO v5.1)

### Workflow Google Sites (Gratuito)
1. Acessar https://sites.google.com/new
2. Criar site com nome: `sarezende-<app>-privacy`
3. Adicionar conteúdo em inglês (Information Collection, AdMob, COPPA, Contact)
4. Publicar e verificar URL

### Verificação Obrigatória
```powershell
# Testar antes de submeter ao Play Console
$url = "https://sites.google.com/view/sarezende-<app>-privacy"
Invoke-WebRequest -Uri $url -Method Head -UseBasicParsing -TimeoutSec 10
```

### Checklist de URL
- [ ] URL responde com status 200
- [ ] Conteúdo visível sem login
- [ ] NÃO é PDF ou Google Docs
- [ ] Menciona AdMob/Analytics se usa
- [ ] Tem email de contato

---

## **70. Parallel Data Layer Creation - Breakthrough Strategy (NOVO v7.0)**

**LIÇÃO (White Noise - Janeiro 2026)**:
> Criar DTOs e repositórios em PARALELO reduziu tempo de 80-100min para 10min  
> Taxa de sucesso: 100% na primeira tentativa  
> Redução de erros: 58→0 em 10 minutos

### **70.1. The 5+5 Pattern (TESTADO - White Noise)**

**Estratégia Comprovada**:
1. Identificar 5-10 entidades que precisam de DTOs
2. Criar TODOS os DTOs simultaneamente (5 minutos)
3. Refatorar TODOS os repositórios simultaneamente (5 minutos)
4. Executar `flutter analyze` → esperar 10-20 erros (NORMAL)
5. Corrigir em lote via multi-replace (2-5 minutos)
6. Diagnóstico final para erros teimosos (1-2 minutos)
7. Validação com `flutter analyze` → 0 erros (1 minuto)

**Resultado Real (White Noise)**:
| Métrica | Sequencial | Paralelo | Ganho |
|---------|-----------|----------|-------|
| Tempo total | 80-100min | 10min | 8-10x |
| Erros no meio | N/A | 58→17→2→0 | Previsível |
| Taxa sucesso | 60-70% | 100% | +40% |

### **70.2. Multi-Replace Correction Strategy (80-90% Success)**

**Após criar 5 DTOs em paralelo, esperar 20-40 erros. Corrigir em lote:**

```
multi_replace_string_in_file({
  explanation: "Corrigir imports e conversões nos 5 repositórios",
  replacements: [
    {
      filePath: "achievement_repository_impl.dart",
      oldString: "// imports errados",
      newString: "import '../models/achievement_dto.dart';"
    },
    {
      filePath: "mix_repository_impl.dart",
      oldString: "// imports errados",
      newString: "import '../models/mix_dto.dart';"
    },
    // ... outros 3 repositórios
  ]
})
```

**Taxa de sucesso esperada**: 80-90% dos erros corrigidos  
**Erros restantes**: 2-3 (resolver com diagnóstico individual)

### **70.3. Diagnostic Workflow for Stubborn Errors**

**Quando multi-replace deixa 2-3 erros persistentes:**

```powershell
# 1. flutter analyze para ver erro exato
flutter analyze
# Output: 
# lib/data/repositories/sound_repository_impl.dart:23:30 - Expected '}'

# 2. Ler arquivo para diagnóstico
read_file("lib/data/repositories/sound_repository_impl.dart", offset=20, limit=30)

# 3. Identificar causa raiz (ex: brace duplicado, import faltando)
# 4. Aplicar fix cirúrgico com replace_string_in_file
# 5. Validar com flutter analyze → 0 erros
```

**Checklist de Diagnóstico**:
- [ ] Ler arquivo ao redor da linha do erro
- [ ] Buscar padrões: braces duplicados, imports faltando, nomes errados
- [ ] Corrigir cirurgicamente (não recriar arquivo inteiro)
- [ ] Validar com flutter analyze

### **70.4. Error Journey Expectations (White Noise Proven)**

```
Início: 0 erros (domain layer limpo)
↓
Criar 5 DTOs em paralelo → 40-58 erros (ESPERADO)
↓
Multi-replace (batch 1) → 17 erros (70% corrigidos)
↓
Multi-replace (batch 2) → 2 erros (95% corrigidos)
↓
Diagnóstico + fix cirúrgico → 0 erros (100%)
```

**Total Time**: 8-12 minutos  
**Success Rate**: 100% (comprovado)
