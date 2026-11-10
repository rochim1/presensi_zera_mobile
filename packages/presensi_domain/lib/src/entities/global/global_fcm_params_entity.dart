import 'package:equatable/equatable.dart';

class GlobalFcmParamsEntity extends Equatable {
  final String appsId;
  final String? device;
  final String? modelDevice;
  final String? firebaseProjectId;

  const GlobalFcmParamsEntity({
    required this.appsId,
    this.modelDevice,
    this.device = 'mobile',
    this.firebaseProjectId,
  });

  @override
  List<Object?> get props => [appsId, device, modelDevice, firebaseProjectId];

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      "input": {
        "apps_id": appsId,
        "model_device": modelDevice,
        "device": device,
        if (firebaseProjectId != null) "firebase_project_id": firebaseProjectId,
      },
    };
  }
}
