# factory_scaffold_wave3.ps1 - Media and Niche

$apps = @(
  # CLUSTER E - MEDIA (25 apps from doc, white_noise exists)
  @{Name = "image_compressor"; Title = "Image Compressor"; Cluster = "media" },
  @{Name = "image_resizer"; Title = "Image Resizer"; Cluster = "media" },
  @{Name = "color_picker"; Title = "Color Picker"; Cluster = "media" },
  @{Name = "exif_remover"; Title = "EXIF Remover"; Cluster = "media" },
  @{Name = "audio_trimmer"; Title = "Audio Trimmer"; Cluster = "media" },
  @{Name = "voice_recorder"; Title = "Voice Recorder"; Cluster = "media" },
  @{Name = "decibel_meter"; Title = "Decibel Meter"; Cluster = "media" },
  @{Name = "guitar_tuner"; Title = "Guitar Tuner"; Cluster = "media" },
  @{Name = "metronome"; Title = "Metronome"; Cluster = "media" },
  # white_noise exists
  @{Name = "rain_sounds"; Title = "Rain Sounds"; Cluster = "media" },
  @{Name = "fan_sounds"; Title = "Fan Sounds"; Cluster = "media" },
  @{Name = "flashlight"; Title = "Flashlight"; Cluster = "media" },
  @{Name = "magnifier"; Title = "Magnifier"; Cluster = "media" },
  @{Name = "mirror"; Title = "Mirror"; Cluster = "media" },
  @{Name = "green_screen"; Title = "Green Screen"; Cluster = "media" },
  @{Name = "dead_pixel_tester"; Title = "Dead Pixel Tester"; Cluster = "media" },
  @{Name = "reading_light"; Title = "Reading Light"; Cluster = "media" },
  @{Name = "vibration_massager"; Title = "Vibration Massager"; Cluster = "media" },
  @{Name = "dog_whistle"; Title = "Dog Whistle"; Cluster = "media" },
  @{Name = "cat_toy"; Title = "Cat Toy"; Cluster = "media" },
  @{Name = "compass"; Title = "Compass"; Cluster = "media" },
  @{Name = "spirit_level"; Title = "Spirit Level"; Cluster = "media" },
  @{Name = "altimeter"; Title = "Altimeter"; Cluster = "media" },
  @{Name = "speedometer"; Title = "Speedometer"; Cluster = "media" },
    
  # CLUSTER F - NICHE (25 apps from doc)
  @{Name = "moon_phases"; Title = "Moon Phases"; Cluster = "niche" },
  @{Name = "prayer_times"; Title = "Prayer Times"; Cluster = "niche" },
  @{Name = "golden_hour"; Title = "Golden Hour"; Cluster = "niche" },
  @{Name = "plant_identifier"; Title = "Plant Identifier"; Cluster = "niche" },
  @{Name = "plant_watering_reminder"; Title = "Plant Watering Reminder"; Cluster = "niche" },
  @{Name = "signature_generator"; Title = "Signature Generator"; Cluster = "niche" },
  @{Name = "business_card_maker"; Title = "Business Card Maker"; Cluster = "niche" },
  @{Name = "watermark_tool"; Title = "Watermark Tool"; Cluster = "niche" },
  @{Name = "meme_generator"; Title = "Meme Generator"; Cluster = "niche" },
  @{Name = "knitting_counter"; Title = "Knitting Counter"; Cluster = "niche" },
  @{Name = "truco_scoreboard"; Title = "Truco Scoreboard"; Cluster = "niche" },
  @{Name = "periodic_table"; Title = "Periodic Table"; Cluster = "niche" },
  @{Name = "us_constitution"; Title = "US Constitution"; Cluster = "niche" },
  @{Name = "first_aid_manual"; Title = "First Aid Manual"; Cluster = "niche" },
  @{Name = "knot_guide"; Title = "Knot Guide"; Cluster = "niche" },
  @{Name = "vin_decoder"; Title = "VIN Decoder"; Cluster = "niche" },
  @{Name = "obd2_codes"; Title = "OBD2 Codes"; Cluster = "niche" },
  @{Name = "ring_size_calculator"; Title = "Ring Size Calculator"; Cluster = "niche" },
  @{Name = "screen_ruler"; Title = "Screen Ruler"; Cluster = "niche" },
  @{Name = "protractor"; Title = "Protractor"; Cluster = "niche" },
  @{Name = "metal_detector"; Title = "Metal Detector"; Cluster = "niche" },
  @{Name = "people_counter"; Title = "People Counter"; Cluster = "niche" },
  @{Name = "gratitude_journal"; Title = "Gratitude Journal"; Cluster = "niche" },
  @{Name = "haiku_generator"; Title = "Haiku Generator"; Cluster = "niche" },
  @{Name = "fortune_cookie"; Title = "Fortune Cookie"; Cluster = "niche" }
)

foreach ($app in $apps) {
  $name = $app.Name
  $cluster = $app.Cluster
  $path = "apps/$cluster/$name"
  $title = $app.Title
    
  # Skip if already using AppShell
  if ((Test-Path "$path/lib/main.dart")) {
    $content = Get-Content "$path/lib/main.dart" -Raw -ErrorAction SilentlyContinue
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

  # Determine cluster enum
  $clusterEnum = switch ($cluster) {
    "media" { "AppCluster.media" }
    "niche" { "AppCluster.niche" }
    default { "AppCluster.utility" }
  }

  # Main.dart
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
          InputType.number('Input'),
        ],
        formula: (values) {
           // TODO: Implement $name feature
           return values.isNotEmpty ? values[0] : 0.0;
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

Write-Host "`nWave 3 Complete! Scaffolded Media and Niche apps."
