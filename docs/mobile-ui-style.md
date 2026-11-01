# Standar UI mobile Pantoo

Acuan yang disepakati: Home, Cuti, Presensi, dan Pusat Persetujuan.

- Header memakai `AppTopBar`: judul rata kiri dekat tombol kembali; subjudul singkat. Jarak horizontal 16 dan area leading 48 logical pixels, tidak mengikuti skala lebar layar. Pusatkan judul hanya untuk tampilan kamera atau layar khusus yang membutuhkannya.
- Warna merek memakai `AppColors.primary` (#087F75), `primaryLight`, dan `primarySoft`. Hindari warna dekoratif berbeda per jenis data.
- Status dan kategori adalah teks netral (`AppChip` / `PantooUi.metadata`), tanpa latar berwarna. Teks status harus tetap lengkap dan bisa dibaca; jangan menggantungkan makna pada warna. Peringatan validasi, aksi berbahaya, dan prioritas penting boleh memakai warna semantik yang ada.
- Daftar memakai satu kartu putih luar: radius 16, border tipis `AppColors.border`, padding 16. Detail di dalam kartu atau bottom sheet memakai garis pembatas, tanpa kartu membulat bertumpuk. Gunakan komponen `AppRequestCard`, `AppCard`, dan `AppDetailSectionCard`.
- Header daftar: tanggal/judul di kiri, metadata/status di kanan; biarkan teks membungkus dengan aman pada layar kecil.
- Jarak mengikuti kelipatan 4: 8 antarikon/teks, 12 antarisi, 16 antarsection. Kontrol filter minimal 48 tinggi; pilihan aktif mint dengan teks teal, bukan warna pelangi.
- Menu Home memakai aset gambar dari `assets/icons/menu`, satu kartu pembungkus grid. Navbar bawah memakai keluarga ikon yang sama, latar mint untuk tab aktif.
- Masuk/Pulang hanya label dan jam; pemisah horizontal dan vertikal. Jadwal/waktu kerja dan ringkasan presensi memakai slide.
- Pengumuman hanya memakai kartu per item; section tidak dibungkus kartu lagi. Latar geometris merek harus halus agar teks tetap kontras.
- Persetujuan tersedia melalui Pusat Persetujuan; jangan menambah tombol approval pada setiap header. Antrean payroll tetap terpisah.

Nilai bersama ada di `lib/core/themes/pantoo_ui.dart`. Perubahan standar diterapkan di komponen bersama terlebih dahulu agar modul baru mewarisinya.
