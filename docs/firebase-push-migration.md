# Migrasi push notification Pantoo HR

Target: Firebase project `pantoo-511802` (project number `941313151223`).
Status lokal (10 November 2026): Firebase telah ditambahkan ke Google Cloud project,
tanpa Google Analytics. FCM HTTP v1 aktif. Android produksi dan development telah
didaftarkan dan konfigurasi gabungannya dipasang di `android/app/google-services.json`.
Kunci pengirim lokal telah dibuat atas persetujuan pemilik akun. Autentikasi Google
untuk pengirim baru berhasil. APK yang sudah terpasang dan server online belum
otomatis berubah; perlu rollout backend sebelum distribusi APK baru.

## Pengirim backend saat masa migrasi

- `PROJECT_ID` dan kredensial lama tetap melayani token lama.
- `FCM_PROJECT_ID=pantoo-511802` menentukan proyek baru yang diizinkan.
- `FCM_SERVICE_ACCOUNT_FILE=private_storage/firebase/pantoo-511802.json` menunjuk
  file rahasia lokal, dikecualikan dari Git dan berada di luar folder publik.
- Aplikasi mengirim `firebase_project_id` dari Firebase native bersama token.
  Backend menyimpan proyek pada token dan memilih Firebase Admin app sesuai proyek.
  Token tanpa metadata memakai proyek lama. Kredensial baru yang hilang/salah tidak
  dialihkan ke pengirim lama.
- Deploy schema GraphQL, resolver, model token, dan pengirim backend beserta
  pengaturan rahasianya sebelum APK baru digunakan. Jangan menaruh private key
  di aplikasi mobile, repositori, atau chat.
- Payload FCM menyertakan `type_notif` agar aplikasi mengetahui tujuan notifikasi.

## Prosedur konfigurasi ulang

1. Buka Firebase Console, pilih atau tambahkan Firebase ke Google Cloud project
   `pantoo-511802`, lalu buka Project settings > General > Your apps.
2. Daftarkan/pilih Android app `com.pantoo.presensi` untuk produksi dan
   `com.pantoo.presensi.dev` untuk development. Unduh `google-services.json`.
   Simpan unduhan untuk diperiksa terlebih dahulu, sebelum mengganti konfigurasi aktif.
3. Pastikan `project_info.project_id` dan `project_number` sesuai target dan
   `client[].client_info.android_client_info.package_name` sesuai varian.
   Jika file terpisah, gunakan `android/app/src/production/google-services.json`
   dan `android/app/src/development/google-services.json`; bila satu file memuat
   kedua client, konfigurasi bersama dapat berada di `android/app/google-services.json`.
4. Pengirim backend memerlukan akses Firebase Cloud Messaging ke project baru.
   Periksa identitas layanan yang dipakai server serta izin pengiriman; simpan
   kredensial hanya di penyimpanan rahasia/server. Jangan mengirim private key di chat.
5. Pertahankan kedua pengirim selama APK lama masih digunakan. Implementasi
   pemilihan proyek backend sudah disiapkan; jangan mengganti `PROJECT_ID` lama
   menjadi proyek baru jika masih ada token lama.

## Verifikasi sebelum rilis

- Gunakan perangkat/akun pengujian sendiri. Pastikan token baru disimpan backend.
- Periksa penerimaan saat aplikasi aktif, di background, dan tertutup, termasuk
  tujuan halaman setelah mengetuk notifikasi.
- Uji izin ditolak, refresh token, login ulang, serta ganti akun.
- Bangun APK sesuai `AGENTS.md`. Jangan mengubah konfigurasi OAuth Google Sign-In
  atau Maps untuk migrasi push ini.
- Firebase Web memerlukan konfigurasi Web tersendiri; jangan menyalin Android app
  ID ke variabel konfigurasi Firebase Web.

Validasi lokal: 10 tes Flutter registrasi/refresh/izin/cold start lulus; 5 tes Node
pemisahan pengirim dan multicast lulus. Firebase Admin berhasil memuat kunci baru
dan memperoleh access token Google tanpa menampilkannya. Belum mengirim push nyata
ke perangkat; diperlukan APK baru serta akun/perangkat pengujian.
Gradle `processDevelopmentDebugGoogleServices` dan
`processProductionDebugGoogleServices` berhasil. Pemeriksaan Dart analyzer
tidak menghasilkan laporan sebelum dihentikan karena tersendat; tes Flutter
di atas tetap berhasil dikompilasi dan dijalankan.

## Perbaikan aplikasi yang sudah disiapkan

### Ikon notifikasi Android

`android/app/src/main/res/drawable/ic_notif.xml` berisi simbol Pantoo monokrom
dengan latar transparan untuk small icon Android. Lima aset PNG Bimbel lama
dihapus agar tidak menimpa vektor menurut kepadatan layar. Foreground/local
notifications secara eksplisit memakai `ic_notif`; FCM background/terminated
memakai resource yang sama lewat AndroidManifest. Warna aksen `#087F75` dan
channel `pantoo` disamakan. `res/raw/keep.xml` mempertahankan ikon/suara ketika
resource shrinking rilis aktif.

Dua tes kontrak notifikasi Android lulus, termasuk payload plugin foreground dan
default FCM background. Pemrosesan resource development dan production berhasil.
Belum ada verifikasi visual pada perangkat: saat pemeriksaan tidak ada perangkat
atau emulator aktif. APK perlu dibangun/dipasang ulang; pesan FCM yang secara
eksplisit mengirim `android.notification.icon` lain dapat menimpa default aplikasi.

Registrasi token menggantikan token cache yang sudah terisi, mendengarkan refresh,
dan mengurutkan permintaan penyimpanan agar token terbaru tetap terakhir. Penutupan
subscription aman saat izin ditolak. Pesan pembuka aplikasi diperiksa melalui
`getInitialMessage`. Pengujian lokal memakai layanan tiruan, bukan pengiriman FCM nyata.

Referensi: [setup Flutter FCM](https://firebase.google.com/docs/cloud-messaging/flutter/get-started),
[menerima pesan Flutter FCM](https://firebase.google.com/docs/cloud-messaging/flutter/receive-messages).
