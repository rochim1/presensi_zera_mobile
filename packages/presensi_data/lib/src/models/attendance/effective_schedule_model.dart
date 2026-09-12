import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:presensi_domain/presensi_domain.dart';

part 'effective_schedule_model.freezed.dart';
part 'effective_schedule_model.g.dart';

@freezed
abstract class EffectiveScheduleModel with _$EffectiveScheduleModel {
  const factory EffectiveScheduleModel({
    @JsonKey(name: 'is_shift') bool? isShift,
    @JsonKey(name: 'is_regular') bool? isRegular,
    @JsonKey(name: 'effective_jam_masuk') String? effectiveJamMasuk,
    @JsonKey(name: 'effective_jam_pulang') String? effectiveJamPulang,
    @JsonKey(name: 'effective_jadwal_name') String? effectiveJadwalName,
  }) = _EffectiveScheduleModel;

  factory EffectiveScheduleModel.fromJson(Map<String, dynamic> json) =>
      _$EffectiveScheduleModelFromJson(json);
}

extension EffectiveScheduleModelX on EffectiveScheduleModel {
  EffectiveSchedule toEntity() {
    return EffectiveSchedule(
      isShift: isShift ?? false,
      isRegular: isRegular ?? false,
      effectiveJamMasuk: effectiveJamMasuk,
      effectiveJamPulang: effectiveJamPulang,
      effectiveJadwalName: effectiveJadwalName,
    );
  }
}
