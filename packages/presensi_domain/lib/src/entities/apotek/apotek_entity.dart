import 'package:equatable/equatable.dart';

class ApotekEntity extends Equatable {
  final String? id;
  final String? kodeApotik;
  final String? namaApotik;
  final String? namaResmi;
  final String? namaAPJ;
  final String? kodePetugas;
  final String? noIzinApotik;
  final String? namaOwner;
  final String? logo;
  final String? email;
  final String? alamat;
  final String? kodePos;
  final String? maps;
  final String? longitude;
  final String? latitude;
  final String? kota;
  final String? provinsi;
  final String? kabupaten;
  final String? kecamatan;
  final String? kelurahan;
  final String? telponNumber;
  final String? status;
  final String? catatan;
  final String? tipeOutlet;
  final String? area;
  final String? kategoriProduk;
  final double? totalValue;
  final String? lastOrderDate;
  final String? userCreatedName;

  const ApotekEntity({
    this.id,
    this.kodeApotik,
    this.namaApotik,
    this.namaResmi,
    this.namaAPJ,
    this.kodePetugas,
    this.noIzinApotik,
    this.namaOwner,
    this.logo,
    this.email,
    this.alamat,
    this.kodePos,
    this.maps,
    this.longitude,
    this.latitude,
    this.kota,
    this.provinsi,
    this.kabupaten,
    this.kecamatan,
    this.kelurahan,
    this.telponNumber,
    this.status,
    this.catatan,
    this.tipeOutlet,
    this.area,
    this.kategoriProduk,
    this.totalValue,
    this.lastOrderDate,
    this.userCreatedName,
  });

  @override
  List<Object?> get props => [
    id,
    kodeApotik,
    namaApotik,
    namaResmi,
    namaAPJ,
    kodePetugas,
    noIzinApotik,
    namaOwner,
    logo,
    email,
    alamat,
    kodePos,
    maps,
    longitude,
    latitude,
    kota,
    provinsi,
    kabupaten,
    kecamatan,
    kelurahan,
    telponNumber,
    status,
    catatan,
    tipeOutlet,
    area,
    kategoriProduk,
    totalValue,
    lastOrderDate,
    userCreatedName,
  ];
}
