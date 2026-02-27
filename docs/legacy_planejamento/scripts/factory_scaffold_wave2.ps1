# factory_scaffold_wave2.ps1 - Finance, Health, Productivity

$apps = @(
  # CLUSTER A - FINANCE (25 apps from doc)
  @{Name = "invoice_generator"; Title = "Invoice Generator"; Cluster = "finance" },
  @{Name = "tip_split_calculator"; Title = "Tip & Split Calculator"; Cluster = "finance" },
  @{Name = "roi_calculator"; Title = "ROI Calculator"; Cluster = "finance" },
  @{Name = "mortgage_calculator"; Title = "Mortgage Calculator"; Cluster = "finance" },
  @{Name = "auto_loan_calculator"; Title = "Auto Loan Calculator"; Cluster = "finance" },
  @{Name = "discount_calculator"; Title = "Discount Calculator"; Cluster = "finance" },
  @{Name = "profit_margin_calculator"; Title = "Profit Margin Calculator"; Cluster = "finance" },
  @{Name = "salary_calculator"; Title = "Salary Calculator"; Cluster = "finance" },
  @{Name = "retirement_calculator"; Title = "Retirement Calculator"; Cluster = "finance" },
  @{Name = "break_even_calculator"; Title = "Break Even Calculator"; Cluster = "finance" },
  @{Name = "mileage_tracker"; Title = "Mileage Tracker"; Cluster = "finance" },
  @{Name = "commission_calculator"; Title = "Commission Calculator"; Cluster = "finance" },
  @{Name = "inflation_calculator"; Title = "Inflation Calculator"; Cluster = "finance" },
  # compound_interest already exists
  @{Name = "unit_price_comparator"; Title = "Unit Price Comparator"; Cluster = "finance" },
  @{Name = "fuel_cost_calculator"; Title = "Fuel Cost Calculator"; Cluster = "finance" },
  @{Name = "rent_vs_buy_calculator"; Title = "Rent vs Buy Calculator"; Cluster = "finance" },
  @{Name = "credit_card_calculator"; Title = "Credit Card Calculator"; Cluster = "finance" },
  @{Name = "net_worth_calculator"; Title = "Net Worth Calculator"; Cluster = "finance" },
  @{Name = "currency_converter"; Title = "Currency Converter"; Cluster = "finance" },
  @{Name = "crypto_calculator"; Title = "Crypto Calculator"; Cluster = "finance" },
  @{Name = "freelance_rate_calculator"; Title = "Freelance Rate Calculator"; Cluster = "finance" },
  @{Name = "dividend_calculator"; Title = "Dividend Calculator"; Cluster = "finance" },
  @{Name = "leasing_calculator"; Title = "Leasing Calculator"; Cluster = "finance" },
  @{Name = "rent_receipt_generator"; Title = "Rent Receipt Generator"; Cluster = "finance" },
    
  # CLUSTER B - HEALTH (25 apps from doc)
  # bmi_calculator already exists
  @{Name = "water_tracker"; Title = "Water Tracker"; Cluster = "health" },
  @{Name = "step_counter"; Title = "Step Counter"; Cluster = "health" },
  @{Name = "bmr_calculator"; Title = "BMR Calculator"; Cluster = "health" },
  # fasting_tracker already exists
  @{Name = "blood_pressure_tracker"; Title = "Blood Pressure Tracker"; Cluster = "health" },
  @{Name = "pregnancy_calculator"; Title = "Pregnancy Calculator"; Cluster = "health" },
  @{Name = "contraction_counter"; Title = "Contraction Counter"; Cluster = "health" },
  @{Name = "period_tracker"; Title = "Period Tracker"; Cluster = "health" },
  @{Name = "breathing_guide"; Title = "Breathing Guide"; Cluster = "health" },
  @{Name = "vision_test"; Title = "Vision Test"; Cluster = "health" },
  @{Name = "protein_calculator"; Title = "Protein Calculator"; Cluster = "health" },
  @{Name = "tooth_brushing_timer"; Title = "Tooth Brushing Timer"; Cluster = "health" },
  @{Name = "hiit_timer"; Title = "HIIT Timer"; Cluster = "health" },
  @{Name = "migraine_diary"; Title = "Migraine Diary"; Cluster = "health" },
  @{Name = "caffeine_tracker"; Title = "Caffeine Tracker"; Cluster = "health" },
  @{Name = "sleep_calculator"; Title = "Sleep Calculator"; Cluster = "health" },
  @{Name = "symptom_tracker"; Title = "Symptom Tracker"; Cluster = "health" },
  @{Name = "weight_tracker"; Title = "Weight Tracker"; Cluster = "health" },
  @{Name = "medication_reminder"; Title = "Medication Reminder"; Cluster = "health" },
  @{Name = "kegel_exercises"; Title = "Kegel Exercises"; Cluster = "health" },
  @{Name = "hearing_test"; Title = "Hearing Test"; Cluster = "health" },
  @{Name = "posture_guide"; Title = "Posture Guide"; Cluster = "health" },
  @{Name = "calorie_calculator"; Title = "Calorie Calculator"; Cluster = "health" },
  @{Name = "macro_calculator"; Title = "Macro Calculator"; Cluster = "health" },
    
  # CLUSTER D - PRODUCTIVITY (25 apps from doc, many exist)
  # word_counter, todo_list, lorem_generator, case_converter, ocr_extractor exist
  # qr_scanner, qr_generator, quick_notes, teleprompter, travel_checklist exist
  # random_name_generator, number_lottery, decision_wheel, game_scoreboard exist
  @{Name = "virtual_dice"; Title = "Virtual Dice"; Cluster = "productivity" },
  @{Name = "multi_timer"; Title = "Multi Timer"; Cluster = "productivity" },
  @{Name = "world_clock"; Title = "World Clock"; Cluster = "productivity" },
  @{Name = "countdown_timer"; Title = "Countdown Timer"; Cluster = "productivity" },
  @{Name = "dog_age_calculator"; Title = "Dog Age Calculator"; Cluster = "productivity" },
  @{Name = "morse_translator"; Title = "Morse Translator"; Cluster = "productivity" },
  @{Name = "nato_alphabet"; Title = "NATO Alphabet"; Cluster = "productivity" },
  @{Name = "anagram_generator"; Title = "Anagram Generator"; Cluster = "productivity" },
  @{Name = "rhyme_dictionary"; Title = "Rhyme Dictionary"; Cluster = "productivity" },
  @{Name = "synonym_antonym"; Title = "Synonym & Antonym"; Cluster = "productivity" },
  @{Name = "quote_generator"; Title = "Quote Generator"; Cluster = "productivity" }
)

