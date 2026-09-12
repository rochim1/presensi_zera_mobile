import 'package:equatable/equatable.dart';

class RegisterParamsEntity extends Equatable {
  final String name;
  final String telpNumber;
  final String username;
  final String email;
  final String password;
  final bool isAdmin;
  final String primaryProduct;
  final String registrationSource;
  final String requestedTrial;

  const RegisterParamsEntity({
    required this.name,
    required this.telpNumber,
    required this.username,
    required this.email,
    required this.password,
    this.isAdmin = false,
    this.primaryProduct = 'hrms',
    this.registrationSource = 'mobile_zera',
    this.requestedTrial = 'pantoo_unlimited',
  });

  @override
  List<Object?> get props => [
    name,
    telpNumber,
    username,
    email,
    password,
    isAdmin,
    primaryProduct,
    registrationSource,
    requestedTrial,
  ];

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'input': {
        'name': name,
        'telp_number': telpNumber,
        'username': username,
        'email': email,
        'password': password,
        'is_admin': isAdmin,
        'primary_product': primaryProduct,
        'registration_source': registrationSource,
        'requested_trial': requestedTrial,
      },
    };
  }
}
