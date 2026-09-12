import 'package:http/http.dart';
import 'package:logger/logger.dart';
import 'package:presensi_data/presensi_data.dart';
import 'package:presensi_domain/presensi_domain.dart';

abstract class PresensiRemoteDatasource {
  /// get all log presensi
  Future<List<PresensiEntity>> getAllData(PresensiFilterEntity params);

  /// get one presensi
  Future<PresensiEntity> getOne(PresensiGetOneParams params);

  /// create Masuk kerja
  Future<PresensiEntity> checkIn(
    CheckInRequest request,
    MultipartFile? fotoPresensiUpload,
    List<MultipartFile> fotoPendukungUpload,
  );

  /// create Pulang Kerja
  Future<PresensiEntity> checkOut(
    CheckOutRequest request,
    MultipartFile? fotoPresensiUpload,
    List<MultipartFile> fotoPendukungUpload,
  );

  /// create Start Istirahat
  Future<PresensiEntity> breakIn(BreakInRequest request);

  /// create End Istirahat
  Future<PresensiEntity> breakOut(BreakOutRequest request);

}

class PresensiRemoteDatasourceImpl extends PresensiRemoteDatasource
    with PresensiGraphQl {
  final GraphQlService graphQlService;
  final Logger logger;

  PresensiRemoteDatasourceImpl({
    required this.graphQlService,
    required this.logger,
  });

  @override
  Future<List<PresensiEntity>> getAllData(PresensiFilterEntity params) async {
    final data = await graphQlService.query(
      query: getAllPresensi,
      variables: params.toJson(),
    );

    final listAsMap = data['GetAllPresensi']['presensi'] as List<dynamic>;

    return listAsMap.map((e) => PresensiModel.fromJson(e)).toList();
  }

  @override
  Future<PresensiEntity> breakIn(BreakInRequest request) async {
    logger.d(
      "PresensiRemoteDatasourceImpl.breakIn: request: ${request.toJson()}",
    );
    final data = await graphQlService.mutation(
      mutation: createPresensi,
      variables: {'input': request.toJson()},
    );

    return PresensiModel.fromJson(
      data['CreatePresensi'] as Map<String, dynamic>,
    );
  }

  @override
  Future<PresensiEntity> breakOut(BreakOutRequest request) async {
    logger.d(
      "PresensiRemoteDatasourceImpl.breakOut: request: ${request.toJson()}",
    );
    final data = await graphQlService.mutation(
      mutation: createPresensi,
      variables: {'input': request.toJson()},
    );

    return PresensiModel.fromJson(
      data['CreatePresensi'] as Map<String, dynamic>,
    );
  }

  @override
  Future<PresensiEntity> checkIn(
    CheckInRequest request,
    MultipartFile? fotoPresensiUpload,
    List<MultipartFile> fotoPendukungUpload,
  ) async {
    final data = await graphQlService.mutation(
      mutation: createPresensi,
      variables: {
        'input': request.toJson(),
        'fotoPresensiUpload': fotoPresensiUpload != null
            ? [fotoPresensiUpload]
            : [],
        'fotoPendukungUpload': fotoPendukungUpload,
      },
    );

    return PresensiModel.fromJson(
      data['CreatePresensi'] as Map<String, dynamic>,
    );
  }

  @override
  Future<PresensiEntity> checkOut(
    CheckOutRequest request,
    MultipartFile? fotoPresensiUpload,
    List<MultipartFile> fotoPendukungUpload,
  ) async {
    logger.d(
      "PresensiRemoteDatasourceImpl.checkOut: request: ${request.toJson()}, fotoPresensiUpload: ${fotoPresensiUpload?.filename} size: ${fotoPresensiUpload?.length}",
    );

    final data = await graphQlService.mutation(
      mutation: createPresensi,
      variables: {
        'input': request.toJson(),
        'fotoPresensiUpload': fotoPresensiUpload != null
            ? [fotoPresensiUpload]
            : [],
        'fotoPendukungUpload': fotoPendukungUpload,
      },
    );

    return PresensiModel.fromJson(
      data['CreatePresensi'] as Map<String, dynamic>,
    );
  }

  @override
  Future<PresensiEntity> getOne(PresensiGetOneParams params) async {
    final data = await graphQlService.query(
      query: getOnePresensi,
      variables: {
        'presensiId': params.presensiId,
        'tanggalPresensi': params.tanggalPresensi,
        'userId': params.userId,
      },
    );

    return PresensiModel.fromJson(
      data['GetOnePresensi'] as Map<String, dynamic>,
    );
  }
}
