import 'package:equatable/equatable.dart';

class AdditionalContactEntity extends Equatable {
  final String? name;
  final String? relation;
  final String? telponNumber;
  final String? address;
  final String? email;

  const AdditionalContactEntity({
    this.name,
    this.relation,
    this.telponNumber,
    this.address,
    this.email,
  });

  @override
  List<Object?> get props {
    return [name, relation, telponNumber, address, email];
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'relation': relation,
      'telpon_number': telponNumber,
      'address': address,
      'email': email,
    };
  }
}
