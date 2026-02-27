# Fix Critical Bugs Discovered in Physical Device Testing
# Date: February 5, 2026
# Issues: BMI Evolution Graph Empty, Pomodoro Timer White Screen

param(
    [switch]$DryRun = $false,
    [switch]$BMIOnly = $false,
    [switch]$PomodoroOnly = $false
)

$ErrorActionPreference = "Stop"
$basePath = "C:\Users\Ernane\Personal\APPs_Flutter_2"

Write-Host "`n╔═══════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║  FIX CRITICAL BUGS - Physical Device Testing         ║" -ForegroundColor Cyan
Write-Host "╚═══════════════════════════════════════════════════════╝`n" -ForegroundColor Cyan

if ($DryRun) {
    Write-Host "🔍 DRY RUN MODE - Nenhuma alteração será feita`n" -ForegroundColor Yellow
}

# ═══════════════════════════════════════════════════════════
# FIX 1: BMI Calculator - Evolution Graph Empty
# ═══════════════════════════════════════════════════════════

if (!$PomodoroOnly) {
    Write-Host "═══════════════════════════════════════════════════════" -ForegroundColor Magenta
    Write-Host "  FIX 1: BMI Calculator - Evolution Graph Empty" -ForegroundColor Magenta
    Write-Host "═══════════════════════════════════════════════════════`n" -ForegroundColor Magenta
    
    Write-Host "📋 Problema:" -ForegroundColor Yellow
    Write-Host "   - Gráfico Evolution mostra eixos mas SEM pontos de dados"
    Write-Host "   - Provider carrega histórico async mas retorna [] antes de terminar"
    Write-Host "   - UI renderiza antes de dados chegarem`n"
    
    Write-Host "🔧 Solução:" -ForegroundColor Green
    Write-Host "   - Converter BmiHistoryNotifier para AsyncNotifier"
    Write-Host "   - Adicionar .when() no EvolutionScreen para loading state"
    Write-Host "   - UI espera dados carregarem antes de renderizar`n"
    
    $bmiProviderPath = Join-Path $basePath "apps\health\bmi_calculator\lib\providers\bmi_provider.dart"
    $bmiScreenPath = Join-Path $basePath "apps\health\bmi_calculator\lib\screens\evolution_screen.dart"
    
    if ($DryRun) {
        Write-Host "   [DRY RUN] Arquivos a serem modificados:" -ForegroundColor Gray
        Write-Host "   - $bmiProviderPath" -ForegroundColor Gray
        Write-Host "   - $bmiScreenPath`n" -ForegroundColor Gray
    } else {
        Write-Host "⚠️  ATENÇÃO: Esta correção requer edição manual do código!" -ForegroundColor Red
        Write-Host "`nPara corrigir manualmente, faça:`n"
        
        Write-Host "1️⃣  Edite: $bmiProviderPath" -ForegroundColor Cyan
        Write-Host @"
   
   MUDE DE:
   final bmiHistoryProvider = NotifierProvider<BmiHistoryNotifier, List<BmiEntry>>(
     BmiHistoryNotifier.new,
   );

   class BmiHistoryNotifier extends Notifier<List<BmiEntry>> {
     @override
     List<BmiEntry> build() {
       _loadHistory();  // ❌ Async sem await
       return [];       // ❌ Retorna vazio antes de carregar
     }
   
   PARA:
   final bmiHistoryProvider = AsyncNotifierProvider<BmiHistoryNotifier, List<BmiEntry>>(
     BmiHistoryNotifier.new,
   );

   class BmiHistoryNotifier extends AsyncNotifier<List<BmiEntry>> {
     @override
     Future<List<BmiEntry>> build() async {
       final prefs = await SharedPreferences.getInstance();
       final String? historyJson = prefs.getString(_storageKey);
       if (historyJson != null) {
         final List<dynamic> decoded = json.decode(historyJson);
         final list = decoded.map((item) => BmiEntry.fromMap(item)).toList();
         list.sort((a, b) => b.date.compareTo(a.date));
         return list;
       }
       return [];
     }
"@
        
        Write-Host "`n2️⃣  Edite: $bmiScreenPath" -ForegroundColor Cyan
        Write-Host @"
   
   MUDE build() PARA:
   @override
   Widget build(BuildContext context, WidgetRef ref) {
     final historyAsync = ref.watch(bmiHistoryProvider);
     final l10n = AppLocalizations.of(context)!;

     return historyAsync.when(
       data: (history) {
         if (history.length < 2) {
           return Center(
             child: Padding(/* empty state message */),
           );
         }
         
         // Código do gráfico existente aqui
         return Padding(/* código do chart */);
       },
       loading: () => const Center(
         child: CircularProgressIndicator(),
       ),
       error: (error, stack) => Center(
         child: Text('Error loading history: \$error'),
       ),
     );
   }
"@
        
        Write-Host "`n📝 Após editar, teste:" -ForegroundColor Yellow
        Write-Host "   1. Adicione 2+ cálculos de BMI"
        Write-Host "   2. Navegue para tab Evolution"
        Write-Host "   3. Verifique que gráfico mostra pontos (não vazio)"
        Write-Host "   4. Feche e reabra app"
        Write-Host "   5. Verifique que pontos persistiram`n"
    }
}

# ═══════════════════════════════════════════════════════════
# FIX 2: Pomodoro Timer - White Screen / Frozen
# ═══════════════════════════════════════════════════════════

if (!$BMIOnly) {
    Write-Host "═══════════════════════════════════════════════════════" -ForegroundColor Magenta
    Write-Host "  FIX 2: Pomodoro Timer - White/Pink Screen Frozen" -ForegroundColor Magenta
    Write-Host "═══════════════════════════════════════════════════════`n" -ForegroundColor Magenta
    
    Write-Host "📋 Problema:" -ForegroundColor Yellow
    Write-Host "   - Tela rosa/branca sem conteúdo"
    Write-Host "   - Apenas AppBar visível"
    Write-Host "   - App parece congelado em loading state`n"
    
    Write-Host "🔧 Solução (Diagnóstico Primeiro):" -ForegroundColor Green
    Write-Host "   - Adicionar debug logging em appInitializationProvider"
    Write-Host "   - Melhorar UI de loading state (cores contrastantes)"
    Write-Host "   - Adicionar timeout de 10 segundos`n"
    
    $pomodoroMainPath = Join-Path $basePath "apps\productivity\pomodoro_timer\lib\main.dart"
    
    if ($DryRun) {
        Write-Host "   [DRY RUN] Arquivo a ser modificado:" -ForegroundColor Gray
        Write-Host "   - $pomodoroMainPath`n" -ForegroundColor Gray
    } else {
        Write-Host "⚠️  DIAGNÓSTICO PRIMEIRO: Adicione logging para identificar onde trava`n" -ForegroundColor Red
        
        Write-Host "1️⃣  Edite: $pomodoroMainPath" -ForegroundColor Cyan
        Write-Host @"
   
   ADICIONE debug no appInitializationProvider (linha ~33):
   
   final appInitializationProvider = FutureProvider.family<bool, SharedPreferences>((ref, prefs) async {
     debugPrint('🔵 [POMODORO INIT] Starting initialization...');
     try {
       debugPrint('🔵 [POMODORO INIT] Initializing deep links...');
       await DeepLinkService.instance.initialize(prefs);
       debugPrint('✅ [POMODORO INIT] Deep links OK');

       if (!kE2ETest) {
         debugPrint('🔵 [POMODORO INIT] Initializing AdMob...');
         await AdService.instance.initialize();
         debugPrint('✅ [POMODORO INIT] AdMob OK');

         debugPrint('🔵 [POMODORO INIT] Gathering consent...');
         ConsentService.instance.gatherConsent(
           onConsentComplete: (error) {
             if (error != null) {
               debugPrint('❌ [POMODORO INIT] Consent error: \${error.message}');
             } else {
               debugPrint('✅ [POMODORO INIT] Consent OK');
             }
           },
         );
       }
       
       debugPrint('✅ [POMODORO INIT] Initialization complete');
       return true;
     } catch (e, st) {
       debugPrint('❌ [POMODORO INIT] Error: \$e\n\$st');
       return true;
     }
   });
"@
        
        Write-Host "`n2️⃣  MELHORE o Loading State (linha ~145):" -ForegroundColor Cyan
        Write-Host @"
   
   SUBSTITUA:
   loading: () => MaterialApp(
     theme: AppTheme.light(themeConfig),
     darkTheme: AppTheme.dark(themeConfig),
     themeMode: appSettings.themeMode,
     home: const Scaffold(
       body: Center(
         child: Column(
           mainAxisAlignment: MainAxisAlignment.center,
           children: [
             CircularProgressIndicator(),
             SizedBox(height: 16),
             Text('Loading...', style: TextStyle(fontSize: 16)),
           ],
         ),
       ),
     ),
   ),
   
   POR:
   loading: () => MaterialApp(
     theme: AppTheme.light(themeConfig),
     darkTheme: AppTheme.dark(themeConfig),
     themeMode: appSettings.themeMode,
     home: Scaffold(
       backgroundColor: Colors.white,  // ✅ Fundo branco explícito
       body: Center(
         child: Column(
           mainAxisAlignment: MainAxisAlignment.center,
           children: [
             CircularProgressIndicator(
               color: themeConfig.primaryColor,  // ✅ Cor visível
             ),
             const SizedBox(height: 16),
             const Text(
               'Pomodoro Timer Loading...',
               style: TextStyle(
                 fontSize: 16,
                 color: Colors.black87,  // ✅ Texto preto visível
                 fontWeight: FontWeight.w500,
               ),
             ),
             const SizedBox(height: 8),
             const Text(
               'Initializing services...',
               style: TextStyle(
                 fontSize: 12,
                 color: Colors.black54,
               ),
             ),
           ],
         ),
       ),
     ),
   ),
"@
        
        Write-Host "`n📝 Após editar, teste no dispositivo físico:" -ForegroundColor Yellow
        Write-Host "   1. Desinstale o app completamente:"
        Write-Host "      adb -s 8c7638ff uninstall sa.rezende.pomodoro_timer`n"
        Write-Host "   2. Compile e instale novamente:"
        Write-Host "      cd apps/productivity/pomodoro_timer"
        Write-Host "      flutter build apk --debug"
        Write-Host "      adb -s 8c7638ff install build/app/outputs/flutter-apk/app-debug.apk`n"
        Write-Host "   3. Capture logs enquanto abre:"
        Write-Host "      adb -s 8c7638ff logcat | Select-String 'POMODORO INIT'`n"
        Write-Host "   4. Identifique onde trava:"
        Write-Host "      - Se parar em 'Initializing deep links' = problema no DeepLinkService"
        Write-Host "      - Se parar em 'Initializing AdMob' = problema no AdService"
        Write-Host "      - Se parar em 'Gathering consent' = problema no ConsentService"
        Write-Host "      - Se NÃO aparecer nenhum log = problema no appSettingsProvider`n"
    }
}

# ═══════════════════════════════════════════════════════════
# SUMMARY
# ═══════════════════════════════════════════════════════════

Write-Host "`n╔═══════════════════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "║  RESUMO DAS CORREÇÕES                                 ║" -ForegroundColor Green
Write-Host "╚═══════════════════════════════════════════════════════╝`n" -ForegroundColor Green

Write-Host "✅ Documentação atualizada:" -ForegroundColor Cyan
Write-Host "   - docs/APRENDIZADOS_CRITICOS_20260205.md (CRIADO)"
Write-Host "   - .github/copilot-instructions.md (ATUALIZADO)`n"

Write-Host "⚠️  Correções MANUAIS necessárias:" -ForegroundColor Yellow
if (!$PomodoroOnly) {
    Write-Host "   1. BMI Calculator - Evolution Graph:"
    Write-Host "      - Converter para AsyncNotifier"
    Write-Host "      - Adicionar .when() no widget"
}
if (!$BMIOnly) {
    Write-Host "   2. Pomodoro Timer - White Screen:"
    Write-Host "      - Adicionar debug logging"
    Write-Host "      - Melhorar loading state UI"
    Write-Host "      - Testar no dispositivo físico com logs"
}

Write-Host "`n📋 PRÓXIMOS PASSOS:" -ForegroundColor Magenta
Write-Host "   1. Aplicar correções manualmente (seguir instruções acima)"
Write-Host "   2. Testar no dispositivo físico (8c7638ff)"
Write-Host "   3. Capturar novos screenshots para validação"
Write-Host "   4. Atualizar artifacts/ com screenshots corrigidos"
Write-Host "   5. Re-executar test_interactive_visual.ps1 para confirmar fixes`n"

Write-Host "📚 Referências:" -ForegroundColor Cyan
Write-Host "   - Aprendizados: docs/APRENDIZADOS_CRITICOS_20260205.md"
Write-Host "   - Screenshots originais: artifacts/interactive_test_20260205_114933"
Write-Host "   - Riverpod AsyncNotifier: https://riverpod.dev/docs/concepts/about_code_generation`n"

if ($DryRun) {
    Write-Host "🔍 DRY RUN COMPLETO - Nenhuma alteração foi feita`n" -ForegroundColor Yellow
}

Write-Host "═══════════════════════════════════════════════════════`n" -ForegroundColor Cyan