foreach ($app in $apps) {
  $name = $app.Name
  $cluster = $app.Cluster
  $path = "apps/$cluster/$name"
  $title = $app.Title
    
  # Skip if already scaffolded with proper structure
  if ((Test-Path "$path/lib/main.dart")) {
    $content = Get-Content "$path/lib/main.dart" -Raw
    if ($content -match "AppShell") {
      Write-Host "Skipping $name (already using AppShell)"
      continue
    }
  }
    
  Write-Host "Scaffolding $name in $cluster..."
    
  # Ensure directories
  if (!(Test-Path $path)) { New-Item -ItemType Directory -Path $path -Force | Out-Null }
  if (!(Test-Path "$path/lib")) { New-Item -ItemType Directory -Path "$path/lib" -Force | Out-Null }
    
  # Pubspec
  $pubspec = @"
name: $name
description: $title
publish_to: 'none'
version: 1.0.0+1

environment:
  sdk: ^3.0.0

dependencies:
  flutter:
    sdk: flutter
  flutter_riverpod: any
  design_system:
    path: ../../../packages/core/design_system
  
dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0

flutter:
  uses-material-design: true
"@
  Set-Content -Path "$path/pubspec.yaml" -Value $pubspec -Encoding UTF8

  # Determine cluster enum value
  $clusterEnum = switch ($cluster) {
    "finance" { "AppCluster.finance" }
    "health" { "AppCluster.health" }
    "productivity" { "AppCluster.productivity" }
    default { "AppCluster.utility" }
  }

  # Main.dart with ConverterTemplate placeholder
  $mainDart = @"
import 'package:flutter/material.dart';
import 'package:design_system/design_system.dart';

void main() {
  runApp(AppShell(
    config: AppConfig(
      title: '$title',
      cluster: $clusterEnum,
      feature: ConverterTemplate(
        inputs: [
          InputType.number('Input 1'),
          InputType.number('Input 2'),
        ],
        formula: (values) {
           // TODO: Implement $name logic
           if (values.isEmpty) return 0.0;
           return values.reduce((a, b) => a + b);
        },
        resultLabel: 'Result',
      ),
    ),
  ));
}
"@
  Set-Content -Path "$path/lib/main.dart" -Value $mainDart -Encoding UTF8
    
  # Clean old structure
  if (Test-Path "$path/lib/src") { Remove-Item "$path/lib/src" -Recurse -Force -ErrorAction SilentlyContinue }
  if (Test-Path "$path/test") { Remove-Item "$path/test" -Recurse -Force -ErrorAction SilentlyContinue }
}

Write-Host "`nWave 2 Complete! Scaffolded Finance, Health, and Productivity apps."
