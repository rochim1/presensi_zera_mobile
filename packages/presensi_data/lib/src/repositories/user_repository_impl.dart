import 'package:dartz/dartz.dart';
import 'package:http/http.dart';
import 'package:logger/logger.dart';
import 'package:presensi_data/core/mapper/app_mappr.dart';
import 'package:presensi_data/presensi_data.dart';
import 'package:presensi_domain/presensi_domain.dart';

class UserRepositoryImpl extends UserRepository {
  final UserRemoteDatasource remoteDatasource;
  final LoginLocalDatasource localDatasource;
  final NetworkInfo networkInfo;
  final AppMappr mapper;
  final Logger log;

  UserRepositoryImpl({
    required this.remoteDatasource,
    required this.localDatasource,
    required this.networkInfo,
    required this.log,
    required this.mapper,
  });

  @override
  Future<Either<Failure, InventarisEntity>> updateVehicle(
    String vehicleId,
    Map<String, dynamic> input,
  ) async {
    try {
      final vehicle = await remoteDatasource.updateVehicle(vehicleId, input);
      return Right(vehicle);
    } on GraphQlException catch (e, stackTrace) {
      log.e(
        'UserRepositoryImpl.updateVehicle graphQL',
        error: e,
        stackTrace: stackTrace,
      );
      return Left(ServerFailure(message: e.message, code: e.code));
    } catch (e, stackTrace) {
      log.e(
        'UserRepositoryImpl.updateVehicle unknown',
        error: e,
        stackTrace: stackTrace,
      );
      return Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, LoginUserEntity>> getUserData() async {
    try {
      final net = await networkInfo.isConnected;
      //! get loginUser from local
      final login = await localDatasource.getLogin() as LoginUserModel;

      if (net) {
        //! get data user from remote by userId
        final user = await remoteDatasource.getUserData(login.userId);
        final img = await remoteDatasource.getProfileImage(login.userId);

        //! copy [User] into [LoginUser]
        final cpUser = login.copyWith(user: user as UserModel);
        final cpImage = cpUser.copyWith(
          user: cpUser.user?.copyWith(urlFoto: img),
        );
        //! save or update new user into [LoginUser]
        await localDatasource.cacheLogin(cpImage);

        return Right(cpImage);
      } else {
        return Right(login);
      }
    } catch (e, s) {
      if (e is! CacheException) log.e(e.toString(), stackTrace: s);
      if (e is GraphQlException) {
        return Left(ServerFailure(message: e.message, code: e.code));
      } else if (e is CacheException) {
        return Left(CacheFailure());
      } else {
        return Left(UnknownFailure());
      }
    }
  }

  @override
  Future<Either<Failure, LoginUserEntity>> getUserLocal() async {
    try {
      final LoginUserEntity data = await localDatasource.getLogin();

      return Right(data);
    } catch (e, s) {
      if (e is! CacheException) log.e(e.toString(), stackTrace: s);
      if (e is CacheException) {
        return Left(CacheFailure());
      } else {
        return Left(UnknownFailure());
      }
    }
  }

  @override
  Future<Either<Failure, String?>> updateImage(MultipartFile? photo) async {
    try {
      final userId = await getCurrentUserId();
      await remoteDatasource.updateImage(photo, userId);

      return Right(SUCCESS_IMAGE_CHANGE);
    } catch (e, s) {
      if (e is! CacheException) log.e(e.toString(), stackTrace: s);
      if (e is GraphQlException) {
        return Left(ServerFailure(message: e.message, code: e.code));
      } else {
        return Left(UnknownFailure());
      }
    }
  }

  @override
  Future<Either<Failure, String?>> updateUser(UserParamsEntity params) async {
    try {
      await remoteDatasource.updateUser(params);

      return Right(SUCCESS_UPDATE_DATA);
    } catch (e, s) {
      if (e is! CacheException) log.e(e.toString(), stackTrace: s);
      if (e is GraphQlException) {
        return Left(ServerFailure(message: e.message, code: e.code));
      } else {
        return Left(UnknownFailure());
      }
    }
  }

  @override
  Future<Either<Failure, String>> updateAccount(UserParamsEntity params) async {
    try {
      await remoteDatasource.updateAccount(params);

      return Right(SUCCESS_UPDATE_PASSWORD);
    } catch (e, s) {
      if (e is! CacheException) log.e(e.toString(), stackTrace: s);
      if (e is GraphQlException) {
        return Left(ServerFailure(message: e.message, code: e.code));
      } else {
        return Left(UnknownFailure());
      }
    }
  }

  @override
  Future<Either<Failure, List<InventarisEntity>>> getAllInventaris(
    InventarisFilterEntity? params,
  ) async {
    try {
      final data = await remoteDatasource.getAllInventaris(params);

      return Right(data);
    } catch (e, s) {
      if (e is! CacheException) log.e(e.toString(), stackTrace: s);
      if (e is GraphQlException) {
        return Left(ServerFailure(message: e.message, code: e.code));
      } else if (e is NotFoundException) {
        return Left(NotFoundFailure(message: FAILURE_NOT_FOUND_INV));
      } else {
        return Left(UnknownFailure());
      }
    }
  }

  @override
  Future<Either<Failure, String>> deleteImage(UserParamsEntity params) async {
    try {
      final data = await remoteDatasource.deleteImage(params);

      if (data) {
        return Right(SUCCESS_IMAGE_DELETE);
      } else {
        return Right(FAILED_IMAGE_DELETE);
      }
    } catch (e, s) {
      if (e is! CacheException) log.e(e.toString(), stackTrace: s);
      if (e is GraphQlException) {
        return Left(ServerFailure(message: e.message, code: e.code));
      } else {
        return Left(UnknownFailure());
      }
    }
  }

  @override
  Future<String?> getCurrentUserId() async {
    try {
      final data = await localDatasource.getLogin();

      return data.userId;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<Either<Failure, User>> getUserById(String id) async {
    try {
      final response = await remoteDatasource.getUserById(id);

      final user = mapper.convert<UserResponse, User>(response);
      return Right(user);
    } on GraphQlException catch (e, stackTrace) {
      if (e is! CacheException)
        log.e(
          "UserRepositoryImpl.getUserById graphQL",
          error: e,
          stackTrace: stackTrace,
        );
      return Left(ServerFailure(message: e.message, code: e.code));
    } catch (e, stackTrace) {
      if (e is! CacheException)
        log.e(
          "UserRepositoryImpl.getUserById unknown",
          error: e,
          stackTrace: stackTrace,
        );
      return Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, List<User>>> getUsers(GetUsersParams params) async {
    try {
      final request = mapper.convert<GetUsersParams, GetUsersRequest>(params);
      final response = await remoteDatasource.getUsers(request);

      final users = response
          .map((v) => mapper.convert<UserResponse, User>(v))
          .toList();

      return Right(users);
    } on GraphQlException catch (e, stackTrace) {
      if (e is! CacheException)
        log.e(
          "UserRepositoryImpl.getUsers graphQL",
          error: e,
          stackTrace: stackTrace,
        );
      return Left(ServerFailure(message: e.message, code: e.code));
    } catch (e, stackTrace) {
      if (e is! CacheException)
        log.e(
          "UserRepositoryImpl.getUsers unknown",
          error: e,
          stackTrace: stackTrace,
        );
      return Left(UnknownFailure());
    }
  }
}
