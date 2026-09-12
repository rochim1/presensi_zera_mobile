import 'package:equatable/equatable.dart';

class GlobalFcmParamsEntity extends Equatable {
  final String appsId;
  final String? device;
  final String? modelDevice;

  const GlobalFcmParamsEntity({
    required this.appsId,
    this.modelDevice,
    this.device = 'mobile',
  });

  @override
  List<Object?> get props => [appsId, device, modelDevice];

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      "input": {
        "apps_id": appsId,
        "model_device": modelDevice,
        "device": device,
      },
    };
  }
}
