import '../l10n/app_localizations.dart';
import '../domain/entities/sound_entity.dart';

String soundName(AppLocalizations loc, String key) {
  switch (key) {
    case 'soundRainLight':
      return loc.soundRainLight;
    case 'soundRainHeavy':
      return loc.soundRainHeavy;
    case 'soundStorm':
      return loc.soundStorm;
    case 'soundRainRoof':
      return loc.soundRainRoof;
    case 'soundForest':
      return loc.soundForest;
    case 'soundOcean':
      return loc.soundOcean;
    case 'soundRiver':
      return loc.soundRiver;
    case 'soundWaterfall':
      return loc.soundWaterfall;
    case 'soundFireplace':
      return loc.soundFireplace;
    case 'soundCafe':
      return loc.soundCafe;
    case 'soundWhiteNoise':
      return loc.soundWhiteNoise;
    case 'soundPinkNoise':
      return loc.soundPinkNoise;
    case 'soundBrownNoise':
      return loc.soundBrownNoise;
    default:
      return key;
  }
}

String achievementTitle(AppLocalizations loc, String key) {
  switch (key) {
    case 'achievementFirstSession':
      return loc.achievementFirstSession;
    case 'achievement10Sessions':
      return loc.achievement10Sessions;
    case 'achievement50Sessions':
      return loc.achievement50Sessions;
    case 'achievement100Sessions':
      return loc.achievement100Sessions;
    case 'achievement500Sessions':
      return loc.achievement500Sessions;
    case 'achievementStreak3':
      return loc.achievementStreak3;
    case 'achievementStreak7':
      return loc.achievementStreak7;
    case 'achievementStreak30':
      return loc.achievementStreak30;
    case 'achievement1Hour':
      return loc.achievement1Hour;
    case 'achievement10Hours':
      return loc.achievement10Hours;
    case 'achievement100Hours':
      return loc.achievement100Hours;
    case 'achievementNightOwl':
      return loc.achievementNightOwl;
    case 'achievementFirstMix':
      return loc.achievementFirstMix;
    case 'achievementMasterMixer':
      return loc.achievementMasterMixer;
    default:
      return key;
  }
}

String achievementDescription(AppLocalizations loc, String key) {
  switch (key) {
    case 'achievementFirstSessionDesc':
      return loc.achievementFirstSessionDesc;
    case 'achievement10SessionsDesc':
      return loc.achievement10SessionsDesc;
    case 'achievement50SessionsDesc':
      return loc.achievement50SessionsDesc;
    case 'achievement100SessionsDesc':
      return loc.achievement100SessionsDesc;
    case 'achievement500SessionsDesc':
      return loc.achievement500SessionsDesc;
    case 'achievementStreak3Desc':
      return loc.achievementStreak3Desc;
    case 'achievementStreak7Desc':
      return loc.achievementStreak7Desc;
    case 'achievementStreak30Desc':
      return loc.achievementStreak30Desc;
    case 'achievement1HourDesc':
      return loc.achievement1HourDesc;
    case 'achievement10HoursDesc':
      return loc.achievement10HoursDesc;
    case 'achievement100HoursDesc':
      return loc.achievement100HoursDesc;
    case 'achievementNightOwlDesc':
      return loc.achievementNightOwlDesc;
    case 'achievementFirstMixDesc':
      return loc.achievementFirstMixDesc;
    case 'achievementMasterMixerDesc':
      return loc.achievementMasterMixerDesc;
    default:
      return key;
  }
}

String categoryName(AppLocalizations loc, SoundCategory category) {
  switch (category) {
    case SoundCategory.rain:
      return loc.categoryRain;
    case SoundCategory.nature:
      return loc.categoryNature;
    case SoundCategory.water:
      return loc.categoryWater;
    case SoundCategory.ambient:
      return loc.categoryAmbient;
    case SoundCategory.noise:
      return loc.categoryNoise;
  }
}
