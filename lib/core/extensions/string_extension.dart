import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:presensi_data/core/_core.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_mobile/injections.dart';

extension StringExtension on String {
  /// Support format date String to DateTime
  /// Format ini support format waktu dan zona waktu.
  /// ```
  /// `2023-09-21T22:49:33.208636Z` convert to [DateTime]
  /// `2023-09-21T22:49:33.208636` convert to [DateTime]
  /// `2023-10-05T20:28:01+07:00` convert to [DateTime]
  /// `2023-10-05` convert to [DateTime]
  /// `05 10 2023` convert to [DateTime]
  /// `22:23:53` convert to [DateTime]
  /// `22:23` convert to [DateTime]
  ///
  /// ```
  DateTime? get toDateTime {
    final dt1 = toISOFormat;
    if (dt1 != null) return dt1;
    final dt2 = toTimeFormat;
    if (dt2 != null) return dt2;
    final dt3 = toYMMMMd;
    if (dt3 != null) return dt3;
    final dt4 = toTimeFormatHHmm;
    if (dt4 != null) return dt4;
    final dt = DateTime.tryParse(this);
    if (dt != null) return dt;

    return toYMMMd;
  }

  /// For ISO8601 date formatting and return is [DateTime].
  /// Format ini support format waktu dan zona waktu.
  /// e.g `2023-10-05T20:28:01+07:00Z` convert to [DateTime]
  DateTime? get toISOFormat {
    try {
      return DateFormat("yyyy-MM-ddTHH:mm:ssZ").parse(this);
    } catch (e) {
      return null;
    }
  }

  /// Format ini support format waktu dan zona waktu.
  /// e.g `22:23:53` convert to [DateTime]
  DateTime? get toTimeFormat {
    try {
      return DateFormat("HH:mm:ss").parse(this);
    } catch (e) {
      return null;
    }
  }

  /// Format ini support format waktu dan zona waktu.
  /// e.g `22:23` convert to [DateTime]
  DateTime? get toTimeFormatHHmm {
    try {
      return DateFormat("HH:mm").parse(this);
    } catch (e) {
      return null;
    }
  }

  DateTime? get toYMMMMd {
    try {
      return DateFormat('dd MMMM yyyy', 'id').parse(this);
    } catch (e) {
      return null;
    }
  }

  DateTime? get toYMMMd {
    try {
      return DateFormat('dd MMM yyyy', 'id').parse(this);
    } catch (e) {
      return null;
    }
  }

  // Format data calendar Cuti from value server '2022-01' to [DateTime]
  DateTime? get calendarCuti => DateFormat('yyyy-MM').parse(this);

  /// Date String convert to date time only
  /// Format ini support format waktu dan zona waktu.
  /// e.g String `12 Agustus 2022` convert to int `ISO8601`
  /// ```
  /// final dateTime = .isISO8601String().toDateTime;
  /// final d = dateTime.yMMMMd;
  /// print(d.toIso8601Server);  //2023-09-21T00:00:00.00Z
  /// timezone other than 'Z' and 'z'.
  /// ```
  String? get toIso8601Server {
    if (isEmpty) return null;
    return DateFormat('dd MMMM yyyy', 'id').parse(this).toIso8601String();
  }

  /// Format ini support to jam and menit
  /// e.g `1 Jam 2 Menit` convert to String
  /// if jam is empty, the jam is hide.
  String? get toTimeMinute {
    if (this == 'NaN') return '';
    double totalMenit = double.tryParse(this) ?? 0.0;

    // Hitung jam dan sisa menit
    final jam = totalMenit ~/ 60;
    final sisaMenit = (totalMenit % 60).round();

    // Format output
    String hasil = (jam > 0) ? '$jam Jam ' : '';
    hasil += '$sisaMenit Menit';

    return hasil;
  }

