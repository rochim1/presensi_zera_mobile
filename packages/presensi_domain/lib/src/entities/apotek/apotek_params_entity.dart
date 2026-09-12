import 'package:equatable/equatable.dart';

class ApotekParamsEntity extends Equatable {
  final String? namaApotik;
  final String? namaResmi;
  final String? namaAPJ;
  final String? noIjin;
  final String? kodePetugas;
  final String? telponNumber;
  final String? latitude;
  final String? longitude;
  final String? provinsi;
  final String? kabupaten;
  final String? kecamatan;
  final String? kelurahan;
  final String? kodePos;
  final String? alamat;
  final String? kodeOutlet;
  final String? email;
  final String? namaOwner;
  final String? website;
  final String? area;
  final String? kategoriProduk;
  final String? tahunBerdiri;
  final String? note;
  final bool? isCandidate;

  const ApotekParamsEntity({
    this.namaApotik,
    this.namaResmi,
    this.noIjin,
    this.kodePetugas,
    this.telponNumber,
    this.latitude,
    this.longitude,
    this.provinsi,
    this.kabupaten,
    this.kecamatan,
    this.kelurahan,
    this.kodePos,
    this.alamat,
    this.namaAPJ,
    this.kodeOutlet,
    this.email,
    this.namaOwner,
    this.website,
    this.area,
    this.kategoriProduk,
    this.tahunBerdiri,
    this.note,
    this.isCandidate = false,
  });

  @override
  List<Object?> get props => [
    namaApotik,
    namaResmi,
    noIjin,
    kodePetugas,
    namaAPJ,
    telponNumber,
    latitude,
    longitude,
    provinsi,
    kabupaten,
    kecamatan,
    kelurahan,
    kodePos,
    alamat,
    kodeOutlet,
    email,
    namaOwner,
    website,
    area,
    kategoriProduk,
    tahunBerdiri,
    note,
  ];

  Map<String, dynamic> toJson() {
    final input = <String, dynamic>{
      "nama_outlet": namaApotik,
      "nama_resmi": namaResmi,
      "nama_PIC": namaAPJ,
      "no_ijin": noIjin,
      "kode_petugas": kodePetugas,
      "telpon_number": telponNumber,
      "latitude": latitude,
      "longitude": longitude,
      "provinsi": provinsi,
      "kabupaten": kabupaten,
      "kecamatan": kecamatan,
      "kelurahan": kelurahan,
      'kode_pos': kodePos,
      "alamat": alamat,
      "kode_outlet": kodeOutlet,
      "email": email,
      "nama_owner": namaOwner,
      "website": website,
      "area": area,
      "kategori_produk": kategoriProduk,
      "tahun_berdiri": tahunBerdiri,
      "note": note,
      "is_candidate": isCandidate,
    };

    input.removeWhere((key, value) => value == null || value == '');

    return <String, dynamic>{"input": input};
  }
}
