import os
import re

def fix_file(path, replacements):
    if not os.path.exists(path): return
    with open(path, 'r', encoding='utf-8') as f: content = f.read()
    new_content = content
    for old, new in replacements:
        new_content = re.sub(old, new, new_content)
    if new_content != content:
        with open(path, 'w', encoding='utf-8') as f: f.write(new_content)

# 1. Fix Pomodoro Timer (Theme & Local Logic)
fix_file('apps/pomodoro_timer/lib/main.dart', [
    (r'import\s+[\'"].*?selected_theme_provider\.dart[\'"];', 'import "package:core_logic/core_logic.dart";'),
    (r'selectedThemeProvider', 'themeProvider'),
    (r'AppTheme\.lightTheme\(selectedTheme\.seedColor\)', 'ThemeData.light().copyWith(primaryColor: selectedTheme.seedColor)'),
    (r'AppTheme\.darkTheme\(selectedTheme\.seedColor\)', 'ThemeData.dark().copyWith(primaryColor: selectedTheme.seedColor)'),
])

# 2. Fix White Noise (Entities)
fix_file('apps/white_noise/lib/domain/entities/streak_entity.dart', [
    (r'final int currentStreak;', 'final int streak;'),
    (r'final int bestStreak;', 'final int xp;'),
])

# 3. Fix ARB plurals (Pomodoro & Compound)
for root, dirs, files in os.walk('apps'):
    for f in files:
        if f.endswith('.arb'):
            path = os.path.join(root, f)
            with open(path, 'r') as file: content = file.read()
            # Ensure plural has 'other'
            if '{count, plural,' in content and 'other' not in content:
                content = content.replace('}', ' other{items}}')
                with open(path, 'w') as file: file.write(content)

