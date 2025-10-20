import 'package:get_it/get_it.dart';
import 'package:kmonie/core/streams/streams.dart';
import 'package:kmonie/database/database.dart';
import 'package:kmonie/repositories/repositories.dart';
import 'package:kmonie/core/services/services.dart';

final GetIt sl = GetIt.instance;

Future<void> init() async {
  sl
    ..registerLazySingleton<KMonieDatabase>(() => KMonieDatabase())
    ..registerLazySingleton<TransactionCategoryService>(() => TransactionCategoryService(sl<KMonieDatabase>()))
    ..registerLazySingleton<TransactionService>(() => TransactionService(sl<KMonieDatabase>()))
    ..registerLazySingleton<BudgetService>(() => BudgetService(sl<KMonieDatabase>()))
    ..registerLazySingleton<AccountService>(() => AccountService(sl<KMonieDatabase>()))
    ..registerLazySingleton<NotificationService>(() => NotificationService.I)
    ..registerLazySingleton<SnackBarService>(() => SnackBarService())
    ..registerLazySingleton<AppStreamEvent>(() => AppStreamEvent())
    ..registerLazySingleton<AccountRepository>(() => AccountRepositoryImpl(sl<AccountService>()));
  await sl<KMonieDatabase>().warmUp();
  await sl<NotificationService>().init();
}
