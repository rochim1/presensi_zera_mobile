# Google Sign-In — Pantoo HR

## Alur aplikasi

- Halaman Masuk dan Daftar memakai Google Sign-In resmi. Web memakai tombol GIS resmi, Android memakai pemilih akun native.
- Client ID web diambil dari `GetGoogleRegistrationClientId` pada backend yang sedang digunakan. Android mengirim ID token untuk audience client ID web yang sama.
- Pantoo memverifikasi ID token melalui mutation `Login`, `provider: google`. Sesi dan cache login tetap memakai alur login Pantoo yang ada, termasuk aturan perangkat dan organisasi.
- Jika backend mengembalikan `GOOGLE_REGISTRATION_DETAILS_REQUIRED`, tampilkan formulir nomor telepon 8–15 digit dan persetujuan eksplisit. Formulir yang dibatalkan tidak membuat akun.
- Akun baru memakai `primary_product: hrms`, `registration_source: mobile_zera`, kemudian mengikuti pengaturan instansi yang sama dengan pendaftaran biasa.
- Token Google hanya dipegang selama proses login, tidak disimpan ke preference/storage dan tidak dikirim ke Chucker debug inspector.

## Google Cloud

Client Android dan client Web sebagai audience server harus berada pada project Google Cloud yang sama. Konfigurasi baru memakai project `pantoo-511802` / `941313151223`, menggantikan client backend lokal sebelumnya yang memiliki prefix project `657305849206`.

### Konfigurasi baru berhasil dibuat — 25 Oktober 2026

Kedua client berikut telah diverifikasi di daftar Google Cloud Clients. Email dukungan dan kontak developer: `adminpantoo@gmail.com`.

| Jenis | Nama | Client ID |
| --- | --- | --- |
| Android | Pantoo HR Android Production | `941313151223-iuejo9cbeqjknf3mg8tdt2n0gl0me0t7.apps.googleusercontent.com` |
| Web | Pantoo HR Web dan Backend | `941313151223-pbdntkrdmhhqc88vafpte9svfdqv6kf8.apps.googleusercontent.com` |
| Android development | Pantoo HR Android Development | `941313151223-mqqh1t26ve4v709farhp3m9vj7dil2q8.apps.googleusercontent.com` |

- Project: `pantoo-511802` / `941313151223`.
- Identitas aplikasi: Pantoo HR, audience External.
- Origin JavaScript Web: `https://app.pantoo.id` dan `http://localhost:7357`; tidak ada redirect URI karena integrasi memakai ID token GIS/native.
- Client Android memakai package dan SHA-1 production APK lokal pada tabel di bawah.
- `GOOGLE_CLIENT_ID` dalam `.env` backend lokal sudah diperbarui ke **client Web** di atas. Client secret tidak diperlukan untuk verifikasi ID token dan tidak disalin ke aplikasi atau dokumentasi.
- Google OAuth sudah dipublikasikan dan status **In production** dikonfirmasi pada halaman Audience tanggal 25 Oktober 2026. Uji login akun Google nyata belum dilakukan.
- APK production 2.0.4+44 sudah dibangun setelah Flutter clean dan diverifikasi: package `com.pantoo.presensi`, versionCode 44, tanda tangan v2 valid dan SHA-1 sesuai client Android production. Server production akan dideploy manual oleh pemilik; belum diverifikasi sesudah deploy.

Buat atau gunakan kembali OAuth client bertipe **Android** dengan pasangan package dan SHA-1 berikut:

| Build | Package | SHA-1 |
| --- | --- | --- |
| Production APK lokal | `com.pantoo.presensi` | `F4:25:EA:43:B5:74:81:3B:A0:10:45:32:45:E5:07:0C:58:45:96:72` |
| Development debug | `com.pantoo.presensi.dev` | `A3:1E:84:F8:72:9C:B4:EF:3D:E1:3B:71:5E:AE:87:CD:8B:24:0D:E7` |

