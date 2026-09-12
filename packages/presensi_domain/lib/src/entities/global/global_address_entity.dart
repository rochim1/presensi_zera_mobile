import 'package:equatable/equatable.dart';

class GlobalAddressEntity extends Equatable {
  final String? name;
  final String? streetAddress;
  final String? subDistrict;
  final String? district;
  final String? subRegency;
  final String? regency;
  final String? province;
  final String? country;
  final String? postal;

  const GlobalAddressEntity({
    this.name,
    this.streetAddress,
    this.subDistrict,
    this.district,
    this.subRegency,
    this.regency,
    this.province,
    this.country,
    this.postal,
  });

  @override
  List<Object?> get props {
    return [
      name,
      streetAddress,
      subDistrict,
      country,
      district,
      subRegency,
      regency,
      province,
      postal,
    ];
  }

  @override
  String toString() {
    if (isEmpty) return '-';
    return '$name, $streetAddress, $subDistrict, $district, $regency, $province, $postal';
  }

  String? toApotekAddress() {
    final parts = [
      subDistrict,
      district,
      regency,
    ].where((s) => s?.trim().isNotEmpty == true).map((s) => s!.trim()).toList();
    final provPost = [
      province?.trim(),
      postal?.trim(),
    ].where((s) => s?.isNotEmpty == true).join(' ');
    if (provPost.isNotEmpty) parts.add(provPost);
    return parts.isEmpty ? null : parts.join(', ');
  }

  String? toMakerTitle() {
    if (subDistrict?.isEmpty ??
        false || (regency?.isEmpty ?? false) || (district?.isEmpty ?? false))
      return null;
    return '$subDistrict, $district, $regency';
  }

  bool get isEmpty =>
      ((district?.isEmpty ?? true) &&
      (regency?.isEmpty ?? true) &&
      (province?.isEmpty ?? true));

  bool get isNotEmpty => !isEmpty;
}
