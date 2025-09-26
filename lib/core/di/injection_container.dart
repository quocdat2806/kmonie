import 'package:get_it/get_it.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../network/exports.dart';
import '../../database/exports.dart';

final GetIt sl = GetIt.instance;

Future<void> init() async {
  sl
    ..registerLazySingleton<Connectivity>(() => Connectivity())
    ..registerLazySingleton<NetworkInfo>(
      () => NetworkInfoImpl(sl<Connectivity>()),
    )
    ..registerLazySingleton<SecureStorageService>(() => SecureStorageService())
    ..registerLazySingleton<KMonieDatabase>(() => KMonieDatabase())
    ..registerLazySingleton<LoggingInterceptor>(() => LoggingInterceptor())
    ..registerLazySingleton<AppDio>(
      () => TranslationDio(
        networkInfo: sl<NetworkInfo>(),
        secure: sl<SecureStorageService>(),
        logging: sl<LoggingInterceptor>(),
      ),
    )
    ..registerLazySingleton<ApiClient>(() => ApiClient(sl<AppDio>().dio));


  await sl<KMonieDatabase>().warmUp();
}
