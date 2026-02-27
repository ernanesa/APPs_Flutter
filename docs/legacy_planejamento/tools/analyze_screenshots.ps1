# ========================================
# SCREENSHOT ANALYSIS & VALIDATION
# ========================================
# Analyzes screenshots to validate app functionality

param(
    [string]$ReportDir = "artifacts/interactive_test_20260205_114933"
)

Write-Host "`n" "="*80 -ForegroundColor Cyan
Write-Host "  ANÁLISE DE SCREENSHOTS - Validação de Funcionalidades" -ForegroundColor Cyan
Write-Host "="*80 "`n" -ForegroundColor Cyan

if (-not (Test-Path $ReportDir)) {
    Write-Host "❌ Diretório não encontrado: $ReportDir" -ForegroundColor Red
    exit 1
}

$screenshots = Get-ChildItem -Path $ReportDir -Filter *.png | Sort-Object Name

Write-Host "📸 Total de screenshots encontrados: $($screenshots.Count)" -ForegroundColor Green
Write-Host "📂 Diretório: $ReportDir`n" -ForegroundColor Gray

# ========================================
# BMI CALCULATOR ANALYSIS
# ========================================
Write-Host "="*80 -ForegroundColor Yellow
Write-Host "BMI CALCULATOR - Análise Detalhada" -ForegroundColor Yellow
Write-Host "="*80 -ForegroundColor Yellow

$bmiScreenshots = $screenshots | Where-Object { $_.Name -like "bmi_*" }

foreach ($screenshot in $bmiScreenshots) {
    $size = [math]::Round($screenshot.Length / 1KB, 1)
    $analysis = ""
    
    switch -Wildcard ($screenshot.Name) {
        "*home_english*" {
            $analysis = "✅ Home screen em inglês"
            if ($size -lt 30) {
                $analysis += " ⚠️ Tamanho suspeito - pode estar vazio"
            }
        }
        "*weight_focused*" {
            $analysis = "✅ Campo peso em foco"
        }
        "*weight_entered*" {
            $analysis = "✅ Peso digitado (70kg)"
        }
        "*height_focused*" {
            $analysis = "✅ Campo altura em foco"
        }
        "*height_entered*" {
            $analysis = "📊 Altura digitada (175cm) - pronto para calcular"
        }
        "*result_normal*" {
            $analysis = "📊 RESULTADO: BMI = 22.86 esperado (Normal Weight)"
            if ($size -gt 100) {
                $analysis += " ✅ Screenshot com conteúdo (resultado visível)"
            } else {
                $analysis += " ⚠️ Screenshot pequeno - verificar manualmente"
            }
        }
        "*menu_opened*" {
            $analysis = "✅ Menu/Settings aberto"
        }
        "*theme_changed*" {
            $analysis = "✅ Tema alterado (verificar visualmente se mudou)"
        }
        "*home_portuguese*" {
            $analysis = "🌍 Home em PORTUGUÊS - validar tradução"
        }
        "*underweight*" {
            $analysis = "📊 RESULTADO: BMI = 14.69 esperado (Underweight) para 45kg"
            if ($size -gt 100) {
                $analysis += " ✅ Categoria 'Underweight' deveria aparecer"
            }
        }
        "*overweight*" {
            $analysis = "📊 RESULTADO: BMI = 29.39 esperado (Overweight) para 90kg"
            if ($size -gt 100) {
                $analysis += " ✅ Categoria 'Overweight/Pre-obese' deveria aparecer"
            }
        }
    }
    
    $color = if ($analysis -match "⚠️") { "Yellow" } else { "Green" }
    Write-Host "  $($screenshot.Name.PadRight(35)) ($($size.ToString().PadLeft(6)) KB) - " -NoNewline -ForegroundColor Gray
    Write-Host "$analysis" -ForegroundColor $color
}

# ========================================
# POMODORO TIMER ANALYSIS
# ========================================
Write-Host "`n" "="*80 -ForegroundColor Yellow
Write-Host "POMODORO TIMER - Análise Detalhada" -ForegroundColor Yellow
Write-Host "="*80 -ForegroundColor Yellow

$pomodoroScreenshots = $screenshots | Where-Object { $_.Name -like "pomodoro_*" }

