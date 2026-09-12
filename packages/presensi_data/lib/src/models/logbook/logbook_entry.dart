import 'package:equatable/equatable.dart';

class LogbookEntry extends Equatable {
  final String id;
  final String tanggalLog;
  final String judulTugas;
  final String? deskripsi;
  final String? kategoriTugas;
  final String? jamMulai;
  final String? jamSelesai;
  final int? durasiMenit;
  final String? userId;
  final String? userName;

  const LogbookEntry({
    required this.id,
    required this.tanggalLog,
    required this.judulTugas,
    this.deskripsi,
    this.kategoriTugas,
    this.jamMulai,
    this.jamSelesai,
    this.durasiMenit,
    this.userId,
    this.userName,
  });

  factory LogbookEntry.fromJson(Map<String, dynamic> json) {
    return LogbookEntry(
      id: json['_id'] ?? '',
      tanggalLog: json['tanggal_log'] ?? '',
      judulTugas: json['judul_tugas'] ?? '',
      deskripsi: json['deskripsi'],
      kategoriTugas: json['kategori_tugas'],
      jamMulai: json['jam_mulai'],
      jamSelesai: json['jam_selesai'],
      durasiMenit: json['durasi_menit'],
      userId: json['user_id']?['_id']?.toString(),
      userName: _resolveUserName(json['user_id']),
    );
  }

  @override
  List<Object?> get props => [id, tanggalLog, judulTugas, userId];

  static String? _resolveUserName(dynamic rawUser) {
    if (rawUser is! Map<String, dynamic>) return null;
    final name = rawUser['name']?.toString().trim();
    if (name != null && name.isNotEmpty) return name;
    final fullName = [rawUser['first_name'], rawUser['last_name']]
        .where((value) => value != null && value.toString().trim().isNotEmpty)
        .map((value) => value.toString().trim())
        .join(' ');
    return fullName.isEmpty ? rawUser['username']?.toString() : fullName;
  }
}

class LogbookUserSummary extends Equatable {
  final String userId;
  final String userName;
  final int totalTask;
  final int totalDurasiMenit;

  const LogbookUserSummary({
    required this.userId,
    required this.userName,
    required this.totalTask,
    required this.totalDurasiMenit,
  });

  factory LogbookUserSummary.fromJson(Map<String, dynamic> json) {
    final rawUser = json['user_id'];
    final user = rawUser is Map<String, dynamic>
        ? rawUser
        : const <String, dynamic>{};
    final name = user['name']?.toString().trim();
    final username = user['username']?.toString().trim();
    return LogbookUserSummary(
      userId: user['_id']?.toString() ?? '',
      userName: name?.isNotEmpty == true
          ? name!
          : username?.isNotEmpty == true
          ? username!
          : 'Karyawan',
      totalTask: (json['total_task'] as num?)?.toInt() ?? 0,
      totalDurasiMenit: (json['total_durasi_menit'] as num?)?.toInt() ?? 0,
    );
  }

  @override
  List<Object?> get props => [userId, userName, totalTask, totalDurasiMenit];
}
