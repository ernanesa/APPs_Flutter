# Padrão Ouro de Performance e Design (2026)

> **MANDATÓRIO PARA TODOS OS APPS E FEATURES DO ECOSSISTEMA**

Este documento define as regras absolutas de performance extrema, latência zero e qualidade premium para todos os aplicativos do SuperApp. Qualquer nova feature ou aplicativo deve herdar e respeitar essas diretrizes.

## 1. Kernel Android & Infraestrutura Nativa
Todas as aplicações devem seguir rigorosamente as seguintes configurações em seus arquivos nativos (`android/app/build.gradle`, `AndroidManifest.xml`):
- **Toolchain de Compilação**: Uso obrigatório de `JavaVersion.VERSION_21` e `jvmTarget = "21"`.
- **SDK Compliance**: Mínimo `minSdkVersion = 26` e `targetSdk = 35` (Android 15+).
- **Engine Flutter**: Ativação explícita da engine **Impeller** via Vulkan para renderização instantânea, sem compilação de shaders tardia (jank):
  `<meta-data android:name="io.flutter.embedding.android.EnableImpeller" android:value="true" />`
- **Predictive Back**: Habilitar a animação preditiva de voltar nativa do Android: `android:enableOnBackInvokedCallback="true"`.

## 2. Design System Premium (Edge-to-Edge)
O app não pode parecer "encaixotado". Ele deve se mesclar perfeitamente ao sistema e à escolha do usuário:
- **Android Native Themes**: O arquivo `styles.xml` deve usar estritamente `Theme.Material3.DayNight.NoActionBar`, com transparência nativa ativada.
- **Material 3 Dynamic Colors**: Todos os apps devem utilizar o pacote `dynamic_color`. O `MaterialApp` na raiz deve ser envolvido pelo `DynamicColorBuilder`, repassando o `ColorScheme` do sistema do usuário em tempo real.
- **Sinestesia e Toque (Haptics)**: Qualquer botão de ação principal (Salvar, Calcular, Deletar) **DEVE** acionar `HapticFeedback.lightImpact()` ou `mediumImpact()`. Isso diferencia um app barato de uma experiência Premium.

## 3. Arquitetura "Zero Latency" (Otimização Extrema)
A interface não pode engasgar. Input de usuário e feedback visual precisam rodar no refresh rate máximo do dispositivo (60/120Hz):
- **O Fim do `setState`**: Para gerenciar lógicas complexas ou inputs dinâmicos, use provedores reativos (Riverpod 3.x), escutando mudanças via `ref.watch` granular.
- **Zero-Cost Isolates (Dart 3.x)**: É PROIBIDO rodar `jsonDecode` ou parsing pesado de Listas no Main Thread. Todo processamento de dados do `SharedPreferences` ou APIs deve ser envolto em `Isolate.run(() => ...)` para não roubar milissegundos da GPU.
- **Isolamento via `RepaintBoundary`**: Quaisquer áreas pesadas ou complexas (Google AdMob, `BackdropFilter` de Glassmorphism, CustomPainters com animações rápidas, ou Textos que não mudam durante uma animação) devem ser encapsuladas em um `RepaintBoundary`. Isso confina o custo de processamento da GPU a uma "ilha".

---
*Este padrão foi ratificado e injetado massivamente no projeto em Fevereiro de 2026. A violação destas regras em code reviews será considerada uma quebra de qualidade Premium.*