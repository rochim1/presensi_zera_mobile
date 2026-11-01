# Build APK/AAB sekaligus web production

Gunakan PowerShell berikut dari root mobile_zera:

```powershell
pwsh -File scripts/build-release.ps1 -Artifact aab
pwsh -File scripts/build-release.ps1 -Artifact apk
pwsh -File scripts/build-release.ps1 -Artifact all
```

Skrip mencadangkan web, menjalankan Flutter clean, mengambil dependensi, membangun web production dan memeriksa kelengkapan serta versinya, lalu membangun Android. Kegagalan web menghentikan build Android dan memulihkan cadangan. Kegagalan Android tetap meninggalkan web terbaru. Tidak ada push, deploy, atau kenaikan versi otomatis.

Aktifkan pengaman commit satu kali per clone:

```powershell
git config core.hooksPath .githooks
```

Pengaman menolak commit bila file inti build web tidak ada di staging, dan menolak push bila commit yang dikirim kehilangan file inti web. Setelah build, sertakan `build/web` bersama perubahan versi pada commit deployment. APK/AAB tetap diabaikan. Hook bukan pengganti build; perintah Flutter manual tetap dapat menghapus output web, sehingga gunakan skrip di atas.
