import 'package:flutter/material.dart';

/// Pengungkapan yang selalu dipakai sebelum aplikasi meminta atau mengaktifkan
/// lokasi latar belakang. Teks ini sengaja spesifik agar pengguna memahami
/// data, tujuan, waktu pengumpulan, dan penerimanya.
Future<bool> showBackgroundLocationDisclosure(BuildContext context) async {
  final accepted = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (dialogContext) => AlertDialog(
      icon: const Icon(Icons.location_on_rounded, color: Colors.redAccent),
      title: const Text('Izin lokasi latar belakang'),
      content: const SingleChildScrollView(
        child: Text(
          'Pantoo mengumpulkan dan mengirimkan data lokasi presisi untuk '
          'mengaktifkan presensi serta live tracking sesi kerja dan lembur, '
          'termasuk saat aplikasi ditutup atau tidak sedang digunakan.\n\n'
          'Lokasi dikirim secara aman ke server '
          'Pantoo dan dapat dilihat oleh admin HR perusahaan yang berwenang untuk '
          'memantau sesi kerja.\n\n'
          'Lokasi tidak digunakan untuk iklan, tidak dibagikan untuk tujuan lain, '
          'dan pelacakan berhenti otomatis saat check-out atau logout. Anda dapat '
          'menolak; fitur Pantoo yang tidak memerlukan live tracking tetap dapat digunakan.',
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(false),
          child: const Text('Tidak setuju'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(dialogContext).pop(true),
          child: const Text('Setuju & lanjutkan'),
        ),
      ],
    ),
  );
  return accepted == true;
}

/// Informasi yang terlihat di login, sehingga alur lokasi tidak tersembunyi
/// bagi pengguna atau reviewer sebelum mereka masuk ke aplikasi.
class BackgroundLocationDisclosureNotice extends StatelessWidget {
  const BackgroundLocationDisclosureNotice({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.withValues(alpha: .06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.withValues(alpha: .22)),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 2),
            child: Icon(Icons.location_on_outlined, color: Colors.blue),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Live tracking hanya menggunakan lokasi presisi saat sesi kerja aktif. '
              'Jika diperlukan, Pantoo akan meminta persetujuan Anda sebelum '
              'mengakses lokasi di latar belakang.',
            ),
          ),
        ],
      ),
    );
  }
}
