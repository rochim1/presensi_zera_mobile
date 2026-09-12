import 'dart:developer';

import 'package:http/http.dart';
import 'package:logger/logger.dart';
import 'package:presensi_data/presensi_data.dart';
import 'package:presensi_domain/presensi_domain.dart';

abstract class UserRemoteDatasource {
  /// get data user remote
  Future<UserEntity> getUserData(String userId);

  /// update user data
  Future<String?> updateUser(UserParamsEntity params);

  /// update user account
  Future<String?> updateAccount(UserParamsEntity params);

  /// create/update data image
  Future<void> updateImage(MultipartFile? photo, String? userId);

  /// delete data image
  Future<bool> deleteImage(UserParamsEntity params);

  /// get all data inventori
  Future<List<InventarisEntity>> getAllInventaris(
    InventarisFilterEntity? params,
  );

  /// get profile image by ID user
  Future<String?> getProfileImage(String? idUser);

  Future<UserResponse> getUserById(String id);

  Future<List<UserResponse>> getUsers(GetUsersRequest request);

  Future<InventarisEntity> updateVehicle(
    String vehicleId,
    Map<String, dynamic> input,
  );
}

class UserRemoteDatasourceImpl extends UserRemoteDatasource with UserGraphQl {
  final GraphQlService graphQlService;
  final Logger logger;

  UserRemoteDatasourceImpl(this.graphQlService, {required this.logger});

  @override
  Future<InventarisEntity> updateVehicle(
    String vehicleId,
    Map<String, dynamic> input,
  ) async {
    const mutation = r'''
mutation UpdateVehicle($_id: ID!, $input: VehicleInput) {
  UpdateVehicle(_id: $_id, input: $input) {
    _id
    jenis_kendaraan
    merk
    plat_nomer
    jadwal_servis_terakhir
    kilometer_terakhir
    kilometer_kembali_servis
    tanggal_pembayaran_pajak
    total_biaya_pajak
    is_cycle_office
  }
}
''';
    final response = await graphQlService.mutation(
      mutation: mutation,
      variables: {'_id': vehicleId, 'input': input},
    );
    final vehicle = response['UpdateVehicle'] as Map<String, dynamic>?;
    if (vehicle == null) {
      throw GraphQlException(message: 'Data kendaraan gagal diperbarui');
    }
    return InventarisModel.fromJson(vehicle);
  }

  @override
  Future<UserEntity> getUserData(String userId) async {
    final data = await graphQlService.query(
      query: getUserQuery,
      variables: {'id': userId},
    );

    return UserModel.fromJson(data['GetOneUser']!);
  }

  @override
  Future<void> updateImage(MultipartFile? photo, String? userId) async {
    await graphQlService.mutation(
      mutation: updateUserImageMutation,
      variables: {
        "input": {"url_foto": photo},
        "id": userId,
      },
    );
  }

  @override
  Future<String?> updateUser(UserParamsEntity params) async {
    log(params.toUpdateAccount().toString());
    final data = await graphQlService.mutation(
      mutation: updateUserMutation,
      variables: params.toUpdateUser(),
    );

    return data['UpdateProfile']['message'];
  }

  @override
  Future<String?> updateAccount(UserParamsEntity params) async {
    final data = await graphQlService.mutation(
      mutation: updateUserMutation,
      variables: params.toUpdateAccount(),
    );

    return data['UpdateProfile']['message'];
  }

  @override
  Future<List<InventarisEntity>> getAllInventaris(
    InventarisFilterEntity? params,
  ) async {
    final data = await graphQlService.query(
      query: getAllInventarisKendaraan,
      variables: params?.toJson(),
    );

    final listAsMap =
        data['GetAllInventarisKendaraan']['inventaris'] as List<dynamic>;

    return listAsMap.map((e) => InventarisModel.fromJson(e)).toList();
  }

  @override
  Future<String?> getProfileImage(String? idUser) async {
    final data = await graphQlService.query(
      query: getImageProfile,
      variables: {'_id': idUser},
    );

    return data['GetProfileImage']['url_foto'];
  }

  @override
  Future<bool> deleteImage(UserParamsEntity params) async {
    final data = await graphQlService.mutation(
      mutation: deleteImageProfile,
      variables: params.toDeleteImage(),
    );

    return data['UpdateProfile']['is_successed'];
  }

  @override
  Future<UserResponse> getUserById(String id) async {
    logger.d("UserRemoteDatasourceImpl.getUserById id: $id");

    final response = await graphQlService.query(
      query: getUserByIdQuery,
      variables: {"id": id},
    );
    logger.d("UserRemoteDatasourceImpl.getUserById response: $response");

    final user = response["GetOneUser"] as Map<String, dynamic>;

    return UserResponse.fromJson(user);
  }

  @override
  Future<List<UserResponse>> getUsers(GetUsersRequest request) async {
    logger.d("UserRemoteDatasourceImpl.getUsers request: ${request.toJson()}");

    final response = await graphQlService.query(
      query: getUsersQuery,
      variables: {"filter": request.toJson()},
    );
    logger.d("UserRemoteDatasourceImpl.getUsers response: $response");

    final users = response["GetAllUser"]["users"] as List<dynamic>;
    return users.map((v) => UserResponse.fromJson(v)).toList();
  }
}
