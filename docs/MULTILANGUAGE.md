# Bahasa Pantoo HR

Bahasa aplikasi tersedia dalam Indonesia dan Inggris. Pemilih tersedia di login,
pengenalan aplikasi, pendaftaran, dan Profil → Umum. Perubahan berlaku langsung tanpa login ulang.
Pilihan **Ikuti perangkat** menggunakan Inggris untuk perangkat berbahasa Inggris
dan Indonesia untuk bahasa perangkat lainnya.

Preferensi disimpan secara lokal melalui SharedPreferences dengan key `app_locale`
(`id` atau `en`). Pilihan mengikuti perangkat menghapus key tersebut. Token login
dan data organisasi tidak diubah. Preferensi ini belum disinkronkan antarperangkat.

## Sumber terjemahan

- `lib/l10n/app_id.arb` dan `app_en.arb` adalah sumber terjemahan aplikasi.
- Flutter `gen-l10n` menghasilkan kelas di `lib/l10n/generated/`.
- UI lama menggunakan `HrText` atau `.tr(context)` secara eksplisit melalui
  `hr_translation_lookup.dart`, yang memanggil kelas hasil `gen-l10n`.
- UI baru sebaiknya langsung menggunakan key semantik dari `hrLocale(context)`.
- `supplemental_ui.json` mencatat label pendek tambahan yang ditemukan saat integrasi.

Jangan terjemahkan nama pengguna/organisasi, nama produk, isi chat, catatan pengguna,
kode status API, route, atau nilai yang dikirim ke server. Gunakan `Text` biasa untuk
data tersebut. `HrText` hanya untuk kalimat antarmuka. Pesan server yang belum dikenal
ditampilkan apa adanya; tidak ada penerjemahan otomatis melalui layanan eksternal.

`Masuk` pada presensi berarti **Check In**. Pada login, gunakan
`hrLocale(context).signInAction` (**Sign In**). Mata uang tetap rupiah.
Tanggal yang ditampilkan melalui formatter bersama mengikuti bahasa aplikasi;
format ISO dan parser kontrak data tetap dipertahankan.

## Memperbarui terjemahan

1. Tambahkan key beserta terjemahan dan metadata placeholder pada kedua ARB.
2. Jalankan `flutter gen-l10n` dari folder `mobile_zera`.
3. Bila masih memakai kalimat sumber pada widget lama, jalankan
   `python scripts/build_hr_translation_lookup.py`.
   Script memakai alias kalimat lama di
   `lib/l10n/legacy_ui_aliases.json`.
4. Jalankan pengujian lokal bahasa dan pengujian halaman yang berubah.

Gunakan key terjemahan dengan parameter untuk kalimat baru yang berisi data dinamis.
Jangan menyusun kalimat Inggris dengan menggabungkan fragmen Indonesia. Pertahankan
placeholder, satuan, aturan proses, dan istilah HR yang konsisten.

Script `migrate_ui_localization.dart` adalah alat migrasi satu kali, bukan bagian
dari build. Periksa perubahan secara manual sebelum memakainya lagi.

## Memeriksa kelengkapan

Pemindaian harus mencakup label literal, label bersyarat, getter/switch pembentuk
tampilan, enum, opsi dropdown, validasi, toast, nama bulan, dan waktu relatif.
Gunakan `scripts/audit_ui_localization.dart`, `audit_display_labels.dart`, dan
`check_dynamic_localization.dart` untuk menghasilkan daftar yang perlu ditinjau.
Daftar kandidat mentah bukan jumlah teks yang terlewat: definisi pesan pada bloc
dan label enum boleh tetap berupa bahasa sumber selama penerimanya melokalisasi UI.

Label enum diterjemahkan saat ditampilkan. Jangan mengubah `toKey`, nilai enum,
identitas pilihan, kode status, filter query, maupun isi permintaan server.
Dropdown membedakan label enum dari nama objek dan pilihan teks bebas.
Judul/catatan yang berasal dari pengajuan pengguna tetap memakai `Text` biasa;
hanya label atau fallback antarmukanya yang diterjemahkan.

Waktu relatif memakai key `relative*` dengan ICU plural dan parameter bertipe `int`.
Label tambahan hasil audit ulang dicatat dalam `rescan*_ui.json`; ARB tetap sumber
aktif. Pengujian `hr_localization_rescan_test.dart` memeriksa kedua bahasa,
parameter, label enum, bulan, dan keutuhan data pengguna.

Toast global yang muncul setelah operasi asinkron menggunakan `.trCurrent()` agar
tidak bergantung pada konteks halaman yang mungkin sudah ditutup. Untuk teks
widget yang harus mengikuti pergantian bahasa langsung, gunakan `.tr(context)`
atau key `hrLocale(context)` pada saat widget dibangun.

## Pemeriksaan label pendek — 10 November 2026

Sapaan jam presensi menggunakan `hrAttendanceClockLabel`: Pagi, Siang, Sore, dan
Malam diterjemahkan sebelum dimasukkan ke kalimat jam. Jangan menerjemahkan hanya
kalimat luarnya sementara parameter tampilan masih berbahasa Indonesia.
Ringkasan pengajuan bulanan dan omzet harian memakai metode localization
berparameter; bulan dan nominal dipertahankan sebagai data yang sudah diformat.

Daftar tambahan ada di `lib/l10n/rescan_short_ui.json`. Katalog aktif kini berisi
1.763 kunci per bahasa. Label KPI, profil, pinjaman, stok, catatan pengajuan,
dan komponen label formulir juga diperiksa. Kode API cuti `pagi`/`siang` tetap
dipertahankan; nama pengguna, kategori, dan isi pengajuan tidak diterjemahkan.

Tes `hr_short_labels_test.dart` memeriksa seluruh batas jam, kedua bahasa,
keutuhan parameter, serta pergantian EN → ID pada dashboard 320 dan 360 dp.
Kartu presensi membatasi ruang tombol agar terjemahan yang lebih panjang tetap
terbaca dan tidak meluber.