  /// Format ini support to jam and menit
  /// e.g `1 Jam 2 Menit` convert to String
  /// if jam is empty, the jam is hide.
  /// 23705detik >> 6 jam dan 0 menit
  String? get toTimeSecond {
    if (this == 'NaN') return '-';
    double totalDetik = double.tryParse(this) ?? 0;

    // Hitung jam dan sisa menit
    final jam = totalDetik ~/ 3600;
    final sisaDetik = (totalDetik % 3600).round();
    int sisaMenit = sisaDetik ~/ 60;

    // Format output
    String hasil = (jam > 0) ? '$jam Jam' : '';
    if (sisaMenit != 0) {
      hasil += ' $sisaMenit Menit';
    }

    return hasil;
  }

  /// format to String '90.00' to 90Km
  String? get toKilometer =>
      '${(double.tryParse(this) ?? 0).toStringAsFixed(2)} Km';

  /// currency String to String
  /// e,g `20000` convert to `Rp20.000.00`.
  String get toCurrency => (NumberFormat.simpleCurrency(
    locale: 'id',
    decimalDigits: 0,
    name: "Rp",
  ).format(int.tryParse(this) ?? 0));

  DateTimeRange get toDateTimeRange {
    List<String> dateParts = split(' - ');
    final startDate = dateParts.first.toDateTime!;
    final endDate = dateParts.last.toDateTime!;
    return DateTimeRange(start: startDate, end: endDate);
  }

  /// for `flutter is very good` first world capital formating to result as `Flutter is very good`
  String get capitalize =>
      '${this[0].toUpperCase()}${substring(1).toLowerCase()}';

  /// currency convert to number
  /// e.g String `20,000` convert to int `20000`
  int get numberDigitOnly => int.parse(replaceAll(".", ""));

  // strip if string is empty
  String get isEmptyStrip => isEmpty ? '-' : this;

  /// handle error with CODE exception
  /// Is code Unauthorized
  bool get isUnauthorized => this == "FORBIDDEN" || this == 'UNAUTHORIZED';

  /// condition for array is Empty or HTTP 404
  bool get isArrayEmpty => this == 'LENGTH_REQUIRED' || this == 'NOT_FOUND';

  /// condition for handle extension name
  bool get isPdf => contains('/pdf');
  bool get isPng => contains('/png');
  bool get isJpg => contains('/jpg');
  bool get isJpeg => contains('/jpeg');

  /// put list text into text
  /// e.g 'Anda baru saja {{par0}} pada {{par1}}'
  String? rich([List<String>? params]) {
    if (params != null && params.isNotEmpty) {
      String result = this;
      for (int i = 0; i < params.length; i++) {
        result = result.replaceAll('{{par${i.toString()}}}', params[i]);
      }
      return result;
    }
    return this;
  }

  /// handle gender copy with [GenderType]
  int? get handleGender {
    if (this == GenderType.m.name) {
      return 0;
    } else if (this == GenderType.f.name) {
      return 1;
    } else {
      return null;
    }
  }

  /// Pattern for valdation email
  bool get regexEmail {
    final RegExp emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
    return emailRegex.hasMatch(this);
  }

  bool get regexPhoneNumber {
    final RegExp phone = RegExp(r'^(\+62|62|021|0)[0-9][1-9][0-9]{6,9}$');
    return phone.hasMatch(this);
  }

  bool get isValidBaseUrl {
    final RegExp url = RegExp(
      r'^(https?:\/\/)?' //! protocol
      r'((([a-zA-Z0-9\-]+\.)+[a-zA-Z0-9\-]+)' //! domain name or IP
      r'|localhost)' //! OR localhost
      r'(:\d{2,5})?' //! port (optional)
      r'(\/)?$', //! trailing slash (optional)
      caseSensitive: false,
    );
    return url.hasMatch(this);
  }