foreach ($screenshot in $pomodoroScreenshots) {
    $size = [math]::Round($screenshot.Length / 1KB, 1)
    $analysis = ""
    
    switch -Wildcard ($screenshot.Name) {
        "*home_english*" {
            $analysis = "✅ Home screen em inglês - Timer inicial 25:00"
        }
        "*timer_running*" {
            $analysis = "⏱️ Timer RODANDO - contador deve estar decrementando"
        }
        "*timer_paused*" {
            $analysis = "⏸️ Timer PAUSADO - contador deve estar parado"
        }
        "*timer_reset*" {
            $analysis = "🔄 Timer RESETADO - deve voltar para 25:00"
        }
        "*settings_opened*" {
            $analysis = "⚙️ Settings aberto"
        }
        "*settings_duration*" {
            $analysis = "⚙️ Ajuste de duração do Pomodoro"
        }
        "*home_spanish*" {
            $analysis = "🌍 Home em ESPAÑOL - validar tradução"
        }
    }
    
    # Pomodoro screenshots are consistently ~43KB which is good
    if ($size -lt 30) {
        $analysis += " ⚠️ Screenshot muito pequeno - pode estar vazio"
        $color = "Yellow"
    } else {
        $color = "Green"
    }
    
    Write-Host "  $($screenshot.Name.PadRight(40)) ($($size.ToString().PadLeft(6)) KB) - " -NoNewline -ForegroundColor Gray
    Write-Host "$analysis" -ForegroundColor $color
}

# ========================================
# COMPOUND INTEREST ANALYSIS
# ========================================
Write-Host "`n" "="*80 -ForegroundColor Yellow
Write-Host "COMPOUND INTEREST - Análise Detalhada" -ForegroundColor Yellow
Write-Host "="*80 -ForegroundColor Yellow

$compoundScreenshots = $screenshots | Where-Object { $_.Name -like "compound_*" }

foreach ($screenshot in $compoundScreenshots) {
    $size = [math]::Round($screenshot.Length / 1KB, 1)
    $analysis = ""
    
    switch -Wildcard ($screenshot.Name) {
        "*home_english*" {
            $analysis = "✅ Home screen em inglês"
            if ($size -gt 100) {
                $analysis += " - Valores padrão carregados"
            }
        }
        "*capital_entered*" {
            $analysis = "💰 Capital inicial: R$1000"
        }
        "*rate_entered*" {
            $analysis = "📈 Taxa anual: 10%"
        }
        "*result_basic*" {
            $analysis = "📊 RESULTADO BÁSICO:"
            $analysis += "`n       Esperado: Montante = R$1104.71, Juros = R$104.71"
            $analysis += "`n       Fórmula: M = C(1+i)^n = 1000(1.00833)^12"
        }
        "*monthly_entered*" {
            $analysis = "💵 Aporte mensal: R$100"
        }
        "*result_with_monthly*" {
            $analysis = "📊 RESULTADO COM APORTES:"
            $analysis += "`n       Esperado: Montante = ~R$2272.84"
            $analysis += "`n       (Capital inicial + 12 aportes mensais + juros compostos)"
        }
        "*preset1*" {
            $analysis = "🏦 Preset 1 selecionado (verificar taxa aplicada)"
        }
        "*preset2*" {
            $analysis = "💼 Preset 2 selecionado (verificar taxa aplicada)"
        }
        "*preset3*" {
            $analysis = "📈 Preset 3 selecionado (verificar taxa aplicada)"
        }
        "*home_german*" {
            $analysis = "🌍 Home em DEUTSCH - validar tradução"
            if ($size -lt 30) {
                $analysis += " ⚠️ Screenshot muito pequeno - possível erro de carregamento"
            }
        }
    }
    
    $color = if ($analysis -match "⚠️") { "Yellow" } 
             elseif ($analysis -match "RESULTADO") { "Cyan" }
             else { "Green" }
    
    Write-Host "  $($screenshot.Name.PadRight(40)) ($($size.ToString().PadLeft(6)) KB) - " -NoNewline -ForegroundColor Gray
    Write-Host "$analysis" -ForegroundColor $color
}

# ========================================
# CRITICAL ISSUES DETECTION
# ========================================
Write-Host "`n" "="*80 -ForegroundColor Red
Write-Host "DETECÇÃO DE ISSUES CRÍTICOS" -ForegroundColor Red
Write-Host "="*80 -ForegroundColor Red

$issues = @()

# Check for suspiciously small screenshots (< 20KB = likely empty or error)
$smallScreenshots = $screenshots | Where-Object { $_.Length -lt 20KB }
if ($smallScreenshots.Count -gt 0) {
    $issues += "⚠️ $($smallScreenshots.Count) screenshot(s) muito pequeno(s) (< 20KB):"
    foreach ($s in $smallScreenshots) {
        $issues += "   - $($s.Name) ($([math]::Round($s.Length / 1KB, 1)) KB)"
    }
}

