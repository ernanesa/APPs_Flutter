import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../l10n/app_localizations.dart';
import '../models/app_theme.dart';
import 'package:core_logic/core_logic.dart';


/// Widget for selecting app themes.
class ThemeSelector extends ConsumerWidget {
  const ThemeSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedTheme = ref.watch(selectedThemeProvider);

    return SizedBox(
      height: 90,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: AppThemes.all.length,
        itemBuilder: (context, index) {
          final appTheme = AppThemes.all[index];
          final isSelected = selectedTheme.id == appTheme.id;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
            child: _ThemeItem(
              appTheme: appTheme,
              isSelected: isSelected,
              onTap: () {
                ref.read(selectedThemeProvider.notifier).selectTheme(appTheme);
              },
            ),
          );
        },
      ),
    );
  }
}

class _ThemeItem extends StatelessWidget {
  final AppTheme appTheme;
  final bool isSelected;
  final VoidCallback onTap;

  const _ThemeItem({
    required this.appTheme,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 72,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isSelected
              ? appTheme.primaryColor.withValues(alpha: 0.15)
              : theme.colorScheme.surfaceContainerHighest.withValues(
                  alpha: 0.3,
                ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? appTheme.primaryColor : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Color preview circle
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [appTheme.primaryColor, appTheme.secondaryColor],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.3),
                  width: 2,
                ),
              ),
              child: isSelected
                  ? const Icon(Icons.check, color: Colors.white, size: 20)
                  : null,
            ),
            const SizedBox(height: 4),
            Text(
              _getLocalizedName(l10n, appTheme.nameKey),
              style: theme.textTheme.bodySmall?.copyWith(
                color: isSelected
                    ? appTheme.primaryColor
                    : theme.colorScheme.onSurface,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 10,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  String _getLocalizedName(AppLocalizations l10n, String key) {
    final Map<String, String> names = {
      'themeTomato': l10n.themeTomato,
      'themeOcean': l10n.themeOcean,
      'themeForest': l10n.themeForest,
      'themeLavender': l10n.themeLavender,
      'themeSunset': l10n.themeSunset,
      'themeMidnight': l10n.themeMidnight,
      'themeRose': l10n.themeRose,
      'themeMint': l10n.themeMint,
    };
    return names[key] ?? key;
  }
}
