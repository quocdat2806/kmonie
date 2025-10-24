import 'package:get_it/get_it.dart';
import 'package:kmonie/core/streams/streams.dart';
import 'package:kmonie/database/database.dart';
import 'package:kmonie/repositories/repositories.dart';
import 'package:kmonie/core/services/services.dart';
import 'package:kmonie/presentation/blocs/calendar_monthly_transaction/calendar_monthly_transaction_bloc.dart';

final GetIt sl = GetIt.instance;

Future<void> init() async {
  sl
    ..registerLazySingleton<KMonieDatabase>(() => KMonieDatabase())
    ..registerLazySingleton<TransactionCategoryService>(() => TransactionCategoryService(sl<KMonieDatabase>()))
    ..registerLazySingleton<TransactionService>(() => TransactionService(sl<KMonieDatabase>(), sl<AccountService>()))
    ..registerLazySingleton<BudgetService>(() => BudgetService(sl<KMonieDatabase>(), sl<TransactionService>()))
    ..registerLazySingleton<AccountService>(() => AccountService(sl<KMonieDatabase>()))
    ..registerLazySingleton<NotificationService>(() => NotificationService.I)
    ..registerLazySingleton<AppStreamEvent>(() => AppStreamEvent())
    ..registerLazySingleton<AccountRepository>(() => AccountRepositoryImpl(sl<AccountService>()))
    ..registerLazySingleton<TransactionRepository>(() => TransactionRepositoryImpl(sl<TransactionService>()))
    ..registerLazySingleton<TransactionCategoryRepository>(() => TransactionCategoryRepositoryImpl(sl<TransactionCategoryService>()))
    ..registerLazySingleton<CalendarMonthlyTransactionBloc>(() => CalendarMonthlyTransactionBloc(sl<TransactionRepository>(), sl<TransactionCategoryRepository>()));
  await sl<KMonieDatabase>().warmUp();
  await sl<NotificationService>().init();
}
