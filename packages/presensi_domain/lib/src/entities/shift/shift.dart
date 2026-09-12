class Shift {
  final String id;
  final String name;
  final DateTime? jamMasuk;
  final DateTime? jamPulang;
  final Duration? totalKerja;
  final Duration? durasiIstirahat;

  const Shift({
    required this.id,
    required this.name,
    required this.jamMasuk,
    required this.jamPulang,
    this.totalKerja,
    this.durasiIstirahat,
  });
}
