# Environment Configuration

This document contains detailed environment configuration information for the KMonie Flutter project.

## 🖥️ System Requirements

### Minimum Requirements
- **OS**: Windows 10 (1903+), macOS 10.14+, or Ubuntu 18.04+
- **RAM**: 8GB
- **Storage**: 10GB free space
- **CPU**: 64-bit processor

### Recommended Requirements
- **OS**: Windows 11, macOS 12+, or Ubuntu 20.04+
- **RAM**: 16GB
- **Storage**: 20GB free space
- **CPU**: Multi-core 64-bit processor

## 🔧 Development Environment

### Flutter & Dart
```bash
Flutter 3.35.3 • channel stable
Framework • revision a402d9a437
Engine • hash 672c59cfa87c8070c20ba2cd1a6c2a1baf5cf08b
Tools • Dart 3.9.2 • DevTools 2.48.0
```

### Java Development Kit
- **Version**: OpenJDK 17 (LTS)
- **Vendor**: Eclipse Temurin (recommended)
- **Download**: https://adoptium.net/temurin/releases/?version=17
- **JAVA_HOME**: Set to JDK installation directory

### Android Development
- **Android Studio**: Latest stable version
- **Android SDK**: API Level 35 (Android 15)
- **Min SDK**: API Level 21 (Android 5.0)
- **Target SDK**: API Level 35 (Android 15)
- **Build Tools**: Latest version
- **NDK**: Included with Flutter

### Gradle Configuration
```properties
# gradle.properties
org.gradle.jvmargs=-Xmx8G -XX:MaxMetaspaceSize=4G -XX:ReservedCodeCacheSize=512m -XX:+HeapDumpOnOutOfMemoryError -XX:+UseG1GC
android.useAndroidX=true
android.enableJetifier=true
```

```properties
# gradle-wrapper.properties
distributionUrl=https\://services.gradle.org/distributions/gradle-8.11.1-all.zip
```

## 📱 Device Configuration

### Android Emulator
- **API Level**: 21+ (Android 5.0+), Target 35 (Android 15)
- **Architecture**: x86_64 or arm64
- **RAM**: 4GB+ allocated
- **Storage**: 8GB+ allocated

### Physical Device
- **Android Version**: 5.0+ (API 21+), Target 15 (API 35)
- **USB Debugging**: Enabled
- **Developer Options**: Enabled

## 🛠️ IDE Configuration

### Android Studio
- **Version**: Latest stable
- **Plugins**: Flutter, Dart, Kotlin
- **Settings**: 
  - Flutter SDK path configured
  - Dart SDK path configured
  - Android SDK path configured

### VS Code (Alternative)
- **Extensions**: Flutter, Dart, Android iOS Emulator
- **Settings**: Flutter SDK path configured

## 📦 Dependencies

### Flutter Dependencies
```yaml
environment:
  sdk: ^3.9.2

dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  flutter_bloc: ^9.1.1
  bloc: ^9.0.0
  dartz: ^0.10.1
  equatable: ^2.0.7
  get_it: ^8.2.0
  dio: ^5.9.0
  retrofit: ^4.6.0
  internet_connection_checker: ^3.0.1
  json_annotation: ^4.9.0
  intl: ^0.20.2
  flutter_launcher_icons: ^0.14.4
  flutter_secure_storage: ^9.2.4
  amplitude_flutter: ^4.3.7
  go_router: ^16.2.1
  connectivity_plus: ^6.1.5
  logger: ^2.6.0
  device_info_plus: ^12.0.0
  permission_handler: ^12.0.1
  firebase_core: ^4.0.0
  url_launcher: ^6.3.2
  flutter_svg: ^2.2.1
  rxdart: ^0.28.0
  bloc_concurrency: ^0.3.0
```

### Development Dependencies
```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^6.0.0
  bloc_test: ^10.0.0
  mockito: ^5.5.0
  build_runner: ^2.6.0
  retrofit_generator: ^10.0.1
  json_serializable: ^6.10.0
```

## 🔍 Environment Variables

### Required Environment Variables
```bash
# Flutter
FLUTTER_ROOT=/path/to/flutter
DART_SDK=/path/to/flutter/bin/cache/dart-sdk

# Android
ANDROID_HOME=/path/to/android/sdk
ANDROID_SDK_ROOT=/path/to/android/sdk
JAVA_HOME=/path/to/java

# Optional
FLUTTER_WEB_AUTO_DETECT=true
```

## 🚀 Build Configuration

### Debug Build
```bash
flutter run --debug
```

### Release Build
```bash
flutter build apk --release
flutter build appbundle --release
```

### Profile Build
```bash
flutter run --profile
```

## 📊 Performance Settings

### Gradle Performance
- **JVM Heap**: 8GB
- **Metaspace**: 4GB
- **Code Cache**: 512MB
- **Garbage Collector**: G1GC (optimized for Java 17)
- **Parallel Builds**: Enabled
- **Build Cache**: Enabled

### Flutter Performance
- **Hot Reload**: Enabled
- **Hot Restart**: Enabled
- **Build Cache**: Enabled
- **Incremental Builds**: Enabled

## 🔧 Troubleshooting

### Common Environment Issues

1. **Flutter Doctor Issues**
   ```bash
   flutter doctor -v
   flutter doctor --android-licenses
   ```

2. **Java Version Issues**
   ```bash
   java -version
   echo $JAVA_HOME
   ```

3. **Android SDK Issues**
   ```bash
   flutter doctor --android-licenses
   sdkmanager --list
   ```

4. **Gradle Issues**
   ```bash
   cd android
   ./gradlew --version
   ./gradlew clean
   ```

### Performance Issues

1. **Slow Builds**
   - Increase Gradle heap size
   - Enable build cache
   - Use SSD storage

2. **Memory Issues**
   - Increase JVM heap size
   - Close unnecessary applications
   - Use 64-bit JDK

3. **Emulator Issues**
   - Enable hardware acceleration
   - Allocate more RAM
   - Use x86_64 images

## 📝 Notes

- Always use the exact versions specified in this document
- Keep Flutter and Dart SDKs updated together
- Regularly update Android SDK and build tools
- Monitor Gradle and Flutter performance
- Use version control for environment configuration

---

**Last Updated**: September 2024
**Maintained By**: Development Team
