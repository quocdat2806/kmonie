import 'package:get_it/get_it.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:kmonie/core/streams/streams.dart';
import 'package:kmonie/core/network/network.dart';
import 'package:kmonie/database/database.dart';
import 'package:kmonie/core/services/services.dart';
import 'package:kmonie/repository/auth_repository.dart';

final GetIt sl = GetIt.instance;

Future<void> init() async {
  sl
    ..registerLazySingleton<Connectivity>(() => Connectivity())
    ..registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl<Connectivity>()))
    ..registerLazySingleton<SecureStorageService>(() => SecureStorageService())
    ..registerLazySingleton<SharedPreferencesService>(() => SharedPreferencesService())
    ..registerLazySingleton<KMonieDatabase>(() => KMonieDatabase())
    ..registerLazySingleton<LoggingInterceptor>(() => LoggingInterceptor())
    ..registerLazySingleton<AppDio>(() => TranslationDio(networkInfo: sl<NetworkInfo>(), secure: sl<SecureStorageService>(), logging: sl<LoggingInterceptor>()))
    ..registerLazySingleton<ApiClient>(() => ApiClient(sl<AppDio>().dio))
    ..registerLazySingleton<TransactionCategoryService>(() => TransactionCategoryService(sl<KMonieDatabase>()))
    ..registerLazySingleton<TransactionService>(() => TransactionService(sl<KMonieDatabase>()))
    ..registerLazySingleton<BudgetService>(() => BudgetService(sl<KMonieDatabase>()))
    ..registerLazySingleton<SnackBarService>(() => SnackBarService())
    ..registerLazySingleton<NotificationService>(() => NotificationService.I)
    ..registerLazySingleton<AppStreamEvent>(() => AppStreamEvent())
    ..registerLazySingleton<UserService>(() => UserService())
    ..registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl<ApiClient>()));
  await sl<KMonieDatabase>().warmUp();
  await sl<NotificationService>().init();
}
