import 'package:equatable/equatable.dart';
import 'package:presensi_domain/presensi_domain.dart';

class UserParamsEntity extends Equatable {
  /// delete|edit is required
  final String userId;
  final String? noIdentitas;
  final String? name;
  final String? username;
  final String? gender;
  final String? email;
  final String? identityType;
  final String? address;
  final String? domisili;
  final String? posCode;
  final String? urlFoto;
  final String? dateOfBirth;
  final String? telpNumber;
  final int? instansiId;
  final int? managerId;
  final String? leaveRemain;
  final String? dateJoin;
  final String? dateResign;
  final bool? isAdmin;
  final List<AdditionalContactEntity>? additionalContact;
  final String? deletedAt;
  final String? deleteReason;
  final String? password;

  /// delete image is required
  final bool? isFotoDeleted;

  const UserParamsEntity({
    required this.userId,
    this.noIdentitas,
    this.name,
    this.username,
    this.gender,
    this.email,
    this.identityType,
    this.address,
    this.domisili,
    this.posCode,
    this.urlFoto,
    this.dateOfBirth,
    this.telpNumber,
    this.instansiId,
    this.managerId,
    this.leaveRemain,
    this.dateJoin,
    this.dateResign,
    this.isAdmin,
    this.additionalContact,
    this.deletedAt,
    this.deleteReason,
    this.password,
    this.isFotoDeleted,
  });

  @override
  List<Object?> get props {
    return [
      userId,
      noIdentitas,
      name,
      username,
      gender,
      email,
      identityType,
      address,
      domisili,
      posCode,
      urlFoto,
      dateOfBirth,
      telpNumber,
      instansiId,
      managerId,
      leaveRemain,
      dateJoin,
      dateResign,
      isAdmin,
      additionalContact,
      deletedAt,
      deleteReason,
      password,
      isFotoDeleted,
    ];
  }

  Map<String, dynamic> toUpdateUser() {
    return <String, dynamic>{
      'id': userId,
      'input': <String, dynamic>{
        'gender': gender,
        'address': address,
        'telp_number': telpNumber,
      },
    };
  }

  Map<String, dynamic> toUpdateAccount() {
    return <String, dynamic>{
      'id': userId,
      'input': <String, dynamic>{'password': password},
    };
  }

  Map<String, dynamic> toDeleteImage() {
    return <String, dynamic>{
      'id': userId,
      'input': <String, dynamic>{'isFotoDeleted': isFotoDeleted},
    };
  }
}
