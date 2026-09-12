import 'package:dartz/dartz.dart';
import 'package:http/http.dart';
import 'package:presensi_data/core/_core.dart';
import 'package:presensi_domain/presensi_domain.dart';

abstract class UserRepository {
  /// get data user local
  Future<Either<Failure, LoginUserEntity>> getUserLocal();

  /// get data user remote
  Future<Either<Failure, LoginUserEntity>> getUserData();

  /// update account
  Future<Either<Failure, String>> updateAccount(UserParamsEntity params);

  /// update user
  Future<Either<Failure, String?>> updateUser(UserParamsEntity params);

  /// create or update profile image
  Future<Either<Failure, String?>> updateImage(MultipartFile? photo);

  /// delete user image
  Future<Either<Failure, String>> deleteImage(UserParamsEntity params);

  /// get all data inventaris
  Future<Either<Failure, List<InventarisEntity>>> getAllInventaris(
    InventarisFilterEntity? params,
  );

  Future<String?> getCurrentUserId();

  Future<Either<Failure, User>> getUserById(String id);

  Future<Either<Failure, List<User>>> getUsers(GetUsersParams params);

  Future<Either<Failure, InventarisEntity>> updateVehicle(
    String vehicleId,
    Map<String, dynamic> input,
  );
}
