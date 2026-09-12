import 'package:dartz/dartz.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_data/presensi_data.dart';
import 'package:presensi_data/src/datasources/remote/email_remote_datasource.dart';

class EmailRepositoryImpl implements EmailRepository {
  final EmailRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  EmailRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, int>> countUnreadEmail() async {
    try {
      final count = await remoteDataSource.countUnreadEmail();
      return Right(count);
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<EmailEntity>>> getAllEmail({
    Map<String, dynamic>? filter,
    int? limit,
    int? offset,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteData = await remoteDataSource.getAllEmail(
          filter: filter,
          limit: limit,
          offset: offset,
        );
        return Right(remoteData);
      } catch (e) {
        if (e is Failure) return Left(e);
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return const Left(ServerFailure(message: 'Tidak ada koneksi internet'));
    }
  }

  @override
  Future<Either<Failure, void>> readEmail(String id) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.readEmail(id);
        return const Right(null);
      } catch (e) {
        if (e is Failure) return Left(e);
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return const Left(ServerFailure(message: 'Tidak ada koneksi internet'));
    }
  }
}
