import 'package:flutter/material.dart';
import 'presentation/routes/app_router.dart';
import 'application/auth/auth_bloc.dart';
import 'application/auth/auth_event.dart';
import 'database/secure_storage_service.dart';
import 'app.dart';
import 'package:kmonie/core/di/injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  final AuthBloc authBloc = AuthBloc(di.sl<SecureStorageService>())
    ..add(AuthAppStarted());
  final AppRouter appRouter = AppRouter(authBloc);
  runApp(App(authBloc: authBloc, appRouter: appRouter));
}
