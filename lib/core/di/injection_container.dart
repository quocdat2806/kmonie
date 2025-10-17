import 'package:get_it/get_it.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:kmonie/core/streams/streams.dart';
import 'package:kmonie/core/network/network.dart';
import 'package:kmonie/database/database.dart';
import 'package:kmonie/core/services/services.dart';
import 'package:kmonie/repositories/repositories.dart';

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
    ..registerLazySingleton<AccountService>(() => AccountService(sl<KMonieDatabase>()))
    ..registerLazySingleton<NotificationService>(() => NotificationService.I)
    ..registerLazySingleton<UserService>(() => UserService())
    ..registerLazySingleton<SnackBarService>(() => SnackBarService())
    ..registerLazySingleton<AppStreamEvent>(() => AppStreamEvent())
    ..registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl<ApiClient>()))
    ..registerLazySingleton<AccountRepository>(() => AccountRepositoryImpl(sl<AccountService>()));
  await sl<KMonieDatabase>().warmUp();
  await sl<NotificationService>().init();
}
