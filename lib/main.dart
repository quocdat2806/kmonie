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

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
}
