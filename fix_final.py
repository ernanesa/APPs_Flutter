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

# 1. pomodoro_timer
reg_rep('apps/pomodoro_timer/lib/providers/settings_provider.dart', [
    (r"final sharedPreferencesProvider[\s\S]*?\}\);", "")
])

# 2. compound_interest_calculator
reg_rep('apps/compound_interest_calculator/lib/main.dart', [
    (r"if \(state == AppLifecycleState.resumed && await ConsentService\.canRequestAds\(\)\)[\s\S]*?\}", 
     "if (state == AppLifecycleState.resumed) {\n      ConsentService.canRequestAds().then((can) {\n        if (can) AdService.showAppOpenAdIfAvailable();\n      });\n    }"),
    (r"if \(await ConsentService\.canRequestAds\(\)\)", "final canReq = await ConsentService.canRequestAds();\n  if (canReq)")
])
reg_rep('apps/compound_interest_calculator/lib/presentation/providers/history_provider.dart', [
    (r"\.valueOrNull", ".value")
])
reg_rep('apps/compound_interest_calculator/lib/presentation/screens/calculator_screen.dart', [
    (r"final historyNotifier = ref\.read\(historyProvider\.notifier\);\n", ""),
    (r"\.valueOrNull", ".value")
])

# 3. fasting_tracker
# Fix references to shared_prefs_provider in all of fasting_tracker
for f in glob.glob('apps/fasting_tracker/lib/**/*.dart', recursive=True):
    reg_rep(f, [
        (r"import '.*?shared_prefs_provider\.dart';", "import 'package:core_logic/core_logic.dart';")
    ])

reg_rep('apps/fasting_tracker/lib/services/notification_service.dart', [
    (r"android: AndroidInitializationSettings", "AndroidInitializationSettings"),
])

reg_rep('apps/fasting_tracker/lib/widgets/ad_banner_widget.dart', [
    (r"!AdService\.adsEnabled", "!(AdService.adsEnabled)"),
    (r"AdService\.createAdaptiveBannerAd\(", "AdService.createAdaptiveBannerAd(width: constraints.maxWidth.toInt(),"),
    (r"onLoaded: ", "onAdLoaded: "),
    (r"onFailed: ", "onAdFailedToLoad: ")
])

# 4. white_noise
reg_rep('apps/white_noise/lib/main.dart', [
    (r"if \(state == AppLifecycleState.resumed && await ConsentService\.canRequestAds\(\)\)[\s\S]*?\}", 
     "if (state == AppLifecycleState.resumed) {\n      ConsentService.canRequestAds().then((can) {\n        if (can) AdService.showAppOpenAdIfAvailable();\n      });\n    }"),
    (r"final prefsAsync = ref\.watch\(sharedPreferencesProvider\);\n\n    return prefsAsync\.when\([\s\S]*?\);", 
     "return const _AppRoot();"),
    (r"if \(await ConsentService\.canRequestAds\(\)\)", "final canReq = await ConsentService.canRequestAds();\n  if (canReq)")
])

reg_rep('apps/white_noise/lib/presentation/providers/repository_providers.dart', [
    (r"\.requireValue", "")
])

reg_rep('apps/white_noise/lib/presentation/screens/settings_screen.dart', [
    (r"isPrivacyOptionsRequired", "privacyOptionsRequirementStatus() == PrivacyOptionsRequirementStatus.required"),
    (r"ConsentService\.showPrivacyOptions\(\)", "ConsentService.showPrivacyOptionsForm()")
])

reg_rep('apps/white_noise/lib/presentation/widgets/ad_banner_widget.dart', [
    (r"await AdService\.createAdaptiveBannerAd", "AdService.createAdaptiveBannerAd")
])

