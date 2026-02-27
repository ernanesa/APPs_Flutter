import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../domain/entities/app_theme.dart';
import '../providers/theme_provider.dart';
import '../providers/locale_provider.dart';

/// Settings screen
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final currentTheme = ref.watch(themeProvider);
    final currentLocale = ref.watch(localeProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),
      body: ListView(
        children: [
          // Appearance section
          _buildSectionHeader(context, l10n.appearance, Icons.palette),

          // Theme section
          ListTile(
            title: Text(l10n.colorTheme),
            subtitle: Text(_getThemeName(currentTheme.name, l10n)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children:
                  AppThemeType.values.map((themeType) {
                    final isSelected = themeType == currentTheme;
                    return _ThemeChip(
                      themeType: themeType,
                      isSelected: isSelected,
                      onTap:
                          () => ref
                              .read(themeProvider.notifier)
                              .setTheme(themeType),
                      l10n: l10n,
                    );
                  }).toList(),
            ),
          ),

          const SizedBox(height: 16),

          // Language section
          ListTile(
            leading: const Icon(Icons.language),
            title: Text(l10n.language),
            subtitle: Text(_getLanguageName(currentLocale?.languageCode, l10n)),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showLanguageSelector(context, ref, l10n),
          ),

          const SizedBox(height: 24),

          // About section
          _buildSectionHeader(context, l10n.about, Icons.info),
          ListTile(
            leading: const Icon(Icons.description),
            title: Text(l10n.version),
            subtitle: const Text('1.0.0'),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  void _showLanguageSelector(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
  ) {
    final currentLocale = ref.read(localeProvider);

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  l10n.language,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              const Divider(),
              ListTile(
                title: Text(l10n.languageDefault),
                trailing:
                    currentLocale == null
                        ? const Icon(Icons.check, color: Colors.green)
                        : null,
                onTap: () {
                  ref.read(localeProvider.notifier).setLocale(null);
                  Navigator.pop(context);
                },
              ),
              Expanded(
                child: ListView(
                  children: [
                    _buildLanguageItem(context, ref, 'en', 'English'),
                    _buildLanguageItem(context, ref, 'pt', 'Português'),
                    _buildLanguageItem(context, ref, 'es', 'Español'),
                    _buildLanguageItem(context, ref, 'fr', 'Français'),
                    _buildLanguageItem(context, ref, 'de', 'Deutsch'),
                    _buildLanguageItem(context, ref, 'ar', 'العربية'),
                    _buildLanguageItem(context, ref, 'hi', 'हिन्दी'),
                    _buildLanguageItem(context, ref, 'bn', 'বাংলা'),
                    _buildLanguageItem(context, ref, 'ja', '日本語'),
                    _buildLanguageItem(context, ref, 'ru', 'Русский'),
                    _buildLanguageItem(context, ref, 'zh', '中文'),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLanguageItem(
    BuildContext context,
    WidgetRef ref,
    String code,
    String name,
  ) {
    final currentLocale = ref.watch(localeProvider);
    final isSelected = currentLocale?.languageCode == code;

    return ListTile(
      title: Text(name),
      trailing:
          isSelected ? const Icon(Icons.check, color: Colors.green) : null,
      onTap: () {
        ref.read(localeProvider.notifier).setLocale(Locale(code));
        Navigator.pop(context);
      },
    );
  }

  String _getLanguageName(String? code, AppLocalizations l10n) {
    if (code == null) return l10n.languageDefault;
    switch (code) {
      case 'en':
        return 'English';
      case 'pt':
        return 'Português';
      case 'es':
        return 'Español';
      case 'fr':
        return 'Français';
      case 'de':
        return 'Deutsch';
      case 'ar':
        return 'العربية';
      case 'hi':
        return 'हिन्दी';
      case 'bn':
        return 'বাংলা';
      case 'ja':
        return '日本語';
      case 'ru':
        return 'Русский';
      case 'zh':
        return '中文';
      default:
        return code;
    }
  }

  String _getThemeName(String name, AppLocalizations l10n) {
    switch (name) {
      case 'forest':
        return l10n.themeForest;
      case 'ocean':
        return l10n.themeOcean;
      case 'sunset':
        return l10n.themeSunset;
      case 'lavender':
        return l10n.themeLavender;
      case 'midnight':
        return l10n.themeMidnight;
      case 'rose':
        return l10n.themeRose;
      case 'mint':
        return l10n.themeMint;
      case 'amber':
        return l10n.themeAmber;
      default:
        return name;
    }
  }

  Widget _buildSectionHeader(
    BuildContext context,
    String title,
    IconData icon,
  ) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: theme.colorScheme.primary),
          const SizedBox(width: 8),
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class _ThemeChip extends StatelessWidget {
  final AppThemeType themeType;
  final bool isSelected;
  final VoidCallback onTap;
  final AppLocalizations l10n;

  const _ThemeChip({
    required this.themeType,
    required this.isSelected,
    required this.onTap,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    // Theme available for future enhancements
    // final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? themeType.primaryColor
                  : themeType.primaryColor.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: themeType.primaryColor,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: themeType.primaryColor,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              _getThemeName(themeType.name, l10n),
              style: TextStyle(
                color: isSelected ? Colors.white : themeType.primaryColor,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getThemeName(String name, AppLocalizations l10n) {
    switch (name) {
      case 'forest':
        return l10n.themeForest;
      case 'ocean':
        return l10n.themeOcean;
      case 'sunset':
        return l10n.themeSunset;
      case 'lavender':
        return l10n.themeLavender;
      case 'midnight':
        return l10n.themeMidnight;
      case 'rose':
        return l10n.themeRose;
      case 'mint':
        return l10n.themeMint;
      case 'amber':
        return l10n.themeAmber;
      default:
        return name;
    }
  }
}
