import os
import re
import subprocess

APPS_DIR = 'apps'
styles_xml_content = '''<?xml version="1.0" encoding="utf-8"?>
<resources>
    <style name="LaunchTheme" parent="Theme.Material3.DayNight.NoActionBar">
        <item name="android:windowBackground">@drawable/launch_background</item>
        <item name="android:windowTranslucentStatus">true</item>
        <item name="android:windowTranslucentNavigation">true</item>
        <item name="android:windowLayoutInDisplayCutoutMode">shortEdges</item>
    </style>

    <style name="NormalTheme" parent="Theme.Material3.DayNight.NoActionBar">
        <item name="android:windowBackground">?android:colorBackground</item>
        <item name="android:windowDrawsSystemBarBackgrounds">true</item>
        <item name="android:statusBarColor">@android:color/transparent</item>
        <item name="android:navigationBarColor">@android:color/transparent</item>
        <item name="android:windowLayoutInDisplayCutoutMode">shortEdges</item>
    </style>
</resources>
'''

for app in os.listdir(APPS_DIR):
    app_path = os.path.join(APPS_DIR, app)
    if not os.path.isdir(app_path): continue
    
    print(f"Otimizando {app}...")
    
    # 1. Android build.gradle
    build_gradle_path = os.path.join(app_path, 'android', 'app', 'build.gradle')
    if os.path.exists(build_gradle_path):
        with open(build_gradle_path, 'r') as f:
            content = f.read()
        content = re.sub(r'JavaVersion\.VERSION_1_8', 'JavaVersion.VERSION_21', content)
        content = re.sub(r'JavaVersion\.VERSION_11', 'JavaVersion.VERSION_21', content)
        content = re.sub(r'jvmTarget\s*=\s*["\']?(1\.8|11|17|JavaVersion\.VERSION_1_8)["\']?', 'jvmTarget = "21"', content)
        with open(build_gradle_path, 'w') as f:
            f.write(content)
            
    # 2. AndroidManifest.xml
    manifest_path = os.path.join(app_path, 'android', 'app', 'src', 'main', 'AndroidManifest.xml')
    if os.path.exists(manifest_path):
        with open(manifest_path, 'r') as f:
            content = f.read()
        if 'EnableImpeller' not in content:
            content = content.replace('<activity', '<activity\n            android:enableOnBackInvokedCallback="true"')
            impeller_meta = '<meta-data android:name="io.flutter.embedding.android.EnableImpeller" android:value="true" />'
            content = content.replace('</activity>', f'    {impeller_meta}\n        </activity>')
        content = content.replace('@style/LaunchTheme', '@style/NormalTheme')
        with open(manifest_path, 'w') as f:
            f.write(content)
            
    # 3. styles.xml
    styles_path = os.path.join(app_path, 'android', 'app', 'src', 'main', 'res', 'values', 'styles.xml')
    if os.path.exists(styles_path):
        with open(styles_path, 'w') as f:
            f.write(styles_xml_content)

    # 4. pubspec.yaml -> Adicionar dynamic_color
    pubspec_path = os.path.join(app_path, 'pubspec.yaml')
    if os.path.exists(pubspec_path):
        print(f"  Instalando dynamic_color em {app}...")
        subprocess.run(['flutter', 'pub', 'add', 'dynamic_color'], cwd=app_path, stdout=subprocess.DEVNULL)

print("✅ Todos os apps receberam o Padrão Ouro Nativo.")
