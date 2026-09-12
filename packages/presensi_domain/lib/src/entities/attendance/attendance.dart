import 'package:presensi_domain/presensi_domain.dart';

class Attendance {
  final String id;
  final String? keterangan;
  final AttendanceType type;
  final StatusKerja status;
  final DateTime? date;
  final DateTime? jamMasuk;
  final DateTime? jamPulang;
  final AppLocation? locationCheckIn;
  final AppLocation? locationCheckOut;
  final Duration? totalKerja;
  final Duration? totalIstirahat;
  final List<AttendanceActivity> activities;
  final User? user;
  final AttendancePhoto? fotoPresensi;
  final AttendancePhoto? fotoPendukung;
  final String? jarakCheckInToStandar;
  final String? jarakCheckOutToStandar;
  final AttendanceCurrentSetting? currentSetting;

  const Attendance({
    required this.id,
    required this.type,
    required this.status,
    this.jamMasuk,
    this.jamPulang,
    this.date,
    this.locationCheckIn,
    this.locationCheckOut,
    required this.totalKerja,
    required this.totalIstirahat,
    this.activities = const [],
    this.keterangan,
    this.user,
    this.fotoPresensi,
    this.fotoPendukung,
    this.jarakCheckInToStandar,
    this.jarakCheckOutToStandar,
    this.currentSetting,
  });
}

class AttendancePhoto {
  final String? checkIn;
  final String? checkOut;

  const AttendancePhoto({this.checkIn, this.checkOut});
}

class AttendanceActivity {
  final String name;
  final DateTime? jamMulai;
  final bool isLate;
  final String? keterangan;
  final AttendanceActivityFormatLocal? formatLocal;

  const AttendanceActivity({
    required this.name,
    this.jamMulai,
    required this.isLate,
    this.keterangan,
    this.formatLocal,
  });
}

class AttendanceActivityFormatLocal {
  final String? full;

  const AttendanceActivityFormatLocal({this.full});
}

class AttendanceCurrentSetting {
  final String? jamMasuk;
  final String? jamPulang;

  const AttendanceCurrentSetting({this.jamMasuk, this.jamPulang});
}
