import 'package:get_it/get_it.dart';
import 'package:kmonie/core/streams/streams.dart';
import 'package:kmonie/database/database.dart';
import 'package:kmonie/repositories/repositories.dart';
import 'package:kmonie/core/services/services.dart';
import 'package:kmonie/core/utils/utils.dart';

final GetIt sl = GetIt.instance;

bool _isInitialized = false;

Future<void> init({bool backgroundMode = false}) async {
  if (_isInitialized) {
    return;
  }

  try {
    if (!sl.isRegistered<KMonieDatabase>()) {
      sl.registerLazySingleton<KMonieDatabase>(() => KMonieDatabase());
    }
    if (!sl.isRegistered<AccountService>()) {
      sl.registerLazySingleton<AccountService>(
        () => AccountService(sl<KMonieDatabase>()),
      );
    }
    if (!sl.isRegistered<TransactionCategoryService>()) {
      sl.registerLazySingleton<TransactionCategoryService>(
        () => TransactionCategoryService(sl<KMonieDatabase>()),
      );
    }
    if (!sl.isRegistered<TransactionService>()) {
      sl.registerLazySingleton<TransactionService>(
        () => TransactionService(sl<KMonieDatabase>(), sl<AccountService>()),
      );
    }
    if (!sl.isRegistered<BudgetService>()) {
      sl.registerLazySingleton<BudgetService>(
        () => BudgetService(sl<KMonieDatabase>(), sl<TransactionService>()),
      );
    }
    if (!sl.isRegistered<DataService>()) {
      sl.registerLazySingleton<DataService>(
        () => DataService(sl<KMonieDatabase>(), sl<TransactionService>()),
      );
    }
    if (!sl.isRegistered<TransactionAutomationService>()) {
      sl.registerLazySingleton<TransactionAutomationService>(
        () => TransactionAutomationService(sl<KMonieDatabase>()),
      );
    }
    if (!sl.isRegistered<NotificationService>()) {
      sl.registerLazySingleton<NotificationService>(
        () => NotificationService.I,
      );
    }
    if (!sl.isRegistered<AppStreamEvent>()) {
      sl.registerLazySingleton<AppStreamEvent>(() => AppStreamEvent());
    }
    if (!sl.isRegistered<AccountRepository>()) {
      sl.registerLazySingleton<AccountRepository>(
        () => AccountRepositoryImpl(sl<AccountService>()),
      );
    }
    if (!sl.isRegistered<TransactionRepository>()) {
      sl.registerLazySingleton<TransactionRepository>(
        () => TransactionRepositoryImpl(sl<TransactionService>()),
      );
    }
    if (!sl.isRegistered<TransactionCategoryRepository>()) {
      sl.registerLazySingleton<TransactionCategoryRepository>(
        () =>
            TransactionCategoryRepositoryImpl(sl<TransactionCategoryService>()),
      );
    }
    if (!sl.isRegistered<BudgetRepository>()) {
      sl.registerLazySingleton<BudgetRepository>(
        () => BudgetRepositoryImpl(sl<BudgetService>()),
      );
    }
    if (!sl.isRegistered<DataRepository>()) {
      sl.registerLazySingleton<DataRepository>(
        () => DataRepositoryImpl(sl<DataService>()),
      );
    }

    await sl<KMonieDatabase>().warmUp();
    await sl<NotificationService>().init();

    if (!backgroundMode) {
      await sl<TransactionCategoryService>().getAll();
    }

    _isInitialized = true;
  } catch (e) {
    logger.e('Error initializing DI: $e');
    rethrow;
  }
}
