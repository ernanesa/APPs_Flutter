import 'package:flutter/material.dart';
import '../../domain/entities/health_info.dart';

/// Health information button and dialog
class HealthInfoButton extends StatelessWidget {
  const HealthInfoButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.info_outline),
      tooltip: 'healthInfo',
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
    // '' removed

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
                          "healthInfoTitle",
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "healthInfoSubtitle",
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
                    "benefitsTitle",
                    Icons.thumb_up,
                    Colors.green,
                  ),
                  const SizedBox(height: 8),
                  ...HealthInfo.benefits.map(
                    (info) => _buildInfoCard(
                      context,
                      info,
                      Colors.green.shade50,
                      Colors.green,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Warnings section
                  _buildSectionHeader(
                    context,
                    "warningsTitle",
                    Icons.warning_amber,
                    Colors.orange,
                  ),
                  const SizedBox(height: 8),
                  ...HealthInfo.warnings.map(
                    (info) => _buildInfoCard(
                      context,
                      info,
                      Colors.orange.shade50,
                      Colors.orange,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Tips section
                  _buildSectionHeader(
                    context,
                    "tipsTitle",
                    Icons.lightbulb,
                    Colors.blue,
                  ),
                  const SizedBox(height: 8),
                  ...HealthInfo.tips.map(
                    (info) => _buildInfoCard(
                      context,
                      info,
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
                                "sources",
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
                            "disclaimer",
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
    
    Color backgroundColor,
    Color accentColor,
  ) {
    final theme = Theme.of(context);

    // Get localized strings
    final title = _getLocalizedTitle(info.titleKey);
    final description = _getLocalizedDescription(info.descriptionKey);

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

  String _getLocalizedTitle(String key, ) {
    switch (key) {
      // Benefits
      case 'benefitWeightTitle':
        return "benefitWeightTitle";
      case 'benefitBloodPressureTitle':
        return "benefitBloodPressureTitle";
      case 'benefitHeartHealthTitle':
        return "benefitHeartHealthTitle";
      case 'benefitDiabetesTitle':
        return "benefitDiabetesTitle";
      case 'benefitCognitiveTitle':
        return "benefitCognitiveTitle";
      case 'benefitTissueTitle':
        return "benefitTissueTitle";
      case 'benefitMetabolicTitle':
        return "benefitMetabolicTitle";
      case 'benefitCellularTitle':
        return "benefitCellularTitle";
      // Warnings
      case 'warningChildrenTitle':
        return "warningChildrenTitle";
      case 'warningPregnantTitle':
        return "warningPregnantTitle";
      case 'warningBreastfeedingTitle':
        return "warningBreastfeedingTitle";
      case 'warningType1DiabetesTitle':
        return "warningType1DiabetesTitle";
      case 'warningEatingDisordersTitle':
        return "warningEatingDisordersTitle";
      case 'warningMuscleLossTitle':
        return "warningMuscleLossTitle";
      case 'warningConsultDoctorTitle':
        return "warningConsultDoctorTitle";
      // Tips
      case 'tipHydrationTitle':
        return "tipHydrationTitle";
      case 'tipGradualStartTitle':
        return "tipGradualStartTitle";
      case 'tipBalancedMealsTitle':
        return "tipBalancedMealsTitle";
      case 'tipExerciseTitle':
        return "tipExerciseTitle";
      default:
        return key;
    }
  }

  String _getLocalizedDescription(String key, ) {
    switch (key) {
      // Benefits
      case 'benefitWeightDesc':
        return "benefitWeightDesc";
      case 'benefitBloodPressureDesc':
        return "benefitBloodPressureDesc";
      case 'benefitHeartHealthDesc':
        return "benefitHeartHealthDesc";
      case 'benefitDiabetesDesc':
        return "benefitDiabetesDesc";
      case 'benefitCognitiveDesc':
        return "benefitCognitiveDesc";
      case 'benefitTissueDesc':
        return "benefitTissueDesc";
      case 'benefitMetabolicDesc':
        return "benefitMetabolicDesc";
      case 'benefitCellularDesc':
        return "benefitCellularDesc";
      // Warnings
      case 'warningChildrenDesc':
        return "warningChildrenDesc";
      case 'warningPregnantDesc':
        return "warningPregnantDesc";
      case 'warningBreastfeedingDesc':
        return "warningBreastfeedingDesc";
      case 'warningType1DiabetesDesc':
        return "warningType1DiabetesDesc";
      case 'warningEatingDisordersDesc':
        return "warningEatingDisordersDesc";
      case 'warningMuscleLossDesc':
        return "warningMuscleLossDesc";
      case 'warningConsultDoctorDesc':
        return "warningConsultDoctorDesc";
      // Tips
      case 'tipHydrationDesc':
        return "tipHydrationDesc";
      case 'tipGradualStartDesc':
        return "tipGradualStartDesc";
      case 'tipBalancedMealsDesc':
        return "tipBalancedMealsDesc";
      case 'tipExerciseDesc':
        return "tipExerciseDesc";
      default:
        return key;
    }
  }
}