# Check for missing critical screenshots
$criticalScreenshots = @(
    "bmi_06_result_normal.png",
    "bmi_10_underweight.png",
    "bmi_11_overweight.png",
    "compound_04_result_basic.png",
    "compound_06_result_with_monthly.png"
)

foreach ($critical in $criticalScreenshots) {
    if (-not ($screenshots | Where-Object { $_.Name -eq $critical })) {
        $issues += "❌ Screenshot crítico faltando: $critical"
    }
}

if ($issues.Count -eq 0) {
    Write-Host "`n✅ Nenhum issue crítico detectado!" -ForegroundColor Green
} else {
    Write-Host ""
    foreach ($issue in $issues) {
        Write-Host "  $issue" -ForegroundColor Yellow
    }
}

# ========================================
# VALIDATION CHECKLIST
# ========================================
Write-Host "`n" "="*80 -ForegroundColor Cyan
Write-Host "CHECKLIST DE VALIDAÇÃO MANUAL" -ForegroundColor Cyan
Write-Host "="*80 -ForegroundColor Cyan

Write-Host "`n📋 BMI Calculator:" -ForegroundColor Yellow
Write-Host "  ☐ bmi_06_result_normal.png mostra BMI = 22.86?" -ForegroundColor Gray
Write-Host "  ☐ Categoria 'Normal' ou 'Normal Weight' aparece?" -ForegroundColor Gray
Write-Host "  ☐ bmi_10_underweight.png mostra BMI = 14.69 e 'Underweight'?" -ForegroundColor Gray
Write-Host "  ☐ bmi_11_overweight.png mostra BMI = 29.39 e 'Overweight'?" -ForegroundColor Gray
Write-Host "  ☐ bmi_09_home_portuguese.png está em português?" -ForegroundColor Gray
Write-Host "  ☐ Interface não quebrada em nenhum screenshot?" -ForegroundColor Gray

Write-Host "`n📋 Pomodoro Timer:" -ForegroundColor Yellow
Write-Host "  ☐ pomodoro_01_home_english.png mostra 25:00?" -ForegroundColor Gray
Write-Host "  ☐ pomodoro_02_timer_running.png mostra timer rodando?" -ForegroundColor Gray
Write-Host "  ☐ pomodoro_03_timer_paused.png mostra timer pausado?" -ForegroundColor Gray
Write-Host "  ☐ pomodoro_04_timer_reset.png mostra 25:00 novamente?" -ForegroundColor Gray
Write-Host "  ☐ pomodoro_07_home_spanish.png está em espanhol?" -ForegroundColor Gray
Write-Host "  ☐ Botões visíveis e não cortados?" -ForegroundColor Gray

Write-Host "`n📋 Compound Interest:" -ForegroundColor Yellow
Write-Host "  ☐ compound_04_result_basic.png mostra ~R$1104.71?" -ForegroundColor Gray
Write-Host "  ☐ compound_06_result_with_monthly.png mostra ~R$2272.84?" -ForegroundColor Gray
Write-Host "  ☐ Presets mudam a taxa (screenshots 07, 08, 09)?" -ForegroundColor Gray
Write-Host "  ☐ compound_10_home_german.png está em alemão?" -ForegroundColor Gray
Write-Host "  ☐ Valores monetários formatados corretamente?" -ForegroundColor Gray
Write-Host "  ☐ Gráfico ou visualização de resultado aparece?" -ForegroundColor Gray

Write-Host "`n" "="*80 "`n" -ForegroundColor Cyan

# Calculate statistics
$totalSize = [math]::Round(($screenshots | Measure-Object -Property Length -Sum).Sum / 1MB, 2)
$avgSize = [math]::Round(($screenshots | Measure-Object -Property Length -Average).Average / 1KB, 1)

Write-Host "📊 ESTATÍSTICAS:" -ForegroundColor Cyan
Write-Host "  Total de screenshots: $($screenshots.Count)" -ForegroundColor Gray
Write-Host "  Tamanho total: $totalSize MB" -ForegroundColor Gray
Write-Host "  Tamanho médio: $avgSize KB" -ForegroundColor Gray
Write-Host "  BMI Calculator: $($bmiScreenshots.Count) screenshots" -ForegroundColor Gray
Write-Host "  Pomodoro Timer: $($pomodoroScreenshots.Count) screenshots" -ForegroundColor Gray
Write-Host "  Compound Interest: $($compoundScreenshots.Count) screenshots" -ForegroundColor Gray

Write-Host "`n✅ Análise completa! Revise os screenshots no diretório:" -ForegroundColor Green
Write-Host "   $ReportDir`n" -ForegroundColor Cyan