Client production dan client development debug sudah dibuat dan dikonfirmasi Google Console.

Untuk instalasi dari Google Play, tambahkan client Android dengan package production dan SHA-1 **App signing key certificate** dari Play Console. Sertifikat tersebut dapat berbeda dari APK lokal/upload key.

Web client yang sama perlu mengizinkan origin web tempat aplikasi Flutter dijalankan, termasuk origin localhost untuk pengujian. Jangan menambahkan origin yang tidak digunakan.

`google-services.json` yang ada tidak memuat OAuth clients. Kode memberikan server client ID secara eksplisit; file itu tidak perlu diberi ID atau secret buatan. Registrasi package/SHA-1 tetap diperlukan di Google Cloud.

iOS memerlukan registrasi iOS client dan URL scheme Google tersendiri sebelum diuji di iOS.

## Backend

Deploy backend yang menyediakan `GetGoogleRegistrationClientId`, input Google pada `Login`, serta jalur pendaftaran yang meminta data tambahan. Pastikan `GOOGLE_CLIENT_ID` sudah diisi dengan client ID web dari project yang sama.

Perubahan backend terkait ada pada `graphql/users/user.resolvers.js`: teruskan context request pada login Google yang membuat akun baru dan pertahankan `legal_consent` sampai `CreateUser` mencatat persetujuan.

Pada pemeriksaan 25 Oktober 2026, endpoint production dari `.env.production` mengembalikan `MISDIRECTED_REQUEST` untuk query `GetGoogleRegistrationClientId`. Query tersebut sudah tersedia di source backend lokal; deployment production perlu diverifikasi sebelum uji login nyata.

## Pengujian

- Flutter: `flutter test test/google_login_test.dart test/login_captcha_test.dart`
- Backend: `node --test tests/google_login.security.test.js tests/login_credentials.security.test.js tests/google_auth_public_fields.test.js` — 13 pengujian lulus pada paket backend terisolasi dari base production.
- Uji nyata: akun lama, pembatalan pemilih akun, akun baru tanpa persetujuan, akun baru lengkap, aturan satu perangkat, dan APK yang diinstal dari Play jika digunakan.

Implementasi SDK mengikuti dokumentasi resmi: https://pub.dev/packages/google_sign_in dan https://pub.dev/packages/google_sign_in_android.

## Paket rilis 2.0.4+44

- APK: releases/2.0.4+44/PantooHR-2.0.4-44-production.apk.
- Backend manual: releases/2.0.4+44/PantooHR-backend-google-auth.zip; petunjuk dan patch ada di folder backend.
- Flutter: 7 pengujian login Google/CAPTCHA lulus sebelum clean dan build.
- Origin localhost 7357, client Android development, dan kelengkapan Branding sudah disimpan. Publikasi sudah dikonfirmasi dan status **In production** diverifikasi di Google Console.
- Query publik harus lolos scripts/verify-google-auth-production.cjs setelah deploy sebelum uji login Google nyata.


## Port development tetap

VS Code memakai dart.flutterRunAdditionalArgs pada .vscode/settings.json untuk port 7357; konfigurasi Dev Web Google (7357) menjalankan Chrome. Dari PowerShell gunakan ./run-dev-web.ps1. Skrip berhenti jika port digunakan, tanpa mengganti port atau menghentikan proses lain. Gunakan alamat http://localhost:7357, bukan 127.0.0.1. Backend development localhost:8080/graphql belum dapat dihubungi pada pemeriksaan terakhir; jalankan backend dan periksa query publik sebelum menguji akun Google.


Pemeriksaan endpoint production sesudah publikasi OAuth masih gagal: query konfigurasi Google belum tersedia. Pemilik perlu menerapkan paket backend manual, kemudian menjalankan pemeriksaan ulang dan uji login nyata. Publikasi OAuth tidak menggantikan deploy backend.

