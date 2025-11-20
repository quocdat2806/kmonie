import 'package:dartz/dartz.dart';
import 'package:kmonie/core/error/error.dart';
import 'package:kmonie/core/services/services.dart';

abstract class DataRepository {
  Future<Either<Failure, void>> deleteAllUserData();
}

class DataRepositoryImpl implements DataRepository {
  DataRepositoryImpl(this._dataService);

  final DataService _dataService;

  @override
  Future<Either<Failure, void>> deleteAllUserData() async {
    try {
      await _dataService.deleteAllUserData();
      return const Right(null);
    } catch (e) {
      return Left(Failure.cache(e.toString()));
    }
  }
}
