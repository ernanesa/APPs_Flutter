import os
import re

# 1. Fix global notification service parameters for v20
path = 'packages/core_logic/lib/src/services/global_notification_service.dart'
if os.path.exists(path):
    with open(path, 'r') as f: content = f.read()
    content = content.replace('_plugin.initialize(initSettings)', "_plugin.initialize(initSettings, onDidReceiveNotificationResponse: null)")
    content = content.replace('_plugin.show(id, title, body, details)', "_plugin.show(id, title, body, notificationDetails: details)")
    with open(path, 'w') as f: f.write(content)

# 2. Fix fasting screens
for root, dirs, files in os.walk('packages/features/feature_fasting'):
    for f in files:
        if f.endswith('.dart'):
            path = os.path.join(root, f)
            with open(path, 'r') as f: content = f.read()
            # replace remaining l10n and achievements
            content = re.sub(r'l10n:[^,]+,?', '', content)
            content = re.sub(r'\bl10n\b', "''", content)
            content = re.sub(r'final\s+;\n', '', content)
            content = re.sub(r'AppLocalizations[^;]+;', '', content)
            content = content.replace('ref.watch(achievementsProvider)', 'null')
            content = content.replace('"achievementsProgress"()', '0.0')
            with open(path, 'w') as f: f.write(content)

print("Applied final UI fixes.")
