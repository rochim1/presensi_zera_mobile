import 'package:http/http.dart';

class CreateLeaveRequestParams {
  final String tipeCuti;
  final String alasan;
  final DateTime tanggalIzin;
  final DateTime tanggalMasuk;
  final bool isHalfDay;
  final String? halfDayType;
  final String? delegasiKepada;
  final MultipartFile? attachment;

  const CreateLeaveRequestParams({
    required this.tipeCuti,
    required this.alasan,
    required this.tanggalIzin,
    required this.tanggalMasuk,
    this.isHalfDay = false,
    this.halfDayType,
    this.delegasiKepada,
    this.attachment,
  });
}
