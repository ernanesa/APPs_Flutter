# factory_scaffold.ps1

$apps = @(
  @{Name = "unit_converter"; Title = "Unit Converter"; Cluster = "utility"; Inputs = @("Value", "From", "To") },
  @{Name = "cooking_converter"; Title = "Cooking Converter"; Cluster = "utility"; Inputs = @("Value", "Density") },
  @{Name = "clothing_size_converter"; Title = "Clothing Size Converter"; Cluster = "utility"; Inputs = @("Size", "Standard", "Target") },
  @{Name = "shoe_size_converter"; Title = "Shoe Size Converter"; Cluster = "utility"; Inputs = @("Size", "Standard", "Target") },
  @{Name = "torque_converter"; Title = "Torque Converter"; Cluster = "utility"; Inputs = @("Value", "From", "To") },
  @{Name = "pressure_converter"; Title = "Pressure Converter"; Cluster = "utility"; Inputs = @("Value", "From", "To") },
  @{Name = "fuel_mix_calculator"; Title = "Fuel Mix Calculator"; Cluster = "utility"; Inputs = @("Gasoline (L)", "Ratio") },
  @{Name = "concrete_calculator"; Title = "Concrete Calculator"; Cluster = "utility"; Inputs = @("Length (m)", "Width (m)", "Depth (m)") },
  @{Name = "brick_calculator"; Title = "Brick Calculator"; Cluster = "utility"; Inputs = @("Wall Length (m)", "Wall Height (m)", "Brick Type") },
  @{Name = "paint_calculator"; Title = "Paint Calculator"; Cluster = "utility"; Inputs = @("Wall Width (m)", "Wall Height (m)", "Coats") },
  @{Name = "number_base_converter"; Title = "Number Base Converter"; Cluster = "utility"; Inputs = @("Value", "From Base", "To Base") },
  @{Name = "resistor_color_code"; Title = "Resistor Color Code"; Cluster = "utility"; Inputs = @("Band 1", "Band 2", "Multiplier") },
  @{Name = "ohms_law_calculator"; Title = "Ohms Law Calculator"; Cluster = "utility"; Inputs = @("Voltage (V)", "Current (I)", "Resistance (R)") },
  @{Name = "voltage_drop_calculator"; Title = "Voltage Drop Calculator"; Cluster = "utility"; Inputs = @("Current", "Distance", "Wire Gauge") },
  @{Name = "temperature_converter"; Title = "Temperature Converter"; Cluster = "utility"; Inputs = @("Value", "From", "To") },
  @{Name = "download_speed_calculator"; Title = "Download Speed Calculator"; Cluster = "utility"; Inputs = @("File Size (GB)", "Speed (Mbps)") },
  @{Name = "ppi_calculator"; Title = "PPI Calculator"; Cluster = "utility"; Inputs = @("Width (px)", "Height (px)", "Diagonal (in)") },
  @{Name = "aspect_ratio_calculator"; Title = "Aspect Ratio Calculator"; Cluster = "utility"; Inputs = @("Width", "Height") },
  @{Name = "timezone_converter"; Title = "Timezone Converter"; Cluster = "utility"; Inputs = @("Time", "From", "To") },
  @{Name = "age_calculator_precise"; Title = "Age Calculator"; Cluster = "utility"; Inputs = @("Birth Date") },
  @{Name = "date_calculator"; Title = "Date Calculator"; Cluster = "utility"; Inputs = @("Start Date", "End Date") },
  @{Name = "password_generator"; Title = "Password Generator"; Cluster = "utility"; Inputs = @("Length") },
  @{Name = "base64_encoder"; Title = "Base64 Encoder"; Cluster = "utility"; Inputs = @("Text") },
  @{Name = "hash_generator"; Title = "Hash Generator"; Cluster = "utility"; Inputs = @("Text") }
)

foreach ($app in $apps) {
  $name = $app.Name
  $path = "apps/utility/$name"
  $title = $app.Title
    
  Write-Host "Scaffolding $name..."
    
  # Ensure directory
  if (!(Test-Path $path)) { New-Item -ItemType Directory -Path $path -Force | Out-Null }
  if (!(Test-Path "$path/lib")) { New-Item -ItemType Directory -Path "$path/lib" -Force | Out-Null }
    
  # Pubspec
  # Using 'any' for flutter_riverpod to resolve compatibility with design_system
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

  # Main.dart
  $inputsDart = ""
  foreach ($inp in $app.Inputs) {
    $inputsDart += "          InputType.number('$inp'),`n"
  }

  $mainDart = @"
import 'package:flutter/material.dart';
import 'package:design_system/design_system.dart';

void main() {
  runApp(AppShell(
    config: AppConfig(
      title: '$title',
      cluster: AppCluster.utility,
      feature: ConverterTemplate(
        inputs: [
$inputsDart
        ],
        formula: (values) {
           // TODO: Implement specific formula for $name
           if (values.isEmpty) return 0.0;
           return values.reduce((a, b) => a * b); // Placeholder
        },
        resultLabel: 'Result',
      ),
    ),
  ));
}
"@
  Set-Content -Path "$path/lib/main.dart" -Value $mainDart -Encoding UTF8
    
  # Remove old src/test if exists
  if (Test-Path "$path/lib/src") { Remove-Item "$path/lib/src" -Recurse -Force }
  if (Test-Path "$path/test") { Remove-Item "$path/test" -Recurse -Force }
}

Write-Host "Wave 1 (Utilities) Complete."
