# Pomodoro Timer

A beautiful, feature-rich Pomodoro Timer app built with Flutter following the Beast Mode Flutter protocol.

## Features

- 🍅 **Classic Pomodoro Technique**: 25-min focus sessions, 5-min short breaks, 15-min long breaks
- ⚙️ **Customizable Durations**: Adjust focus, short break, and long break durations
- 📊 **Statistics**: Track daily and weekly progress with beautiful charts
- 🌍 **11 Languages**: EN, PT, ES, ZH, DE, FR, AR, BN, HI, JA, RU
- 🎨 **Material 3 Design**: Modern, clean UI with dark mode support
- 🔊 **Sound & Haptic Feedback**: Customizable audio and vibration alerts
- 💰 **AdMob Integration**: Banner, Interstitial, and App Open ads
- 🔐 **GDPR Compliant**: UMP consent flow for EU/EEA/UK users

## Tech Stack

- **Flutter**: 3.6.0+
- **State Management**: Riverpod 2.6.1
- **Ads**: google_mobile_ads 5.3.0
- **Audio**: audioplayers 6.1.0
- **Charts**: fl_chart 0.70.2
- **Storage**: shared_preferences 2.3.5
- **Localization**: flutter_localizations + intl

## Project Structure

```
lib/
├── l10n/                 # Localization files (11 languages)
├── logic/                # Business logic
│   └── pomodoro_logic.dart
├── models/               # Data models
│   ├── pomodoro_session.dart
│   ├── pomodoro_settings.dart
│   └── timer_state.dart
├── providers/            # Riverpod providers
│   ├── settings_provider.dart
│   └── timer_provider.dart
├── screens/              # UI screens
│   ├── timer_screen.dart
│   ├── settings_screen.dart
│   └── statistics_screen.dart
├── services/             # External services
│   ├── ad_service.dart
│   ├── consent_service.dart
│   └── sound_service.dart
├── widgets/              # Reusable widgets
│   ├── timer_display.dart
│   ├── control_buttons.dart
│   ├── session_indicator.dart
│   ├── session_type_label.dart
│   └── ad_banner_widget.dart
└── main.dart             # App entry point
```

## Getting Started

### Prerequisites

- Flutter SDK 3.6.0+
- Android SDK (API 21+)
- Android Emulator or physical device

### Installation

```bash
# Navigate to project
cd pomodoro_timer

# Get dependencies
flutter pub get

# Generate localization
flutter gen-l10n

# Run the app
flutter run
```

### Running Tests

```bash
flutter test
```

### Building Release

```bash
flutter build appbundle --release
```

## Configuration

### Android

- **Namespace**: `sa.rezende.pomodoro_timer`
- **Target SDK**: 35 (Android 15)
- **Min SDK**: 21 (Android 5.0)
- **AGP**: 8.5.1+ (16KB page size compatible)

### AdMob (Production)

Replace test IDs in:
- `lib/services/ad_service.dart`
- `android/app/src/main/AndroidManifest.xml`

## Checklist Before Publishing

- [ ] Replace AdMob test IDs with production IDs
- [ ] Configure signing keys for release
- [ ] Update versionCode and versionName
- [ ] Prepare store assets (icon, screenshots, feature graphic)
- [ ] Write privacy policy
- [ ] Test on multiple devices

## License

This project is proprietary. All rights reserved.

## Author

SA Rezende - Beast Mode Flutter Developer
