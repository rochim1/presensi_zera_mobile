import 'package:presensi_domain/presensi_domain.dart';

class HomeAlertResponse {
  final String? greeting;
  final String? alertType;
  final String? alertMessage;

  const HomeAlertResponse({
    this.greeting,
    this.alertType,
    this.alertMessage,
  });

  factory HomeAlertResponse.fromJson(Map<String, dynamic> json) {
    return HomeAlertResponse(
      greeting: json['greeting'] as String?,
      alertType: json['alert_type'] as String?,
      alertMessage: json['alert_message'] as String?,
    );
  }

  HomeAlert toEntity() => HomeAlert(
        greeting: greeting,
        alertType: alertType,
        alertMessage: alertMessage,
      );
}
