/// Health information about intermittent fasting
/// Based on research from Johns Hopkins Medicine and Harvard Health
class HealthInfo {
  final String id;
  final String titleKey;
  final String descriptionKey;
  final HealthInfoType type;
  final String icon;
  final String? sourceUrl;

  const HealthInfo({
    required this.id,
    required this.titleKey,
    required this.descriptionKey,
    required this.type,
    required this.icon,
    this.sourceUrl,
  });

  /// Benefits of intermittent fasting (from Johns Hopkins & Harvard)
  static const List<HealthInfo> benefits = [
    HealthInfo(
      id: 'weight_management',
      titleKey: 'benefitWeightTitle',
      descriptionKey: 'benefitWeightDesc',
      type: HealthInfoType.benefit,
      icon: '⚖️',
      sourceUrl:
          'https://www.hopkinsmedicine.org/health/wellness-and-prevention/intermittent-fasting-what-is-it-and-how-does-it-work',
    ),
    HealthInfo(
      id: 'blood_pressure',
      titleKey: 'benefitBloodPressureTitle',
      descriptionKey: 'benefitBloodPressureDesc',
      type: HealthInfoType.benefit,
      icon: '❤️',
      sourceUrl:
          'https://www.hopkinsmedicine.org/health/wellness-and-prevention/intermittent-fasting-what-is-it-and-how-does-it-work',
    ),
    HealthInfo(
      id: 'heart_health',
      titleKey: 'benefitHeartHealthTitle',
      descriptionKey: 'benefitHeartHealthDesc',
      type: HealthInfoType.benefit,
      icon: '💓',
      sourceUrl:
          'https://www.hopkinsmedicine.org/health/wellness-and-prevention/intermittent-fasting-what-is-it-and-how-does-it-work',
    ),
    HealthInfo(
      id: 'diabetes_management',
      titleKey: 'benefitDiabetesTitle',
      descriptionKey: 'benefitDiabetesDesc',
      type: HealthInfoType.benefit,
      icon: '🩺',
      sourceUrl:
          'https://www.health.harvard.edu/blog/intermittent-fasting-surprising-update-2018062914156',
    ),
    HealthInfo(
      id: 'cognitive_function',
      titleKey: 'benefitCognitiveTitle',
      descriptionKey: 'benefitCognitiveDesc',
      type: HealthInfoType.benefit,
      icon: '🧠',
      sourceUrl:
          'https://www.hopkinsmedicine.org/health/wellness-and-prevention/intermittent-fasting-what-is-it-and-how-does-it-work',
    ),
    HealthInfo(
      id: 'tissue_health',
      titleKey: 'benefitTissueTitle',
      descriptionKey: 'benefitTissueDesc',
      type: HealthInfoType.benefit,
      icon: '🔬',
      sourceUrl:
          'https://www.hopkinsmedicine.org/health/wellness-and-prevention/intermittent-fasting-what-is-it-and-how-does-it-work',
    ),
    HealthInfo(
      id: 'metabolic_switch',
      titleKey: 'benefitMetabolicTitle',
      descriptionKey: 'benefitMetabolicDesc',
      type: HealthInfoType.benefit,
      icon: '🔄',
      sourceUrl:
          'https://www.health.harvard.edu/blog/intermittent-fasting-surprising-update-2018062914156',
    ),
    HealthInfo(
      id: 'cellular_repair',
      titleKey: 'benefitCellularTitle',
      descriptionKey: 'benefitCellularDesc',
      type: HealthInfoType.benefit,
      icon: '🧬',
      sourceUrl:
          'https://www.health.harvard.edu/blog/intermittent-fasting-surprising-update-2018062914156',
    ),
  ];

  /// Warnings and contraindications
  static const List<HealthInfo> warnings = [
    HealthInfo(
      id: 'children',
      titleKey: 'warningChildrenTitle',
      descriptionKey: 'warningChildrenDesc',
      type: HealthInfoType.warning,
      icon: '👶',
    ),
    HealthInfo(
      id: 'pregnant',
      titleKey: 'warningPregnantTitle',
      descriptionKey: 'warningPregnantDesc',
      type: HealthInfoType.warning,
      icon: '🤰',
    ),
    HealthInfo(
      id: 'breastfeeding',
      titleKey: 'warningBreastfeedingTitle',
      descriptionKey: 'warningBreastfeedingDesc',
      type: HealthInfoType.warning,
      icon: '🍼',
    ),
    HealthInfo(
      id: 'type1_diabetes',
      titleKey: 'warningType1DiabetesTitle',
      descriptionKey: 'warningType1DiabetesDesc',
      type: HealthInfoType.warning,
      icon: '💉',
    ),
    HealthInfo(
      id: 'eating_disorders',
      titleKey: 'warningEatingDisordersTitle',
      descriptionKey: 'warningEatingDisordersDesc',
      type: HealthInfoType.warning,
      icon: '⚠️',
    ),
    HealthInfo(
      id: 'muscle_loss',
      titleKey: 'warningMuscleLossTitle',
      descriptionKey: 'warningMuscleLossDesc',
      type: HealthInfoType.warning,
      icon: '💪',
    ),
    HealthInfo(
      id: 'consult_doctor',
      titleKey: 'warningConsultDoctorTitle',
      descriptionKey: 'warningConsultDoctorDesc',
      type: HealthInfoType.warning,
      icon: '👨‍⚕️',
    ),
  ];

  /// Tips for successful fasting
  static const List<HealthInfo> tips = [
    HealthInfo(
      id: 'hydration',
      titleKey: 'tipHydrationTitle',
      descriptionKey: 'tipHydrationDesc',
      type: HealthInfoType.tip,
      icon: '💧',
    ),
    HealthInfo(
      id: 'gradual_start',
      titleKey: 'tipGradualStartTitle',
      descriptionKey: 'tipGradualStartDesc',
      type: HealthInfoType.tip,
      icon: '🌱',
    ),
    HealthInfo(
      id: 'balanced_meals',
      titleKey: 'tipBalancedMealsTitle',
      descriptionKey: 'tipBalancedMealsDesc',
      type: HealthInfoType.tip,
      icon: '🥗',
    ),
    HealthInfo(
      id: 'exercise',
      titleKey: 'tipExerciseTitle',
      descriptionKey: 'tipExerciseDesc',
      type: HealthInfoType.tip,
      icon: '🏃',
    ),
  ];
}

enum HealthInfoType { benefit, warning, tip }
