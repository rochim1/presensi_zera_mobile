import 'package:equatable/equatable.dart';

class InstansiEntity extends Equatable {
  final String? namaResmi;
  final String? logo;
  final String? namaInstansi;
  final String? website;
  final String? telponNumber;
  final String? tahunBerdiri;
  final String? alamat;
  final String? kegiatanUsaha;
  final String? dasarHukumPendirian;
  final String? subscriptionStatus;

  const InstansiEntity({
    this.namaResmi,
    this.logo,
    this.namaInstansi,
    this.website,
    this.telponNumber,
    this.tahunBerdiri,
    this.alamat,
    this.kegiatanUsaha,
    this.dasarHukumPendirian,
    this.subscriptionStatus,
  });

  @override
  List<Object?> get props => [
    namaResmi,
    logo,
    namaInstansi,
    website,
    telponNumber,
    tahunBerdiri,
    alamat,
    kegiatanUsaha,
    dasarHukumPendirian,
    subscriptionStatus,
  ];
}