  // String convert role
  String? get divisiTypeNamed {
    if (isEmpty) return null;

    // Check specific edge cases
    final lower = toLowerCase();
    if (lower == 'apj_alkes' || lower == 'apj alkes') return 'APJ Alkes';
    if (lower == 'it_staff' || lower == 'staff it') return 'Staff IT';

    // General conversion: replace underscores with spaces, then capitalize words
    final words = replaceAll('_', ' ').split(' ');
    final capitalizedWords = words.map((word) {
      if (word.isEmpty) return word;
      if (word.toLowerCase() == 'it') return 'IT';
      if (word.toLowerCase() == 'apj') return 'APJ';
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).toList();

    return capitalizedWords.join(' ');
  }

  // String convert role
  // TODO : Fix hardcode role
  DivisiType? get toDivisiType {
    switch (this) {
      case 'Marketing':
        return DivisiType.marketing;
      case 'Kurir':
        return DivisiType.courier;
      case 'Operasional Manager':
        return DivisiType.operationalManager;
      case 'Staff Gudang':
        return DivisiType.werehouseStaff;
      case 'APJ Alkes':
        return DivisiType.apjAlkes;
      case 'Apoteker':
        return DivisiType.apoteker;
      case 'Staff Admin':
        return DivisiType.adminStaff;
      case 'online_staff':
        return DivisiType.onlineStaff;
      case 'Direktur':
        return DivisiType.director;
      case 'Staff IT':
        return DivisiType.itStaff;
      case 'Staff Pajak':
        return DivisiType.taxStaff;
      //
      case 'marketing':
        return DivisiType.marketing;
      case 'courier':
        return DivisiType.courier;
      case 'operational_manager':
        return DivisiType.operationalManager;
      case 'werehouse_staff':
        return DivisiType.werehouseStaff;
      case 'apj_alkes':
        return DivisiType.apjAlkes;
      case 'apoteker':
        return DivisiType.apoteker;
      case 'admin_staff':
        return DivisiType.adminStaff;
      case 'director':
        return DivisiType.director;
      case 'it_staff':
        return DivisiType.itStaff;
      case 'tax_staff':
        return DivisiType.taxStaff;
      default:
        return DivisiType.galat;
    }
  }

  /// to print name UI the status kerja
  StatusKerja? get toStatusKerja {
    switch (this) {
      case 'kerja':
        return StatusKerja.kerja;
      case 'pulang':
        return StatusKerja.pulang;
      case 'istirahat':
        return StatusKerja.istirahat;
      case 'mulaiKerja':
        return StatusKerja.mulaiKerja;
      default:
        return StatusKerja.galat;
    }
  }

  StatusIzinType? get toStatusIzin {
    switch (this) {
      case 'diajukan':
        return StatusIzinType.diajukan;
      case 'diterima':
        return StatusIzinType.diterima;
      default:
        return StatusIzinType.ditolak;
    }
  }

  TypeCuti? get toTypeCuti {
    switch (this) {
      case 'izin_cuti_tahunan':
        return TypeCuti.izinCutiTahunan;
      case 'izin_sakit':
        return TypeCuti.izinSakit;
      case 'izin_urusan_keluarga':
        return TypeCuti.izinUrusanKeluarga;
      default:
        return TypeCuti.lainnya;
    }
  }

  StatusTask? get toStatusTask {
    switch (this) {
      case 'done':
        return StatusTask.done;
      case 'pending':
        return StatusTask.pending;
      default:
        return StatusTask.cancel;
    }
  }

  JenisKendaraan? get toJenisKendaraan {
    switch (this) {
      case 'motor':
        return JenisKendaraan.motor;
      case 'mobil':
        return JenisKendaraan.mobil;
      default:
        return JenisKendaraan.trukEkspedisi;
    }
  }

  JenisPembatalan? get toJenisPembatalan {
    switch (this) {
      case 'wrong_selected':
        return JenisPembatalan.wrongSelected;
      default:
        return JenisPembatalan.other;
    }
  }

  NotificationType? get toNotification {
    switch (this) {
      case 'notifikasi_jam_masuk':
        return NotificationType.notifikasiJamMasuk;
      case 'notifikasi_jam_pulang':
        return NotificationType.notifikasiJamPulang;
      case 'notifikasi_jam_istirahat':
        return NotificationType.notifikasiJamIstirahat;
      case 'notifikasi_cuti_diajukan':
        return NotificationType.notifikasiCutiDiajukan;
      case 'notifikasi_cuti_diterima':
        return NotificationType.notifikasiCutiDiterima;
      case 'notifikasi_cuti_ditolak':
        return NotificationType.notifikasiCutiDitolak;
      case 'notifikasi_task_from_admin':
        return NotificationType.notifikasiTaskFromAdmin;
      case 'notifikasi_task_done_today':
        return NotificationType.notifikasiTaskDoneToday;
      case 'notifikasi_task_cancel_today':
        return NotificationType.notifikasiTaskCancelToday;
      case 'tasks':
        return NotificationType.tasks;
      case 'inventaris':
        return NotificationType.inventaris;
      case 'inventaris_service':
        return NotificationType.inventarisService;
      case 'inventaris_pajak':
        return NotificationType.inventarisPajak;
      default:
        return NotificationType.other;
    }
  }

  ActiveType? get toActiveType {
    switch (this) {
      case 'active':
        return ActiveType.active;
      default:
        return ActiveType.deleted;
    }
  }

  AttendanceType? get toPresenceType {
    switch (trim().toLowerCase()) {
      case 'daily':
      case 'regular':
      case 'reguler':
        return AttendanceType.daily;
      case 'shift':
        return AttendanceType.shift;
      case 'on_call':
      case 'on-call':
      case 'on call':
      case 'oncall':
        return AttendanceType.oncall;
    }
    return null;
  }

  RequestPresensiType get toRequestPresensiType {
    final mapRequestPresensi = {
      'lupa_presensi_masuk': RequestPresensiType.lupaPresensiMasuk,
      'lupa_presensi_pulang': RequestPresensiType.lupaPresensiPulang,
      'lupa_masuk': RequestPresensiType.lupaMasuk,
      'lupa_masuk_dan_pulang': RequestPresensiType.lupaMasukDanPulang,
      'koreksi_masuk': RequestPresensiType.koreksiMasuk,
      'koreksi_pulang': RequestPresensiType.koreksiPulang,
      'koreksi_masuk_dan_pulang': RequestPresensiType.koreksiMasukDanPulang,
      'koreksi_waktu_istirahat': RequestPresensiType.koreksiWaktuIstirahat,
      'dinas_luar': RequestPresensiType.dinasLuar,
      'wfh': RequestPresensiType.wfh,
    };

    return mapRequestPresensi[this] ?? RequestPresensiType.lupaPresensiMasuk;
  }

  RequestPresensiStatus get toRequestPresensiStatus {
    final mapRequestPresensiStatus = {
      RequestPresensiStatus.pending.toKey: RequestPresensiStatus.pending,
      RequestPresensiStatus.approved.toKey: RequestPresensiStatus.approved,
      RequestPresensiStatus.rejected.toKey: RequestPresensiStatus.rejected,
      RequestPresensiStatus.cancelled.toKey: RequestPresensiStatus.cancelled,
    };
    return mapRequestPresensiStatus[this] ?? RequestPresensiStatus.pending;
  }

  Uri? get resolvedApiUri {
    if (isEmpty) return null;

    if (startsWith('http') || startsWith('https')) {
      return Uri.parse(this);
    }

    if (startsWith('//')) {
      return Uri.parse('https:$this');
    }

    final flavorConfig = sl<FlavorConfig>();
    final baseUrl = flavorConfig.baseApi ?? flavorConfig.values?.baseApi;
    final serverUrl = baseUrl?.replaceAll(RegExp(r'/graphql/?$'), '') ?? '';

    return Uri.parse(serverUrl).resolve(this);
  }
}

extension NullableStringExtension on String? {
  String orDefault(String defaultValue) {
    if (this == null || this!.trim().isEmpty) {
      return defaultValue;
    }
    return this!;
  }
}
