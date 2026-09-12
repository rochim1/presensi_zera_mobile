class AttendanceStatistic {
  final String? typePresensi;
  final int totalHariKerja;
  final int totalHadir;
  final int totalTerlambat;
  final int totalTidakHadir;
  final int totalCutiIzin;
  final int totalLibur;
  final double konsistensi;

  const AttendanceStatistic({
    this.typePresensi,
    this.totalHariKerja = 0,
    this.totalHadir = 0,
    this.totalTerlambat = 0,
    this.totalTidakHadir = 0,
    this.totalCutiIzin = 0,
    this.totalLibur = 0,
    this.konsistensi = 0.0,
  });
}
