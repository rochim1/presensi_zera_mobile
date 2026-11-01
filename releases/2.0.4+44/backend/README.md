# Deploy manual Google login Pantoo HR 2.0.4+44

Paket ini hanya memuat perubahan autentikasi Google dari base production `599b5503`. Perubahan lokal lain (finance, penempatan pegawai, presensi, dan lainnya) tidak disertakan. Tidak ada `.env`, password, client secret, atau private key dalam paket.

## Terapkan patch

Jalankan dari folder backend server, sesuai workflow yang ada: `/www/wwwroot/TOM_SERVER`. Letakkan `pantoo-google-auth.patch` di lokasi yang dapat Anda akses.

```sh
git apply --check /path/pantoo-google-auth.patch
git apply /path/pantoo-google-auth.patch
npm ci --omit=dev
node --check graphql/users/user.resolvers.js
node --test tests/google_login.security.test.js tests/login_credentials.security.test.js tests/google_auth_public_fields.test.js
```

Jika `git apply --check` gagal, cocokkan perubahan server dengan base yang tercantum pada `manifest.json` sebelum menerapkan perubahan. Jangan memaksa patch atau mereset pekerjaan server.

## Konfigurasi server

Atur nilai berikut pada `.env` server tanpa mengubah variabel lainnya:

```dotenv
GOOGLE_CLIENT_ID=941313151223-pbdntkrdmhhqc88vafpte9svfdqv6kf8.apps.googleusercontent.com
```

`ecosystem.config.js` dalam patch juga memasang client ID ini pada environment production PM2. Client secret tidak dipakai untuk verifikasi Google ID token.

```sh
pm2 reload ecosystem.config.js --env production --update-env
pm2 save
node scripts/verify-google-auth-production.cjs
```

Pemeriksaan terakhir memverifikasi query publik dan client ID pada `https://graphql.pantoo.id/`; ini belum menggantikan uji login nyata. Setelah PASS, uji akun Google lama, akun baru dengan nomor telepon/persetujuan, pembatalan login, dan aturan perangkat di APK baru.

## Development

Backend development memakai source yang sama dan client ID Web yang sama. Untuk preview web Flutter gunakan konfigurasi `Dev Web Google (7357)` atau:

```sh
flutter run -d chrome --flavor development --target lib/main_development.dart --web-port 7357
```

Untuk Android development, gunakan package `com.pantoo.presensi.dev` dan sertifikat debug yang didokumentasikan pada `docs/google-sign-in.md`. Base URL pada form login harus mengarah ke backend yang dapat dijangkau perangkat; `localhost` pada ponsel menunjuk ke ponsel itu sendiri.

Status publikasi Google dan client development dicatat pada `docs/google-sign-in.md` setelah konfigurasi Google Cloud selesai. Untuk instalasi Play Store, cocokkan juga SHA-1 App Signing di Play Console.
