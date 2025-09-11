import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:kmonie/core/networks/network_info.dart';
import 'package:kmonie/core/networks/logging_interceptor.dart';
import 'package:kmonie/core/networks/app_dio.dart';
import 'package:kmonie/core/networks/api_client.dart';
import 'package:kmonie/database/secure_storage_service.dart';

final GetIt sl = GetIt.instance;

Future<void> init() async {
  sl
    ..registerLazySingleton<InternetConnectionChecker>(
      () => InternetConnectionChecker.createInstance(),
    )
    ..registerLazySingleton<NetworkInfo>(
      () => NetworkInfoImpl(sl<InternetConnectionChecker>()),
    )
    ..registerLazySingleton<SecureStorageService>(() => SecureStorageService())
    ..registerLazySingleton<LoggingInterceptor>(() => LoggingInterceptor())
    ..registerLazySingleton<AppDio>(
      () => TranslationDio(
        networkInfo: sl<NetworkInfo>(),
        secure: sl<SecureStorageService>(),
        logging: sl<LoggingInterceptor>(),
      ),
    )
    ..registerLazySingleton<ApiClient>(() => ApiClient(sl<AppDio>().dio));
}
