import 'package:dartz/dartz.dart';
import 'package:logger/logger.dart';
import 'package:presensi_data/presensi_data.dart';
import 'package:presensi_domain/presensi_domain.dart';

class ApotekRepositoryImpl extends ApotekRepository {
  final ApotekRemoteDatasource remoteDatasource;
  final Logger log;
  final NetworkInfo networkInfo;
  final LocalCacheService localCacheService;

  ApotekRepositoryImpl({
    required this.remoteDatasource,
    required this.log,
    required this.networkInfo,
    required this.localCacheService,
  });

  @override
  Future<Either<Failure, List<ApotekEntity>>> getAllData(
    ApotekFilterEntity params,
  ) async {
    final isOnline = await networkInfo.isConnected;

    if (isOnline) {
      try {
        final data = await remoteDatasource.getAllData(params);

        // Cache the data for offline use
        try {
          final jsonList = data.map((a) => {
            '_id': a.id,
            'kode_apotik': a.kodeApotik,
            'nama_apotik': a.namaApotik,
            'nama_resmi': a.namaResmi,
            'nama_apj': a.namaAPJ,
            'kode_petugas': a.kodePetugas,
            'no_izin_apotik': a.noIzinApotik,
            'nama_owner': a.namaOwner,
            'logo': a.logo,
            'email': a.email,
            'alamat': a.alamat,
            'kode_pos': a.kodePos,
            'maps': a.maps,
            'longitude': a.longitude,
            'latitude': a.latitude,
            'kota': a.kota,
            'provinsi': a.provinsi,
            'kabupaten': a.kabupaten,
            'kecamatan': a.kecamatan,
            'kelurahan': a.kelurahan,
            'telpon_number': a.telponNumber,
            'status': a.status,
          }).toList();
          await localCacheService.cacheApotekList(jsonList);
        } catch (cacheError) {
          log.w('Failed to cache apotek data: $cacheError');
        }

        return Right(data);
      } catch (e, s) {
        if (e is! CacheException) log.e(e.toString(), stackTrace: s);
        if (e is GraphQlException) {
          return Left(ServerFailure(message: e.message, code: e.code));
        } else {
          return Left(UnknownFailure());
        }
      }
    } else {
      // Offline: load from cache
      try {
        final cachedList = await localCacheService.getCachedApotekList();
        if (cachedList.isEmpty) {
          return Left(ServerFailure(message: 'Tidak ada koneksi internet dan data cache kosong.'));
        }

        final apotekEntities = cachedList.map((json) => ApotekEntity(
          id: json['_id'],
          kodeApotik: json['kode_apotik'],
          namaApotik: json['nama_apotik'],
          namaResmi: json['nama_resmi'],
          namaAPJ: json['nama_apj'],
          kodePetugas: json['kode_petugas'],
          noIzinApotik: json['no_izin_apotik'],
          namaOwner: json['nama_owner'],
          logo: json['logo'],
          email: json['email'],
          alamat: json['alamat'],
          kodePos: json['kode_pos'],
          maps: json['maps'],
          longitude: json['longitude'],
          latitude: json['latitude'],
          kota: json['kota'],
          provinsi: json['provinsi'],
          kabupaten: json['kabupaten'],
          kecamatan: json['kecamatan'],
          kelurahan: json['kelurahan'],
          telponNumber: json['telpon_number'],
          status: json['status'],
        )).toList();

        return Right(apotekEntities);
      } catch (e) {
        return Left(ServerFailure(message: 'Gagal memuat data offline: $e'));
      }
    }
  }

  @override
  Future<Either<Failure, ApotekEntity>> postData(
    ApotekParamsEntity params,
  ) async {
    try {
      log.d(params.toJson());
      final data = await remoteDatasource.postData(params);

      return Right(data);
    } catch (e, s) {
      if (e is! CacheException) log.e(e.toString(), stackTrace: s);
      if (e is GraphQlException) {
        return Left(ServerFailure(message: e.message, code: e.code));
      } else {
        return Left(UnknownFailure());
      }
    }
  }
}
