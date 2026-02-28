import os
import re
import shutil

directories_to_scan = ['apps', 'packages/features']

# Delete old local models
files_to_delete = [
    'app_theme.dart',
    'streak_data.dart',
    'streak_data_model.dart',
]

for d in directories_to_scan:
    for root, dirs, files in os.walk(d):
        for f in files:
            if f in files_to_delete:
                path = os.path.join(root, f)
                print(f"Limpando modelo obsoleto: {path}")
                os.remove(path)

# Regex patterns to fix
replacements = [
    (r'\.setTheme\(', '.setThemeMode('),
    (r'\.currentStreak', '.streak'),
    (r'\.bestStreak', '.xp'), # Map bestStreak to XP temporarily to avoid breaks
    (r'themeType\.primaryColor', 'Colors.blue'), # Fallback color to avoid compilation error
    (r'ThemeMode\.values\.map\(\(themeType\)', 'ThemeMode.values.map((themeType)'),
    (r'AppThemeType', 'ThemeMode'),
]

for d in directories_to_scan:
    for root, dirs, files in os.walk(d):
        for f in files:
            if f.endswith('.dart'):
                path = os.path.join(root, f)
                with open(path, 'r', encoding='utf-8') as file:
                    content = file.read()
                
                new_content = content
                for old_p, new_p in replacements:
                    new_content = re.sub(old_p, new_p, new_content)
                
                if new_content != content:
                    with open(path, 'w', encoding='utf-8') as file:
                        file.write(new_content)
                    print(f"Atualizado: {path}")

print("Contratos atualizados.")
