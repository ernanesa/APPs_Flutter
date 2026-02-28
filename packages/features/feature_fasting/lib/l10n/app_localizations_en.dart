// ignore: unused_import
import 'package:intl/intl.dart' as intl;


// ignore_for_file: type=lint

/// The translations for English (`en`).
class 

  @override
  String get appTitle => 'Fasting Tracker';

  @override
  String get settings => 'Settings';

  @override
  String get history => 'History';

  @override
  String get achievements => 'Achievements';

  @override
  String get close => 'Close';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get ok => 'OK';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get ofPreposition => 'of';

  @override
  String get readyToFast => 'Ready to Fast';

  @override
  String get complete => 'Complete';

  @override
  String get endEarly => 'End Early';

  @override
  String get cancelFastingConfirm =>
      'Are you sure you want to cancel this fasting session? Progress will be lost.';

  @override
  String get noHistory => 'No fasting history yet';

  @override
  String get totalHours => 'Total Hours';

  @override
  String get openSource => 'Open Source';

  @override
  String get openSourceDesc => 'Built with Flutter';

  @override
  String get startFasting => 'Start Fasting';

  @override
  String get endFasting => 'End Fasting';

  @override
  String get cancelFasting => 'Cancel Fasting';

  @override
  String get fastingInProgress => 'Fasting in Progress';

  @override
  String get fastingCompleted => 'Fasting Completed!';

  @override
  String get timeRemaining => 'Time Remaining';

  @override
  String get timeElapsed => 'Time Elapsed';

  @override
  String get targetReached => 'Target Reached!';

  @override
  String get selectProtocol => 'Select Protocol';

  @override
  String get protocol12_12 => '12:12';

  @override
  String get protocol12_12Desc => '12h fasting, 12h eating';

  @override
  String get protocol14_10 => '14:10';

  @override
  String get protocol14_10Desc => '14h fasting, 10h eating';

  @override
  String get protocol16_8 => '16:8';

  @override
  String get protocol16_8Desc => '16h fasting, 8h eating (Popular)';

  @override
  String get protocol18_6 => '18:6';

  @override
  String get protocol18_6Desc => '18h fasting, 6h eating';

  @override
  String get protocol20_4 => '20:4';

  @override
  String get protocol20_4Desc => '20h fasting, 4h eating (Warrior)';

  @override
  String get protocol23_1 => '23:1';

  @override
  String get protocol23_1Desc => '23h fasting, 1h eating (OMAD)';

  @override
  String get metabolicStages => 'Metabolic Stages';

  @override
  String get stageFed => 'Fed State';

  @override
  String get stageFedDesc => 'Body digesting food, insulin elevated';

  @override
  String get stageEarlyFasting => 'Early Fasting';

  @override
  String get stageEarlyFastingDesc => 'Blood sugar stabilizing, using glycogen';

  @override
  String get stageFatBurning => 'Fat Burning';

  @override
  String get stageFatBurningDesc => 'Body switching to fat for energy';

  @override
  String get stageKetosis => 'Ketosis';

  @override
  String get stageKetosisDesc => 'Producing ketones, enhanced mental clarity';

  @override
  String get stageDeepKetosis => 'Deep Ketosis';

  @override
  String get stageDeepKetosisDesc =>
      'Maximum fat burning, growth hormone boost';

  @override
  String get stageAutophagy => 'Autophagy';

  @override
  String get stageAutophagyDesc => 'Cellular cleanup and regeneration';

  @override
  String get currentStage => 'Current Stage';

  @override
  String stageStartsAt(int hours) {
    return 'Starts at ${hours}h';
  }

  @override
  String get healthInfo => 'Health Information';

  @override
  String get benefits => 'Benefits';

  @override
  String get warnings => 'Warnings & Precautions';

  @override
  String get tips => 'Tips for Success';

  @override
  String get benefitWeightLoss => 'Promotes weight loss and fat burning';

  @override
  String get benefitInsulin => 'Improves insulin sensitivity';

  @override
  String get benefitBrain => 'Enhances brain function and mental clarity';

  @override
  String get benefitHeart => 'Supports cardiovascular health';

  @override
  String get benefitCellRepair => 'Triggers cellular repair (autophagy)';

  @override
  String get benefitInflammation => 'Reduces inflammation';

  @override
  String get benefitLongevity => 'May promote longevity';

  @override
  String get benefitMetabolism => 'Boosts metabolic health';

  @override
  String get warningPregnant =>
      'Not recommended during pregnancy or breastfeeding';

  @override
  String get warningDiabetes => 'Consult doctor if you have diabetes';

  @override
  String get warningMedication => 'Check with doctor if taking medications';

  @override
  String get warningEatingDisorder => 'Avoid if history of eating disorders';

  @override
  String get warningChildren => 'Not suitable for children or adolescents';

  @override
  String get warningUnderweight => 'Not recommended if underweight';

  @override
  String get warningMedical => 'Consult healthcare provider before starting';

  @override
  String get tipHydration => 'Stay well hydrated during fasting periods';

  @override
  String get tipGradual => 'Start with shorter fasting periods';

  @override
  String get tipNutrition => 'Focus on nutritious foods during eating window';

  @override
  String get tipListenBody => 'Listen to your body and adjust as needed';

  @override
  String get sourceInfo =>
      'Information based on research from Johns Hopkins Medicine and Harvard Health';

  @override
  String get currentStreak => 'Current Streak';

  @override
  String get bestStreak => 'Best Streak';

  @override
  String get totalFasts => 'Total Fasts';

  @override
  String get daysUnit => 'days';

  @override
  String get dayUnit => 'day';

  @override
  String streakDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'days',
      one: 'day',
    );
    return '$count $_temp0';
  }

  @override
  String achievementsProgress(int unlocked, int total) {
    return '$unlocked of $total unlocked';
  }

  @override
  String get achievementUnlocked => 'Achievement Unlocked!';

  @override
  String get notUnlockedYet => 'Not unlocked yet';

  @override
  String unlockedOn(String date) {
    return 'Unlocked on $date';
  }

  @override
  String get categorySession => 'Sessions';

  @override
  String get categoryStreak => 'Streaks';

  @override
  String get categoryTime => 'Time';

  @override
  String get categorySpecial => 'Special';

  @override
  String get achievementFirstFast => 'First Fast';

  @override
  String get achievementFirstFastDesc => 'Complete your first fasting session';

  @override
  String get achievement10Fasts => 'Dedicated Faster';

  @override
  String get achievement10FastsDesc => 'Complete 10 fasting sessions';

  @override
  String get achievement50Fasts => 'Fasting Pro';

  @override
  String get achievement50FastsDesc => 'Complete 50 fasting sessions';

  @override
  String get achievement100Fasts => 'Fasting Master';

  @override
  String get achievement100FastsDesc => 'Complete 100 fasting sessions';

  @override
  String get achievementStreak3 => 'Getting Started';

  @override
  String get achievementStreak3Desc => 'Maintain a 3-day streak';

  @override
  String get achievementStreak7 => 'Week Warrior';

  @override
  String get achievementStreak7Desc => 'Maintain a 7-day streak';

  @override
  String get achievementStreak30 => 'Monthly Champion';

  @override
  String get achievementStreak30Desc => 'Maintain a 30-day streak';

  @override
  String get achievement24Hours => 'Full Day Fast';

  @override
  String get achievement24HoursDesc => 'Complete a 24-hour fast';

  @override
  String get achievement25Fasts => 'Fasting Enthusiast';

  @override
  String get achievement25FastsDesc => 'Complete 25 fasting sessions';

  @override
  String get achievement100Hours => 'Century Club';

  @override
  String get achievement100HoursDesc => 'Accumulate 100 hours of fasting';

  @override
  String get achievement500Hours => '500 Hour Hero';

  @override
  String get achievement500HoursDesc => 'Accumulate 500 hours of fasting';

  @override
  String get achievementStreak14 => 'Two Week Champion';

  @override
  String get achievementStreak14Desc => 'Maintain a 14-day streak';

  @override
  String get achievementKetosis => 'Ketosis Achiever';

  @override
  String get achievementKetosisDesc => 'Reach the ketosis stage (18+ hours)';

  @override
  String get achievementAutophagy => 'Autophagy Achiever';

  @override
  String get achievementAutophagyDesc =>
      'Reach the autophagy stage (48+ hours)';

  @override
  String get achievementEarlyBird => 'Early Bird';

  @override
  String get achievementEarlyBirdDesc => 'Start a fast before 8 AM';

  @override
  String get achievementNightOwl => 'Night Owl';

  @override
  String get achievementNightOwlDesc => 'Complete a fast after 10 PM';

  @override
  String get achievementWeekend => 'Weekend Warrior';

  @override
  String get achievementWeekendDesc => 'Complete a fast on weekend';

  @override
  String get achievementPerfectWeek => 'Perfect Week';

  @override
  String get achievementPerfectWeekDesc => 'Complete 7 fasts in a week';

  @override
  String get colorTheme => 'Color Theme';

  @override
  String get themeForest => 'Forest';

  @override
  String get themeOcean => 'Ocean';

  @override
  String get themeSunset => 'Sunset';

  @override
  String get themeLavender => 'Lavender';

  @override
  String get themeMidnight => 'Midnight';

  @override
  String get themeRose => 'Rose';

  @override
  String get themeMint => 'Mint';

  @override
  String get themeAmber => 'Amber';

  @override
  String get noFastingHistory => 'No fasting history yet';

  @override
  String get startFirstFast => 'Start your first fast to see your progress';

  @override
  String get fastingHistory => 'Fasting History';

  @override
  String get totalFastingTime => 'Total Fasting Time';

  @override
  String get averageFastDuration => 'Average Duration';

  @override
  String get longestFast => 'Longest Fast';

  @override
  String hours(int count) {
    return '${count}h';
  }

  @override
  String minutes(int count) {
    return '${count}m';
  }

  @override
  String hoursMinutes(int hours, int minutes) {
    return '${hours}h ${minutes}m';
  }

  @override
  String get completed => 'Completed';

  @override
  String get cancelled => 'Cancelled';

  @override
  String get inProgress => 'In Progress';

  @override
  String get appearance => 'Appearance';

  @override
  String get language => 'Language';

  @override
  String get languageDefault => 'System Default';

  @override
  String get notifications => 'Notifications';

  @override
  String get enableReminders => 'Enable Reminders';

  @override
  String get reminderTime => 'Reminder Time';

  @override
  String get notificationGoalReachedTitle => 'Target Reached! 🎉';

  @override
  String get notificationGoalReachedBody =>
      'You have successfully reached your fasting goal!';

  @override
  String get about => 'About';

  @override
  String get version => 'Version';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get termsOfService => 'Terms of Service';

  @override
  String get rateApp => 'Rate App';

  @override
  String get shareApp => 'Share App';

  @override
  String get healthInfoTitle => 'Intermittent Fasting';

  @override
  String get healthInfoSubtitle => 'Science-based information';

  @override
  String get benefitsTitle => 'Health Benefits';

  @override
  String get warningsTitle => 'Warnings & Precautions';

  @override
  String get tipsTitle => 'Tips for Success';

  @override
  String get sources => 'Sources';

  @override
  String get disclaimer =>
      'This app is for informational purposes only. Always consult a healthcare provider before starting any fasting regimen.';

  @override
  String get benefitWeightTitle => 'Weight Management';

  @override
  String get benefitWeightDesc =>
      'Intermittent fasting can help reduce body weight and body fat by limiting calorie intake and boosting metabolism.';

  @override
  String get benefitBloodPressureTitle => 'Blood Pressure';

  @override
  String get benefitBloodPressureDesc =>
      'Studies show fasting may help lower blood pressure and improve resting heart rates.';

  @override
  String get benefitHeartHealthTitle => 'Heart Health';

  @override
  String get benefitHeartHealthDesc =>
      'Fasting can improve cardiovascular health markers including cholesterol levels and inflammatory markers.';

  @override
  String get benefitDiabetesTitle => 'Blood Sugar Control';

  @override
  String get benefitDiabetesDesc =>
      'Intermittent fasting may improve insulin sensitivity and help manage Type 2 diabetes.';

  @override
  String get benefitCognitiveTitle => 'Brain Function';

  @override
  String get benefitCognitiveDesc =>
      'Fasting stimulates production of BDNF, a protein that supports brain health and cognitive function.';

  @override
  String get benefitTissueTitle => 'Tissue Health';

  @override
  String get benefitTissueDesc =>
      'Fasting triggers cellular repair processes and may improve tissue health and recovery.';

  @override
  String get benefitMetabolicTitle => 'Metabolic Switch';

  @override
  String get benefitMetabolicDesc =>
      'After 12-36 hours, your body switches from glucose to ketones for energy, improving metabolic flexibility.';

  @override
  String get benefitCellularTitle => 'Cellular Repair';

  @override
  String get benefitCellularDesc =>
      'Fasting initiates autophagy, a process where cells remove damaged components and regenerate.';

  @override
  String get warningChildrenTitle => 'Children & Teens';

  @override
  String get warningChildrenDesc =>
      'Intermittent fasting is not recommended for children or adolescents who are still growing.';

  @override
  String get warningPregnantTitle => 'Pregnancy';

  @override
  String get warningPregnantDesc =>
      'Do not fast during pregnancy as it may affect fetal development.';

  @override
  String get warningBreastfeedingTitle => 'Breastfeeding';

  @override
  String get warningBreastfeedingDesc =>
      'Fasting while breastfeeding may reduce milk supply and nutritional quality.';

  @override
  String get warningType1DiabetesTitle => 'Type 1 Diabetes';

  @override
  String get warningType1DiabetesDesc =>
      'People with Type 1 diabetes should not fast without medical supervision due to hypoglycemia risk.';

  @override
  String get warningEatingDisordersTitle => 'Eating Disorders';

  @override
  String get warningEatingDisordersDesc =>
      'Fasting may trigger or worsen eating disorders. Seek professional help if you have a history.';

  @override
  String get warningMuscleLossTitle => 'Muscle Loss Risk';

  @override
  String get warningMuscleLossDesc =>
      'Extended fasting may lead to muscle loss. Maintain protein intake during eating windows.';

  @override
  String get warningConsultDoctorTitle => 'Consult Your Doctor';

  @override
  String get warningConsultDoctorDesc =>
      'Always consult a healthcare provider before starting fasting, especially if you have medical conditions.';

  @override
  String get tipHydrationTitle => 'Stay Hydrated';

  @override
  String get tipHydrationDesc =>
      'Drink plenty of water, herbal tea, or black coffee during fasting periods. Proper hydration is essential.';

  @override
  String get tipGradualStartTitle => 'Start Gradually';

  @override
  String get tipGradualStartDesc =>
      'Begin with shorter fasting periods (12:12) and gradually increase as your body adapts.';

  @override
  String get tipBalancedMealsTitle => 'Eat Balanced Meals';

  @override
  String get tipBalancedMealsDesc =>
      'Focus on nutritious, whole foods during your eating window. Include proteins, healthy fats, and vegetables.';

  @override
  String get tipExerciseTitle => 'Light Exercise';

  @override
  String get tipExerciseDesc =>
      'Light to moderate exercise is fine while fasting. Avoid intense workouts until you adapt.';
}
