import 'package:equatable/equatable.dart';

class PresensiGetOneParams extends Equatable {
  final String? presensiId;
  final String? tanggalPresensi;
  final String? userId;

  const PresensiGetOneParams({
    this.presensiId,
    this.tanggalPresensi,
    this.userId,
  });

  @override
  List<Object?> get props {
    return [presensiId, tanggalPresensi, userId];
  }

  PresensiGetOneParams copyWith({
    String? presensiId,
    String? tanggalPresensi,
    String? userId,
  }) {
    return PresensiGetOneParams(
      presensiId: presensiId ?? this.presensiId,
      tanggalPresensi: tanggalPresensi ?? this.tanggalPresensi,
      userId: userId ?? this.userId,
    );
  }
}
