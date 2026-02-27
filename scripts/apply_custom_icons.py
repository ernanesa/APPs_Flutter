import os
import shutil
import subprocess

APPS_DIR = '/home/ernane/Personal/APPs_Flutter/apps'
BRAIN_DIR = '/home/ernane/.gemini/antigravity/brain/69a6d3b7-8a2f-476e-a94d-9f7f76332670'

ICONS_MAPPING = {
    'bmi_calculator': 'icon_bmi_1772215455557.png',
    'compound_interest_calculator': 'icon_compound_1772215469056.png',
    'fasting_tracker': 'icon_fasting_1772215481990.png',
    'pomodoro_timer': 'icon_pomodoro_1772215496913.png',
    'water_tracker': 'icon_water_1772215511297.png',
    'white_noise': 'icon_white_noise_1772215523816.png',
    'super_health_app': 'icon_super_health_1772215536108.png',
}

for app, icon_file in ICONS_MAPPING.items():
    app_dir = os.path.join(APPS_DIR, app)
    if not os.path.exists(app_dir):
        print(f"Skipping {app}, folder not found.")
        continue
    
    # 1. Copy icon
    assets_dir = os.path.join(app_dir, 'assets')
    os.makedirs(assets_dir, exist_ok=True)
    shutil.copy(os.path.join(BRAIN_DIR, icon_file), os.path.join(assets_dir, 'icon.png'))
    print(f"Copied icon for {app}")
    
    # 2. Add dependencies and config to pubspec.yaml
    pubspec_path = os.path.join(app_dir, 'pubspec.yaml')
    with open(pubspec_path, 'r') as f:
        content = f.read()
    
    if 'flutter_launcher_icons:' not in content:
        if 'dev_dependencies:' in content and 'flutter_launcher_icons' not in content:
            content = content.replace('dev_dependencies:', 'dev_dependencies:\n  flutter_launcher_icons: ^0.13.1')
        elif 'dev_dependencies:' not in content:
            content += '\ndev_dependencies:\n  flutter_launcher_icons: ^0.13.1\n'
            
        config = """
flutter_icons:
  android: "launcher_icon"
  ios: true
  image_path: "assets/icon.png"
  min_sdk_android: 21
"""
        content += config
        with open(pubspec_path, 'w') as f:
            f.write(content)
        print(f"Updated pubspec.yaml for {app}")
    
    # 3. Run flutter pub get and generator
    print(f"Running generator for {app}...")
    subprocess.run(['flutter', 'pub', 'get'], cwd=app_dir)
    subprocess.run(['flutter', 'pub', 'run', 'flutter_launcher_icons'], cwd=app_dir)
    print(f"Finished generating icons for {app}\n")

print("All icons successfully generated and applied!")
