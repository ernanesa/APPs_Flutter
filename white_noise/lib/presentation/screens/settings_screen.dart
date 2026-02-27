import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../l10n/app_localizations.dart';
import '../../services/consent_service.dart';
import '../providers/settings_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loc = AppLocalizations.of(context)!;
    final settings = ref.watch(settingsProvider);

    const privacyUrl =
        'https://sites.google.com/view/sarezende-white-noise-privacy';

    return Scaffold(
      appBar: AppBar(title: Text(loc.settings)),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          SwitchListTile(
            title: Text(loc.darkMode),
            value: settings.isDarkMode,
            onChanged:
                settings.isLoading
                    ? null
                    : (value) =>
                        ref.read(settingsProvider.notifier).setDarkMode(value),
          ),
          SwitchListTile(
            title: Text(loc.keepScreenOn),
            subtitle: Text(loc.keepScreenOnDesc),
            value: settings.keepScreenOn,
            onChanged:
                settings.isLoading
                    ? null
                    : (value) => ref
                        .read(settingsProvider.notifier)
                        .setKeepScreenOn(value),
          ),
          ListTile(
            title: Text(loc.volume),
            subtitle: Slider(
              value: settings.globalVolume,
              onChanged:
                  settings.isLoading
                      ? null
                      : (value) => ref
                          .read(settingsProvider.notifier)
                          .setGlobalVolume(value),
            ),
          ),
          ListTile(
            title: Text(loc.language),
            trailing: DropdownButton<String>(
              value: settings.languageCode,
              items:
                  AppLocalizations.supportedLocales
                      .map(
                        (locale) => DropdownMenuItem<String>(
                          value: locale.languageCode,
                          child: Text(locale.languageCode),
                        ),
                      )
                      .toList(),
              onChanged:
                  settings.isLoading
                      ? null
                      : (value) {
                        if (value != null) {
                          ref
                              .read(settingsProvider.notifier)
                              .setLanguageCode(value);
                        }
                      },
            ),
          ),
          ListTile(
            title: Text(loc.about),
            subtitle: Text('${loc.appTitle} · ${loc.version} 1.0.0'),
          ),
          ListTile(
            title: Text(loc.privacyPolicy),
            trailing: const Icon(Icons.open_in_new),
            onTap: () async {
              final uri = Uri.parse(privacyUrl);
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri, mode: LaunchMode.externalApplication);
              }
            },
          ),
          if (ConsentService.isPrivacyOptionsRequired)
            ListTile(
              title: Text(loc.privacyPolicy),
              subtitle: Text(loc.settings),
              trailing: const Icon(Icons.manage_accounts_outlined),
              onTap: () => ConsentService.showPrivacyOptions(),
            ),
        ],
      ),
    );
  }
}
