# Pantoo Mobile UI Design & Style Guidelines

Dokumen ini mendefinisikan standar visual dan struktur halaman untuk aplikasi Pantoo Mobile. Gunakan pedoman ini saat merancang halaman baru atau melakukan modifikasi UI agar konsisten di seluruh aplikasi.

---

## 🎨 1. Sistem Warna & Gradasi

### A. Tombol Utama (Action Buttons)
Semua tombol utama/primer harus menggunakan **Linear Gradient** dengan arah `topLeft` ke `bottomRight`.
* **Check In & Default Action**:
  * Warna: `[AppColors.primary, AppColors.secondary]` (Teal ke Lime-Green).
  * Arah: `begin: Alignment.topLeft, end: Alignment.bottomRight`.
  * Shadow: `AppColors.primary` dengan opasitas 40% (`withValues(alpha: 0.4)`), blur radius `12` atau `15`.
* **Check Out & Danger Action**:
  * Warna: `[AppColors.red, AppColors.pink]` (Merah ke Pink).
  * Arah: `begin: Alignment.topLeft, end: Alignment.bottomRight`.
  * Shadow: `AppColors.red` dengan opasitas 40% (`withValues(alpha: 0.4)`).

### B. Input & Fields (Form Unified)
Semua form input (seperti di Halaman Login) harus mengikuti gaya terpadu berikut:
* **Background Field**: Menggunakan warna netral lembut (misalnya `Colors.grey.shade50` atau `AppColors.bgPrimary`).
* **Radius Border**: `24px` atau `16px` (konsisten menggunakan `AppDimens.radiusMediumX` atau `AppDimens.r24` untuk sudut membulat premium).
* **Shadow Field**: Shadow yang sangat tipis/halus agar terlihat melayang (Elevation rendah).
* **Penyajian Error**: Teks error berwarna merah (`AppColors.danger`) yang diletakkan tepat di bawah field dengan padding proporsional.

---

## 📐 2. Layout & Spacing

* **Sistem Margin**: Gunakan sistem kelipatan 8pt (8px, 16px, 24px) untuk padding dan margin luar.
* **Header Halaman Utama**:
  * Selalu gunakan background gambar `geometric_bg.png`.
  * Gunakan bottom sheet model popup (`AppBottomSheet`) untuk bagian dinamis seperti Aktivitas Harian yang menutupi layar dengan efek transisi halus.
* **Sudut Membulat (Corners)**:
  * Gunakan sudut melingkar yang besar (`24px` / `AppDimens.r24`) pada komponen Card, Bottom Sheet, dan Container Utama untuk memberikan kesan modern, premium, dan ramah pengguna.
  * Hindari sudut tajam (`0px` atau `< 12px`).

---

## 🧭 3. Navigasi & Navbar Bottom

* **Tata Letak Tab**:
  1. Index 0: **Home** (`squaresFour`)
  2. Index 1: **Presensi** (`calendarCheck`)
  3. Tengah (Floating Action Button): **Fingerprint Button** (Check In / Check Out)
  4. Index 2: **Kunjungan** (`cardsThree`)
  5. Index 3: **Profile** (`user`)
* **Floating Action Button (FAB) Tengah**:
  * Harus berada di `FloatingActionButtonLocation.centerDocked`.
  * Mengikuti status kehadiran (Check In = Teal/Lime, Check Out = Red/Pink).

---

## 📋 4. Checklist untuk Prompt/AI Developer Selanjutnya
Saat diminta membuat halaman baru:
- [ ] Apakah komponen tombol menggunakan `AppButton` dengan parameter gradient yang sesuai?
- [ ] Apakah textfield yang digunakan sudah memakai `AppTextField` yang terunifikasi dengan style Login?
- [ ] Apakah ukuran margin/padding menggunakan kelipatan 8 (misal `AppDimens.w16`, `AppDimens.h24`)?
- [ ] Apakah semua Card memiliki border radius membulat (`r16` atau `r24`)?
- [ ] Apakah warna background menggunakan warna netral premium (`bgPrimary` / `grey.shade50`)?
