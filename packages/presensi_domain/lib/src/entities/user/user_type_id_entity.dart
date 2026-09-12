import 'package:equatable/equatable.dart';
import 'package:presensi_domain/presensi_domain.dart';

class UserTypeIdEntity extends Equatable {
  final DivisiIdEntity? divisiId;
  final String? jabatan;
  final String? keterangan;
  final InstansiEntity? instansiId;
  final String? level;
  final String? status;
  final String? createdAt;
  final String? updatedAt;

  const UserTypeIdEntity({
    this.divisiId,
    this.jabatan,
    this.keterangan,
    this.instansiId,
    this.level,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props {
    return [
      divisiId,
      jabatan,
      keterangan,
      instansiId,
      level,
      status,
      createdAt,
      updatedAt,
    ];
  }
}
