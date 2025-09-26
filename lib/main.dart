import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app.dart';
import 'application/auth/auth_bloc.dart';
import 'application/auth/auth_event.dart';
import 'core/navigation/app_router.dart';
import 'core/di/injection_container.dart' as di;
import 'database/secure_storage.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  await di.init();
  final AuthBloc authBloc = AuthBloc(di.sl<SecureStorageService>())
    ..add(const AuthAppStarted());
  final AppRouter appRouter = AppRouter(authBloc);
  runApp(App(authBloc: authBloc, appRouter: appRouter));
}
