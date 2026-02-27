import os
import glob
import re

def replace_in_file(path, replacements):
    if not os.path.exists(path): return
    with open(path, 'r', encoding='utf-8') as f:
        content = f.read()
    orig = content
    for old, new in replacements:
        content = content.replace(old, new)
    if content != orig:
        with open(path, 'w', encoding='utf-8') as f:
            f.write(content)
        print(f"Fixed {path}")

def regex_replace_in_file(path, replacements):
    if not os.path.exists(path): return
    with open(path, 'r', encoding='utf-8') as f:
        content = f.read()
    orig = content
    for pattern, new in replacements:
        content = re.sub(pattern, new, content)
    if content != orig:
        with open(path, 'w', encoding='utf-8') as f:
            f.write(content)
        print(f"Regex fixed {path}")

# Fix generic AdService and ConsentService calls
for f in glob.glob('apps/**/*.dart', recursive=True):
    replace_in_file(f, [
        ('AdService.instance.', 'AdService.'),
        ('ConsentService.instance.', 'ConsentService.'),
        ('if (ConsentService.canRequestAds) {', 'if (await ConsentService.canRequestAds()) {'),
        ('&& ConsentService.canRequestAds) {', '&& await ConsentService.canRequestAds()) {'),
        ('AdService.loadInterstitial()', 'AdService.preloadInterstitialAd()'),
        ('AdService.incrementActionAndShowInterstitial()', 'AdService.incrementActionAndShowIfNeeded()'),
        ('ConsentService.showPrivacyOptions()', 'ConsentService.showPrivacyOptionsForm()'),
        ('AdService.createAdaptiveBanner(', 'AdService.createAdaptiveBannerAd('),
    ])

# 1. Fasting Tracker localizations issue
ft_tl = 'apps/fasting_tracker/lib/presentation/widgets/stages_timeline.dart'
replace_in_file(ft_tl, [("import 'package:flutter/material.dart';", "import 'package:flutter/material.dart';\nimport 'package:flutter_gen/gen_l10n/app_localizations.dart';")])
ft_sb = 'apps/fasting_tracker/lib/presentation/widgets/streak_badge.dart'
replace_in_file(ft_sb, [
    ("import 'package:flutter_gen/gen_l10n/app_localizations.dart';", ""), # remove dead path if wrong
    ("import 'package:flutter/material.dart';", "import 'package:flutter/material.dart';\nimport 'package:flutter_gen/gen_l10n/app_localizations.dart';")
])

# Fasting Tracker Ad widget issue and notification parameters
ft_ad = 'apps/fasting_tracker/lib/widgets/ad_banner_widget.dart'
ft_notif = 'apps/fasting_tracker/lib/services/notification_service.dart'
regex_replace_in_file(ft_ad, [
    (r'!AdService.adsEnabled', '!(AdService.adsEnabled)'),
])

# 2. Pomodoro Timer ambiguous provider
pt_settings = 'apps/pomodoro_timer/lib/providers/settings_provider.dart'
regex_replace_in_file(pt_settings, [
    (r'final sharedPreferencesProvider = Provider<SharedPreferences>\(\(ref\) \{.*?\n\}\);\n', ''),
])

# 3. Compound Interest async&& issues
cic_main = 'apps/compound_interest_calculator/lib/main.dart'
regex_replace_in_file(cic_main, [
    (r'if \(state == AppLifecycleState.resumed && await ConsentService.canRequestAds\(\)\) {', 'if (state == AppLifecycleState.resumed) {\n      ConsentService.canRequestAds().then((canRequest) {\n        if (canRequest) AdService.showAppOpenAdIfAvailable();\n      });\n    }')
])

# Compound Interest BannerAd load
cic_calc = 'apps/compound_interest_calculator/lib/presentation/screens/calculator_screen.dart'
regex_replace_in_file(cic_calc, [
    (r'_bannerAd\.load\(\);', '_bannerAd?.load();')
])

# 4. White noise boolean conditions
wn_main = 'apps/white_noise/lib/main.dart'
regex_replace_in_file(wn_main, [
    (r'if \(state == AppLifecycleState.resumed && await ConsentService.canRequestAds\(\)\) {', 'if (state == AppLifecycleState.resumed) {\n      ConsentService.canRequestAds().then((canRequest) {\n        if (canRequest) AdService.showAppOpenAdIfAvailable();\n      });\n    }')
])

# White noise providers
wn_repos = 'apps/white_noise/lib/presentation/providers/repository_providers.dart'
replace_in_file(wn_repos, [
    ("import 'shared_prefs_provider.dart';", "import 'package:core_logic/core_logic.dart';")
])

