import re
import os
import glob

def reg_rep(path, patterns):
    if not os.path.exists(path): return
    with open(path, 'r', encoding='utf-8') as f:
        c = f.read()
    for p, r in patterns:
        c = re.sub(p, r, c)
    with open(path, 'w', encoding='utf-8') as f:
        f.write(c)

# core_ui
with open('packages/core_ui/lib/core_ui.dart', 'w') as f:
    f.write("export 'src/theme/app_theme.dart';\nexport 'src/widgets/primary_button.dart';\nexport 'src/widgets/base_card.dart';\nexport 'src/tokens/spacing.dart';\n")

# pomodoro_timer
reg_rep('apps/pomodoro_timer/lib/providers/settings_provider.dart', [
    (r"final sharedPreferencesProvider = Provider<SharedPreferences>\(\(ref\) \{.*?\n\}\);", "")
])

# fasting_tracker notification service
reg_rep('apps/fasting_tracker/lib/services/notification_service.dart', [
    (r"uiLocalNotificationDateInterpretation:.*?,\n", ""),
    (r"android: AndroidInitializationSettings\('app_icon'\),", "android: AndroidInitializationSettings('app_icon'),")
])

# white_noise ad widget
reg_rep('apps/white_noise/lib/presentation/widgets/ad_banner_widget.dart', [
    (r"await AdService\.createAdaptiveBannerAd\(.*?\)", "await AdService.createAdaptiveBannerAd(width: constraints.maxWidth.toInt())")
])

