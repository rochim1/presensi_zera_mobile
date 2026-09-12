import 'package:equatable/equatable.dart';

class HomeAlert extends Equatable {
  final String? greeting;
  final String? alertType;
  final String? alertMessage;

  const HomeAlert({
    this.greeting,
    this.alertType,
    this.alertMessage,
  });

  @override
  List<Object?> get props => [
        greeting,
        alertType,
        alertMessage,
      ];
}
