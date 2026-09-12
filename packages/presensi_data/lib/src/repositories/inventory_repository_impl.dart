import 'package:dartz/dartz.dart';
import 'package:logger/logger.dart';
import 'package:presensi_data/presensi_data.dart';
import 'package:presensi_domain/presensi_domain.dart';

class InventoryRepositoryImpl implements InventoryRepository {
  final InventoryRemoteDataSource remoteDataSource;
  final Logger logger;

  InventoryRepositoryImpl({
    required this.remoteDataSource,
    required this.logger,
  });

  @override
  Future<Either<Failure, List<IncidentalReport>>> getIncidentalReports({
    int? page,
    int? limit,
    String? search,
  }) async {
    try {
      final response = await remoteDataSource.getIncidentalReports(
        page: page,
        limit: limit,
        search: search,
      );

      final data = response['GetAllInventoryScraps']['items'] as List;
      final result = data.map((item) {
        final createdBy = item['diajukan_oleh'];
        final scrapItems = item['items'] as List? ?? const [];
        final detail = scrapItems.isNotEmpty ? scrapItems.first : const {};
        return IncidentalReport(
          id: item['_id']?.toString() ?? '',
          noIncident: item['no_scrap'],
          inventarisId: detail['inventaris_id']?.toString(),
          kodeInventaris: detail['kode_inventaris'],
          namaInventaris: detail['nama_inventaris'],
          unit: detail['unit'],
          jenisInsiden: item['jenis_insiden'],
          lokasiKejadian: item['lokasi_kejadian'],
          tindakan: detail['tindakan'],
          tanggalKejadian: item['tanggal_scrap'],
          jumlahRusak: (detail['qty'] as num?)?.toInt(),
          jumlahHasilRecycle: (detail['jumlah_hasil_recycle'] as num?)?.toInt(),
          jumlahHilang: (detail['jumlah_hilang'] as num?)?.toInt(),
          stokSebelum: (detail['stok_sebelum'] as num?)?.toInt(),
          stokSesudah: (detail['stok_sesudah'] as num?)?.toInt(),
          keterangan: item['alasan_detail'] ?? item['catatan'],
          status: item['status'],
          createdByName: createdBy != null ? createdBy['name'] : null,
        );
      }).toList();

      return Right(result);
    } catch (e) {
      if (e is GraphQlException) {
        return Left(ServerFailure(message: e.message ?? e.toString()));
      }
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, IncidentalReport>> addIncidentalReport({
    required Map<String, dynamic> input,
  }) async {
    try {
      final response = await remoteDataSource.addIncidentalReport(input: input);
      final data = response['CreateInventoryScrap'];

      final result = IncidentalReport(
        id: data['_id']?.toString() ?? '',
        noIncident: data['no_scrap'],
      );

      return Right(result);
    } catch (e) {
      if (e is GraphQlException) {
        return Left(ServerFailure(message: e.message ?? e.toString()));
      }
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<InventarisItem>>> getInventarisUmum({
    int? page,
    int? limit,
    String? search,
  }) async {
    try {
      final response = await remoteDataSource.getInventarisUmum(
        page: page,
        limit: limit,
        search: search,
      );

      final data = response['GetAllInventarisUmum']['items'] as List;
      final result = data.map((item) {
        return InventarisItem(
          id: item['_id']?.toString() ?? '',
          kodeInventaris: item['kode_inventaris'],
          namaInventaris: item['nama_inventaris'],
          unit: item['unit'],
          kategoriId: item['kategori_id'],
          kategoriNama: item['kategori_nama'],
          totalStok: item['total_stok'],
        );
      }).toList();

      return Right(result);
    } catch (e) {
      if (e is GraphQlException) {
        return Left(ServerFailure(message: e.message ?? e.toString()));
      }
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<InventoryLocationBalance>>> getLocationBalances({
    required String inventoryId,
  }) async {
    try {
      final response = await remoteDataSource.getLocationBalances(
        inventoryId: inventoryId,
      );
      final items = response['GetInventoryLocationBalances']['items'] as List;
      return Right(
        items
            .map(
              (item) => InventoryLocationBalance(
                id: item['_id']?.toString() ?? '',
                branchId: item['lokasi_cabang_id']?.toString(),
                branchName: item['lokasi_cabang_nama'],
                buildingName: item['lokasi_gedung_nama'],
                roomName: item['lokasi_ruangan_nama'],
                rackName: item['lokasi_rak_nama'],
                quantity: (item['qty'] as num?)?.toDouble() ?? 0,
              ),
            )
            .where((item) => item.id.isNotEmpty)
            .toList(),
      );
    } catch (e) {
      if (e is GraphQlException) {
        return Left(ServerFailure(message: e.message ?? e.toString()));
      }
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
