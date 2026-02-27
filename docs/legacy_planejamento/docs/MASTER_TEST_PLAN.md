# 📱 MASTER TEST PLAN - SuperApp Factory

**O Plano de Testes Mais Completo do Mundo**

> Versão: 1.0 | Criado: 5 de Fevereiro de 2026
> Filosofia: "Não basta abrir o app - é preciso USAR, CALCULAR, SALVAR, MODIFICAR, VALIDAR."

---

## 📋 SUMÁRIO

1. [Filosofia e Princípios](#1-filosofia-e-princípios)
2. [Tipos de Testes](#2-tipos-de-testes)
3. [Pirâmide de Testes](#3-pirâmide-de-testes)
4. [Cenários de Teste por Tipo de App](#4-cenários-de-teste-por-tipo-de-app)
5. [Matriz de Dispositivos](#5-matriz-de-dispositivos)
6. [Gestos e Interações](#6-gestos-e-interações)
7. [Testes de Interrupção](#7-testes-de-interrupção)
8. [Testes de Rede](#8-testes-de-rede)
9. [Testes de Acessibilidade](#9-testes-de-acessibilidade)
10. [Testes de i18n (15 idiomas)](#10-testes-de-i18n-15-idiomas)
11. [Métricas de Qualidade](#11-métricas-de-qualidade)
12. [Checklists de Execução](#12-checklists-de-execução)
13. [Script de Automação](#13-script-de-automação)
14. [Lições Críticas Aprendidas](#14-lições-críticas-aprendidas)

---

## 0.2 Addendum: QA Autonomy (v1.0)

Este adendo formaliza os requisitos para operar o pipeline de QA do workspace (ver `docs/QA.md`).

Principais regras operacionais:
- **Quality gate mínimo:** `melos run qa`
- **Assets Play Store:** `melos run check:store_assets`
- **Pipeline completo (por app):** `melos run validate:qa:full -- -AppName <app>`
- **Device físico:** obrigatório antes de publicar (emulador não basta)
- **Artefatos:** goldens/screenshots em `artifacts/` (e Git LFS quando necessário)

## 1. FILOSOFIA E PRINCÍPIOS

### 🎯 Princípio Fundamental

> **"Um teste que só abre o app não é teste - é PIADA."**

Todo teste DEVE:
1. **INSERIR** valores reais
2. **CALCULAR/PROCESSAR** algo
3. **VALIDAR** o resultado
4. **SALVAR** dados
5. **RECARREGAR** e verificar persistência
6. **MODIFICAR** configurações
7. **VERIFICAR** que modificações persistem

### 📐 Regras de Ouro

| #   | Regra                          | Por quê                          |
| --- | ------------------------------ | -------------------------------- |
| 1   | **Device físico > Emulador**   | Emulador esconde bugs críticos   |
| 2   | **Screenshot de CADA ação**    | Evidência visual é lei           |
| 3   | **Delay de 100ms entre ações** | Permite observação humana        |
| 4   | **Kill & restart**             | Testa persistência real          |
| 5   | **15 idiomas**                 | Mercado global                   |
| 6   | **Loading states visíveis**    | Usuário sabe que está carregando |

---

## 2. TIPOS DE TESTES

### 2.1 Testes Funcionais

| Categoria           | O que Testar                          | Prioridade |
| ------------------- | ------------------------------------- | ---------- |
| **UI**              | Layout, widgets, textos, imagens      | 🔴 Crítico  |
| **Navegação**       | Todas as telas acessíveis, back stack | 🔴 Crítico  |
| **Formulários**     | Validação, erros, formatos            | 🔴 Crítico  |
| **Cálculos**        | Precisão matemática, edge cases       | 🔴 Crítico  |
| **Persistência**    | Dados sobrevivem restart              | 🔴 Crítico  |
| **Gráficos/Charts** | Dados históricos exibidos             | 🔴 Crítico  |

### 2.2 Testes Não-Funcionais

| Categoria       | O que Testar                   | Target    |
| --------------- | ------------------------------ | --------- |
| **Performance** | Startup < 2s, 60 FPS           | 🔴 Crítico |
| **Memória**     | Sem leaks, < 100MB             | 🟡 Alto    |
| **Bateria**     | Consumo mínimo em background   | 🟡 Alto    |
| **Tamanho APK** | < 30MB                         | 🟢 Médio   |
| **Segurança**   | Dados sensíveis criptografados | 🟡 Alto    |

### 2.3 Testes de Compatibilidade

| Dimensão            | Range                    | Prioridade |
| ------------------- | ------------------------ | ---------- |
| **Android OS**      | API 26-36 (Android 8-16) | 🔴 Crítico  |
| **Tamanho de Tela** | 5" a 10"                 | 🔴 Crítico  |
| **Densidade**       | mdpi a xxxhdpi           | 🟡 Alto     |
| **RAM**             | 2GB a 16GB               | 🟡 Alto     |

---

## 3. PIRÂMIDE DE TESTES

```
                    ┌───────────────────┐
                    │    E2E Device     │  10%  - Device físico
                    │     (Patrol)      │        Lento, confiável
                    ├───────────────────┤
                    │    Integration    │  20%  - Fluxos completos
                    │  (flutter_test)   │        Componentes conectados
                    ├───────────────────┤
                    │    Widget Tests   │  30%  - Componentes isolados
                    │  (flutter_test)   │        Rápido, focado
                    ├───────────────────┤
                    │    Unit Tests     │  40%  - Lógica pura
                    │  (flutter_test)   │        Instantâneo
                    └───────────────────┘
```

### Cobertura Mínima Exigida

| Área                       | Cobertura Mínima |
| -------------------------- | ---------------- |
| Lógica de negócio (domain) | 90%              |
| Cálculos e formatadores    | 100%             |
| Providers/State management | 80%              |
| Widgets críticos           | 70%              |
| Utilitários                | 60%              |
| **TOTAL**                  | **75%**          |

---

## 4. CENÁRIOS DE TESTE POR TIPO DE APP

### 4.1 🧮 Apps de Calculadora (BMI, Compound Interest, etc.)

```yaml
CENÁRIO_COMPLETO:
  preparação:
    - App instalado
    - Dados anteriores limpos (opcional)

  teste_entrada_valores:
    - Abrir app
    - Screenshot: tela inicial
    - Tap no campo 1 (peso/principal)
    - Limpar campo (backspace x5)
    - Inserir valor: "75"
    - Screenshot: valor inserido
    - Tap no campo 2 (altura/taxa)
    - Limpar campo
    - Inserir valor: "175"
    - Screenshot: segundo valor inserido
    - Fechar teclado (KEYCODE_BACK)
    - Screenshot: tela pronta para cálculo

  teste_cálculo:
    - Tap botão calcular
    - Aguardar 500ms
    - Screenshot: resultado exibido
    - Validar texto do resultado (ex: "22.86" ou "Normal")

  teste_persistência:
    - Navegar para histórico/evolução
    - Screenshot: tela de histórico
    - Verificar que novo cálculo aparece na lista
    - Force stop app: `am force-stop <package>`
    - Reabrir app
    - Navegar para histórico
    - Screenshot: após restart
    - Verificar que dados persistem

  teste_configurações:
    - Navegar para settings
    - Screenshot: configurações
    - Modificar unidade (kg→lbs ou metric→imperial)
    - Screenshot: unidade modificada
    - Voltar para home
    - Verificar que exibe na nova unidade
    - Restart app
    - Verificar que configuração persiste

  casos_de_borda:
    - Valor negativo: deve rejeitar ou validar
    - Valor zero: deve tratar graciosamente
    - Valor muito grande (999999): deve funcionar
    - Divisão por zero: deve mostrar erro amigável
    - Precisão decimal: 0.1 + 0.2 deve = 0.3 (não 0.30000000004)
```

### 4.2 ⏱️ Apps de Timer/Pomodoro

```yaml
CENÁRIO_COMPLETO:
  teste_timer_básico:
    - Abrir app
    - Screenshot: tela inicial (timer zerado ou configurado)
    - Tap botão START
    - Aguardar 3 segundos
    - Screenshot: timer rodando (verificar countdown)
    - Tap botão PAUSE
    - Aguardar 2 segundos
    - Screenshot: timer pausado
    - Verificar que tempo NÃO avançou durante pause
    - Tap botão RESUME
    - Aguardar 2 segundos
    - Screenshot: timer rodando novamente
    - Tap botão RESET
    - Screenshot: timer resetado

  teste_background:
    - Iniciar timer
    - Screenshot: timer rodando
    - Pressionar HOME (app vai para background)
    - Aguardar 10 segundos
    - Reabrir app
    - Screenshot: após voltar do background
    - Verificar que timer avançou ~10 segundos

  teste_kill_recovery:
    - Iniciar timer
    - Force stop: `am force-stop <package>`
    - Reabrir app
    - Screenshot: após kill
    - Verificar comportamento (deve mostrar estado salvo ou resetar)

  teste_notificações:
    - Configurar timer para 1 minuto
    - Iniciar timer
    - Enviar app para background
    - Aguardar timer completar
    - Verificar notificação no notification shade
    - Screenshot: notificação

  teste_configurações:
    - Abrir settings
    - Screenshot: configurações
    - Modificar duração do pomodoro (25→30 min)
    - Modificar som de notificação
    - Modificar tema (light→dark)
    - Screenshot: após modificações
    - Restart app
    - Verificar que configurações persistem
```

### 4.3 🏋️ Apps de Saúde/Fitness (Fasting, Weight Tracker)

```yaml
CENÁRIO_COMPLETO:
  teste_entrada_dados:
    - Abrir app
    - Screenshot: tela inicial
    - Criar nova entrada (jejum, peso, etc.)
    - Screenshot: formulário de entrada
    - Preencher dados com valores válidos
    - Screenshot: dados preenchidos
    - Salvar
    - Screenshot: após salvar

  teste_histórico_e_gráficos:
    - Navegar para tela de histórico/evolução
    - Screenshot: gráfico com dados
    - Verificar que dados aparecem no gráfico
    - Scroll vertical (se lista)
    - Scroll horizontal (se gráfico timeline)
    - Screenshot: após interação com gráfico

  teste_edição:
    - Selecionar entrada existente
    - Screenshot: detalhes da entrada
    - Editar valores
    - Salvar
    - Screenshot: após edição
    - Verificar que gráfico reflete alteração

  teste_exclusão:
    - Selecionar entrada
    - Excluir (long press ou swipe ou botão delete)
    - Screenshot: confirmação de exclusão
    - Confirmar exclusão
    - Screenshot: após exclusão
    - Verificar que entrada sumiu do histórico e gráfico

  teste_persistência_completa:
    - Criar 3 entradas com datas diferentes
    - Verificar gráfico mostra evolução
    - Force stop app
    - Reabrir
    - Screenshot: gráfico após restart
    - Verificar que TODAS as entradas persistem
    - ⚠️ CRÍTICO: Gráfico NÃO pode estar vazio!
```

### 4.4 🎵 Apps de Mídia (White Noise, Music)

```yaml
CENÁRIO_COMPLETO:
  teste_playback:
    - Abrir app
    - Screenshot: tela inicial com lista de sons
    - Tap em um som para reproduzir
    - Aguardar 2 segundos
    - Screenshot: som reproduzindo (indicador visual)
    - Verificar que áudio está tocando
    - Tap pause
    - Screenshot: pausado
    - Verificar que áudio parou

  teste_mixagem:
    - Selecionar som 1
    - Ajustar volume (slider)
    - Screenshot: volume ajustado
    - Selecionar som 2 (se app suporta mix)
    - Screenshot: dois sons selecionados
    - Verificar mixagem

  teste_background:
    - Iniciar reprodução
    - Enviar para background
    - Aguardar 10 segundos
    - Verificar que áudio continua
    - Verificar controles no notification shade
    - Screenshot: notificação de mídia

  teste_configurações:
    - Abrir settings
    - Modificar tema
    - Modificar timer de sleep
    - Screenshot: configurações
    - Restart
    - Verificar persistência
```

### 4.5 📝 Apps de Produtividade (Todo, Notes)

```yaml
CENÁRIO_COMPLETO:
  teste_crud_completo:
    - Abrir app
    - Screenshot: lista vazia ou com itens
    - Criar novo item
    - Preencher título e descrição
    - Screenshot: formulário preenchido
    - Salvar
    - Screenshot: item na lista
    - Tap no item para editar
    - Screenshot: tela de edição
    - Modificar conteúdo
    - Salvar
    - Screenshot: após edição
    - Marcar como completo (checkbox)
    - Screenshot: item completado
    - Excluir item (swipe ou botão)
    - Screenshot: item removido

  teste_ordenação:
    - Criar 5 itens
    - Alterar ordenação (data, prioridade, alfabético)
    - Screenshot: cada ordenação

  teste_filtros:
    - Criar itens com diferentes status
    - Aplicar filtro (todos, completos, pendentes)
    - Screenshot: cada filtro

  teste_busca:
    - Tap no ícone de busca
    - Digitar termo de busca
    - Screenshot: resultados
    - Limpar busca
    - Screenshot: lista restaurada
```

### 4.6 🎲 Apps Genéricos (decisão genérica)

```yaml
CENÁRIO_BÁSICO:
  exploração_completa:
    - Abrir app
    - Screenshot: home
    - Tap centro da tela (ação principal)
    - Screenshot: após ação
    - Tap canto superior direito (settings/menu)
    - Screenshot: menu/settings
    - Voltar (KEYCODE_BACK)
    - Swipe down (refresh)
    - Screenshot: após swipe
    - Swipe left (navegação)
    - Screenshot: após swipe left
    - Swipe right (navegação)
    - Screenshot: após swipe right
    - Long press no centro (contexto)
    - Screenshot: menu de contexto (se houver)
```

---

## 5. MATRIZ DE DISPOSITIVOS

### 5.1 Devices Físicos Obrigatórios

| Categoria        | Device Recomendado      | Prioridade |
| ---------------- | ----------------------- | ---------- |
| **Phone Small**  | Pixel 4a / Galaxy A32   | 🔴 Crítico  |
| **Phone Medium** | Pixel 7 / Galaxy S22    | 🔴 Crítico  |
| **Phone Large**  | Pixel 7 Pro / S24 Ultra | 🟡 Alto     |
| **Low-end**      | 2GB RAM, Android 8      | 🔴 Crítico  |
| **Tablet**       | Galaxy Tab S8           | 🟡 Alto     |

### 5.2 Emuladores (apenas desenvolvimento)

| AVD         | API | Uso              |
| ----------- | --- | ---------------- |
| Phone_API26 | 26  | Mínimo suportado |
| Phone_API35 | 35  | Target atual     |
| Tablet_10   | 35  | Layout tablet    |

### 5.3 Telas e Densidades

```
OBRIGATÓRIO TESTAR:
├── 5.0" - 360x640 (mdpi)
├── 5.5" - 1080x1920 (xxhdpi)
├── 6.0" - 1080x2340 (xxhdpi)
├── 6.7" - 1440x3200 (xxxhdpi)
├── 7.0" tablet - 800x1280 (hdpi)
└── 10.1" tablet - 1200x1920 (xhdpi)
```

---

## 6. GESTOS E INTERAÇÕES

### 6.1 Comandos ADB para Gestos

```powershell
# TAP (clique)
adb shell input tap <x> <y>

# SWIPE (deslizar)
adb shell input swipe <x1> <y1> <x2> <y2> <duration_ms>

# LONG PRESS (toque longo)
adb shell input swipe <x> <y> <x> <y> 500

# TEXTO
adb shell input text "valor"

# TECLAS ESPECIAIS
adb shell input keyevent KEYCODE_BACK
adb shell input keyevent KEYCODE_HOME
adb shell input keyevent KEYCODE_DEL      # Backspace
adb shell input keyevent KEYCODE_ENTER
adb shell input keyevent KEYCODE_MOVE_END
adb shell input keyevent KEYCODE_TAB

# SCROLL
adb shell input swipe 540 1500 540 500 300  # Scroll up
adb shell input swipe 540 500 540 1500 300  # Scroll down

# PINCH (zoom) - requer coordenadas específicas
# Melhor usar via Espresso ou Patrol
```

### 6.2 Gestos a Validar

| Gesto           | Teste             | Comando                             |
| --------------- | ----------------- | ----------------------------------- |
| Tap             | Botões, links     | `input tap x y`                     |
| Double tap      | Zoom, like        | `input tap x y; input tap x y`      |
| Long press      | Menu contexto     | `input swipe x y x y 500`           |
| Swipe left      | Navegação, delete | `input swipe 800 1000 200 1000 200` |
| Swipe right     | Navegação, back   | `input swipe 200 1000 800 1000 200` |
| Swipe up        | Scroll            | `input swipe 540 1500 540 500 200`  |
| Swipe down      | Refresh           | `input swipe 540 500 540 1500 200`  |
| Pinch in        | Zoom out          | Widget test                         |
| Pinch out       | Zoom in           | Widget test                         |
| Pull to refresh | Atualizar lista   | `input swipe 540 300 540 1200 300`  |

---

## 7. TESTES DE INTERRUPÇÃO

### 7.1 Cenários Obrigatórios

| Interrupção        | Comportamento Esperado | Comando ADB                                                                                            |
| ------------------ | ---------------------- | ------------------------------------------------------------------------------------------------------ |
| Chamada telefônica | Pausar, retomar após   | — (manual)                                                                                             |
| SMS/Notificação    | Não crashar            | `am broadcast -a android.intent.action.SMS_RECEIVED`                                                   |
| Low battery        | Continuar funcionando  | `am broadcast -a android.intent.action.BATTERY_LOW`                                                    |
| Multitasking       | Preservar estado       | `HOME` + reabrir                                                                                       |
| Screen off/on      | Retomar onde parou     | `KEYCODE_POWER` x2                                                                                     |
| Rotação            | Layout adapta          | `content insert --uri content://settings/system --bind name:s:accelerometer_rotation --bind value:i:0` |

### 7.2 Script de Teste de Interrupção

```powershell
function Test-Interruption {
    param([string]$Package)

    # Iniciar app
    adb shell am start -n "$Package/.MainActivity"
    Start-Sleep -Seconds 2

    # Simular low battery
    Write-Host "Testing: Low Battery"
    adb shell am broadcast -a android.intent.action.BATTERY_LOW
    Start-Sleep -Seconds 1
    adb exec-out screencap -p > "interruption_battery.png"

    # Simular multitask
    Write-Host "Testing: Multitask (HOME + return)"
    adb shell input keyevent KEYCODE_HOME
    Start-Sleep -Seconds 3
    adb shell am start -n "$Package/.MainActivity"
    Start-Sleep -Seconds 1
    adb exec-out screencap -p > "interruption_multitask.png"

    # Simular rotação
    Write-Host "Testing: Rotation"
    adb shell content insert --uri content://settings/system --bind name:s:accelerometer_rotation --bind value:i:0
    adb shell content insert --uri content://settings/system --bind name:s:user_rotation --bind value:i:1
    Start-Sleep -Seconds 1
    adb exec-out screencap -p > "interruption_landscape.png"
    adb shell content insert --uri content://settings/system --bind name:s:user_rotation --bind value:i:0
    Start-Sleep -Seconds 1
    adb exec-out screencap -p > "interruption_portrait_restored.png"
}
```

---

## 8. TESTES DE REDE

### 8.1 Cenários de Rede

| Condição          | Teste                | Comportamento Esperado                     |
| ----------------- | -------------------- | ------------------------------------------ |
| Sem rede          | Desativar WiFi/dados | Mostrar dados em cache ou mensagem offline |
| Rede lenta (2G)   | Throttle 50kbps      | Loading state, sem timeout prematuro       |
| Rede intermitente | Toggle rápido        | Retry logic, sem crash                     |
| Switch WiFi→4G    | Mudar conexão        | Requisições continuam                      |

### 8.2 Comandos para Simular Rede

```powershell
# Desativar WiFi
adb shell svc wifi disable

# Desativar dados móveis
adb shell svc data disable

# Reativar
adb shell svc wifi enable
adb shell svc data enable

# Modo avião
adb shell settings put global airplane_mode_on 1
adb shell am broadcast -a android.intent.action.AIRPLANE_MODE

# Throttle (requer root ou emulador)
# No emulador: Extended Controls > Cellular > Network Type
```

---

## 9. TESTES DE ACESSIBILIDADE

### 9.1 Checklist WCAG 2.1

| Critério                  | Requisito                      | Como Testar                    |
| ------------------------- | ------------------------------ | ------------------------------ |
| **Alternativas de texto** | Imagens têm descrição          | TalkBack lê todas as imagens   |
| **Contraste**             | 4.5:1 texto normal, 3:1 grande | Ferramentas de contraste       |
| **Tamanho do toque**      | ≥ 48dp                         | Medir com régua de layout      |
| **Feedback**              | Ações têm confirmação          | Ativar TalkBack                |
| **Navegação por teclado** | Funciona sem touch             | Teclado Bluetooth              |
| **Font scaling**          | Funciona com 200%              | Settings > Display > Font size |

### 9.2 Testes com TalkBack

```powershell
# Ativar TalkBack
adb shell settings put secure enabled_accessibility_services com.google.android.marvin.talkback/com.google.android.marvin.talkback.TalkBackService
adb shell settings put secure accessibility_enabled 1

# Desativar TalkBack
adb shell settings put secure enabled_accessibility_services ""
adb shell settings put secure accessibility_enabled 0
```

### 9.3 Validação Flutter

```dart
// Todo widget interativo DEVE ter semanticsLabel
ElevatedButton(
  key: const Key('calculate_button'),
  onPressed: () => calculate(),
  child: Text(l10n.calculate),
  // ✅ OBRIGATÓRIO para acessibilidade
  semanticsLabel: 'Calculate BMI, double tap to activate',
)

// Icons DEVEM ter semanticLabel
Icon(
  Icons.settings,
  semanticLabel: 'Settings',
)

// Images DEVEM ter semanticLabel
Image.asset(
  'assets/logo.png',
  semanticLabel: 'App logo',
)
```

---

## 10. TESTES DE i18n (15 IDIOMAS)

### 10.1 Idiomas Obrigatórios

| Código | Idioma           | Direção | População |
| ------ | ---------------- | ------- | --------- |
| en     | English          | LTR     | 1.5B      |
| zh     | 中文 (Chinese)   | LTR     | 1.1B      |
| hi     | हिन्दी (Hindi)      | LTR     | 600M      |
| es     | Español          | LTR     | 550M      |
| ar     | العربية (Arabic) | **RTL** | 400M      |
| bn     | বাংলা (Bengali)     | LTR     | 270M      |
| pt     | Português        | LTR     | 260M      |
| ru     | Русский          | LTR     | 250M      |
| ja     | 日本語           | LTR     | 125M      |
| de     | Deutsch          | LTR     | 100M      |
| fr     | Français         | LTR     | 100M      |
| ko     | 한국어 (Korean)  | LTR     | 80M       |
| id     | Indonesian       | LTR     | 200M      |
| it     | Italiano         | LTR     | 65M       |
| tr     | Türkçe           | LTR     | 80M       |

### 10.2 Script de Teste de Idiomas

```powershell
$locales = @("en-US", "zh-CN", "hi-IN", "es-ES", "ar-SA", "bn-BD", "pt-BR", "ru-RU", "ja-JP", "de-DE", "fr-FR", "ko-KR", "id-ID", "it-IT", "tr-TR")

foreach ($locale in $locales) {
    Write-Host "Testing: $locale"

    # Mudar idioma
    adb shell "setprop persist.sys.locale $locale; setprop ctl.restart zygote"
    Start-Sleep -Seconds 30  # Aguardar reinício

    # Abrir app
    adb shell am start -n "$Package/.MainActivity"
    Start-Sleep -Seconds 2

    # Screenshot
    adb exec-out screencap -p > "locale_$locale.png"

    # Verificações:
    # - Textos traduzidos
    # - Sem overflow
    # - RTL correto (ar-SA)
}
```

### 10.3 Checklist RTL (Árabe)

- [ ] Layout espelhado (elementos à direita)
- [ ] Texto alinhado à direita
- [ ] Ícones direcionais espelhados (setas, etc.)
- [ ] Gestos de navegação invertidos
- [ ] Date picker funciona corretamente
- [ ] Números exibidos corretamente (LTR dentro de RTL)

---

## 11. MÉTRICAS DE QUALIDADE

### 11.1 Targets Obrigatórios

| Métrica             | Target  | Crítico | Fonte                   |
| ------------------- | ------- | ------- | ----------------------- |
| **Crash-free rate** | > 99.5% | < 98%   | Firebase Crashlytics    |
| **ANR rate**        | < 0.47% | > 0.5%  | Play Console            |
| **Cold startup**    | < 2s    | > 4s    | Profiler                |
| **Warm startup**    | < 1s    | > 2s    | Profiler                |
| **Frame rate**      | 60fps   | < 50fps | DevTools                |
| **Memory (idle)**   | < 100MB | > 200MB | Profiler                |
| **APK size**        | < 30MB  | > 50MB  | Build output            |
| **Test coverage**   | > 75%   | < 50%   | flutter test --coverage |

### 11.2 Play Store Requirements (2026)

| Requisito      | Valor                    |
| -------------- | ------------------------ |
| ANR rate       | < 0.47%                  |
| Crash rate     | < 1.09%                  |
| Target SDK     | API 35+                  |
| 64-bit         | Obrigatório              |
| 16KB page size | Obrigatório (AGP 8.5.1+) |

---

## 12. CHECKLISTS DE EXECUÇÃO

### 12.1 Checklist Pré-Build

- [ ] `flutter analyze` sem erros
- [ ] `flutter test` 100% passing
- [ ] Traduções geradas (`flutter gen-l10n`)
- [ ] Ícone customizado (NÃO é Flutter default)
- [ ] IDs AdMob de produção configurados
- [ ] Versão incrementada

### 12.2 Checklist por App - EXECUÇÃO COMPLETA

```yaml
# SALVAR COMO: test_execution_checklist.yaml

app_name: ________________
data_teste: ________________
testador: ________________

PRE_REQUISITOS:
  - [ ] App instalado no device físico
  - [ ] Device conectado (adb devices)
  - [ ] Pasta de screenshots criada

TESTES_FUNCIONAIS:
  abertura:
    - [ ] App abre sem crash
    - [ ] Tela inicial carrega completamente
    - [ ] Loading state visível (se houver)
    - [ ] Screenshot: 01_home.png

  entrada_de_dados:
    - [ ] Campo 1 recebe foco ao tap
    - [ ] Teclado aparece
    - [ ] Valor inserido corretamente
    - [ ] Screenshot: 02_input_1.png
    - [ ] Campo 2 recebe foco
    - [ ] Valor inserido corretamente
    - [ ] Screenshot: 03_input_2.png

  processamento:
    - [ ] Botão de ação clicado
    - [ ] Resultado exibido corretamente
    - [ ] Resultado matematicamente correto
    - [ ] Screenshot: 04_result.png

  persistencia:
    - [ ] Navegar para histórico/evolução
    - [ ] Dados aparecem no histórico
    - [ ] Gráfico exibe dados (SE APLICÁVEL)
    - [ ] Screenshot: 05_history.png
    - [ ] Force stop app
    - [ ] Reabrir app
    - [ ] Dados persistem após restart
    - [ ] Screenshot: 06_after_restart.png

  configuracoes:
    - [ ] Abrir settings
    - [ ] Screenshot: 07_settings.png
    - [ ] Modificar configuração 1
    - [ ] Modificar configuração 2
    - [ ] Modificar tema (light/dark)
    - [ ] Screenshot: 08_settings_modified.png
    - [ ] Voltar para home
    - [ ] Verificar que modificações aplicadas
    - [ ] Restart app
    - [ ] Verificar que configurações persistem

TESTES_EDGE_CASES:
  - [ ] Valor negativo: rejeita ou trata
  - [ ] Valor zero: trata graciosamente
  - [ ] Valor muito grande: funciona
  - [ ] Caracteres inválidos: rejeita

TESTES_NAO_FUNCIONAIS:
  performance:
    - [ ] Startup < 2 segundos
    - [ ] Sem jank (60fps)
    - [ ] Sem memory leaks

  interrupcoes:
    - [ ] Multitask (HOME + voltar): OK
    - [ ] Rotação: layout adapta
    - [ ] Low battery: não afeta

TESTES_I18N:
  - [ ] Inglês: textos corretos
  - [ ] Português: tradução completa
  - [ ] Árabe (RTL): layout espelhado
  - [ ] Alemão: sem overflow (textos longos)

RESULTADO:
  status: [ ] PASSED  [ ] FAILED
  bugs_encontrados:
    -
    -
  screenshots_salvos: ________________
  observacoes:
    -
```

---

## 13. SCRIPT DE AUTOMAÇÃO

### 13.1 Localização do Script

```
tools/
├── test_apps_COMPLETE.ps1     # Script principal
├── test_functions.ps1          # Funções auxiliares
└── app_test_scenarios/         # Cenários por app
    ├── bmi_calculator.yaml
    ├── pomodoro_timer.yaml
    └── compound_interest.yaml
```

### 13.2 Parâmetros do Script

```powershell
# Uso completo
.\test_apps_COMPLETE.ps1 `
    -Apps "bmi_calculator,pomodoro_timer" `
    -DelayMs 100 `
    -Languages "en,pt,ar" `
    -IncludeInterruption $true `
    -IncludeNetwork $false `
    -SaveScreenshots $true `
    -ReportFormat "markdown"

# Uso rápido (smoke test)
.\test_apps_COMPLETE.ps1 -Apps "all" -Quick
```

### 13.3 Estrutura de Output

```
artifacts/
└── test_run_20260205_143000/
    ├── REPORT.md                 # Relatório geral
    ├── bmi_calculator/
    │   ├── screenshots/
    │   │   ├── 01_home.png
    │   │   ├── 02_weight_input.png
    │   │   └── ...
    │   ├── logcat.txt
    │   └── result.json
    └── pomodoro_timer/
        └── ...
```

---

## 14. LIÇÕES CRÍTICAS APRENDIDAS

### 14.1 Emulador vs Device Físico

```
❌ PERIGO: 9/9 testes passaram no emulador
✅ REALIDADE: Device físico revelou 2 bugs CRÍTICOS:
   - BMI: Gráfico de evolução VAZIO
   - Pomodoro: Tela branca/congelada

🎯 REGRA: SEMPRE testar em device físico antes de release
```

### 14.2 Async Loading Bug

```dart
// ❌ BUG: Provider retorna lista vazia antes de carregar
@override
List<BmiEntry> build() {
  _loadHistory();  // Async sem await!
  return [];       // UI renderiza vazio
}

// ✅ CORRETO: AsyncNotifier + .when()
@override
Future<List<BmiEntry>> build() async {
  return await _loadHistory();
}

// Na UI:
historyAsync.when(
  data: (data) => Chart(data),
  loading: () => CircularProgressIndicator(),
  error: (e, s) => ErrorWidget(e),
);
```

### 14.3 Loading State Invisível

```dart
// ❌ ERRADO: Loading parece app travado
loading: () => Scaffold(
  backgroundColor: Colors.white,  // Igual ao conteúdo!
  body: Center(child: CircularProgressIndicator()),
)

// ✅ CORRETO: Loading visível e contrastante
loading: () => Scaffold(
  backgroundColor: Colors.grey[200],  // CONTRASTE
  body: Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircularProgressIndicator(color: Colors.blue),
        SizedBox(height: 16),
        Text('Carregando...'),
      ],
    ),
  ),
)
```

### 14.4 Screenshots São Evidência

```
REGRA DE OURO:
├── Screenshot ANTES de cada ação
├── Screenshot DEPOIS de cada ação
├── Delay de observação = 100ms (mínimo)
├── Nomes descritivos: [app]_[step]_[lang].png
└── REVISAR TODOS os screenshots manualmente
```

---

## 📚 REFERÊNCIAS

- [Google Android Testing Guidelines](https://developer.android.com/training/testing)
- [Apple XCTest Documentation](https://developer.apple.com/documentation/xctest)
- [Flutter Testing Documentation](https://docs.flutter.dev/testing)
- [WCAG 2.1 Guidelines](https://www.w3.org/WAI/WCAG21/quickref/)
- [ISTQB Mobile Testing](https://www.istqb.org/)

---

**Versão:** 1.0 | **Criado:** 5 de Fevereiro de 2026
**Autor:** Test Engineering Team | SuperApp Factory

> *"Teste tudo. Valide cada pixel. Meça cada milissegundo. Zero bugs em produção."*
