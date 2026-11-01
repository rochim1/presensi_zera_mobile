# Optimasi gambar mobile Zera — 26 Oktober 2026

34 ikon menu di assets/icons/menu diubah dari 1254 × 1254 menjadi 256 × 256 piksel dengan resampling Lanczos dan encoding PNG lossless. Transparansi RGBA, nama file, serta jalur aset dipertahankan. Ukuran ini masih di atas cache render ikon aplikasi (90–156 piksel).

- Sebelum: 26.989.996 byte.
- Sesudah: 1.308.576 byte.
- Penghematan: 25.681.420 byte (95,15%).
- Perbandingan pada ukuran render 156 piksel, dikompositkan pada latar putih: selisih rata-rata 0,338 dari 255 per kanal; ikon terburuk 0,467.
- Cadangan asli disimpan di luar aset aplikasi: output/mobile-zera-image-compression/2026-10-26/original-menu-icons.zip pada root workspace. Laporan per berkas tersedia pada folder yang sama, report.json.

Gambar dokumentasi assets/docs/SOLID.jpg tidak terdaftar sebagai aset Flutter sehingga tidak memengaruhi ukuran aplikasi. Aset gambar runtime lain jauh lebih kecil; ikon menu merupakan penyumbang gambar terbesar.

APK/AAB yang sudah dibuat sebelumnya tidak diubah. Optimasi masuk pada build aplikasi berikutnya; pengurangan ukuran unduhan akhir bergantung pada kompresi paket dan pemisahan perangkat oleh Play Store.

Validasi Flutter: flutter test test/home_menu_icons_test.dart — 4 pengujian lulus (decoding/transparansi seluruh ikon, grid menu, navbar bawah, dan aksi menu profil).
