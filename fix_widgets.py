import re
import os

def reg_rep(path, patterns):
    if not os.path.exists(path): return
    with open(path, 'r', encoding='utf-8') as f:
        c = f.read()
    for p, r in patterns:
        c = re.sub(p, r, c)
    with open(path, 'w', encoding='utf-8') as f:
        f.write(c)

# 1. pomodoro_timer
reg_rep('apps/pomodoro_timer/lib/screens/settings_screen.dart', [
    (r"              if \(ConsentService\.isPrivacyOptionsRequired\)\s+ListTile\(\s+leading: const Icon\(Icons\.cookie_outlined\),\s+title: const Text\('Privacy Options'\),\s+trailing: const Icon\(Icons\.chevron_right\),\s+onTap: \(\) \{[\s\S]*?\},[\s\S]*?\}\);[\s\S]*?\},[\s\S]*?\),",
     """              ListTile(
                leading: const Icon(Icons.cookie_outlined),
                title: const Text('Privacy Options'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () async {
                  await ConsentService.showPrivacyOptionsForm();
                },
              ),""")
])

# 2. white_noise
reg_rep('apps/white_noise/lib/presentation/widgets/ad_banner_widget.dart', [
    (r"final ad = AdService.createAdaptiveBannerAd\(width: constraints.maxWidth.toInt\(\)\);",
     "final ad = await AdService.createAdaptiveBannerAd(width: width.toInt());"),
    (r"if \(!mounted\) \{\n      ad\.dispose\(\);",
     "if (!mounted && ad != null) {\n      ad.dispose();")
])

# 3. compound_interest_calculator
reg_rep('apps/compound_interest_calculator/lib/presentation/screens/calculator_screen.dart', [
    (r"bottomNavigationBar: SafeArea\([\s\S]*?child: SizedBox\([\s\S]*?height: 60,[\s\S]*?child: AdWidget\(ad: AdService\.createBannerAd\(\)\.\.load\(\)\),[\s\S]*?\),[\s\S]*?\),",
     "bottomNavigationBar: const SizedBox(height: 60),")
])

