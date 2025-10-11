import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'app.dart';
import 'application/auth/auth.dart';
import 'core/di/di.dart' as di;
import 'core/navigation/navigation.dart';
import 'database/database.dart';

DotEnv dotenv = DotEnv();
Future<void> main() async {
  return runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      await initializeDateFormatting('vi_VN');
      await Firebase.initializeApp();
      await dotenv.load();
      FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
      PlatformDispatcher.instance.onError = (error, stack) {
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
        return true;
      };

      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

      await di.init();

      final AuthBloc authBloc = AuthBloc(di.sl<SecureStorageService>())..add(const AuthAppStarted());
      final AppRouter appRouter = AppRouter(authBloc);

      Stripe.publishableKey = dotenv.env['PUBLISH_ABLE_KEY']!;
      await Stripe.instance.applySettings();

      runApp(App(authBloc: authBloc, appRouter: appRouter));
    },
    (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    },
  );
}
