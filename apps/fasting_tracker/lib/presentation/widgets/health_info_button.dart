import 'package:flutter/material.dart';
import '../../domain/entities/health_info.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// Health information button and dialog
class HealthInfoButton extends StatelessWidget {
  const HealthInfoButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.info_outline),
      tooltip: AppLocalizations.of(context)!.healthInfo,
      onPressed: () => showHealthInfoSheet(context),
    );
  }

  void showHealthInfoSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => const HealthInfoSheet(),
    );
  }
}

/// Bottom sheet with health information
class HealthInfoSheet extends StatelessWidget {
  const HealthInfoSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Column(
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: theme.colorScheme.onSurfaceVariant.withValues(
                  alpha: 0.4,
                ),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Header
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(
                    Icons.medical_information,
                    color: theme.colorScheme.primary,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.healthInfoTitle,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          l10n.healthInfoSubtitle,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            // Content
            Expanded(
              child: ListView(
                controller: scrollController,
                padding: const EdgeInsets.all(16),
                children: [
                  // Benefits section
                  _buildSectionHeader(
                    context,
                    l10n.benefitsTitle,
                    Icons.thumb_up,
                    Colors.green,
                  ),
                  const SizedBox(height: 8),
                  ...HealthInfo.benefits.map(
                    (info) => _buildInfoCard(
                      context,
                      info,
                      l10n,
                      Colors.green.shade50,
                      Colors.green,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Warnings section
                  _buildSectionHeader(
                    context,
                    l10n.warningsTitle,
                    Icons.warning_amber,
                    Colors.orange,
                  ),
                  const SizedBox(height: 8),
                  ...HealthInfo.warnings.map(
                    (info) => _buildInfoCard(
                      context,
                      info,
                      l10n,
                      Colors.orange.shade50,
                      Colors.orange,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Tips section
                  _buildSectionHeader(
                    context,
                    l10n.tipsTitle,
                    Icons.lightbulb,
                    Colors.blue,
                  ),
                  const SizedBox(height: 8),
                  ...HealthInfo.tips.map(
                    (info) => _buildInfoCard(
                      context,
                      info,
                      l10n,
                      Colors.blue.shade50,
                      Colors.blue,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Sources
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.source,
                                size: 20,
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                l10n.sources,
                                style: theme.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '• Johns Hopkins Medicine\n• Harvard Health Publishing',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Disclaimer
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.errorContainer.withValues(
                        alpha: 0.3,
                      ),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: theme.colorScheme.error.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.info,
                          size: 20,
                          color: theme.colorScheme.error,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            l10n.disclaimer,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onErrorContainer,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSectionHeader(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
  ) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(width: 8),
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard(
    BuildContext context,
    HealthInfo info,
    AppLocalizations l10n,
    Color backgroundColor,
    Color accentColor,
  ) {
    final theme = Theme.of(context);

    // Get localized strings
    final title = _getLocalizedTitle(info.titleKey, l10n);
    final description = _getLocalizedDescription(info.descriptionKey, l10n);

    return Card(
      color: backgroundColor,
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(info.icon, style: const TextStyle(fontSize: 24)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(description, style: theme.textTheme.bodySmall),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getLocalizedTitle(String key, AppLocalizations l10n) {
    switch (key) {
      // Benefits
      case 'benefitWeightTitle':
        return l10n.benefitWeightTitle;
      case 'benefitBloodPressureTitle':
        return l10n.benefitBloodPressureTitle;
      case 'benefitHeartHealthTitle':
        return l10n.benefitHeartHealthTitle;
      case 'benefitDiabetesTitle':
        return l10n.benefitDiabetesTitle;
      case 'benefitCognitiveTitle':
        return l10n.benefitCognitiveTitle;
      case 'benefitTissueTitle':
        return l10n.benefitTissueTitle;
      case 'benefitMetabolicTitle':
        return l10n.benefitMetabolicTitle;
      case 'benefitCellularTitle':
        return l10n.benefitCellularTitle;
      // Warnings
      case 'warningChildrenTitle':
        return l10n.warningChildrenTitle;
      case 'warningPregnantTitle':
        return l10n.warningPregnantTitle;
      case 'warningBreastfeedingTitle':
        return l10n.warningBreastfeedingTitle;
      case 'warningType1DiabetesTitle':
        return l10n.warningType1DiabetesTitle;
      case 'warningEatingDisordersTitle':
        return l10n.warningEatingDisordersTitle;
      case 'warningMuscleLossTitle':
        return l10n.warningMuscleLossTitle;
      case 'warningConsultDoctorTitle':
        return l10n.warningConsultDoctorTitle;
      // Tips
      case 'tipHydrationTitle':
        return l10n.tipHydrationTitle;
      case 'tipGradualStartTitle':
        return l10n.tipGradualStartTitle;
      case 'tipBalancedMealsTitle':
        return l10n.tipBalancedMealsTitle;
      case 'tipExerciseTitle':
        return l10n.tipExerciseTitle;
      default:
        return key;
    }
  }

  String _getLocalizedDescription(String key, AppLocalizations l10n) {
    switch (key) {
      // Benefits
      case 'benefitWeightDesc':
        return l10n.benefitWeightDesc;
      case 'benefitBloodPressureDesc':
        return l10n.benefitBloodPressureDesc;
      case 'benefitHeartHealthDesc':
        return l10n.benefitHeartHealthDesc;
      case 'benefitDiabetesDesc':
        return l10n.benefitDiabetesDesc;
      case 'benefitCognitiveDesc':
        return l10n.benefitCognitiveDesc;
      case 'benefitTissueDesc':
        return l10n.benefitTissueDesc;
      case 'benefitMetabolicDesc':
        return l10n.benefitMetabolicDesc;
      case 'benefitCellularDesc':
        return l10n.benefitCellularDesc;
      // Warnings
      case 'warningChildrenDesc':
        return l10n.warningChildrenDesc;
      case 'warningPregnantDesc':
        return l10n.warningPregnantDesc;
      case 'warningBreastfeedingDesc':
        return l10n.warningBreastfeedingDesc;
      case 'warningType1DiabetesDesc':
        return l10n.warningType1DiabetesDesc;
      case 'warningEatingDisordersDesc':
        return l10n.warningEatingDisordersDesc;
      case 'warningMuscleLossDesc':
        return l10n.warningMuscleLossDesc;
      case 'warningConsultDoctorDesc':
        return l10n.warningConsultDoctorDesc;
      // Tips
      case 'tipHydrationDesc':
        return l10n.tipHydrationDesc;
      case 'tipGradualStartDesc':
        return l10n.tipGradualStartDesc;
      case 'tipBalancedMealsDesc':
        return l10n.tipBalancedMealsDesc;
      case 'tipExerciseDesc':
        return l10n.tipExerciseDesc;
      default:
        return key;
    }
  }
}
