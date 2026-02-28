import os

# 1. Fix locale_provider missing riverpod import
path = 'packages/core_logic/lib/src/providers/locale_provider.dart'
if os.path.exists(path):
    with open(path, 'r') as f: content = f.read()
    if 'import \'package:flutter_riverpod/flutter_riverpod.dart\';' not in content:
        content = "import 'package:flutter_riverpod/flutter_riverpod.dart';\n" + content
    with open(path, 'w') as f: f.write(content)

# 2. Fix main.dart ConsumerState build signature & AppTheme
path = 'apps/super_health_app/lib/main.dart'
if os.path.exists(path):
    with open(path, 'r') as f: content = f.read()
    content = content.replace('Widget build(BuildContext context, WidgetRef ref) {', 'Widget build(BuildContext context) {')
    if "import 'package:core_ui/core_ui.dart';" not in content:
        content = "import 'package:core_ui/core_ui.dart';\n" + content
    with open(path, 'w') as f: f.write(content)

# 3. Fix BMI and Water using old streak providers
for path in ['packages/features/feature_bmi/lib/screens/home_screen.dart', 'packages/features/feature_water/lib/presentation/screens/home_screen.dart']:
    if os.path.exists(path):
        with open(path, 'r') as f: content = f.read()
        content = content.replace('bmiStreakProvider', 'streakProvider')
        content = content.replace('waterStreakProvider', 'streakProvider')
        with open(path, 'w') as f: f.write(content)

# 4. Fix notification service named parameters
path = 'packages/core_logic/lib/src/services/global_notification_service.dart'
if os.path.exists(path):
    with open(path, 'r') as f: content = f.read()
    content = content.replace('_plugin.initialize(initSettings, onDidReceiveNotificationResponse: null)', '_plugin.initialize(initializationSettings: initSettings)')
    content = content.replace('_plugin.show(id, title, body, notificationDetails: details)', '_plugin.show(id, title, body, notificationDetails: details)')
    with open(path, 'w') as f: f.write(content)

# 5. Fix fasting settings currentTheme.name to currentTheme.mode.name
path = 'packages/features/feature_fasting/lib/presentation/screens/settings_screen.dart'
if os.path.exists(path):
    with open(path, 'r') as f: content = f.read()
    content = content.replace('currentTheme.name', 'currentTheme.mode.name')
    with open(path, 'w') as f: f.write(content)

# 6. Fix achievements call
path = 'packages/features/feature_fasting/lib/presentation/screens/achievements_screen.dart'
if os.path.exists(path):
    with open(path, 'r') as f: content = f.read()
    content = content.replace('"achievementsProgress"()', '0.0')
    with open(path, 'w') as f: f.write(content)

# 7. Fix Streak Badge regex syntax error
path = 'packages/features/feature_fasting/lib/presentation/widgets/streak_badge.dart'
if os.path.exists(path):
    with open(path, 'r') as f: content = f.read()
    content = content.replace("final _ = AppLocalizations.of(context)!;", "")
    content = content.replace("final '' = '';", "")
    with open(path, 'w') as f: f.write(content)

