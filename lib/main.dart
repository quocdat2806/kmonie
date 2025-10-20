import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'app.dart';
import 'core/di/di.dart' as di;
// import 'package:google_mobile_ads/google_mobile_ads.dart';

DotEnv dotenv = DotEnv();
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Debug-only: log widget rebuilds to trace unexpected redraws
  assert(() {
    debugPrintRebuildDirtyWidgets = true;
    debugProfileBuildsEnabled = true;
    return true;
  }());
  await initializeDateFormatting('vi_VN');
  await Firebase.initializeApp();
  await dotenv.load();
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
  // MobileAds.instance.initialize();

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  await di.init();
  runApp(const App());

  // return runZonedGuarded(
  //   () async {
  //     WidgetsFlutterBinding.ensureInitialized();
  //     await initializeDateFormatting('vi_VN');
  //     await Firebase.initializeApp();
  //     await dotenv.load();
  //     FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  //     PlatformDispatcher.instance.onError = (error, stack) {
  //       FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
  //       return true;
  //     };
  //     // MobileAds.instance.initialize();

  //     SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  //     SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  //     await di.init();
  //     runApp(const App());
  //   },
  //   (error, stack) {
  //     FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
  //   },
  // );
}
