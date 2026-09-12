import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:presensi_data/presensi_data.dart';

part 'shift_response.freezed.dart';

part 'shift_response.g.dart';

@freezed
abstract class ShiftResponse with _$ShiftResponse {
  const factory ShiftResponse({
    @JsonKey(name: '_id') required String id,
    @JsonKey(name: 'nama_shift', defaultValue: '') required String name,
    @JsonKey(name: 'jam_masuk') @TimeConverter() DateTime? jamMasuk,
    @JsonKey(name: 'jam_pulang') @TimeConverter() DateTime? jamPulang,
    @JsonKey(name: 'total_kerja') @DurationConverter() Duration? totalKerja,
    @JsonKey(name: 'durasi_istirahat')
    @DurationConverter()
    Duration? durasiIstirahat,
  }) = _ShiftResponse;

  factory ShiftResponse.fromJson(Map<String, dynamic> json) =>
      _$ShiftResponseFromJson(json);
}
