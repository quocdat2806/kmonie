import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

import 'app.dart';
import 'application/auth/auth_bloc.dart';
import 'application/auth/auth_event.dart';
import 'core/di/injection_container.dart' as di;
import 'core/navigation/app_router.dart';
import 'database/drift_local_database.dart';
import 'database/secure_storage.dart';
import 'firebase_options.dart';

Future<void> main() async {
  return runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

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

      if (kDebugMode) {
        final byteOfDb = await di.sl<KMonieDatabase>().dbPhysicalSizeBytes();
        print('📦 DB size: $byteOfDb bytes');
      }

      Stripe.publishableKey = "pk_test_51SDHp1KG9jKZvhX6E60AycY54tBvWzkFqMRsJR7nQ060ouzuA634qMCq3qUM1c407jR2Na1sqNFSDnnddxwgTMrL00ktRGIeXW";
      await Stripe.instance.applySettings();

      runApp(App(authBloc: authBloc, appRouter: appRouter));
    },
    (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    },
  );
}
