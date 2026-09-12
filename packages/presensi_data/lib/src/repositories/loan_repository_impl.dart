import 'package:dartz/dartz.dart';
import 'package:presensi_data/presensi_data.dart';
import 'package:presensi_domain/presensi_domain.dart';

class LoanRepositoryImpl implements LoanRepository {
  final LoanRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  LoanRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<EmployeeLoan>>> getEmployeeLoans(
      GetEmployeeLoansParams params) async {
    if (await networkInfo.isConnected) {
      try {
        final models = await remoteDataSource.getEmployeeLoans(params);
        return Right(models.map((e) => e.toEntity()).toList());
      } on GraphQlException catch (e) {
        return Left(ServerFailure(message: e.message));
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return Left(const ServerFailure(message: 'No Internet Connection'));
    }
  }

  @override
  Future<Either<Failure, EmployeeLoan>> createEmployeeLoan(
      CreateEmployeeLoanParams params) async {
    if (await networkInfo.isConnected) {
      try {
        final model = await remoteDataSource.createEmployeeLoan(params);
        return Right(model.toEntity());
      } on GraphQlException catch (e) {
        return Left(ServerFailure(message: e.message));
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return Left(const ServerFailure(message: 'No Internet Connection'));
    }
  }
}
