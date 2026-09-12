import 'package:equatable/equatable.dart';

class OutletEntity extends Equatable {
  final String? id;
  final String? namaOutlet;
  final String? kodeOutlet;
  final String? alamat;
  final String? telponNumber;
  final String? priceLevel;
  final String? latitude;
  final String? longitude;

  const OutletEntity({
    this.id,
    this.namaOutlet,
    this.kodeOutlet,
    this.alamat,
    this.telponNumber,
    this.priceLevel,
    this.latitude,
    this.longitude,
  });

  @override
  List<Object?> get props => [id, namaOutlet, kodeOutlet, alamat, telponNumber, priceLevel, latitude, longitude];
}
