import re
import os

path = 'apps/fasting_tracker/lib/services/notification_service.dart'
if os.path.exists(path):
    with open(path, 'r', encoding='utf-8') as f:
        c = f.read()

    # Fix initialization settings
    c = re.sub(r"await _notificationsPlugin\.initialize\([\s\S]*?initializationSettings,[\s\S]*?onDidReceiveNotificationResponse: \(details\) \{",
               """await _notificationsPlugin.initialize(
      initializationSettings: const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(
          requestSoundPermission: false,
          requestBadgePermission: false,
          requestAlertPermission: false,
        ),
      ),
      onDidReceiveNotificationResponse: (details) {""", c)

    with open(path, 'w', encoding='utf-8') as f:
        f.write(c)

