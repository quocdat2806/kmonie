# KMonie - Flutter App

A Flutter application for personal finance management with modern UI and clean architecture custom

## 📋 Prerequisites

Before running this project, make sure you have the following installed on your system:

### Required Software

| Software | Version  | Download Link |
|----------|----------|---------------|
| **Flutter SDK** | `3.35.3` | [Download Flutter](https://flutter.dev/docs/get-started/install) |
| **Dart SDK** | `3.9.2`  | (Included with Flutter) |
| **Java JDK** | `17`     | [Download OpenJDK 17](https://adoptium.net/temurin/releases/?version=17) |
| **Android Studio** | Latest   | [Download Android Studio](https://developer.android.com/studio) |
| **Gradle** | `9.0.0`  | (Included with Android Studio) |

### System Requirements

- **Android SDK**: API Level 21+ (Android 5.0+), Target API 36 (Android 16)

## 🚀 Getting Started

### 1. Clone the Repository

```bash
git clone <repository-url>
cd KMonie
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Generate Code (if needed)

```bash
flutter packages pub run build_runner build
```

### 4. Run the App

```bash
# Debug mode
flutter run

# Release mode
flutter run --release

# Specific device
flutter run -d <device-id>
```

### Flutter Configuration

- **Flutter Version**: 3.35.3
- **Dart Version**: 3.9.2
- **Channel**: stable

### Android Configuration

- **Compile SDK**: 36
- **Min SDK**: 21
- **Target SDK**: 36
- **Java Version**: 17
- **Gradle Version**: 9.0.0
- **Android Gradle Plugin**: 8.13.0
- **Kotlin**: 2.2.20

### Project Structure

```
lib/
├── app.dart                 # App entry point
├── main.dart               # Main function
├── core/                   # Core utilities and configurations
│   ├── constants/          # App constants
│   ├── error/              # Error handling
│   ├── networks/           # Network layer
│   ├── theme/              # App theme
│   └── text_styles/        # Text styles
├── presentation/           # UI layer
│   ├── bloc/              # State management
│   ├── pages/             # Screen pages
│   ├── widgets/           # Reusable widgets
│   └── routes/            # Navigation routes
├── application/           # Application layer
├── database/              # Local storage
└── repositories/          # Data repositories
```

## 📱 Features

- **Clean Architecture**: Following SOLID principles
- **State Management**: BLoC pattern with flutter_bloc
- **Navigation**: Custom navigation with go_router
- **Network**: Dio for HTTP requests with Retrofit
- **Local Storage**: Flutter Secure Storage
- **UI Components**: Custom widgets with consistent design
- **Error Handling**: Comprehensive error management
- **Analytics**: Amplitude integration

## 🔧 Build Configuration

### Android Build

The app is configured to build for Android with the following settings:

- **Application ID**: `com.quocdat.kmonie`
- **Namespace**: `com.quocdat.kmonie`
- **Min SDK**: 21 (Android 5.0)
- **Target SDK**: 36 (Android 16)
- **Compile SDK**: 36


## 🚨 Troubleshooting

### Common Issues

1. **Flutter Doctor Issues**
   ```bash
   flutter doctor
   flutter doctor --android-licenses
   ```

2. **Gradle Build Issues**
   ```bash
   cd android
   ./gradlew clean
   cd ..
   flutter clean
   flutter pub get
   ```

3. **Dependency Issues**
   ```bash
   flutter pub deps
   flutter pub upgrade
   ```

4. **Code Generation Issues**
   ```bash
   flutter packages pub run build_runner clean
   flutter packages pub run build_runner build --delete-conflicting-outputs
   ```
## 📞 Support

For support and questions, please contact dath33603@gmail.com(+84327596141)