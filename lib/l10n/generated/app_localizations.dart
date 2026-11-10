import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_id.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('id'),
  ];

  /// Modul: attendance, consignment, shift. Audit: HR-ID-22E806DF79
  ///
  /// In id, this message translates to:
  /// **' (Hari Ini)'**
  String get hr22e806df79;

  /// Modul: sistem & komponen umum. Audit: HR-ID-7C050D16B5
  ///
  /// In id, this message translates to:
  /// **' Silakan coba lagi nanti!'**
  String get hr7c050d16b5;

  /// Modul: activity. Audit: HR-ID-CEC82D6A29
  ///
  /// In id, this message translates to:
  /// **' · radius {nilai1} m'**
  String hrcec82d6a29(String nilai1);

  /// Modul: delivery. Audit: HR-ID-831F9868F1
  ///
  /// In id, this message translates to:
  /// **'* NOO: Pemesanan pertama kali dari outlet yang belum pernah order sebelumnya.'**
  String get hr831f9868f1;

  /// Modul: delivery. Audit: HR-ID-D44A55837D
  ///
  /// In id, this message translates to:
  /// **'* Repeat Order: Pemesanan ulang rutin sesuai siklus belanja normal outlet.'**
  String get hrd44a55837d;

  /// Modul: delivery. Audit: HR-ID-49D312CD22
  ///
  /// In id, this message translates to:
  /// **'* Top Up: Pemesanan tambahan sisipan di luar jadwal rutin outlet (stok cepat habis).'**
  String get hr49d312cd22;

  /// Modul: leave. Audit: HR-ID-D9A4757F90
  ///
  /// In id, this message translates to:
  /// **'- Hari'**
  String get hrd9a4757f90;

  /// Modul: delivery, order. Audit: HR-ID-A2537CB6F5
  ///
  /// In id, this message translates to:
  /// **'- Rp {nilai1}'**
  String hra2537cb6f5(String nilai1);

  /// Modul: leave. Audit: HR-ID-2B1D32EDAC
  ///
  /// In id, this message translates to:
  /// **'0,5 hari'**
  String get hr2b1d32edac;

  /// Modul: login. Audit: HR-ID-CFF2156D20
  ///
  /// In id, this message translates to:
  /// **'08xxxxxxxxxx'**
  String get hrcff2156d20;

  /// Modul: loan. Audit: HR-ID-ED0A4E4860
  ///
  /// In id, this message translates to:
  /// **'1 Bulan'**
  String get hred0a4e4860;

  /// Modul: loan. Audit: HR-ID-B8D1183F9A
  ///
  /// In id, this message translates to:
  /// **'12 Bulan'**
  String get hrb8d1183f9a;

  /// Modul: loan. Audit: HR-ID-BED063676C
  ///
  /// In id, this message translates to:
  /// **'3 Bulan'**
  String get hrbed063676c;

  /// Modul: loan. Audit: HR-ID-90233A0964
  ///
  /// In id, this message translates to:
  /// **'6 Bulan'**
  String get hr90233a0964;

  /// Modul: intro. Audit: HR-ID-7F0E188B8C
  ///
  /// In id, this message translates to:
  /// **'Absensi Real-time'**
  String get hr7f0e188b8c;

  /// Modul: payroll. Audit: HR-ID-FEAFEB4E2C
  ///
  /// In id, this message translates to:
  /// **'Adjustment (+)'**
  String get hrfeafeb4e2c;

  /// Modul: payroll. Audit: HR-ID-DE5B177E0B
  ///
  /// In id, this message translates to:
  /// **'Adjustment (-)'**
  String get hrde5b177e0b;

  /// Modul: sistem & komponen umum. Audit: HR-ID-9BFAA0CC52
  ///
  /// In id, this message translates to:
  /// **'AED — Dirham UEA'**
  String get hr9bfaa0cc52;

  /// Modul: main. Audit: HR-ID-42683CCC8F
  ///
  /// In id, this message translates to:
  /// **'Agar live tracking tetap berjalan selama sesi kerja, buka pengaturan Pantoo lalu pilih Izin > Lokasi > Izinkan sepanjang waktu.'**
  String get hr42683ccc8f;

  /// Modul: attendance_request, common, leave, overtime, payroll, reimbursement, shift, sistem & komponen umum. Audit: HR-ID-7F1C552399
  ///
  /// In id, this message translates to:
  /// **'Agustus'**
  String get hr7f1c552399;

  /// Modul: overtime. Audit: HR-ID-CB2ED9295B
  ///
  /// In id, this message translates to:
  /// **'Ajukan Lembur'**
  String get hrcb2ed9295b;

  /// Modul: loan. Audit: HR-ID-B9A0D7F421
  ///
  /// In id, this message translates to:
  /// **'Ajukan Pinjaman'**
  String get hrb9a0d7f421;

  /// Modul: reimbursement. Audit: HR-ID-33D56A71F6
  ///
  /// In id, this message translates to:
  /// **'Ajukan Reimbursement'**
  String get hr33d56a71f6;

  /// Modul: attendance_request. Audit: HR-ID-EA34F444C9
  ///
  /// In id, this message translates to:
  /// **'Ajukan Request Presensi'**
  String get hrea34f444c9;

  /// Modul: shift. Audit: HR-ID-CFEE23DADB
  ///
  /// In id, this message translates to:
  /// **'Ajukan Tukar Shift'**
  String get hrcfee23dadb;

  /// Modul: home. Audit: HR-ID-2BA37E1D0B
  ///
  /// In id, this message translates to:
  /// **'Akhiri Lembur'**
  String get hr2ba37e1d0b;

  /// Modul: intro. Audit: HR-ID-A97C94897D
  ///
  /// In id, this message translates to:
  /// **'Akses data di mana saja tanpa hambatan'**
  String get hra97c94897d;

  /// Modul: pesan & model bersama. Audit: HR-ID-8FF51868F6
  ///
  /// In id, this message translates to:
  /// **'Akses kamera ditolak'**
  String get hr8ff51868f6;

  /// Modul: pesan & model bersama. Audit: HR-ID-DD89C4E208
  ///
  /// In id, this message translates to:
  /// **'Akses lokasi ditolak'**
  String get hrdd89c4e208;

  /// Modul: pesan & model bersama. Audit: HR-ID-356D69E765
  ///
  /// In id, this message translates to:
  /// **'Akses lokasi ditolak, silakan buka pengaturan Aplikasi'**
  String get hr356d69e765;

  /// Modul: pesan & model bersama. Audit: HR-ID-F0AF1BBF7B
  ///
  /// In id, this message translates to:
  /// **'Akses penyimpanan ditolak'**
  String get hrf0af1bbf7b;

  /// Modul: pesan & model bersama. Audit: HR-ID-37EA0EA607
  ///
  /// In id, this message translates to:
  /// **'Akses penyimpanan ditolak, silakan buka pengaturan Aplikasi'**
  String get hr37ea0ea607;

  /// Modul: kalender. Audit: HR-ID-8E50E254C4
  ///
  /// In id, this message translates to:
  /// **'Aksi event'**
  String get hr8e50e254c4;

  /// Modul: apotek, home, profile, sistem & komponen umum, survey. Audit: HR-ID-89F29D42AD
  ///
  /// In id, this message translates to:
  /// **'Aktif'**
  String get hr89f29d42ad;

  /// Modul: home. Audit: HR-ID-742B53B70C
  ///
  /// In id, this message translates to:
  /// **'aktif'**
  String get hr742b53b70c;

  /// Modul: announcement. Audit: HR-ID-6AC0D76CDB
  ///
  /// In id, this message translates to:
  /// **'Aktif / Berjalan'**
  String get hr6ac0d76cdb;

  /// Modul: activity. Audit: HR-ID-0393312967
  ///
  /// In id, this message translates to:
  /// **'Aktifkan layanan lokasi untuk memindai kegiatan ini.'**
  String get hr0393312967;

  /// Modul: activity. Audit: HR-ID-73A61A138D
  ///
  /// In id, this message translates to:
  /// **'Aktifkan layanan lokasi untuk presensi kegiatan ini.'**
  String get hr73a61a138d;

  /// Modul: main. Audit: HR-ID-ABDE10DBAA
  ///
  /// In id, this message translates to:
  /// **'Aktifkan lokasi latar belakang'**
  String get hrabde10dbaa;

  /// Modul: activity. Audit: HR-ID-9B38CF5DC1
  ///
  /// In id, this message translates to:
  /// **'Aktifkan presensi QR'**
  String get hr9b38cf5dc1;

  /// Modul: home. Audit: HR-ID-08901D8845
  ///
  /// In id, this message translates to:
  /// **'Aktivitas'**
  String get hr08901d8845;

  /// Modul: kpi. Audit: HR-ID-9B9FB14B99
  ///
  /// In id, this message translates to:
  /// **'Akui Hasil'**
  String get hr9b9fb14b99;

  /// Modul: login. Audit: HR-ID-B6FB56E06D
  ///
  /// In id, this message translates to:
  /// **'Akun belum berhasil dibuat. Silakan periksa data lalu coba lagi.'**
  String get hrb6fb56e06d;

  /// Modul: apotek, profile. Audit: HR-ID-85B6ED5C3B
  ///
  /// In id, this message translates to:
  /// **'Alamat'**
  String get hr85b6ed5c3b;

  /// Modul: pesan & model bersama. Audit: HR-ID-12F493F2D6
  ///
  /// In id, this message translates to:
  /// **'alamat'**
  String get hr12f493f2d6;

  /// Modul: profile. Audit: HR-ID-DAEAFA5507
  ///
  /// In id, this message translates to:
  /// **'Alamat & Domisili'**
  String get hrdaeafa5507;

  /// Modul: delivery. Audit: HR-ID-E4DA436494
  ///
  /// In id, this message translates to:
  /// **'Alamat Kirim'**
  String get hre4da436494;

  /// Modul: profile. Audit: HR-ID-947A4E6DDA
  ///
  /// In id, this message translates to:
  /// **'Alamat KTP'**
  String get hr947a4e6dda;

  /// Modul: delivery. Audit: HR-ID-B9BB8337AD
  ///
  /// In id, this message translates to:
  /// **'Alamat Outlet'**
  String get hrb9bb8337ad;

  /// Modul: pesan & model bersama. Audit: HR-ID-8C1B850B8B
  ///
  /// In id, this message translates to:
  /// **'Alamat server tidak valid'**
  String get hr8c1b850b8b;

  /// Modul: apotek. Audit: HR-ID-310724E771
  ///
  /// In id, this message translates to:
  /// **'Alamat tidak ditemukan'**
  String get hr310724e771;

  /// Modul: sistem & komponen umum. Audit: HR-ID-8700759364
  ///
  /// In id, this message translates to:
  /// **'Alamat tidak ditemukan!'**
  String get hr8700759364;

  /// Modul: attendance. Audit: HR-ID-6D08DB6474
  ///
  /// In id, this message translates to:
  /// **'Alamat tidak tersedia'**
  String get hr6d08db6474;

  /// Modul: attendance_request, delivery, komponen umum, leave, overtime, shift. Audit: HR-ID-3FAA833B08
  ///
  /// In id, this message translates to:
  /// **'Alasan'**
  String get hr3faa833b08;

  /// Modul: pesan & model bersama. Audit: HR-ID-A402CC68ED
  ///
  /// In id, this message translates to:
  /// **'alasan'**
  String get hra402cc68ed;

  /// Modul: leave. Audit: HR-ID-B9539588D6
  ///
  /// In id, this message translates to:
  /// **'Alasan Cuti'**
  String get hrb9539588d6;

  /// Modul: shift. Audit: HR-ID-22304CEA66
  ///
  /// In id, this message translates to:
  /// **'Alasan Dibatalkan'**
  String get hr22304cea66;

  /// Modul: loan, shift. Audit: HR-ID-E72B0473BD
  ///
  /// In id, this message translates to:
  /// **'Alasan Ditolak'**
  String get hre72b0473bd;

  /// Modul: home. Audit: HR-ID-D9BE0E9148
  ///
  /// In id, this message translates to:
  /// **'Alasan Lembur (Opsional)'**
  String get hrd9be0e9148;

  /// Modul: payroll. Audit: HR-ID-D439472A36
  ///
  /// In id, this message translates to:
  /// **'Alasan Pembatalan: {nilai1}'**
  String hrd439472a36(String nilai1);

  /// Modul: payroll. Audit: HR-ID-1A3A88C343
  ///
  /// In id, this message translates to:
  /// **'Alasan penolakan'**
  String get hr1a3a88c343;

  /// Modul: shift. Audit: HR-ID-C5C56B2CEA
  ///
  /// In id, this message translates to:
  /// **'Alasan Penolakan'**
  String get hrc5c56b2cea;

  /// Modul: attendance_request, leave, overtime, reimbursement, shift. Audit: HR-ID-378B777E74
  ///
  /// In id, this message translates to:
  /// **'Alasan Penolakan wajib diisi'**
  String get hr378b777e74;

  /// Modul: payroll. Audit: HR-ID-4C604643E5
  ///
  /// In id, this message translates to:
  /// **'Alasan penolakan wajib diisi'**
  String get hr4c604643e5;

  /// Modul: attendance_request, leave, overtime, reimbursement, shift. Audit: HR-ID-4E5E94C578
  ///
  /// In id, this message translates to:
  /// **'Alasan tidak boleh lebih dari {nilai1} karakter'**
  String hr4e5e94c578(String nilai1);

  /// Modul: shift. Audit: HR-ID-7F86679DE0
  ///
  /// In id, this message translates to:
  /// **'Alasan Tukar'**
  String get hr7f86679de0;

  /// Modul: attendance_request, leave, overtime, shift. Audit: HR-ID-3FE0554C1B
  ///
  /// In id, this message translates to:
  /// **'Alasan wajib diisi'**
  String get hr3fe0554c1b;

  /// Modul: attendance_request, leave, overtime, reimbursement. Audit: HR-ID-018F71F803
  ///
  /// In id, this message translates to:
  /// **'Alasan {nilai1}'**
  String hr018f71f803(String nilai1);

  /// Modul: payroll. Audit: HR-ID-58061AA544
  ///
  /// In id, this message translates to:
  /// **'Alpha'**
  String get hr58061aa544;

  /// Modul: instansi. Audit: HR-ID-C0E257A26F
  ///
  /// In id, this message translates to:
  /// **'Ambil dengan kamera'**
  String get hrc0e257a26f;

  /// Modul: common. Audit: HR-ID-2591F0FBDF
  ///
  /// In id, this message translates to:
  /// **'Ambil foto objek'**
  String get hr2591f0fbdf;

  /// Modul: common. Audit: HR-ID-27E218AE0D
  ///
  /// In id, this message translates to:
  /// **'Ambil Foto Selfie'**
  String get hr27e218ae0d;

  /// Modul: delivery. Audit: HR-ID-4460F3B529
  ///
  /// In id, this message translates to:
  /// **'Anda baru saja membatalkan kunjungan untuk {nilai1}'**
  String hr4460f3b529(String nilai1);

  /// Modul: delivery. Audit: HR-ID-171A22C91C
  ///
  /// In id, this message translates to:
  /// **'Anda berhasil melakukan kunjungan di {nilai1}'**
  String hr171a22c91c(String nilai1);

  /// Modul: apotek. Audit: HR-ID-E4B8ED1728
  ///
  /// In id, this message translates to:
  /// **'Anda berhasil membuat Outlet {nilai1}.'**
  String hre4b8ed1728(String nilai1);

  /// Modul: delivery. Audit: HR-ID-DE523A9798
  ///
  /// In id, this message translates to:
  /// **'Anda berhasil menambahkan kunjungan ke {nilai1}.'**
  String hrde523a9798(String nilai1);

  /// Modul: attendance. Audit: HR-ID-DAB4E39C5F
  ///
  /// In id, this message translates to:
  /// **'Anda dapat melihat presensi tim sesuai izin admin. Ringkasan di bawah adalah presensi Anda.'**
  String get hrdab4e39c5f;

  /// Modul: attendance. Audit: HR-ID-F0487F1C95
  ///
  /// In id, this message translates to:
  /// **'Anda harus mengisi logbook sebelum Check Out.'**
  String get hrf0487f1c95;

  /// Modul: app. Audit: HR-ID-B7E82D88EC
  ///
  /// In id, this message translates to:
  /// **'Anda masih memiliki presensi aktif. Lakukan presensi pulang sebelum memulai lembur.'**
  String get hrb7e82d88ec;

  /// Modul: sistem & komponen umum. Audit: HR-ID-15A86560C2
  ///
  /// In id, this message translates to:
  /// **'Anda menerima pesan baru'**
  String get hr15a86560c2;

  /// Modul: delivery. Audit: HR-ID-C2BFDA1182
  ///
  /// In id, this message translates to:
  /// **'Anda sudah pulang. Tekan tombol \"Mulai Lembur\" di Beranda terlebih dahulu jika ingin membatalkan Kunjungan.'**
  String get hrc2bfda1182;

  /// Modul: delivery. Audit: HR-ID-8DCEFC74CC
  ///
  /// In id, this message translates to:
  /// **'Anda sudah pulang. Tekan tombol \"Mulai Lembur\" di Beranda terlebih dahulu jika ingin membuat Kunjungan tambahan.'**
  String get hr8dcefc74cc;

  /// Modul: delivery. Audit: HR-ID-FDC432535F
  ///
  /// In id, this message translates to:
  /// **'Anda sudah pulang. Tekan tombol \"Mulai Lembur\" di Beranda terlebih dahulu jika ingin mengerjakan Kunjungan.'**
  String get hrfdc432535f;

  /// Modul: kpi. Audit: HR-ID-11879516EF
  ///
  /// In id, this message translates to:
  /// **'Anda tidak memiliki izin untuk melihat KPI.'**
  String get hr11879516ef;

  /// Modul: sistem & komponen umum. Audit: HR-ID-C8A509E40C
  ///
  /// In id, this message translates to:
  /// **'Anda yakin ingin keluar dari aplikasi?'**
  String get hrc8a509e40c;

  /// Modul: approval_center. Audit: HR-ID-0A3BF5C802
  ///
  /// In id, this message translates to:
  /// **'Antrean payroll dipisahkan dari pengajuan harian agar peninjauan periode dan batch tetap fokus.'**
  String get hr0a3bf5c802;

  /// Modul: sistem & komponen umum. Audit: HR-ID-E010B91FE1
  ///
  /// In id, this message translates to:
  /// **'Apakah Anda yakin ingin keluar dari halaman ini?'**
  String get hre010b91fe1;

  /// Modul: delivery. Audit: HR-ID-3C89108C6B
  ///
  /// In id, this message translates to:
  /// **'Apakah kamu sudah di lokasi outlet yang benar saat ini?'**
  String get hr3c89108c6b;

  /// Modul: attendance. Audit: HR-ID-75C2946070
  ///
  /// In id, this message translates to:
  /// **'Apakah kondisi ini berkaitan dengan pekerjaan?'**
  String get hr75c2946070;

  /// Modul: development. Audit: HR-ID-96220C5446
  ///
  /// In id, this message translates to:
  /// **'Api Key'**
  String get hr96220c5446;

  /// Modul: development. Audit: HR-ID-4956012B24
  ///
  /// In id, this message translates to:
  /// **'App Id'**
  String get hr4956012b24;

  /// Modul: development. Audit: HR-ID-4FB43108E7
  ///
  /// In id, this message translates to:
  /// **'App Name'**
  String get hr4fb43108e7;

  /// Modul: development. Audit: HR-ID-055C4CE8BD
  ///
  /// In id, this message translates to:
  /// **'App Version'**
  String get hr055c4ce8bd;

  /// Modul: leave. Audit: HR-ID-99DEE8440A
  ///
  /// In id, this message translates to:
  /// **'Approval Cuti'**
  String get hr99dee8440a;

  /// Modul: attendance_request, leave, overtime, reimbursement, shift. Audit: HR-ID-50E8417185
  ///
  /// In id, this message translates to:
  /// **'Approval gagal diproses, silakan coba lagi'**
  String get hr50e8417185;

  /// Modul: overtime. Audit: HR-ID-1925E5646C
  ///
  /// In id, this message translates to:
  /// **'Approval Lembur'**
  String get hr1925e5646c;

  /// Modul: reimbursement. Audit: HR-ID-1C50C6FA50
  ///
  /// In id, this message translates to:
  /// **'Approval Reimbursement'**
  String get hr1c50c6fa50;

  /// Modul: attendance_request. Audit: HR-ID-52CB835454
  ///
  /// In id, this message translates to:
  /// **'Approval Request Presensi'**
  String get hr52cb835454;

  /// Modul: shift. Audit: HR-ID-C731D86F13
  ///
  /// In id, this message translates to:
  /// **'Approval Tukar Shift'**
  String get hrc731d86f13;

  /// Modul: komponen umum. Audit: HR-ID-F18FC1523C
  ///
  /// In id, this message translates to:
  /// **'Approver'**
  String get hrf18fc1523c;

  /// Modul: attendance_request, common, leave, overtime, payroll, reimbursement, shift, sistem & komponen umum. Audit: HR-ID-A0393902DB
  ///
  /// In id, this message translates to:
  /// **'April'**
  String get hra0393902db;

  /// Modul: activity. Audit: HR-ID-5B2CDFF05C
  ///
  /// In id, this message translates to:
  /// **'Arahkan kamera ke QR karyawan'**
  String get hr5b2cdff05c;

  /// Modul: activity. Audit: HR-ID-BADB83283D
  ///
  /// In id, this message translates to:
  /// **'Arahkan kamera ke QR kegiatan'**
  String get hrbadb83283d;

  /// Modul: apotek. Audit: HR-ID-2745DEBAA6
  ///
  /// In id, this message translates to:
  /// **'Area'**
  String get hr2745debaa6;

  /// Modul: sistem & komponen umum. Audit: HR-ID-64EA47E1A9
  ///
  /// In id, this message translates to:
  /// **'ARS — Peso Argentina'**
  String get hr64ea47e1a9;

  /// Modul: pesan & model bersama. Audit: HR-ID-A41A93A538
  ///
  /// In id, this message translates to:
  /// **'Assignment not found'**
  String get hra41a93a538;

  /// Modul: login. Audit: HR-ID-0F35190A78
  ///
  /// In id, this message translates to:
  /// **'atau dengan email'**
  String get hr0f35190a78;

  /// Modul: sistem & komponen umum. Audit: HR-ID-6FED677EE0
  ///
  /// In id, this message translates to:
  /// **'AUD — Dollar Australia'**
  String get hr6fed677ee0;

  /// Modul: app. Audit: HR-ID-DA1BFA784B
  ///
  /// In id, this message translates to:
  /// **'Auto tutup lembur karena lupa akhiri lembur'**
  String get hrda1bfa784b;

  /// Modul: attendance. Audit: HR-ID-A9EAE40CAA
  ///
  /// In id, this message translates to:
  /// **'Bagaimana perasaanmu setelah bekerja hari ini?'**
  String get hra9eae40caa;

  /// Modul: chat. Audit: HR-ID-4656D25B52
  ///
  /// In id, this message translates to:
  /// **'Balas di thread...'**
  String get hr4656d25b52;

  /// Modul: profile. Audit: HR-ID-A19B1C9644
  ///
  /// In id, this message translates to:
  /// **'Bantuan'**
  String get hra19b1c9644;

  /// Modul: apotek. Audit: HR-ID-CEBD72FB21
  ///
  /// In id, this message translates to:
  /// **'Barang MSL'**
  String get hrcebd72fb21;

  /// Modul: development. Audit: HR-ID-59765745C0
  ///
  /// In id, this message translates to:
  /// **'Base Api'**
  String get hr59765745c0;

  /// Modul: login. Audit: HR-ID-1DBD61F556
  ///
  /// In id, this message translates to:
  /// **'Base URL'**
  String get hr1dbd61f556;

  /// Modul: activity, announcement, attendance_request, dashboard, delivery, global, kalender, kpi, leave, logbook, overtime, payroll, reimbursement. Audit: HR-ID-1433539C3B
  ///
  /// In id, this message translates to:
  /// **'Batal'**
  String get hr1433539c3b;

  /// Modul: delivery. Audit: HR-ID-51851C7D17
  ///
  /// In id, this message translates to:
  /// **'batal'**
  String get hr51851c7d17;

  /// Modul: delivery, shift. Audit: HR-ID-DBE47C83D4
  ///
  /// In id, this message translates to:
  /// **'Batalkan'**
  String get hrdbe47c83d4;

  /// Modul: delivery, global. Audit: HR-ID-2DD2B35B98
  ///
  /// In id, this message translates to:
  /// **'Batalkan Kunjungan'**
  String get hr2dd2b35b98;

  /// Modul: home. Audit: HR-ID-8251C1FFD9
  ///
  /// In id, this message translates to:
  /// **'Batalkan Lembur'**
  String get hr8251c1ffd9;

  /// Modul: home. Audit: HR-ID-FC81515D1C
  ///
  /// In id, this message translates to:
  /// **'Batalkan Lembur?'**
  String get hrfc81515d1c;

  /// Modul: shift. Audit: HR-ID-84B2639E7A
  ///
  /// In id, this message translates to:
  /// **'Batalkan tukar shift?'**
  String get hr84b2639e7a;

  /// Modul: sistem & komponen umum. Audit: HR-ID-8F6C8ADFD3
  ///
  /// In id, this message translates to:
  /// **'BDT — Taka Bangladesh'**
  String get hr8f6c8adfd3;

  /// Modul: development. Audit: HR-ID-1B644F2FC8
  ///
  /// In id, this message translates to:
  /// **'BE Version'**
  String get hr1b644f2fc8;

  /// Modul: home. Audit: HR-ID-A52B6C3AEA
  ///
  /// In id, this message translates to:
  /// **'Belum ada aktivitas'**
  String get hra52b6c3aea;

  /// Modul: dashboard. Audit: HR-ID-E54B21F8DE
  ///
  /// In id, this message translates to:
  /// **'Belum ada data kunjungan bulan ini'**
  String get hre54b21f8de;

  /// Modul: dashboard. Audit: HR-ID-D9A10E3969
  ///
  /// In id, this message translates to:
  /// **'Belum ada data perjalanan'**
  String get hrd9a10e3969;

  /// Modul: attendance. Audit: HR-ID-7C34C8A0C7
  ///
  /// In id, this message translates to:
  /// **'Belum ada data {nilai1}'**
  String hr7c34c8a0c7(String nilai1);

  /// Modul: apotek. Audit: HR-ID-CD92D8C507
  ///
  /// In id, this message translates to:
  /// **'Belum Ada Data {nilai1}'**
  String hrcd92d8c507(String nilai1);

  /// Modul: chat. Audit: HR-ID-50C0B34F91
  ///
  /// In id, this message translates to:
  /// **'Belum ada email'**
  String get hr50c0b34f91;

  /// Modul: approval_center. Audit: HR-ID-A686CE4FD9
  ///
  /// In id, this message translates to:
  /// **'Belum ada jenis persetujuan yang ditugaskan kepada Anda.'**
  String get hra686ce4fd9;

  /// Modul: activity. Audit: HR-ID-B4B93FFB10
  ///
  /// In id, this message translates to:
  /// **'Belum ada kegiatan pada bulan ini.'**
  String get hrb4b93ffb10;

  /// Modul: global. Audit: HR-ID-8463DE9269
  ///
  /// In id, this message translates to:
  /// **'Belum ada Kunjungan hari ini'**
  String get hr8463de9269;

  /// Modul: sistem & komponen umum. Audit: HR-ID-E42E303E51
  ///
  /// In id, this message translates to:
  /// **'Belum ada Kunjungan ini!'**
  String get hre42e303e51;

  /// Modul: global. Audit: HR-ID-1C12372625
  ///
  /// In id, this message translates to:
  /// **'Belum ada kunjungan untuk memulai produktivitas Anda'**
  String get hr1c12372625;

  /// Modul: home. Audit: HR-ID-22BA29BDBA
  ///
  /// In id, this message translates to:
  /// **'Belum ada kunjungan yang dijadwalkan untuk hari ini'**
  String get hr22ba29bdba;

  /// Modul: inventory. Audit: HR-ID-21AA026A48
  ///
  /// In id, this message translates to:
  /// **'Belum Ada Laporan'**
  String get hr21aa026a48;

  /// Modul: logbook. Audit: HR-ID-5FE0565F5D
  ///
  /// In id, this message translates to:
  /// **'Belum ada logbook hari ini'**
  String get hr5fe0565f5d;

  /// Modul: logbook. Audit: HR-ID-8699B86353
  ///
  /// In id, this message translates to:
  /// **'Belum ada logbook karyawan'**
  String get hr8699b86353;

  /// Modul: home. Audit: HR-ID-CFEF54162A
  ///
  /// In id, this message translates to:
  /// **'Belum ada pengajuan bulan ini.'**
  String get hrcfef54162a;

  /// Modul: home. Audit: HR-ID-335CFEEBC2
  ///
  /// In id, this message translates to:
  /// **'Belum ada pengumuman'**
  String get hr335cfeebc2;

  /// Modul: chat. Audit: HR-ID-781A049F2F
  ///
  /// In id, this message translates to:
  /// **'Belum ada percakapan'**
  String get hr781a049f2f;

  /// Modul: chat. Audit: HR-ID-7616EFFF89
  ///
  /// In id, this message translates to:
  /// **'Belum ada pesan'**
  String get hr7616efff89;

  /// Modul: activity. Audit: HR-ID-6F32282E0B
  ///
  /// In id, this message translates to:
  /// **'Belum ada peserta yang tercatat hadir.'**
  String get hr6f32282e0b;

  /// Modul: order. Audit: HR-ID-09D431B764
  ///
  /// In id, this message translates to:
  /// **'Belum ada produk yang dipilih'**
  String get hr09d431b764;

  /// Modul: delivery. Audit: HR-ID-5311556B00
  ///
  /// In id, this message translates to:
  /// **'Belum ada referensi pengantaran (DO) yang ditetapkan admin.'**
  String get hr5311556b00;

  /// Modul: delivery. Audit: HR-ID-255575630E
  ///
  /// In id, this message translates to:
  /// **'Belum ada referensi tagihan yang ditetapkan admin.'**
  String get hr255575630e;

  /// Modul: attendance_request. Audit: HR-ID-09D065A429
  ///
  /// In id, this message translates to:
  /// **'Belum ada riwayat persetujuan.'**
  String get hr09d065a429;

  /// Modul: payroll. Audit: HR-ID-18C05170A0
  ///
  /// In id, this message translates to:
  /// **'Belum ada slip gaji yang diunduh'**
  String get hr18c05170a0;

  /// Modul: dashboard. Audit: HR-ID-0A44EEB8ED
  ///
  /// In id, this message translates to:
  /// **'Belum ada target untuk bulan ini'**
  String get hr0a44eeb8ed;

  /// Modul: home. Audit: HR-ID-0FB44DE65E
  ///
  /// In id, this message translates to:
  /// **'Belum Check In hari ini'**
  String get hr0fb44de65e;

  /// Modul: order. Audit: HR-ID-C1E63FE558
  ///
  /// In id, this message translates to:
  /// **'Belum Lunas'**
  String get hrc1e63fe558;

  /// Modul: sistem & komponen umum. Audit: HR-ID-863CD49891
  ///
  /// In id, this message translates to:
  /// **'Belum Masuk Kerja hari ini!'**
  String get hr863cd49891;

  /// Modul: survey. Audit: HR-ID-08FFC5F4E5
  ///
  /// In id, this message translates to:
  /// **'Belum Mulai'**
  String get hr08ffc5f4e5;

  /// Modul: login. Audit: HR-ID-299FB65023
  ///
  /// In id, this message translates to:
  /// **'Belum punya akun? '**
  String get hr299fb65023;

  /// Modul: announcement, profile. Audit: HR-ID-6E493B3A03
  ///
  /// In id, this message translates to:
  /// **'Berakhir'**
  String get hr6e493b3a03;

  /// Modul: sistem & komponen umum. Audit: HR-ID-6D95148F45
  ///
  /// In id, this message translates to:
  /// **'Berhasil ambil gambar!'**
  String get hr6d95148f45;

  /// Modul: profile. Audit: HR-ID-FC6F802F9F
  ///
  /// In id, this message translates to:
  /// **'Berhasil Ganti Kata Sandi'**
  String get hrfc6f802f9f;

  /// Modul: attendance_request, leave, overtime, reimbursement, shift. Audit: HR-ID-80E203C9E4
  ///
  /// In id, this message translates to:
  /// **'Berhasil membuat approval'**
  String get hr80e203c9e4;

  /// Modul: global. Audit: HR-ID-B0EC1538BF
  ///
  /// In id, this message translates to:
  /// **'Berhasil memperbaharui Aplikasi'**
  String get hrb0ec1538bf;

  /// Modul: home. Audit: HR-ID-13F405298C
  ///
  /// In id, this message translates to:
  /// **'Berhasil mencatat lembur'**
  String get hr13f405298c;

  /// Modul: loan. Audit: HR-ID-7656614086
  ///
  /// In id, this message translates to:
  /// **'Berhasil mengajukan pinjaman'**
  String get hr7656614086;

  /// Modul: reimbursement. Audit: HR-ID-8D620F17E7
  ///
  /// In id, this message translates to:
  /// **'Berhasil mengajukan reimbursement'**
  String get hr8d620f17e7;

  /// Modul: overtime. Audit: HR-ID-8F005E9AE8
  ///
  /// In id, this message translates to:
  /// **'Berhasil mengajukan request lembur'**
  String get hr8f005e9ae8;

  /// Modul: attendance_request. Audit: HR-ID-43547E6C3A
  ///
  /// In id, this message translates to:
  /// **'Berhasil mengajukan request presensi'**
  String get hr43547e6c3a;

  /// Modul: kpi. Audit: HR-ID-C6C890EDFC
  ///
  /// In id, this message translates to:
  /// **'Berhasil mengirim review'**
  String get hrc6c890edfc;

  /// Modul: overtime. Audit: HR-ID-23B0E6078A
  ///
  /// In id, this message translates to:
  /// **'Berhasil mengubah request lembur'**
  String get hr23b0e6078a;

  /// Modul: kpi. Audit: HR-ID-1B9970BF68
  ///
  /// In id, this message translates to:
  /// **'Berhasil menyimpan penilaian'**
  String get hr1b9970bf68;

  /// Modul: development. Audit: HR-ID-C12CBACD71
  ///
  /// In id, this message translates to:
  /// **'Berhasil salin FCM Token'**
  String get hrc12cbacd71;

  /// Modul: development. Audit: HR-ID-3DE3DBB4AA
  ///
  /// In id, this message translates to:
  /// **'Berhasil salin ID user'**
  String get hr3de3dbb4aa;

  /// Modul: development. Audit: HR-ID-F85FDCF17F
  ///
  /// In id, this message translates to:
  /// **'Berhasil salin JWT'**
  String get hrf85fdcf17f;

  /// Modul: delivery. Audit: HR-ID-CAAE69049C
  ///
  /// In id, this message translates to:
  /// **'BERHASIL TERKIRIM'**
  String get hrcaae69049c;

  /// Modul: komponen umum. Audit: HR-ID-136974A8E1
  ///
  /// In id, this message translates to:
  /// **'Berhasil!'**
  String get hr136974a8e1;

  /// Modul: sistem & komponen umum. Audit: HR-ID-FE079DCF26
  ///
  /// In id, this message translates to:
  /// **'BHD — Dinar Bahrain'**
  String get hrfe079dcf26;

  /// Modul: consignment. Audit: HR-ID-DFC2FDECDF
  ///
  /// In id, this message translates to:
  /// **'Biaya Estimasi'**
  String get hrdfc2fdecdf;

  /// Modul: profile. Audit: HR-ID-15D45E3AC3
  ///
  /// In id, this message translates to:
  /// **'Biaya Pajak'**
  String get hr15d45e3ac3;

  /// Modul: profile. Audit: HR-ID-68F6FF6C5D
  ///
  /// In id, this message translates to:
  /// **'biaya pajak'**
  String get hr68f6ff6c5d;

  /// Modul: global. Audit: HR-ID-DA9D849A8C
  ///
  /// In id, this message translates to:
  /// **'Boleh di kosongkan'**
  String get hrda9d849a8c;

  /// Modul: instansi. Audit: HR-ID-A0715D3A79
  ///
  /// In id, this message translates to:
  /// **'Boleh memakai nomor penanggung jawab sementara.'**
  String get hra0715d3a79;

  /// Modul: payroll. Audit: HR-ID-B1E7253AE1
  ///
  /// In id, this message translates to:
  /// **'BPJS JHT'**
  String get hrb1e7253ae1;

  /// Modul: payroll. Audit: HR-ID-AFA6EDA2AA
  ///
  /// In id, this message translates to:
  /// **'BPJS JP'**
  String get hrafa6eda2aa;

  /// Modul: payroll. Audit: HR-ID-C447141B75
  ///
  /// In id, this message translates to:
  /// **'BPJS Kesehatan'**
  String get hrc447141b75;

  /// Modul: sistem & komponen umum. Audit: HR-ID-FD70706EE0
  ///
  /// In id, this message translates to:
  /// **'BRL — Real Brasil'**
  String get hrfd70706ee0;

  /// Modul: sistem & komponen umum. Audit: HR-ID-A926C6A91F
  ///
  /// In id, this message translates to:
  /// **'Browser atau perangkat belum memberi akses kamera. Periksa izin kamera untuk situs/aplikasi ini lalu coba lagi.'**
  String get hra926c6a91f;

  /// Modul: sistem & komponen umum. Audit: HR-ID-FE86390481
  ///
  /// In id, this message translates to:
  /// **'Browser tidak menemukan kamera yang bisa digunakan. Pastikan perangkat memiliki kamera, izin kamera untuk situs ini aktif, dan coba buka halaman langsung di browser melalui HTTPS.'**
  String get hrfe86390481;

  /// Modul: login. Audit: HR-ID-A73F9C464F
  ///
  /// In id, this message translates to:
  /// **'Buat akun dan lanjutkan'**
  String get hra73f9c464f;

  /// Modul: chat. Audit: HR-ID-798FCB004F
  ///
  /// In id, this message translates to:
  /// **'Buat Grup'**
  String get hr798fcb004f;

  /// Modul: chat. Audit: HR-ID-67A663EC0B
  ///
  /// In id, this message translates to:
  /// **'Buat Grup Baru'**
  String get hr67a663ec0b;

  /// Modul: instansi. Audit: HR-ID-480FE21129
  ///
  /// In id, this message translates to:
  /// **'Buat instansi atau organisasi untuk melanjutkan'**
  String get hr480fe21129;

  /// Modul: inventory. Audit: HR-ID-950A6C6C64
  ///
  /// In id, this message translates to:
  /// **'Buat Laporan'**
  String get hr950a6c6c64;

  /// Modul: inventory. Audit: HR-ID-1DE611100F
  ///
  /// In id, this message translates to:
  /// **'Buat Laporan Insiden'**
  String get hr1de611100f;

  /// Modul: apotek. Audit: HR-ID-352EB14903
  ///
  /// In id, this message translates to:
  /// **'Buat Order (Taking Order)'**
  String get hr352eb14903;

  /// Modul: order. Audit: HR-ID-66404B5AAE
  ///
  /// In id, this message translates to:
  /// **'Buat Order Sekarang'**
  String get hr66404b5aae;

  /// Modul: attendance_request, leave, overtime, reimbursement. Audit: HR-ID-7B416B8CD5
  ///
  /// In id, this message translates to:
  /// **'Buat Request'**
  String get hr7b416b8cd5;

  /// Modul: approval_center. Audit: HR-ID-53814037F8
  ///
  /// In id, this message translates to:
  /// **'Buka batch, periode, dan rincian payroll'**
  String get hr53814037f8;

  /// Modul: global. Audit: HR-ID-6373A941A0
  ///
  /// In id, this message translates to:
  /// **'Buka di Google Maps'**
  String get hr6373a941a0;

  /// Modul: home. Audit: HR-ID-BA7F0C5D3D
  ///
  /// In id, this message translates to:
  /// **'Buka Logbook Harian'**
  String get hrba7f0c5d3d;

  /// Modul: global. Audit: HR-ID-40862E5092
  ///
  /// In id, this message translates to:
  /// **'Buka PDF di tab baru'**
  String get hr40862e5092;

  /// Modul: main. Audit: HR-ID-AE9FDE4E84
  ///
  /// In id, this message translates to:
  /// **'Buka Pengaturan'**
  String get hrae9fde4e84;

  /// Modul: activity. Audit: HR-ID-DFBB555375
  ///
  /// In id, this message translates to:
  /// **'Buka presensi'**
  String get hrdfbb555375;

  /// Modul: logbook. Audit: HR-ID-5F5A3C2F57
  ///
  /// In id, this message translates to:
  /// **'Buka Riwayat Logbook Karyawan'**
  String get hr5f5a3c2f57;

  /// Modul: attendance. Audit: HR-ID-9A03D2A29B
  ///
  /// In id, this message translates to:
  /// **'Buka Tautan File'**
  String get hr9a03d2a29b;

  /// Modul: delivery. Audit: HR-ID-8186146941
  ///
  /// In id, this message translates to:
  /// **'Bukti Kunjungan'**
  String get hr8186146941;

  /// Modul: reimbursement. Audit: HR-ID-B519ABAF52
  ///
  /// In id, this message translates to:
  /// **'Bukti Pembayaran'**
  String get hrb519abaf52;

  /// Modul: reimbursement. Audit: HR-ID-1DD635B9DD
  ///
  /// In id, this message translates to:
  /// **'Bukti Pembayaran wajib diisi'**
  String get hr1dd635b9dd;

  /// Modul: attendance_request, home, leave, overtime. Audit: HR-ID-918B0C20A4
  ///
  /// In id, this message translates to:
  /// **'Bukti Pendukung'**
  String get hr918b0c20a4;

  /// Modul: attendance. Audit: HR-ID-ED78E30228
  ///
  /// In id, this message translates to:
  /// **'Bukti pendukung (Wajib)'**
  String get hred78e30228;

  /// Modul: home, leave, overtime. Audit: HR-ID-993A7B1FF3
  ///
  /// In id, this message translates to:
  /// **'Bukti pendukung wajib diunggah'**
  String get hr993a7b1ff3;

  /// Modul: attendance. Audit: HR-ID-56775D1123
  ///
  /// In id, this message translates to:
  /// **'Bukti pendukung wajib diunggah sesuai pengaturan admin'**
  String get hr56775d1123;

  /// Modul: komponen umum, leave, payroll, shift. Audit: HR-ID-A72FDA5A26
  ///
  /// In id, this message translates to:
  /// **'Bulan'**
  String get hra72fda5a26;

  /// Modul: pesan & model bersama. Audit: HR-ID-763D72F8AA
  ///
  /// In id, this message translates to:
  /// **'bulan'**
  String get hr763d72f8aa;

  /// Modul: attendance, attendance_request, komponen umum, leave, overtime, payroll, reimbursement. Audit: HR-ID-3002EC0752
  ///
  /// In id, this message translates to:
  /// **'Bulan Ini'**
  String get hr3002ec0752;

  /// Modul: sistem & komponen umum. Audit: HR-ID-C535065B05
  ///
  /// In id, this message translates to:
  /// **'CAD — Dollar Kanada'**
  String get hrc535065b05;

  /// Modul: pesan & model bersama. Audit: HR-ID-AA4EAE1307
  ///
  /// In id, this message translates to:
  /// **'Cannot convert {nilai1} to double'**
  String hraa4eae1307(String nilai1);

  /// Modul: delivery, order. Audit: HR-ID-938A181550
  ///
  /// In id, this message translates to:
  /// **'CANVAS (JUAL LANGSUNG)'**
  String get hr938a181550;

  /// Modul: apotek. Audit: HR-ID-9A3012D934
  ///
  /// In id, this message translates to:
  /// **'Cari kabupaten/kota...'**
  String get hr9a3012d934;

  /// Modul: inventory. Audit: HR-ID-B3F63360C7
  ///
  /// In id, this message translates to:
  /// **'Cari nama atau SKU produk...'**
  String get hrb3f63360c7;

  /// Modul: attendance. Audit: HR-ID-59D8DEB323
  ///
  /// In id, this message translates to:
  /// **'Cari Nama Pegawai'**
  String get hr59d8deb323;

  /// Modul: delivery. Audit: HR-ID-15A89FF305
  ///
  /// In id, this message translates to:
  /// **'Cari No. DO / No. Order...'**
  String get hr15a89ff305;

  /// Modul: apotek. Audit: HR-ID-D0B02C6D19
  ///
  /// In id, this message translates to:
  /// **'Cari outlet...'**
  String get hrd0b02c6d19;

  /// Modul: chat. Audit: HR-ID-3F82446438
  ///
  /// In id, this message translates to:
  /// **'Cari Pengguna'**
  String get hr3f82446438;

  /// Modul: chat. Audit: HR-ID-A8ED55ADE8
  ///
  /// In id, this message translates to:
  /// **'Cari pesan...'**
  String get hra8ed55ade8;

  /// Modul: instansi. Audit: HR-ID-9613CCDF85
  ///
  /// In id, this message translates to:
  /// **'Cari pilihan...'**
  String get hr9613ccdf85;

  /// Modul: inventory. Audit: HR-ID-4590A78877
  ///
  /// In id, this message translates to:
  /// **'Cari produk atau SKU...'**
  String get hr4590a78877;

  /// Modul: delivery. Audit: HR-ID-95F7887B56
  ///
  /// In id, this message translates to:
  /// **'Cari produk/SKU...'**
  String get hr95f7887b56;

  /// Modul: apotek. Audit: HR-ID-45D4A3DF08
  ///
  /// In id, this message translates to:
  /// **'Cari provinsi...'**
  String get hr45d4a3df08;

  /// Modul: global. Audit: HR-ID-4D8130DA4E
  ///
  /// In id, this message translates to:
  /// **'Cari sesuatu...'**
  String get hr4d8130da4e;

  /// Modul: komponen umum. Audit: HR-ID-447D335AA8
  ///
  /// In id, this message translates to:
  /// **'Cari...'**
  String get hr447d335aa8;

  /// Modul: delivery, order. Audit: HR-ID-BA47E40A30
  ///
  /// In id, this message translates to:
  /// **'Cash / Lunas'**
  String get hrba47e40a30;

  /// Modul: delivery, order. Audit: HR-ID-03E452BA1A
  ///
  /// In id, this message translates to:
  /// **'Cash On Delivery (COD)'**
  String get hr03e452ba1a;

  /// Modul: intro. Audit: HR-ID-E88266A96C
  ///
  /// In id, this message translates to:
  /// **'Catat kehadiran dengan GPS akurat'**
  String get hre88266a96c;

  /// Modul: attendance, delivery, komponen umum, payroll. Audit: HR-ID-9F09AEFD0D
  ///
  /// In id, this message translates to:
  /// **'Catatan'**
  String get hr9f09aefd0d;

  /// Modul: attendance, kpi. Audit: HR-ID-BE4647E972
  ///
  /// In id, this message translates to:
  /// **'Catatan (Opsional)'**
  String get hrbe4647e972;

  /// Modul: payroll. Audit: HR-ID-4D40BD22AE
  ///
  /// In id, this message translates to:
  /// **'Catatan (opsional)'**
  String get hr4d40bd22ae;

  /// Modul: order. Audit: HR-ID-B6E0E39441
  ///
  /// In id, this message translates to:
  /// **'Catatan Order'**
  String get hrb6e0e39441;

  /// Modul: kpi. Audit: HR-ID-3800FE95FB
  ///
  /// In id, this message translates to:
  /// **'Catatan Review (Opsional)'**
  String get hr3800fe95fb;

  /// Modul: reimbursement. Audit: HR-ID-AAB3E9BD88
  ///
  /// In id, this message translates to:
  /// **'Catatan Tambahan'**
  String get hraab3e9bd88;

  /// Modul: inventory. Audit: HR-ID-D0A1AE9B0F
  ///
  /// In id, this message translates to:
  /// **'Catatan tambahan...'**
  String get hrd0a1ae9b0f;

  /// Modul: attendance, reimbursement. Audit: HR-ID-6FBEEEDFE8
  ///
  /// In id, this message translates to:
  /// **'Catatan tidak boleh lebih dari {nilai1} karakter'**
  String hr6fbeeedfe8(String nilai1);

  /// Modul: home. Audit: HR-ID-8F9D08B034
  ///
  /// In id, this message translates to:
  /// **'Cek pengumuman terbaru dari perusahaanmu'**
  String get hr8f9d08b034;

  /// Modul: profile. Audit: HR-ID-F56B0FB8F4
  ///
  /// In id, this message translates to:
  /// **'Chat langsung dengan tim customer service'**
  String get hrf56b0fb8f4;

  /// Modul: attendance, shift. Audit: HR-ID-D37A6B7F44
  ///
  /// In id, this message translates to:
  /// **'Check In'**
  String get hrd37a6b7f44;

  /// Modul: attendance, shift. Audit: HR-ID-8749989281
  ///
  /// In id, this message translates to:
  /// **'Check Out'**
  String get hr8749989281;

  /// Modul: attendance. Audit: HR-ID-04264FEF1B
  ///
  /// In id, this message translates to:
  /// **'Checkout disimpan offline dan akan dikirim otomatis'**
  String get hr04264fef1b;

  /// Modul: intro. Audit: HR-ID-738CFFF2AE
  ///
  /// In id, this message translates to:
  /// **'Checkpoint Pengantaran'**
  String get hr738cfff2ae;

  /// Modul: sistem & komponen umum. Audit: HR-ID-8DD3B22A87
  ///
  /// In id, this message translates to:
  /// **'CHF — Franc Swiss'**
  String get hr8dd3b22a87;

  /// Modul: loan. Audit: HR-ID-B40F2FE69E
  ///
  /// In id, this message translates to:
  /// **'Cicilan ke-{nilai1}'**
  String hrb40f2fe69e(String nilai1);

  /// Modul: loan. Audit: HR-ID-6F00543364
  ///
  /// In id, this message translates to:
  /// **'Cicilan/Bulan'**
  String get hr6f00543364;

  /// Modul: sistem & komponen umum. Audit: HR-ID-5B2C7AE942
  ///
  /// In id, this message translates to:
  /// **'CLP — Peso Chile'**
  String get hr5b2c7ae942;

  /// Modul: sistem & komponen umum. Audit: HR-ID-A9C47FD213
  ///
  /// In id, this message translates to:
  /// **'CNY — Yuan Tiongkok'**
  String get hra9c47fd213;

  /// Modul: login. Audit: HR-ID-00108ED7C1
  ///
  /// In id, this message translates to:
  /// **'Coba hubungkan Google'**
  String get hr00108ed7c1;

  /// Modul: activity, approval_center, home, sistem & komponen umum. Audit: HR-ID-3A4D28A11E
  ///
  /// In id, this message translates to:
  /// **'Coba lagi'**
  String get hr3a4d28a11e;

  /// Modul: home, kpi, logbook, payroll, van_stock. Audit: HR-ID-4D65E89014
  ///
  /// In id, this message translates to:
  /// **'Coba Lagi'**
  String get hr4d65e89014;

  /// Modul: delivery. Audit: HR-ID-9016BF9B5B
  ///
  /// In id, this message translates to:
  /// **'Coba Lagi Order'**
  String get hr9016bf9b5b;

  /// Modul: pesan & model bersama. Audit: HR-ID-26AD1F4CD4
  ///
  /// In id, this message translates to:
  /// **'Connect to Internet'**
  String get hr26ad1f4cd4;

  /// Modul: logbook. Audit: HR-ID-A91AFA11D1
  ///
  /// In id, this message translates to:
  /// **'Contoh: Meeting'**
  String get hra91afa11d1;

  /// Modul: logbook. Audit: HR-ID-FB44996F86
  ///
  /// In id, this message translates to:
  /// **'Contoh: Menyusun laporan'**
  String get hrfb44996f86;

  /// Modul: instansi. Audit: HR-ID-0617813777
  ///
  /// In id, this message translates to:
  /// **'Contoh: pendidikan, layanan sosial, atau perdagangan.'**
  String get hr0617813777;

  /// Modul: sistem & komponen umum. Audit: HR-ID-37D60C8026
  ///
  /// In id, this message translates to:
  /// **'COP — Peso Kolombia'**
  String get hr37d60c8026;

  /// Modul: home, leave, payroll. Audit: HR-ID-7D69C0CDB6
  ///
  /// In id, this message translates to:
  /// **'Cuti'**
  String get hr7d69c0cdb6;

  /// Modul: leave, pesan & model bersama. Audit: HR-ID-320012BA17
  ///
  /// In id, this message translates to:
  /// **'cuti'**
  String get hr320012ba17;

  /// Modul: approval_center, home. Audit: HR-ID-5BFC4FEE1C
  ///
  /// In id, this message translates to:
  /// **'Cuti & izin'**
  String get hr5bfc4fee1c;

  /// Modul: attendance. Audit: HR-ID-42A8BF2B76
  ///
  /// In id, this message translates to:
  /// **'Cuti / Izin'**
  String get hr42a8bf2b76;

  /// Modul: kalender. Audit: HR-ID-979D3C61DA
  ///
  /// In id, this message translates to:
  /// **'Cuti Bersama'**
  String get hr979d3c61da;

  /// Modul: sistem & komponen umum. Audit: HR-ID-3ECDD47B81
  ///
  /// In id, this message translates to:
  /// **'Cuti untuk hari ini!'**
  String get hr3ecdd47b81;

  /// Modul: intro. Audit: HR-ID-CC9C81B2CF
  ///
  /// In id, this message translates to:
  /// **'Cuti, izin, dan shift dalam satu aplikasi'**
  String get hrcc9c81b2cf;

  /// Modul: sistem & komponen umum. Audit: HR-ID-01CEB55406
  ///
  /// In id, this message translates to:
  /// **'CZK — Koruna Ceko'**
  String get hr01ceb55406;

  /// Modul: login. Audit: HR-ID-22212AA89D
  ///
  /// In id, this message translates to:
  /// **'Daftar'**
  String get hr22212aa89d;

  /// Modul: attendance. Audit: HR-ID-DB84989A23
  ///
  /// In id, this message translates to:
  /// **'Daftar Aktivitas'**
  String get hrdb84989a23;

  /// Modul: login. Audit: HR-ID-9CBC1186E3
  ///
  /// In id, this message translates to:
  /// **'Daftar Akun'**
  String get hr9cbc1186e3;

  /// Modul: login. Audit: HR-ID-AC0D9505CF
  ///
  /// In id, this message translates to:
  /// **'Daftar Akun Baru'**
  String get hrac0d9505cf;

  /// Modul: login. Audit: HR-ID-FF8630DD37
  ///
  /// In id, this message translates to:
  /// **'Daftar di sini'**
  String get hrff8630dd37;

  /// Modul: profile. Audit: HR-ID-857B7E34DA
  ///
  /// In id, this message translates to:
  /// **'Daftar kendaraan yang terdaftar untuk perjalanan dinas'**
  String get hr857b7e34da;

  /// Modul: kpi. Audit: HR-ID-87E08FE469
  ///
  /// In id, this message translates to:
  /// **'Daftar KPI Tim'**
  String get hr87e08fe469;

  /// Modul: apotek. Audit: HR-ID-677AAD4139
  ///
  /// In id, this message translates to:
  /// **'Daftar Outlet'**
  String get hr677aad4139;

  /// Modul: order. Audit: HR-ID-FB8EE25720
  ///
  /// In id, this message translates to:
  /// **'Daftar Piutang Outlet'**
  String get hrfb8ee25720;

  /// Modul: consignment, shift. Audit: HR-ID-B7170C9650
  ///
  /// In id, this message translates to:
  /// **'Dari'**
  String get hrb7170c9650;

  /// Modul: dashboard. Audit: HR-ID-1958204121
  ///
  /// In id, this message translates to:
  /// **'dari {nilai1}'**
  String hr1958204121(String nilai1);

  /// Modul: profile. Audit: HR-ID-7A316E3E00
  ///
  /// In id, this message translates to:
  /// **'Dasar Hukum'**
  String get hr7a316e3e00;

  /// Modul: sistem & komponen umum. Audit: HR-ID-14FA1E786A
  ///
  /// In id, this message translates to:
  /// **'Data akun atau presensi belum dapat dimuat. Periksa koneksi lalu coba lagi.'**
  String get hr14fa1e786a;

  /// Modul: intro. Audit: HR-ID-2DCE4A230E
  ///
  /// In id, this message translates to:
  /// **'Data Aman'**
  String get hr2dce4a230e;

  /// Modul: home. Audit: HR-ID-DD70498C8C
  ///
  /// In id, this message translates to:
  /// **'Data Belum Tersinkronisasi'**
  String get hrdd70498c8c;

  /// Modul: pesan & model bersama. Audit: HR-ID-01DD902097
  ///
  /// In id, this message translates to:
  /// **'Data berhasil di hapus'**
  String get hr01dd902097;

  /// Modul: pesan & model bersama. Audit: HR-ID-EFF8F09EAD
  ///
  /// In id, this message translates to:
  /// **'Data berhasil di tambahkan'**
  String get hreff8f09ead;

  /// Modul: pesan & model bersama. Audit: HR-ID-24916AFBA7
  ///
  /// In id, this message translates to:
  /// **'Data berhasil di ubah'**
  String get hr24916afba7;

  /// Modul: delivery. Audit: HR-ID-A6F0C22B65
  ///
  /// In id, this message translates to:
  /// **'Data DO ({nilai1}) tidak ditemukan di daftar server. Memerlukan sinkronisasi ulang.'**
  String hra6f0c22b65(String nilai1);

  /// Modul: pesan & model bersama. Audit: HR-ID-C7FD248451
  ///
  /// In id, this message translates to:
  /// **'Data gagal ditambahkan'**
  String get hrc7fd248451;

  /// Modul: pesan & model bersama. Audit: HR-ID-2F2357E7A4
  ///
  /// In id, this message translates to:
  /// **'Data Inventaris Kosong'**
  String get hr2f2357e7a4;

  /// Modul: pesan & model bersama. Audit: HR-ID-0F612856D6
  ///
  /// In id, this message translates to:
  /// **'Data is null'**
  String get hr0f612856d6;

  /// Modul: profile. Audit: HR-ID-5F5B54FECD
  ///
  /// In id, this message translates to:
  /// **'Data kendaraan berhasil diperbarui'**
  String get hr5f5b54fecd;

  /// Modul: pesan & model bersama. Audit: HR-ID-132272999C
  ///
  /// In id, this message translates to:
  /// **'Data kendaraan gagal diperbarui'**
  String get hr132272999c;

  /// Modul: delivery. Audit: HR-ID-2B6CC702C2
  ///
  /// In id, this message translates to:
  /// **'Data Kunjungan'**
  String get hr2b6cc702c2;

  /// Modul: inventory. Audit: HR-ID-8CCA3B91ED
  ///
  /// In id, this message translates to:
  /// **'Data laporan insidental masih kosong.'**
  String get hr8cca3b91ed;

  /// Modul: apotek. Audit: HR-ID-38D3489D86
  ///
  /// In id, this message translates to:
  /// **'Data Outlet tidak ditemukan'**
  String get hr38d3489d86;

  /// Modul: app. Audit: HR-ID-D2D8126E50
  ///
  /// In id, this message translates to:
  /// **'Data pengguna tidak ditemukan'**
  String get hrd2d8126e50;

  /// Modul: delivery. Audit: HR-ID-3E1FDCC554
  ///
  /// In id, this message translates to:
  /// **'Data tagihan tidak ditemukan. Memerlukan sinkronisasi ulang dengan admin.'**
  String get hr3e1fdcc554;

  /// Modul: pesan & model bersama. Audit: HR-ID-1FE15261C1
  ///
  /// In id, this message translates to:
  /// **'Data tersimpan, tetapi upload bukti lembur tidak terkonfirmasi.'**
  String get hr1fe15261c1;

  /// Modul: pesan & model bersama. Audit: HR-ID-07551E42DC
  ///
  /// In id, this message translates to:
  /// **'Data tersimpan, tetapi upload bukti pembayaran tidak terkonfirmasi.'**
  String get hr07551e42dc;

  /// Modul: pesan & model bersama. Audit: HR-ID-8A42F38448
  ///
  /// In id, this message translates to:
  /// **'Data tersimpan, tetapi upload bukti presensi tidak terkonfirmasi.'**
  String get hr8a42f38448;

  /// Modul: pesan & model bersama. Audit: HR-ID-DE25754BE0
  ///
  /// In id, this message translates to:
  /// **'Data tersimpan, tetapi upload dokumen cuti tidak terkonfirmasi.'**
  String get hrde25754be0;

  /// Modul: pesan & model bersama. Audit: HR-ID-2EE88949CE
  ///
  /// In id, this message translates to:
  /// **'Data tidak berhasil diperbaharui, Silakan hubungi Tim Pengembang'**
  String get hr2ee88949ce;

  /// Modul: pesan & model bersama. Audit: HR-ID-A7D5538E2C
  ///
  /// In id, this message translates to:
  /// **'Data tidak ditemukan'**
  String get hra7d5538e2c;

  /// Modul: logbook. Audit: HR-ID-CBD14F2EF5
  ///
  /// In id, this message translates to:
  /// **'Data yang dihapus tidak dapat dikembalikan.'**
  String get hrcbd14f2ef5;

  /// Modul: apotek. Audit: HR-ID-23DEBB504A
  ///
  /// In id, this message translates to:
  /// **'Data {nilai1} saat ini belum tersedia untuk diakses dari aplikasi mobile.'**
  String hr23debb504a(String nilai1);

  /// Modul: sistem & komponen umum. Audit: HR-ID-4258A0D25D
  ///
  /// In id, this message translates to:
  /// **'Data {par0} duplikat!'**
  String hr4258a0d25d(String par0);

  /// Modul: development. Audit: HR-ID-BD604D99E7
  ///
  /// In id, this message translates to:
  /// **'Debug'**
  String get hrbd604d99e7;

  /// Modul: leave. Audit: HR-ID-0657F1B4B7
  ///
  /// In id, this message translates to:
  /// **'Delegasikan Tugas Kepada'**
  String get hr0657f1b4b7;

  /// Modul: login. Audit: HR-ID-302FF330B2
  ///
  /// In id, this message translates to:
  /// **'Dengan mendaftar, Anda memahami '**
  String get hr302ff330b2;

  /// Modul: attendance_request, common, leave, overtime, payroll, reimbursement, shift, sistem & komponen umum. Audit: HR-ID-7D0ACB5D79
  ///
  /// In id, this message translates to:
  /// **'Desember'**
  String get hr7d0acb5d79;

  /// Modul: kalender, reimbursement. Audit: HR-ID-7E9FD19219
  ///
  /// In id, this message translates to:
  /// **'Deskripsi'**
  String get hr7e9fd19219;

  /// Modul: logbook. Audit: HR-ID-9946F4F18C
  ///
  /// In id, this message translates to:
  /// **'Deskripsi (Opsional)'**
  String get hr9946f4f18c;

  /// Modul: logbook. Audit: HR-ID-CAE6DEE62B
  ///
  /// In id, this message translates to:
  /// **'Deskripsi *'**
  String get hrcae6dee62b;

  /// Modul: chat. Audit: HR-ID-989241B71E
  ///
  /// In id, this message translates to:
  /// **'Deskripsi Grup (Opsional)'**
  String get hr989241b71e;

  /// Modul: reimbursement. Audit: HR-ID-AF68F53883
  ///
  /// In id, this message translates to:
  /// **'Deskripsi tidak boleh lebih dari {nilai1} karakter'**
  String hraf68f53883(String nilai1);

  /// Modul: logbook. Audit: HR-ID-1247E227F3
  ///
  /// In id, this message translates to:
  /// **'Deskripsi tugas wajib diisi'**
  String get hr1247e227f3;

  /// Modul: reimbursement. Audit: HR-ID-1156B129CD
  ///
  /// In id, this message translates to:
  /// **'Deskripsi wajib diisi'**
  String get hr1156b129cd;

  /// Modul: kpi. Audit: HR-ID-7C9A7C0610
  ///
  /// In id, this message translates to:
  /// **'Detail'**
  String get hr7c9a7c0610;

  /// Modul: apotek. Audit: HR-ID-2D27781F45
  ///
  /// In id, this message translates to:
  /// **'Detail Alamat'**
  String get hr2d27781f45;

  /// Modul: leave. Audit: HR-ID-777B87A514
  ///
  /// In id, this message translates to:
  /// **'Detail Cuti'**
  String get hr777b87a514;

  /// Modul: delivery. Audit: HR-ID-D0A8582785
  ///
  /// In id, this message translates to:
  /// **'Detail Harian'**
  String get hrd0a8582785;

  /// Modul: profile. Audit: HR-ID-1049363C5C
  ///
  /// In id, this message translates to:
  /// **'Detail Instansi/Organisasi'**
  String get hr1049363c5c;

  /// Modul: activity. Audit: HR-ID-5D6606072B
  ///
  /// In id, this message translates to:
  /// **'Detail Kegiatan'**
  String get hr5d6606072b;

  /// Modul: delivery. Audit: HR-ID-8D297799CE
  ///
  /// In id, this message translates to:
  /// **'Detail Kunjungan'**
  String get hr8d297799ce;

  /// Modul: overtime. Audit: HR-ID-C4347B332C
  ///
  /// In id, this message translates to:
  /// **'Detail Lembur'**
  String get hrc4347b332c;

  /// Modul: apotek. Audit: HR-ID-3069498A9B
  ///
  /// In id, this message translates to:
  /// **'Detail Outlet'**
  String get hr3069498a9b;

  /// Modul: logbook. Audit: HR-ID-93964CFFC3
  ///
  /// In id, this message translates to:
  /// **'Detail pekerjaan...'**
  String get hr93964cffc3;

  /// Modul: delivery. Audit: HR-ID-D67ACCC306
  ///
  /// In id, this message translates to:
  /// **'Detail Pembatalan'**
  String get hrd67accc306;

  /// Modul: profile. Audit: HR-ID-C72C63EF47
  ///
  /// In id, this message translates to:
  /// **'Detail Perusahaan'**
  String get hrc72c63ef47;

  /// Modul: chat. Audit: HR-ID-0D4011C9A4
  ///
  /// In id, this message translates to:
  /// **'Detail Pesan Internal'**
  String get hr0d4011c9a4;

  /// Modul: loan. Audit: HR-ID-F7B9BC8854
  ///
  /// In id, this message translates to:
  /// **'Detail Pinjaman'**
  String get hrf7b9bc8854;

  /// Modul: attendance. Audit: HR-ID-A5F62AF8FA
  ///
  /// In id, this message translates to:
  /// **'Detail Presensi'**
  String get hra5f62af8fa;

  /// Modul: reimbursement. Audit: HR-ID-30E04B65F1
  ///
  /// In id, this message translates to:
  /// **'Detail Reimbursement'**
  String get hr30e04b65f1;

  /// Modul: attendance_request. Audit: HR-ID-FFC17C7C1D
  ///
  /// In id, this message translates to:
  /// **'Detail Request'**
  String get hrffc17c7c1d;

  /// Modul: attendance_request. Audit: HR-ID-CD2AB1B262
  ///
  /// In id, this message translates to:
  /// **'Detail Request Presensi'**
  String get hrcd2ab1b262;

  /// Modul: shift. Audit: HR-ID-8ADB8E7F0A
  ///
  /// In id, this message translates to:
  /// **'Detail Shift'**
  String get hr8adb8e7f0a;

  /// Modul: payroll. Audit: HR-ID-C3201344D4
  ///
  /// In id, this message translates to:
  /// **'Detail Slip Gaji'**
  String get hrc3201344d4;

  /// Modul: delivery. Audit: HR-ID-7E3A13D998
  ///
  /// In id, this message translates to:
  /// **'Detail Surat Jalan (DO)'**
  String get hr7e3a13d998;

  /// Modul: delivery. Audit: HR-ID-FA212AEC3E
  ///
  /// In id, this message translates to:
  /// **'Detail Tagihan'**
  String get hrfa212aec3e;

  /// Modul: delivery. Audit: HR-ID-40AD9C9C6C
  ///
  /// In id, this message translates to:
  /// **'Detail termin tidak tersedia pada sistem saat ini. Harap konfirmasi dengan admin.'**
  String get hr40ad9c9c6c;

  /// Modul: shift. Audit: HR-ID-4F539A7E9A
  ///
  /// In id, this message translates to:
  /// **'Detail Tukar Shift'**
  String get hr4f539a7e9a;

  /// Modul: common. Audit: HR-ID-DD1B988951
  ///
  /// In id, this message translates to:
  /// **'Deteksi wajah Web belum siap. Periksa koneksi lalu coba lagi.'**
  String get hrdd1b988951;

  /// Modul: development. Audit: HR-ID-197304FE94
  ///
  /// In id, this message translates to:
  /// **'Dev Information'**
  String get hr197304fe94;

  /// Modul: apotek. Audit: HR-ID-27A97E79D4
  ///
  /// In id, this message translates to:
  /// **'Dibuat Oleh'**
  String get hr27a97e79d4;

  /// Modul: attendance_request, reimbursement, shift. Audit: HR-ID-C5B4092DCF
  ///
  /// In id, this message translates to:
  /// **'DIBUAT PADA: {nilai1}'**
  String hrc5b4092dcf(String nilai1);

  /// Modul: delivery. Audit: HR-ID-7EA78F63B1
  ///
  /// In id, this message translates to:
  /// **'Dikerjakan oleh {nilai1}'**
  String hr7ea78f63b1(String nilai1);

  /// Modul: activity. Audit: HR-ID-B82D50DB4E
  ///
  /// In id, this message translates to:
  /// **'Diperbarui dalam {nilai1} detik'**
  String hrb82d50db4e(String nilai1);

  /// Modul: home, leave, sistem & komponen umum. Audit: HR-ID-8C5B409273
  ///
  /// In id, this message translates to:
  /// **'Disetujui'**
  String get hr8c5b409273;

  /// Modul: delivery, order. Audit: HR-ID-6CC10ED567
  ///
  /// In id, this message translates to:
  /// **'Diskon'**
  String get hr6cc10ed567;

  /// Modul: delivery, order. Audit: HR-ID-BFDF46B918
  ///
  /// In id, this message translates to:
  /// **'Diskon (Rp)'**
  String get hrbfdf46b918;

  /// Modul: apotek. Audit: HR-ID-79031DB6DE
  ///
  /// In id, this message translates to:
  /// **'Ditambahkan Oleh'**
  String get hr79031db6de;

  /// Modul: sistem & komponen umum. Audit: HR-ID-A6D38A6F93
  ///
  /// In id, this message translates to:
  /// **'Ditampilkan saat pelacakan lokasi sesi kerja aktif.'**
  String get hra6d38a6f93;

  /// Modul: home, leave, sistem & komponen umum. Audit: HR-ID-C4397F065A
  ///
  /// In id, this message translates to:
  /// **'Ditolak'**
  String get hrc4397f065a;

  /// Modul: delivery, home, overtime, reimbursement. Audit: HR-ID-68A0BA81EC
  ///
  /// In id, this message translates to:
  /// **'ditolak'**
  String get hr68a0ba81ec;

  /// Modul: reimbursement, shift. Audit: HR-ID-91AFCC1A24
  ///
  /// In id, this message translates to:
  /// **'DIUPDATE PADA: {nilai1}'**
  String hr91afcc1a24(String nilai1);

  /// Modul: profile. Audit: HR-ID-BC584DCD70
  ///
  /// In id, this message translates to:
  /// **'Divisi'**
  String get hrbc584dcd70;

  /// Modul: sistem & komponen umum. Audit: HR-ID-8A8ABC514B
  ///
  /// In id, this message translates to:
  /// **'DKK — Krone Denmark'**
  String get hr8a8abc514b;

  /// Modul: sistem & komponen umum. Audit: HR-ID-BD1E7AAFE4
  ///
  /// In id, this message translates to:
  /// **'Dokumen tidak dapat dibaca. Silakan pilih ulang file.'**
  String get hrbd1e7aafe4;

  /// Modul: delivery. Audit: HR-ID-D3F38F9213
  ///
  /// In id, this message translates to:
  /// **'Driver / Kendaraan'**
  String get hrd3f38f9213;

  /// Modul: leave, logbook. Audit: HR-ID-B7D4C20C85
  ///
  /// In id, this message translates to:
  /// **'Durasi'**
  String get hrb7d4c20c85;

  /// Modul: shift. Audit: HR-ID-D9206BD134
  ///
  /// In id, this message translates to:
  /// **'Durasi Istirahat'**
  String get hrd9206bd134;

  /// Modul: attendance, shift. Audit: HR-ID-24DCA39876
  ///
  /// In id, this message translates to:
  /// **'Durasi Kerja'**
  String get hr24dca39876;

  /// Modul: development. Audit: HR-ID-1370004DA7
  ///
  /// In id, this message translates to:
  /// **'Duration'**
  String get hr1370004da7;

  /// Modul: pesan & model bersama. Audit: HR-ID-A5145D929A
  ///
  /// In id, this message translates to:
  /// **'E002 Timeout: {nilai1}'**
  String hra5145d929a(String nilai1);

  /// Modul: pesan & model bersama. Audit: HR-ID-6866A6F39F
  ///
  /// In id, this message translates to:
  /// **'E005 Unknown Link Exception: {nilai1}'**
  String hr6866a6f39f(String nilai1);

  /// Modul: pesan & model bersama. Audit: HR-ID-81DD1CF0B4
  ///
  /// In id, this message translates to:
  /// **'E010 HandshakeException: {nilai1}'**
  String hr81dd1cf0b4(String nilai1);

  /// Modul: activity, announcement, attendance_request, leave, logbook, overtime, reimbursement, shift. Audit: HR-ID-5301648DCF
  ///
  /// In id, this message translates to:
  /// **'Edit'**
  String get hr5301648dcf;

  /// Modul: delivery. Audit: HR-ID-1D685A1E24
  ///
  /// In id, this message translates to:
  /// **'Edit Harga Manual'**
  String get hr1d685a1e24;

  /// Modul: sistem & komponen umum. Audit: HR-ID-050EED2184
  ///
  /// In id, this message translates to:
  /// **'EGP — Pound Mesir'**
  String get hr050eed2184;

  /// Modul: login, profile. Audit: HR-ID-84ADD5B295
  ///
  /// In id, this message translates to:
  /// **'Email'**
  String get hr84add5b295;

  /// Modul: instansi. Audit: HR-ID-7EFF2D8E52
  ///
  /// In id, this message translates to:
  /// **'Email Instansi/Organisasi'**
  String get hr7eff2d8e52;

  /// Modul: instansi. Audit: HR-ID-750461409B
  ///
  /// In id, this message translates to:
  /// **'Email kontak aktif. Boleh memakai email pendaftar sementara.'**
  String get hr750461409b;

  /// Modul: login. Audit: HR-ID-87C3B49741
  ///
  /// In id, this message translates to:
  /// **'Email sudah digunakan'**
  String get hr87c3b49741;

  /// Modul: login. Audit: HR-ID-5C9FBA8B32
  ///
  /// In id, this message translates to:
  /// **'Email tersedia'**
  String get hr5c9fba8b32;

  /// Modul: login, sistem & komponen umum. Audit: HR-ID-D026A79FF2
  ///
  /// In id, this message translates to:
  /// **'Email tidak valid'**
  String get hrd026a79ff2;

  /// Modul: sistem & komponen umum. Audit: HR-ID-474F179FA8
  ///
  /// In id, this message translates to:
  /// **'Email wajib diisi'**
  String get hr474f179fa8;

  /// Modul: login. Audit: HR-ID-9395988394
  ///
  /// In id, this message translates to:
  /// **'email@example.com'**
  String get hr9395988394;

  /// Modul: development. Audit: HR-ID-D443A11855
  ///
  /// In id, this message translates to:
  /// **'Environment'**
  String get hrd443a11855;

  /// Modul: global. Audit: HR-ID-7F2F6A15CF
  ///
  /// In id, this message translates to:
  /// **'Error'**
  String get hr7f2f6a15cf;

  /// Modul: pesan & model bersama. Audit: HR-ID-4DF0768534
  ///
  /// In id, this message translates to:
  /// **'Error while getting contacts '**
  String get hr4df0768534;

  /// Modul: dashboard. Audit: HR-ID-7A7DF91A84
  ///
  /// In id, this message translates to:
  /// **'Estimasi Biaya Transportasi'**
  String get hr7a7df91a84;

  /// Modul: sistem & komponen umum. Audit: HR-ID-01A0952713
  ///
  /// In id, this message translates to:
  /// **'EUR — Euro'**
  String get hr01a0952713;

  /// Modul: kalender. Audit: HR-ID-007E53289F
  ///
  /// In id, this message translates to:
  /// **'Event \"{nilai1}\" akan dihapus.'**
  String hr007e53289f(String nilai1);

  /// Modul: kalender. Audit: HR-ID-FC48C53153
  ///
  /// In id, this message translates to:
  /// **'Event berhasil dihapus'**
  String get hrfc48c53153;

  /// Modul: kalender. Audit: HR-ID-DB49E6A2B6
  ///
  /// In id, this message translates to:
  /// **'Event berhasil diperbarui'**
  String get hrdb49e6a2b6;

  /// Modul: kalender. Audit: HR-ID-7D5DEBEE1C
  ///
  /// In id, this message translates to:
  /// **'Event berhasil ditambahkan'**
  String get hr7d5debee1c;

  /// Modul: kalender. Audit: HR-ID-56736500E6
  ///
  /// In id, this message translates to:
  /// **'Event Berulang'**
  String get hr56736500e6;

  /// Modul: pesan & model bersama. Audit: HR-ID-4A473F03C4
  ///
  /// In id, this message translates to:
  /// **'Failed to create loan'**
  String get hr4a473f03c4;

  /// Modul: sistem & komponen umum. Audit: HR-ID-3308AF32B6
  ///
  /// In id, this message translates to:
  /// **'Failed to get address'**
  String get hr3308af32b6;

  /// Modul: development. Audit: HR-ID-09B28AEB8D
  ///
  /// In id, this message translates to:
  /// **'FCM Token'**
  String get hr09b28aeb8d;

  /// Modul: attendance_request, common, leave, overtime, payroll, reimbursement, shift, sistem & komponen umum. Audit: HR-ID-FFD23111DB
  ///
  /// In id, this message translates to:
  /// **'Februari'**
  String get hrffd23111db;

  /// Modul: payroll. Audit: HR-ID-943C963714
  ///
  /// In id, this message translates to:
  /// **'File PDF tidak ditemukan'**
  String get hr943c963714;

  /// Modul: delivery. Audit: HR-ID-BDF8875DF9
  ///
  /// In id, this message translates to:
  /// **'File Pendukung'**
  String get hrbdf8875df9;

  /// Modul: pesan & model bersama. Audit: HR-ID-370C680B73
  ///
  /// In id, this message translates to:
  /// **'File tidak bisa dibuka'**
  String get hr370c680b73;

  /// Modul: pesan & model bersama. Audit: HR-ID-17D7FEBEB9
  ///
  /// In id, this message translates to:
  /// **'File tidak ditemukan'**
  String get hr17d7febeb9;

  /// Modul: leave. Audit: HR-ID-D8E022192B
  ///
  /// In id, this message translates to:
  /// **'Filter Cuti'**
  String get hrd8e022192b;

  /// Modul: overtime. Audit: HR-ID-59F3EDD0C6
  ///
  /// In id, this message translates to:
  /// **'Filter Lembur'**
  String get hr59f3edd0c6;

  /// Modul: attendance. Audit: HR-ID-544A3E527B
  ///
  /// In id, this message translates to:
  /// **'Filter Presensi'**
  String get hr544a3e527b;

  /// Modul: attendance. Audit: HR-ID-B807822FBD
  ///
  /// In id, this message translates to:
  /// **'Filter presensi lainnya'**
  String get hrb807822fbd;

  /// Modul: attendance_request. Audit: HR-ID-D377AC5C4D
  ///
  /// In id, this message translates to:
  /// **'Filter Request Presensi'**
  String get hrd377ac5c4d;

  /// Modul: payroll. Audit: HR-ID-395608917D
  ///
  /// In id, this message translates to:
  /// **'Filter Slip Gaji'**
  String get hr395608917d;

  /// Modul: intro. Audit: HR-ID-B90729451A
  ///
  /// In id, this message translates to:
  /// **'Fitur manajemen order untuk tim sales'**
  String get hrb90729451a;

  /// Modul: instansi. Audit: HR-ID-6B03993CCB
  ///
  /// In id, this message translates to:
  /// **'Format email tidak valid'**
  String get hr6b03993ccb;

  /// Modul: attendance, attendance_request, leave, overtime, reimbursement. Audit: HR-ID-3A3466A6DF
  ///
  /// In id, this message translates to:
  /// **'Format file harus: {nilai1}'**
  String hr3a3466a6df(String nilai1);

  /// Modul: leave. Audit: HR-ID-31205A7B65
  ///
  /// In id, this message translates to:
  /// **'Format kontak tidak valid'**
  String get hr31205a7b65;

  /// Modul: delivery. Audit: HR-ID-E6B2C8A52A
  ///
  /// In id, this message translates to:
  /// **'Foto Bukti'**
  String get hre6b2c8a52a;

  /// Modul: common. Audit: HR-ID-91E21CB19C
  ///
  /// In id, this message translates to:
  /// **'Foto Dokumen'**
  String get hr91e21cb19c;

  /// Modul: attendance. Audit: HR-ID-011C8B9B19
  ///
  /// In id, this message translates to:
  /// **'Foto gagal diproses, silakan coba lagi'**
  String get hr011c8b9b19;

  /// Modul: attendance. Audit: HR-ID-BF8586C682
  ///
  /// In id, this message translates to:
  /// **'Foto Pendukung'**
  String get hrbf8586c682;

  /// Modul: delivery. Audit: HR-ID-DE6195C87D
  ///
  /// In id, this message translates to:
  /// **'Foto Pendukung / Nota'**
  String get hrde6195c87d;

  /// Modul: delivery. Audit: HR-ID-1DFFB3CC96
  ///
  /// In id, this message translates to:
  /// **'Foto Plakat Lokasi'**
  String get hr1dffb3cc96;

  /// Modul: attendance. Audit: HR-ID-240B243120
  ///
  /// In id, this message translates to:
  /// **'Foto Presensi'**
  String get hr240b243120;

  /// Modul: attendance. Audit: HR-ID-D713EBF6DD
  ///
  /// In id, this message translates to:
  /// **'Foto Selfie wajib diambil'**
  String get hrd713ebf6dd;

  /// Modul: delivery. Audit: HR-ID-F93FE69910
  ///
  /// In id, this message translates to:
  /// **'Foto Stample'**
  String get hrf93fe69910;

  /// Modul: home. Audit: HR-ID-224BC6B911
  ///
  /// In id, this message translates to:
  /// **'Gagal'**
  String get hr224bc6b911;

  /// Modul: delivery. Audit: HR-ID-160439AE86
  ///
  /// In id, this message translates to:
  /// **'GAGAL (TOKO TUTUP / DITOLAK)'**
  String get hr160439ae86;

  /// Modul: sistem & komponen umum. Audit: HR-ID-EFE1FBCC48
  ///
  /// In id, this message translates to:
  /// **'Gagal ambil gambar!'**
  String get hrefe1fbcc48;

  /// Modul: shift. Audit: HR-ID-C2A3DE2632
  ///
  /// In id, this message translates to:
  /// **'Gagal membatalkan'**
  String get hrc2a3de2632;

  /// Modul: app. Audit: HR-ID-F23B3F233B
  ///
  /// In id, this message translates to:
  /// **'Gagal membatalkan lembur. Silakan coba lagi.'**
  String get hrf23b3f233b;

  /// Modul: attendance_request, leave, overtime, reimbursement, shift. Audit: HR-ID-42C0CB1F6C
  ///
  /// In id, this message translates to:
  /// **'Gagal membuat approval: {nilai1}'**
  String hr42c0cb1f6c(String nilai1);

  /// Modul: chat. Audit: HR-ID-F60AFAA7AC
  ///
  /// In id, this message translates to:
  /// **'Gagal membuat grup'**
  String get hrf60afaa7ac;

  /// Modul: instansi. Audit: HR-ID-2150A28434
  ///
  /// In id, this message translates to:
  /// **'Gagal membuat instansi: {nilai1}'**
  String hr2150a28434(String nilai1);

  /// Modul: global. Audit: HR-ID-9A4DC0379E
  ///
  /// In id, this message translates to:
  /// **'Gagal membuka Google Maps'**
  String get hr9a4dc0379e;

  /// Modul: attendance. Audit: HR-ID-B2D363CC9A
  ///
  /// In id, this message translates to:
  /// **'Gagal memuat alamat ({nilai1}, {nilai2})'**
  String hrb2d363cc9a(String nilai1, String nilai2);

  /// Modul: pesan & model bersama. Audit: HR-ID-CAA944A2D0
  ///
  /// In id, this message translates to:
  /// **'Gagal memuat data offline: {nilai1}'**
  String hrcaa944a2d0(String nilai1);

  /// Modul: apotek. Audit: HR-ID-8BA04029F0
  ///
  /// In id, this message translates to:
  /// **'Gagal memuat data outlet'**
  String get hr8ba04029f0;

  /// Modul: dashboard. Audit: HR-ID-544317F574
  ///
  /// In id, this message translates to:
  /// **'Gagal memuat data:\n{nilai1}'**
  String hr544317f574(String nilai1);

  /// Modul: logbook. Audit: HR-ID-C382E229F7
  ///
  /// In id, this message translates to:
  /// **'Gagal memuat detail logbook'**
  String get hrc382e229f7;

  /// Modul: shift. Audit: HR-ID-4ACB9BB0E8
  ///
  /// In id, this message translates to:
  /// **'Gagal memuat jadwal shift: {nilai1}'**
  String hr4acb9bb0e8(String nilai1);

  /// Modul: inventory. Audit: HR-ID-DA152DD5BD
  ///
  /// In id, this message translates to:
  /// **'Gagal memuat katalog'**
  String get hrda152dd5bd;

  /// Modul: logbook. Audit: HR-ID-6C3C94F0AF
  ///
  /// In id, this message translates to:
  /// **'Gagal memuat kategori logbook'**
  String get hr6c3c94f0af;

  /// Modul: activity. Audit: HR-ID-4D8043837A
  ///
  /// In id, this message translates to:
  /// **'Gagal memuat kehadiran: {nilai1}'**
  String hr4d8043837a(String nilai1);

  /// Modul: chat. Audit: HR-ID-DCF9610BA6
  ///
  /// In id, this message translates to:
  /// **'Gagal memuat pengguna'**
  String get hrdcf9610ba6;

  /// Modul: delivery, inventory. Audit: HR-ID-2301ACB824
  ///
  /// In id, this message translates to:
  /// **'Gagal memuat produk'**
  String get hr2301acb824;

  /// Modul: attendance. Audit: HR-ID-BFD07FEE43
  ///
  /// In id, this message translates to:
  /// **'Gagal memuat statistik'**
  String get hrbfd07fee43;

  /// Modul: delivery. Audit: HR-ID-122F1AF2F6
  ///
  /// In id, this message translates to:
  /// **'Gagal memuat tagihan'**
  String get hr122f1af2f6;

  /// Modul: van_stock. Audit: HR-ID-061DE2AE2E
  ///
  /// In id, this message translates to:
  /// **'Gagal memuat Van Stock: {message}'**
  String hr061de2ae2e(String message);

  /// Modul: home. Audit: HR-ID-016C373C1B
  ///
  /// In id, this message translates to:
  /// **'Gagal Memulai Istirahat'**
  String get hr016c373c1b;

  /// Modul: app. Audit: HR-ID-99105432BE
  ///
  /// In id, this message translates to:
  /// **'Gagal memulai lembur. Silakan coba lagi.'**
  String get hr99105432be;

  /// Modul: kalender. Audit: HR-ID-8D219AD012
  ///
  /// In id, this message translates to:
  /// **'Gagal menambahkan event: {nilai1}'**
  String hr8d219ad012(String nilai1);

  /// Modul: logbook. Audit: HR-ID-53DD9EA096
  ///
  /// In id, this message translates to:
  /// **'Gagal menambahkan kategori logbook: {nilai1}'**
  String hr53dd9ea096(String nilai1);

  /// Modul: announcement. Audit: HR-ID-1D631030F7
  ///
  /// In id, this message translates to:
  /// **'Gagal menambahkan pengumuman: {nilai1}'**
  String hr1d631030f7(String nilai1);

  /// Modul: pesan & model bersama. Audit: HR-ID-79B1576581
  ///
  /// In id, this message translates to:
  /// **'Gagal mencatat pembayaran'**
  String get hr79b1576581;

  /// Modul: payroll. Audit: HR-ID-B4EC9B4AB1
  ///
  /// In id, this message translates to:
  /// **'Gagal mendapatkan direktori penyimpanan'**
  String get hrb4ec9b4ab1;

  /// Modul: sistem & komponen umum. Audit: HR-ID-E775A9F99E
  ///
  /// In id, this message translates to:
  /// **'Gagal mendapatkan lokasi dari browser'**
  String get hre775a9f99e;

  /// Modul: global. Audit: HR-ID-0000D8F6D1
  ///
  /// In id, this message translates to:
  /// **'Gagal mendapatkan lokasi. Pastikan GPS aktif.'**
  String get hr0000d8f6d1;

  /// Modul: global. Audit: HR-ID-6DFF1C0ABC
  ///
  /// In id, this message translates to:
  /// **'Gagal mendapatkan lokasi: {message}'**
  String hr6dff1c0abc(String message);

  /// Modul: attendance_request. Audit: HR-ID-FACCAA290A
  ///
  /// In id, this message translates to:
  /// **'Gagal mengajukan request presensi: {nilai1}'**
  String hrfaccaa290a(String nilai1);

  /// Modul: attendance_request, leave, reimbursement. Audit: HR-ID-1C04C45378
  ///
  /// In id, this message translates to:
  /// **'Gagal menghapus'**
  String get hr1c04c45378;

  /// Modul: kalender. Audit: HR-ID-9B7F77FBD0
  ///
  /// In id, this message translates to:
  /// **'Gagal menghapus event: {nilai1}'**
  String hr9b7f77fbd0(String nilai1);

  /// Modul: announcement. Audit: HR-ID-2B9E190528
  ///
  /// In id, this message translates to:
  /// **'Gagal menghapus pengumuman: {nilai1}'**
  String hr2b9e190528(String nilai1);

  /// Modul: delivery. Audit: HR-ID-E2277DC7D4
  ///
  /// In id, this message translates to:
  /// **'Gagal mengirim pengajuan'**
  String get hre2277dc7d4;

  /// Modul: shift. Audit: HR-ID-4AFE9330C7
  ///
  /// In id, this message translates to:
  /// **'Gagal mengirim request tukar shift: {nilai1}'**
  String hr4afe9330c7(String nilai1);

  /// Modul: home. Audit: HR-ID-7D81A0A954
  ///
  /// In id, this message translates to:
  /// **'Gagal Menyelesaikan Istirahat'**
  String get hr7d81a0a954;

  /// Modul: app. Audit: HR-ID-D00F1AFBF9
  ///
  /// In id, this message translates to:
  /// **'Gagal menyimpan lembur. Silakan coba lagi.'**
  String get hrd00f1afbf9;

  /// Modul: pesan & model bersama. Audit: HR-ID-87FB4127A6
  ///
  /// In id, this message translates to:
  /// **'Gagal menyimpan order offline: {nilai1}'**
  String hr87fb4127a6(String nilai1);

  /// Modul: overtime. Audit: HR-ID-521F0B1BCA
  ///
  /// In id, this message translates to:
  /// **'Gagal menyimpan request lembur: {nilai1}'**
  String hr521f0b1bca(String nilai1);

  /// Modul: pesan & model bersama. Audit: HR-ID-5EE790C0C9
  ///
  /// In id, this message translates to:
  /// **'Gagal terhubung ke server'**
  String get hr5ee790c0c9;

  /// Modul: komponen umum. Audit: HR-ID-F3C0F6D239
  ///
  /// In id, this message translates to:
  /// **'Gagal, coba lagi'**
  String get hrf3c0f6d239;

  /// Modul: leave, reimbursement. Audit: HR-ID-C9F3197036
  ///
  /// In id, this message translates to:
  /// **'Gagal: {nilai1}'**
  String hrc9f3197036(String nilai1);

  /// Modul: home. Audit: HR-ID-78F77057E5
  ///
  /// In id, this message translates to:
  /// **'Gaji'**
  String get hr78f77057e5;

  /// Modul: payroll. Audit: HR-ID-E7F81F712A
  ///
  /// In id, this message translates to:
  /// **'Gaji Bersih (Take Home Pay)'**
  String get hre7f81f712a;

  /// Modul: payroll. Audit: HR-ID-099FCEBFB6
  ///
  /// In id, this message translates to:
  /// **'Gaji Bersih: {nilai1}'**
  String hr099fcebfb6(String nilai1);

  /// Modul: payroll. Audit: HR-ID-0009F45FC5
  ///
  /// In id, this message translates to:
  /// **'Gaji Pokok'**
  String get hr0009f45fc5;

  /// Modul: global. Audit: HR-ID-55FF234628
  ///
  /// In id, this message translates to:
  /// **'Galeri'**
  String get hr55ff234628;

  /// Modul: pesan & model bersama. Audit: HR-ID-D8BA7DD945
  ///
  /// In id, this message translates to:
  /// **'Gambar berhasil diganti'**
  String get hrd8ba7dd945;

  /// Modul: pesan & model bersama. Audit: HR-ID-D5ABF66F25
  ///
  /// In id, this message translates to:
  /// **'Gambar berhasil hapus'**
  String get hrd5abf66f25;

  /// Modul: login. Audit: HR-ID-23E2E47741
  ///
  /// In id, this message translates to:
  /// **'Gambar CAPTCHA tidak dapat ditampilkan. Coba login kembali.'**
  String get hr23e2e47741;

  /// Modul: pesan & model bersama. Audit: HR-ID-7DC1B03BDE
  ///
  /// In id, this message translates to:
  /// **'Gambar gagal dihapus'**
  String get hr7dc1b03bde;

  /// Modul: pesan & model bersama. Audit: HR-ID-A7315ABCF8
  ///
  /// In id, this message translates to:
  /// **'Ganti gambar dibatalkan'**
  String get hra7315abcf8;

  /// Modul: sistem & komponen umum. Audit: HR-ID-D21E315662
  ///
  /// In id, this message translates to:
  /// **'GBP — Pound Inggris'**
  String get hrd21e315662;

  /// Modul: home. Audit: HR-ID-5D0ADDB63A
  ///
  /// In id, this message translates to:
  /// **'Geser untuk Istirahat'**
  String get hr5d0addb63a;

  /// Modul: home. Audit: HR-ID-1E297DE730
  ///
  /// In id, this message translates to:
  /// **'Geser untuk Kerja'**
  String get hr1e297de730;

  /// Modul: kpi. Audit: HR-ID-5E9E1DAC72
  ///
  /// In id, this message translates to:
  /// **'Geser untuk memberi nilai'**
  String get hr5e9e1dac72;

  /// Modul: home. Audit: HR-ID-C1E9914A6E
  ///
  /// In id, this message translates to:
  /// **'Geser untuk Presensi'**
  String get hrc1e9914a6e;

  /// Modul: login. Audit: HR-ID-1B155396B4
  ///
  /// In id, this message translates to:
  /// **'Google belum dapat dihubungkan. Silakan coba lagi.'**
  String get hr1b155396b4;

  /// Modul: login. Audit: HR-ID-B10ADEA98B
  ///
  /// In id, this message translates to:
  /// **'Google belum memberikan verifikasi akun. Silakan coba lagi.'**
  String get hrb10adea98b;

  /// Modul: login. Audit: HR-ID-2F13348883
  ///
  /// In id, this message translates to:
  /// **'Google belum tersedia. Anda tetap bisa masuk atau daftar dengan email.'**
  String get hr2f13348883;

  /// Modul: sistem & komponen umum. Audit: HR-ID-5277921574
  ///
  /// In id, this message translates to:
  /// **'Google Sign-In belum diaktifkan pada server ini.'**
  String get hr5277921574;

  /// Modul: order. Audit: HR-ID-91FAAFB129
  ///
  /// In id, this message translates to:
  /// **'Grand Total'**
  String get hr91faafb129;

  /// Modul: delivery. Audit: HR-ID-0FD1597934
  ///
  /// In id, this message translates to:
  /// **'Gross Sales'**
  String get hr0fd1597934;

  /// Modul: chat. Audit: HR-ID-17BD477CFE
  ///
  /// In id, this message translates to:
  /// **'Grup gagal dibuat, silakan coba lagi'**
  String get hr17bd477cfe;

  /// Modul: instansi. Audit: HR-ID-D7F13A2231
  ///
  /// In id, this message translates to:
  /// **'Gunakan GPS'**
  String get hrd7f13a2231;

  /// Modul: instansi. Audit: HR-ID-1344C75514
  ///
  /// In id, this message translates to:
  /// **'Gunakan nomor aktif yang diawali 0 atau 62'**
  String get hr1344c75514;

  /// Modul: attendance, payroll. Audit: HR-ID-A236DAF2DF
  ///
  /// In id, this message translates to:
  /// **'Hadir'**
  String get hra236daf2df;

  /// Modul: payroll. Audit: HR-ID-0158EC3A96
  ///
  /// In id, this message translates to:
  /// **'Halaman {nilai1} tidak dapat ditampilkan'**
  String hr0158ec3a96(String nilai1);

  /// Modul: leave. Audit: HR-ID-B63184B048
  ///
  /// In id, this message translates to:
  /// **'Half Day Pagi (07:00 - 12:00)'**
  String get hrb63184b048;

  /// Modul: leave. Audit: HR-ID-8AC74B136C
  ///
  /// In id, this message translates to:
  /// **'Half Day Siang (13:00 - 17:00)'**
  String get hr8ac74b136c;

  /// Modul: activity, announcement, attendance_request, global, kalender, leave, logbook, notification, overtime, reimbursement. Audit: HR-ID-9D053C98FD
  ///
  /// In id, this message translates to:
  /// **'Hapus'**
  String get hr9d053c98fd;

  /// Modul: profile. Audit: HR-ID-67260693F9
  ///
  /// In id, this message translates to:
  /// **'Hapus Akun'**
  String get hr67260693f9;

  /// Modul: kalender. Audit: HR-ID-25A2C064AB
  ///
  /// In id, this message translates to:
  /// **'Hapus Event?'**
  String get hr25a2c064ab;

  /// Modul: activity. Audit: HR-ID-F201FB5503
  ///
  /// In id, this message translates to:
  /// **'Hapus kegiatan?'**
  String get hrf201fb5503;

  /// Modul: logbook. Audit: HR-ID-CCA4B90026
  ///
  /// In id, this message translates to:
  /// **'Hapus Logbook?'**
  String get hrcca4b90026;

  /// Modul: leave. Audit: HR-ID-94658B74B6
  ///
  /// In id, this message translates to:
  /// **'Hapus pengajuan cuti?'**
  String get hr94658b74b6;

  /// Modul: overtime. Audit: HR-ID-75838E9EFC
  ///
  /// In id, this message translates to:
  /// **'Hapus pengajuan lembur?'**
  String get hr75838e9efc;

  /// Modul: announcement. Audit: HR-ID-55645BD4CA
  ///
  /// In id, this message translates to:
  /// **'Hapus Pengumuman?'**
  String get hr55645bd4ca;

  /// Modul: reimbursement. Audit: HR-ID-F46C36A561
  ///
  /// In id, this message translates to:
  /// **'Hapus reimbursement?'**
  String get hrf46c36a561;

  /// Modul: attendance_request. Audit: HR-ID-6002EA5B16
  ///
  /// In id, this message translates to:
  /// **'Hapus request presensi?'**
  String get hr6002ea5b16;

  /// Modul: chat, komponen umum, logbook, notification. Audit: HR-ID-D300B7BCAA
  ///
  /// In id, this message translates to:
  /// **'Hari Ini'**
  String get hrd300b7bcaa;

  /// Modul: attendance, leave, payroll. Audit: HR-ID-654583B2E9
  ///
  /// In id, this message translates to:
  /// **'Hari Kerja'**
  String get hr654583b2e9;

  /// Modul: leave. Audit: HR-ID-EA36617E82
  ///
  /// In id, this message translates to:
  /// **'Hari Libur'**
  String get hrea36617e82;

  /// Modul: kalender. Audit: HR-ID-250FB589BF
  ///
  /// In id, this message translates to:
  /// **'Hari Libur Nasional'**
  String get hr250fb589bf;

  /// Modul: kalender. Audit: HR-ID-4245662DF9
  ///
  /// In id, this message translates to:
  /// **'Hari Libur Perusahaan'**
  String get hr4245662df9;

  /// Modul: kpi. Audit: HR-ID-7960C25744
  ///
  /// In id, this message translates to:
  /// **'Hasil KPI berhasil dikonfirmasi'**
  String get hr7960c25744;

  /// Modul: inventory. Audit: HR-ID-C5AF6EFB1F
  ///
  /// In id, this message translates to:
  /// **'Hasil Recycle'**
  String get hrc5af6efb1f;

  /// Modul: inventory. Audit: HR-ID-FCFC6E5A57
  ///
  /// In id, this message translates to:
  /// **'Hasil recycle tidak boleh melebihi jumlah terdampak'**
  String get hrfcfc6e5a57;

  /// Modul: kpi. Audit: HR-ID-721D37C5FE
  ///
  /// In id, this message translates to:
  /// **'Hasil review: {nilai1} / 5 • Grade {nilai2}'**
  String hr721d37c5fe(String nilai1, String nilai2);

  /// Modul: sistem & komponen umum. Audit: HR-ID-E877968B72
  ///
  /// In id, this message translates to:
  /// **'HKD — Dollar Hong Kong'**
  String get hre877968b72;

  /// Modul: komponen umum. Audit: HR-ID-70F8BB9A8A
  ///
  /// In id, this message translates to:
  /// **'Home'**
  String get hr70f8bb9a8a;

  /// Modul: intro. Audit: HR-ID-7974D6219B
  ///
  /// In id, this message translates to:
  /// **'HRMS & Sales Terpadu'**
  String get hr7974d6219b;

  /// Modul: profile. Audit: HR-ID-AA5AD2F294
  ///
  /// In id, this message translates to:
  /// **'Hubungi Kami'**
  String get hraa5ad2f294;

  /// Modul: apotek. Audit: HR-ID-29FFFE870F
  ///
  /// In id, this message translates to:
  /// **'Hutang'**
  String get hr29fffe870f;

  /// Modul: profile. Audit: HR-ID-BE8A022A4F
  ///
  /// In id, this message translates to:
  /// **'ID Tugas: {nilai1}'**
  String hrbe8a022a4f(String nilai1);

  /// Modul: development. Audit: HR-ID-BFDFD0A3D6
  ///
  /// In id, this message translates to:
  /// **'ID User'**
  String get hrbfdfd0a3d6;

  /// Modul: van_stock. Audit: HR-ID-876783B980
  ///
  /// In id, this message translates to:
  /// **'Identitas pengguna tidak ditemukan. Silakan login ulang.'**
  String get hr876783b980;

  /// Modul: sistem & komponen umum. Audit: HR-ID-219EBEDF37
  ///
  /// In id, this message translates to:
  /// **'IDR — Rupiah'**
  String get hr219ebedf37;

  /// Modul: sistem & komponen umum. Audit: HR-ID-7935CA60A3
  ///
  /// In id, this message translates to:
  /// **'ILS — Shekel Israel'**
  String get hr7935ca60a3;

  /// Modul: sistem & komponen umum. Audit: HR-ID-C8414A8238
  ///
  /// In id, this message translates to:
  /// **'Image compression failed'**
  String get hrc8414a8238;

  /// Modul: home. Audit: HR-ID-C2A3603814
  ///
  /// In id, this message translates to:
  /// **'Incidental\nReport'**
  String get hrc2a3603814;

  /// Modul: inventory. Audit: HR-ID-D135CF55A6
  ///
  /// In id, this message translates to:
  /// **'Incidental Report'**
  String get hrd135cf55a6;

  /// Modul: delivery, order. Audit: HR-ID-ACAB0F85C2
  ///
  /// In id, this message translates to:
  /// **'INDENT / PRE ORDER (PO)'**
  String get hracab0f85c2;

  /// Modul: kpi. Audit: HR-ID-B3227A6418
  ///
  /// In id, this message translates to:
  /// **'Indikator KPI belum tersedia.'**
  String get hrb3227a6418;

  /// Modul: leave. Audit: HR-ID-A749432B0C
  ///
  /// In id, this message translates to:
  /// **'Info: Jika durasi pengajuan Anda melebihi sisa cuti, maka hari yang berlebih akan dihitung sebagai Unpaid Leave (Potong Gaji).'**
  String get hra749432b0c;

  /// Modul: global, logbook. Audit: HR-ID-EE74A69945
  ///
  /// In id, this message translates to:
  /// **'Informasi'**
  String get hree74a69945;

  /// Modul: profile. Audit: HR-ID-B12E36F071
  ///
  /// In id, this message translates to:
  /// **'Informasi Akun'**
  String get hrb12e36f071;

  /// Modul: approval_center. Audit: HR-ID-A843E42BA2
  ///
  /// In id, this message translates to:
  /// **'Informasi akun belum tersedia.'**
  String get hra843e42ba2;

  /// Modul: leave. Audit: HR-ID-71E8773744
  ///
  /// In id, this message translates to:
  /// **'Informasi Cuti'**
  String get hr71e8773744;

  /// Modul: notification. Audit: HR-ID-BF1478444B
  ///
  /// In id, this message translates to:
  /// **'Informasi dan pembaruan terbaru'**
  String get hrbf1478444b;

  /// Modul: profile. Audit: HR-ID-F36F016266
  ///
  /// In id, this message translates to:
  /// **'Informasi Instansi/Organisasi'**
  String get hrf36f016266;

  /// Modul: shift. Audit: HR-ID-065957ECFA
  ///
  /// In id, this message translates to:
  /// **'Informasi jadwal kerja'**
  String get hr065957ecfa;

  /// Modul: reimbursement. Audit: HR-ID-DA7A29E2F3
  ///
  /// In id, this message translates to:
  /// **'Informasi Keuangan'**
  String get hrda7a29e2f3;

  /// Modul: komponen umum. Audit: HR-ID-88B51AEACA
  ///
  /// In id, this message translates to:
  /// **'Informasi lengkap pengajuan'**
  String get hr88b51aeaca;

  /// Modul: profile. Audit: HR-ID-91C187B0E4
  ///
  /// In id, this message translates to:
  /// **'Informasi lengkap tentang perusahaan tempat bekerja'**
  String get hr91c187b0e4;

  /// Modul: komponen umum. Audit: HR-ID-B2959E1DDE
  ///
  /// In id, this message translates to:
  /// **'Informasi Pengajuan'**
  String get hrb2959e1dde;

  /// Modul: leave. Audit: HR-ID-92FC375E7E
  ///
  /// In id, this message translates to:
  /// **'Informasi pengajuan cuti'**
  String get hr92fc375e7e;

  /// Modul: announcement. Audit: HR-ID-50E740A0F5
  ///
  /// In id, this message translates to:
  /// **'Informasi pengumuman perusahaan'**
  String get hr50e740a0f5;

  /// Modul: attendance_request. Audit: HR-ID-E7A94D753A
  ///
  /// In id, this message translates to:
  /// **'Informasi Request'**
  String get hre7a94d753a;

  /// Modul: attendance. Audit: HR-ID-F5E797BECA
  ///
  /// In id, this message translates to:
  /// **'Informasi Utama'**
  String get hrf5e797beca;

  /// Modul: profile. Audit: HR-ID-0DCEBFA4D6
  ///
  /// In id, this message translates to:
  /// **'Informasi versi aplikasi yang sedang digunakan'**
  String get hr0dcebfa4d6;

  /// Modul: sistem & komponen umum. Audit: HR-ID-CB3E199A91
  ///
  /// In id, this message translates to:
  /// **'INR — Rupee India'**
  String get hrcb3e199a91;

  /// Modul: instansi. Audit: HR-ID-E4C62D3C1C
  ///
  /// In id, this message translates to:
  /// **'Instansi belum berhasil dibuat. Silakan coba lagi.'**
  String get hre4c62d3c1c;

  /// Modul: instansi. Audit: HR-ID-B641BDB57B
  ///
  /// In id, this message translates to:
  /// **'Instansi berhasil dibuat'**
  String get hrb641bdb57b;

  /// Modul: instansi. Audit: HR-ID-82A58BF97A
  ///
  /// In id, this message translates to:
  /// **'Instansi berhasil dibuat dan siap digunakan.'**
  String get hr82a58bf97a;

  /// Modul: intro. Audit: HR-ID-88F4A0CDA2
  ///
  /// In id, this message translates to:
  /// **'Interface yang user-friendly'**
  String get hr88f4a0cda2;

  /// Modul: pesan & model bersama. Audit: HR-ID-8F199DE752
  ///
  /// In id, this message translates to:
  /// **'Invalid announcement date'**
  String get hr8f199de752;

  /// Modul: pesan & model bersama. Audit: HR-ID-2CA5F0C85D
  ///
  /// In id, this message translates to:
  /// **'Invalid timestamp format: {nilai1}'**
  String hr2ca5f0c85d(String nilai1);

  /// Modul: instansi. Audit: HR-ID-D8ACE5FB7F
  ///
  /// In id, this message translates to:
  /// **'Isi data dasar berikut. Data lain dapat dilengkapi nanti melalui web.'**
  String get hrd8ace5fb7f;

  /// Modul: logbook. Audit: HR-ID-52F86EC639
  ///
  /// In id, this message translates to:
  /// **'Isi kedua jam atau kosongkan keduanya'**
  String get hr52f86ec639;

  /// Modul: attendance. Audit: HR-ID-37127808DD
  ///
  /// In id, this message translates to:
  /// **'Isi Logbook Sekarang'**
  String get hr37127808dd;

  /// Modul: announcement. Audit: HR-ID-1AEFEC08B9
  ///
  /// In id, this message translates to:
  /// **'Isi Pengumuman *'**
  String get hr1aefec08b9;

  /// Modul: announcement. Audit: HR-ID-9B3C41640B
  ///
  /// In id, this message translates to:
  /// **'Isi pengumuman wajib diisi'**
  String get hr9b3c41640b;

  /// Modul: payroll. Audit: HR-ID-9ABF395C31
  ///
  /// In id, this message translates to:
  /// **'Izin'**
  String get hr9abf395c31;

  /// Modul: sistem & komponen umum. Audit: HR-ID-59055C91B2
  ///
  /// In id, this message translates to:
  /// **'Izin Cuti Tahunan'**
  String get hr59055c91b2;

  /// Modul: global. Audit: HR-ID-2C01D143F0
  ///
  /// In id, this message translates to:
  /// **'Izin lokasi browser'**
  String get hr2c01d143f0;

  /// Modul: activity. Audit: HR-ID-6487875A16
  ///
  /// In id, this message translates to:
  /// **'Izin lokasi diperlukan untuk memindai kegiatan ini.'**
  String get hr6487875a16;

  /// Modul: activity. Audit: HR-ID-5F554A0E47
  ///
  /// In id, this message translates to:
  /// **'Izin lokasi diperlukan untuk presensi kegiatan ini.'**
  String get hr5f554a0e47;

  /// Modul: global. Audit: HR-ID-6FD5AF9A43
  ///
  /// In id, this message translates to:
  /// **'Izin lokasi latar belakang'**
  String get hr6fd5af9a43;

  /// Modul: sistem & komponen umum. Audit: HR-ID-E15F8DC779
  ///
  /// In id, this message translates to:
  /// **'Izin Sakit'**
  String get hre15f8dc779;

  /// Modul: attendance. Audit: HR-ID-BEBF877BDD
  ///
  /// In id, this message translates to:
  /// **'Izin tim belum dapat diperbarui. Periksa koneksi lalu ketuk tombol perbarui.'**
  String get hrbebf877bdd;

  /// Modul: sistem & komponen umum. Audit: HR-ID-6659587A12
  ///
  /// In id, this message translates to:
  /// **'Izin Urusan Keluarga'**
  String get hr6659587a12;

  /// Modul: pesan & model bersama. Audit: HR-ID-D0C4750430
  ///
  /// In id, this message translates to:
  /// **'jabatan'**
  String get hrd0c4750430;

  /// Modul: delivery. Audit: HR-ID-7D04E9643B
  ///
  /// In id, this message translates to:
  /// **'Jadwal / Termin Pembayaran'**
  String get hr7d04e9643b;

  /// Modul: loan. Audit: HR-ID-B2AD2A37C3
  ///
  /// In id, this message translates to:
  /// **'Jadwal Cicilan'**
  String get hrb2ad2a37c3;

  /// Modul: home. Audit: HR-ID-0D29EF6379
  ///
  /// In id, this message translates to:
  /// **'Jadwal Masuk'**
  String get hr0d29ef6379;

  /// Modul: delivery. Audit: HR-ID-8F16EDBBD8
  ///
  /// In id, this message translates to:
  /// **'Jadwal Pembayaran'**
  String get hr8f16edbbd8;

  /// Modul: home. Audit: HR-ID-BF6CD5066A
  ///
  /// In id, this message translates to:
  /// **'Jadwal Pulang'**
  String get hrbf6cd5066a;

  /// Modul: profile. Audit: HR-ID-BE8DA64170
  ///
  /// In id, this message translates to:
  /// **'Jadwal Service'**
  String get hrbe8da64170;

  /// Modul: attendance_request. Audit: HR-ID-5C9CA8CF99
  ///
  /// In id, this message translates to:
  /// **'Jadwal Shift'**
  String get hr5c9ca8cf99;

  /// Modul: shift. Audit: HR-ID-645D138745
  ///
  /// In id, this message translates to:
  /// **'Jadwal Shift Tujuan'**
  String get hr645d138745;

  /// Modul: shift. Audit: HR-ID-7F56517479
  ///
  /// In id, this message translates to:
  /// **'Jadwal Shift Tujuan wajib dipilih'**
  String get hr7f56517479;

  /// Modul: attendance_request, shift. Audit: HR-ID-4D7F219F61
  ///
  /// In id, this message translates to:
  /// **'Jadwal Shift wajib dipilih'**
  String get hr4d7f219f61;

  /// Modul: komponen umum. Audit: HR-ID-9D0EB3AD55
  ///
  /// In id, this message translates to:
  /// **'Jam'**
  String get hr9d0eb3ad55;

  /// Modul: attendance_request. Audit: HR-ID-A36FA14316
  ///
  /// In id, this message translates to:
  /// **'Jam Check In'**
  String get hra36fa14316;

  /// Modul: attendance_request. Audit: HR-ID-FC92EA8613
  ///
  /// In id, this message translates to:
  /// **'Jam Check In wajib diisi'**
  String get hrfc92ea8613;

  /// Modul: attendance_request. Audit: HR-ID-26CB9A44C8
  ///
  /// In id, this message translates to:
  /// **'Jam Check Out'**
  String get hr26cb9a44c8;

  /// Modul: attendance_request. Audit: HR-ID-D276066290
  ///
  /// In id, this message translates to:
  /// **'Jam Check Out wajib diisi'**
  String get hrd276066290;

  /// Modul: shift. Audit: HR-ID-C1BB24844F
  ///
  /// In id, this message translates to:
  /// **'Jam Masuk'**
  String get hrc1bb24844f;

  /// Modul: activity. Audit: HR-ID-BF0E076C59
  ///
  /// In id, this message translates to:
  /// **'Jam mulai'**
  String get hrbf0e076c59;

  /// Modul: overtime. Audit: HR-ID-E4F6BFD7EB
  ///
  /// In id, this message translates to:
  /// **'Jam Mulai'**
  String get hre4f6bfd7eb;

  /// Modul: logbook. Audit: HR-ID-A2554A7D11
  ///
  /// In id, this message translates to:
  /// **'Jam mulai dan selesai wajib diisi'**
  String get hra2554a7d11;

  /// Modul: overtime. Audit: HR-ID-BDADFD2CD5
  ///
  /// In id, this message translates to:
  /// **'Jam Mulai wajib diisi'**
  String get hrbdadfd2cd5;

  /// Modul: shift. Audit: HR-ID-93ECD4EEEB
  ///
  /// In id, this message translates to:
  /// **'Jam Pulang'**
  String get hr93ecd4eeeb;

  /// Modul: activity. Audit: HR-ID-34D43D76C8
  ///
  /// In id, this message translates to:
  /// **'Jam selesai'**
  String get hr34d43d76c8;

  /// Modul: overtime. Audit: HR-ID-BF93DB39C5
  ///
  /// In id, this message translates to:
  /// **'Jam Selesai'**
  String get hrbf93db39c5;

  /// Modul: activity. Audit: HR-ID-FA072C8DC1
  ///
  /// In id, this message translates to:
  /// **'Jam selesai harus setelah jam mulai.'**
  String get hrfa072c8dc1;

  /// Modul: logbook. Audit: HR-ID-149799881A
  ///
  /// In id, this message translates to:
  /// **'Jam selesai tidak boleh sebelum jam mulai'**
  String get hr149799881a;

  /// Modul: overtime. Audit: HR-ID-37A339AB9F
  ///
  /// In id, this message translates to:
  /// **'Jam Selesai wajib diisi'**
  String get hr37a339ab9f;

  /// Modul: attendance_request, common, leave, overtime, payroll, reimbursement, shift, sistem & komponen umum. Audit: HR-ID-7A0A8C2A65
  ///
  /// In id, this message translates to:
  /// **'Januari'**
  String get hr7a0a8c2a65;

  /// Modul: consignment. Audit: HR-ID-1627E3C3DE
  ///
  /// In id, this message translates to:
  /// **'Jarak Estimasi'**
  String get hr1627e3c3de;

  /// Modul: profile. Audit: HR-ID-16D995C458
  ///
  /// In id, this message translates to:
  /// **'Jatuh Tempo Pajak Tahunan'**
  String get hr16d995c458;

  /// Modul: loan. Audit: HR-ID-3792572FCF
  ///
  /// In id, this message translates to:
  /// **'Jatuh tempo {nilai1}'**
  String hr3792572fcf(String nilai1);

  /// Modul: leave. Audit: HR-ID-FABB2B5C77
  ///
  /// In id, this message translates to:
  /// **'Jenis'**
  String get hrfabb2b5c77;

  /// Modul: leave. Audit: HR-ID-886463A46D
  ///
  /// In id, this message translates to:
  /// **'Jenis Cuti'**
  String get hr886463a46d;

  /// Modul: inventory. Audit: HR-ID-D073AC05DE
  ///
  /// In id, this message translates to:
  /// **'Jenis Insiden'**
  String get hrd073ac05de;

  /// Modul: profile. Audit: HR-ID-23ED9BD24B
  ///
  /// In id, this message translates to:
  /// **'Jenis Kelamin'**
  String get hr23ed9bd24b;

  /// Modul: delivery, profile. Audit: HR-ID-6DB6C09E3A
  ///
  /// In id, this message translates to:
  /// **'Jenis Kendaraan'**
  String get hr6db6c09e3a;

  /// Modul: delivery. Audit: HR-ID-421CBFF8A2
  ///
  /// In id, this message translates to:
  /// **'Jenis Pembatalan'**
  String get hr421cbff8a2;

  /// Modul: attendance_request. Audit: HR-ID-8FA1043794
  ///
  /// In id, this message translates to:
  /// **'Jenis Presensi'**
  String get hr8fa1043794;

  /// Modul: attendance_request. Audit: HR-ID-1303DE0F09
  ///
  /// In id, this message translates to:
  /// **'Jenis Presensi wajib diisi'**
  String get hr1303de0f09;

  /// Modul: attendance_request. Audit: HR-ID-5D0CF842CE
  ///
  /// In id, this message translates to:
  /// **'Jenis Request'**
  String get hr5d0cf842ce;

  /// Modul: attendance_request. Audit: HR-ID-904A15974C
  ///
  /// In id, this message translates to:
  /// **'Jenis Request Presensi'**
  String get hr904a15974c;

  /// Modul: delivery. Audit: HR-ID-618D3A2C05
  ///
  /// In id, this message translates to:
  /// **'Jika membatalkan kunjungan, maka BBM / Reimburse transport tidak akan dihitung.'**
  String get hr618d3a2c05;

  /// Modul: logbook. Audit: HR-ID-B4D944E1A1
  ///
  /// In id, this message translates to:
  /// **'Jika waktu kosong, mulai pertama dari check-in/jadwal (fallback {nilai1}). Log berikutnya mulai dari selesai sebelumnya; durasi otomatis {nilai2}.'**
  String hrb4d944e1a1(String nilai1, String nilai2);

  /// Modul: inventory. Audit: HR-ID-C86442AAAC
  ///
  /// In id, this message translates to:
  /// **'Jml Rusak'**
  String get hrc86442aaac;

  /// Modul: delivery. Audit: HR-ID-035A6F9E80
  ///
  /// In id, this message translates to:
  /// **'Journey Plan'**
  String get hr035a6f9e80;

  /// Modul: sistem & komponen umum. Audit: HR-ID-F21FD835BB
  ///
  /// In id, this message translates to:
  /// **'JPY — Yen Jepang'**
  String get hrf21fd835bb;

  /// Modul: reimbursement. Audit: HR-ID-89FA19D7DE
  ///
  /// In id, this message translates to:
  /// **'Judul'**
  String get hr89fa19d7de;

  /// Modul: announcement, kalender. Audit: HR-ID-CBAFCEECFC
  ///
  /// In id, this message translates to:
  /// **'Judul *'**
  String get hrcbafceecfc;

  /// Modul: activity. Audit: HR-ID-8E9DC56D5B
  ///
  /// In id, this message translates to:
  /// **'Judul kegiatan *'**
  String get hr8e9dc56d5b;

  /// Modul: reimbursement. Audit: HR-ID-0691618495
  ///
  /// In id, this message translates to:
  /// **'Judul tidak boleh lebih dari {nilai1} karakter'**
  String hr0691618495(String nilai1);

  /// Modul: logbook. Audit: HR-ID-5313EBDBA7
  ///
  /// In id, this message translates to:
  /// **'Judul Tugas *'**
  String get hr5313ebdba7;

  /// Modul: logbook. Audit: HR-ID-51613D280D
  ///
  /// In id, this message translates to:
  /// **'Judul tugas wajib diisi'**
  String get hr51613d280d;

  /// Modul: activity, announcement, kalender, reimbursement. Audit: HR-ID-DCB8666371
  ///
  /// In id, this message translates to:
  /// **'Judul wajib diisi'**
  String get hrdcb8666371;

  /// Modul: attendance_request, common, leave, overtime, payroll, reimbursement, shift, sistem & komponen umum. Audit: HR-ID-AEB2D1B92E
  ///
  /// In id, this message translates to:
  /// **'Juli'**
  String get hraeb2d1b92e;

  /// Modul: payroll. Audit: HR-ID-51BCFA0AC3
  ///
  /// In id, this message translates to:
  /// **'Jumlah slip'**
  String get hr51bcfa0ac3;

  /// Modul: inventory. Audit: HR-ID-6AC954D5CE
  ///
  /// In id, this message translates to:
  /// **'Jumlah Terdampak'**
  String get hr6ac954d5ce;

  /// Modul: inventory. Audit: HR-ID-6C736AC52D
  ///
  /// In id, this message translates to:
  /// **'Jumlah terdampak harus lebih dari 0'**
  String get hr6c736ac52d;

  /// Modul: delivery, order. Audit: HR-ID-641ECF81FC
  ///
  /// In id, this message translates to:
  /// **'Jumlah Termin'**
  String get hr641ecf81fc;

  /// Modul: order. Audit: HR-ID-C46B980096
  ///
  /// In id, this message translates to:
  /// **'Jumlah Termin (Bulan)'**
  String get hrc46b980096;

  /// Modul: attendance_request, common, leave, overtime, payroll, reimbursement, shift, sistem & komponen umum. Audit: HR-ID-7E1115BD02
  ///
  /// In id, this message translates to:
  /// **'Juni'**
  String get hr7e1115bd02;

  /// Modul: apotek. Audit: HR-ID-9AE430B557
  ///
  /// In id, this message translates to:
  /// **'Kabupaten/Kota'**
  String get hr9ae430b557;

  /// Modul: home, kalender. Audit: HR-ID-6D46ADF5DE
  ///
  /// In id, this message translates to:
  /// **'Kalender Kerja'**
  String get hr6d46adf5de;

  /// Modul: global. Audit: HR-ID-83008F45AE
  ///
  /// In id, this message translates to:
  /// **'Kamera'**
  String get hr83008f45ae;

  /// Modul: sistem & komponen umum. Audit: HR-ID-6F003ADDDD
  ///
  /// In id, this message translates to:
  /// **'Kamera tidak dapat dibuka. Tutup aplikasi lain yang menggunakan kamera lalu coba lagi.'**
  String get hr6f003adddd;

  /// Modul: common. Audit: HR-ID-F68DFDC060
  ///
  /// In id, this message translates to:
  /// **'Kamera tidak ditemukan pada perangkat ini.'**
  String get hrf68dfdc060;

  /// Modul: sistem & komponen umum. Audit: HR-ID-54A4E8CC28
  ///
  /// In id, this message translates to:
  /// **'Kamera tidak ditemukan, silakan unggah foto!'**
  String get hr54a4e8cc28;

  /// Modul: sistem & komponen umum. Audit: HR-ID-9E635050F4
  ///
  /// In id, this message translates to:
  /// **'Kamera web memerlukan HTTPS atau localhost. Buka aplikasi melalui alamat HTTPS.'**
  String get hr9e635050f4;

  /// Modul: login. Audit: HR-ID-A9FB19B586
  ///
  /// In id, this message translates to:
  /// **'Kami telah mengirim email verifikasi ke alamat email Anda. Buka email tersebut dan verifikasi akun sebelum login. Jika belum terlihat, periksa folder Spam atau Junk.'**
  String get hra9fb19b586;

  /// Modul: profile. Audit: HR-ID-56D62C9923
  ///
  /// In id, this message translates to:
  /// **'Kartu Identitas & QR Kegiatan'**
  String get hr56d62c9923;

  /// Modul: activity, komponen umum, logbook, pesan & model bersama, profile. Audit: HR-ID-BB1EE7385E
  ///
  /// In id, this message translates to:
  /// **'Karyawan'**
  String get hrbb1ee7385e;

  /// Modul: profile. Audit: HR-ID-E29C4DE3E9
  ///
  /// In id, this message translates to:
  /// **'Karyawan {nilai1}'**
  String hre29c4de3e9(String nilai1);

  /// Modul: home. Audit: HR-ID-821358EFCF
  ///
  /// In id, this message translates to:
  /// **'Kasbon\n(Loan)'**
  String get hr821358efcf;

  /// Modul: home. Audit: HR-ID-788FCE5616
  ///
  /// In id, this message translates to:
  /// **'Katalog'**
  String get hr788fce5616;

  /// Modul: inventory. Audit: HR-ID-E88A8F7B27
  ///
  /// In id, this message translates to:
  /// **'Katalog Produk Digital'**
  String get hre88a8f7b27;

  /// Modul: profile. Audit: HR-ID-858105E0ED
  ///
  /// In id, this message translates to:
  /// **'Katasandi dari username {nilai1} berhasil diganti'**
  String hr858105e0ed(String nilai1);

  /// Modul: announcement, apotek, logbook, reimbursement. Audit: HR-ID-B7964404A7
  ///
  /// In id, this message translates to:
  /// **'Kategori'**
  String get hrb7964404a7;

  /// Modul: logbook. Audit: HR-ID-4D5E1691EC
  ///
  /// In id, this message translates to:
  /// **'Kategori belum tersedia'**
  String get hr4d5e1691ec;

  /// Modul: leave. Audit: HR-ID-470A10B88E
  ///
  /// In id, this message translates to:
  /// **'Kategori Cuti wajib diisi'**
  String get hr470a10b88e;

  /// Modul: logbook. Audit: HR-ID-E6CF7866FC
  ///
  /// In id, this message translates to:
  /// **'Kategori logbook belum tersedia'**
  String get hre6cf7866fc;

  /// Modul: logbook. Audit: HR-ID-5BD002BB53
  ///
  /// In id, this message translates to:
  /// **'Kategori logbook berhasil ditambahkan'**
  String get hr5bd002bb53;

  /// Modul: pesan & model bersama. Audit: HR-ID-28DA2F4D04
  ///
  /// In id, this message translates to:
  /// **'Kategori logbook gagal dibuat'**
  String get hr28da2f4d04;

  /// Modul: logbook. Audit: HR-ID-83D1153A02
  ///
  /// In id, this message translates to:
  /// **'Kategori Logbook{nilai1}'**
  String hr83d1153a02(String nilai1);

  /// Modul: delivery. Audit: HR-ID-8166EA178D
  ///
  /// In id, this message translates to:
  /// **'Kategori Order'**
  String get hr8166ea178d;

  /// Modul: apotek. Audit: HR-ID-0498A927AA
  ///
  /// In id, this message translates to:
  /// **'Kategori Produk'**
  String get hr0498a927aa;

  /// Modul: leave. Audit: HR-ID-5A5DC78661
  ///
  /// In id, this message translates to:
  /// **'Kategori tidak diketahui'**
  String get hr5a5dc78661;

  /// Modul: logbook. Audit: HR-ID-3B7DAF9E78
  ///
  /// In id, this message translates to:
  /// **'Kategori tugas wajib dipilih'**
  String get hr3b7daf9e78;

  /// Modul: reimbursement. Audit: HR-ID-B6A81F1B70
  ///
  /// In id, this message translates to:
  /// **'Kategori wajib diisi'**
  String get hrb6a81f1b70;

  /// Modul: shift. Audit: HR-ID-138EB50F2F
  ///
  /// In id, this message translates to:
  /// **'Ke'**
  String get hr138eb50f2f;

  /// Modul: login, profile. Audit: HR-ID-F1240B7C6E
  ///
  /// In id, this message translates to:
  /// **'Kebijakan Privasi'**
  String get hrf1240b7c6e;

  /// Modul: login. Audit: HR-ID-1DA462FB8C
  ///
  /// In id, this message translates to:
  /// **'Kebijakan Privasi Pantoo HRMS'**
  String get hr1da462fb8c;

  /// Modul: activity. Audit: HR-ID-59C0AC61AB
  ///
  /// In id, this message translates to:
  /// **'Kegiatan'**
  String get hr59c0ac61ab;

  /// Modul: home. Audit: HR-ID-197789F184
  ///
  /// In id, this message translates to:
  /// **'Kegiatan &\nKehadiran'**
  String get hr197789f184;

  /// Modul: activity. Audit: HR-ID-A055C81C35
  ///
  /// In id, this message translates to:
  /// **'Kegiatan berhasil dihapus'**
  String get hra055c81c35;

  /// Modul: activity. Audit: HR-ID-44B93600B2
  ///
  /// In id, this message translates to:
  /// **'Kegiatan berhasil diperbarui'**
  String get hr44b93600b2;

  /// Modul: activity. Audit: HR-ID-340C50C2A0
  ///
  /// In id, this message translates to:
  /// **'Kegiatan berhasil ditambahkan'**
  String get hr340c50c2a0;

  /// Modul: instansi, profile. Audit: HR-ID-B574EB2E86
  ///
  /// In id, this message translates to:
  /// **'Kegiatan Utama'**
  String get hrb574eb2e86;

  /// Modul: activity. Audit: HR-ID-E6CDC6C970
  ///
  /// In id, this message translates to:
  /// **'Kegiatan “{nilai1}” akan dihapus.'**
  String hre6cdc6c970(String nilai1);

  /// Modul: activity. Audit: HR-ID-B9944207F9
  ///
  /// In id, this message translates to:
  /// **'Kehadiran'**
  String get hrb9944207f9;

  /// Modul: pesan & model bersama. Audit: HR-ID-96B2A40229
  ///
  /// In id, this message translates to:
  /// **'kehadiran'**
  String get hr96b2a40229;

  /// Modul: pesan & model bersama. Audit: HR-ID-ECEA96060E
  ///
  /// In id, this message translates to:
  /// **'Kehadiran berhasil dicatat'**
  String get hrecea96060e;

  /// Modul: activity. Audit: HR-ID-02392EFF60
  ///
  /// In id, this message translates to:
  /// **'Kehadiran dicatat oleh petugas melalui QR karyawan.'**
  String get hr02392eff60;

  /// Modul: pesan & model bersama. Audit: HR-ID-1ADC6D6E8E
  ///
  /// In id, this message translates to:
  /// **'Kehadiran kegiatan berhasil dicatat'**
  String get hr1adc6d6e8e;

  /// Modul: profile. Audit: HR-ID-127D164881
  ///
  /// In id, this message translates to:
  /// **'Kelola informasi pribadi dan data diri Anda'**
  String get hr127d164881;

  /// Modul: shift. Audit: HR-ID-6D6A1FE975
  ///
  /// In id, this message translates to:
  /// **'Kelola jadwal dan pengajuan tukar shift Anda'**
  String get hr6d6a1fe975;

  /// Modul: activity. Audit: HR-ID-BD06CF6B95
  ///
  /// In id, this message translates to:
  /// **'Kelola kegiatan dan kehadiran'**
  String get hrbd06cf6b95;

  /// Modul: attendance. Audit: HR-ID-EA43712F6C
  ///
  /// In id, this message translates to:
  /// **'Kelola kehadiran dan riwayat presensi Anda'**
  String get hrea43712f6c;

  /// Modul: leave. Audit: HR-ID-D7FF0BFDCF
  ///
  /// In id, this message translates to:
  /// **'Kelola pengajuan cuti Anda'**
  String get hrd7ff0bfdcf;

  /// Modul: attendance_request. Audit: HR-ID-06D13889FF
  ///
  /// In id, this message translates to:
  /// **'Kelola pengajuan koreksi presensi Anda'**
  String get hr06d13889ff;

  /// Modul: overtime. Audit: HR-ID-B7D952CCC9
  ///
  /// In id, this message translates to:
  /// **'Kelola pengajuan lembur Anda'**
  String get hrb7d952ccc9;

  /// Modul: reimbursement. Audit: HR-ID-099E62D40E
  ///
  /// In id, this message translates to:
  /// **'Kelola pengajuan reimbursement Anda'**
  String get hr099e62d40e;

  /// Modul: approval_center. Audit: HR-ID-C53BBEC635
  ///
  /// In id, this message translates to:
  /// **'Kelola persetujuan sesuai kewenangan Anda'**
  String get hrc53bbec635;

  /// Modul: profile. Audit: HR-ID-A421CE222C
  ///
  /// In id, this message translates to:
  /// **'Keluar'**
  String get hra421ce222c;

  /// Modul: profile. Audit: HR-ID-B6BD535FF6
  ///
  /// In id, this message translates to:
  /// **'Keluar dari akun pada perangkat ini'**
  String get hrb6bd535ff6;

  /// Modul: global, shift. Audit: HR-ID-C43A6E25B7
  ///
  /// In id, this message translates to:
  /// **'Kembali'**
  String get hrc43a6e25b7;

  /// Modul: consignment, profile. Audit: HR-ID-79E4EC31D6
  ///
  /// In id, this message translates to:
  /// **'Kendaraan'**
  String get hr79e4ec31d6;

  /// Modul: delivery. Audit: HR-ID-13479D024F
  ///
  /// In id, this message translates to:
  /// **'Kendaraan utama belum ditetapkan. Hubungi admin.'**
  String get hr13479d024f;

  /// Modul: sistem & komponen umum. Audit: HR-ID-D9C1B5BC47
  ///
  /// In id, this message translates to:
  /// **'Kerja'**
  String get hrd9c1b5bc47;

  /// Modul: sistem & komponen umum. Audit: HR-ID-37918E591E
  ///
  /// In id, this message translates to:
  /// **'kerja'**
  String get hr37918e591e;

  /// Modul: delivery. Audit: HR-ID-B2E22AACF3
  ///
  /// In id, this message translates to:
  /// **'Kerjakan Kunjungan'**
  String get hrb2e22aacf3;

  /// Modul: pesan & model bersama. Audit: HR-ID-23F8A007F0
  ///
  /// In id, this message translates to:
  /// **'Kesalahan input data'**
  String get hr23f8a007f0;

  /// Modul: profile. Audit: HR-ID-76FC3B16F6
  ///
  /// In id, this message translates to:
  /// **'Ketentuan dan kebijakan privasi aplikasi'**
  String get hr76fc3b16f6;

  /// Modul: login. Audit: HR-ID-802C6998EA
  ///
  /// In id, this message translates to:
  /// **'Ketentuan Layanan'**
  String get hr802c6998ea;

  /// Modul: activity, inventory. Audit: HR-ID-557F56DDB6
  ///
  /// In id, this message translates to:
  /// **'Keterangan'**
  String get hr557f56ddb6;

  /// Modul: loan. Audit: HR-ID-5FFF42105C
  ///
  /// In id, this message translates to:
  /// **'Ketik alasan...'**
  String get hr5fff42105c;

  /// Modul: delivery. Audit: HR-ID-396FB21085
  ///
  /// In id, this message translates to:
  /// **'Ketik lalu Enter/Koma'**
  String get hr396fb21085;

  /// Modul: chat. Audit: HR-ID-787F3583E6
  ///
  /// In id, this message translates to:
  /// **'Ketik nama pengguna...'**
  String get hr787f3583e6;

  /// Modul: chat. Audit: HR-ID-8B6B593A76
  ///
  /// In id, this message translates to:
  /// **'Ketik pesan...'**
  String get hr8b6b593a76;

  /// Modul: logbook. Audit: HR-ID-120B3A115E
  ///
  /// In id, this message translates to:
  /// **'Ketuk + untuk mencatat aktivitas'**
  String get hr120b3a115e;

  /// Modul: profile. Audit: HR-ID-06EB8AAA72
  ///
  /// In id, this message translates to:
  /// **'Kilomenter Terakhir'**
  String get hr06eb8aaa72;

  /// Modul: profile. Audit: HR-ID-652D0716C4
  ///
  /// In id, this message translates to:
  /// **'kilometer pengingat servis'**
  String get hr652d0716c4;

  /// Modul: profile. Audit: HR-ID-1DB59A40A2
  ///
  /// In id, this message translates to:
  /// **'Kilometer Saat Ini'**
  String get hr1db59a40a2;

  /// Modul: profile. Audit: HR-ID-6843BB5B53
  ///
  /// In id, this message translates to:
  /// **'kilometer saat ini'**
  String get hr6843bb5b53;

  /// Modul: intro. Audit: HR-ID-7532A96550
  ///
  /// In id, this message translates to:
  /// **'Kinerja Cepat'**
  String get hr7532a96550;

  /// Modul: attendance_request, kpi, leave, overtime, reimbursement, shift. Audit: HR-ID-00D1624E7E
  ///
  /// In id, this message translates to:
  /// **'Kirim'**
  String get hr00d1624e7e;

  /// Modul: kpi. Audit: HR-ID-F94AA18FDD
  ///
  /// In id, this message translates to:
  /// **'Kirim Penilaian'**
  String get hrf94aa18fdd;

  /// Modul: kpi. Audit: HR-ID-4CB9D488E4
  ///
  /// In id, this message translates to:
  /// **'Kirim penilaian?'**
  String get hr4cb9d488e4;

  /// Modul: chat. Audit: HR-ID-28BF10D443
  ///
  /// In id, this message translates to:
  /// **'Kirim pesan pertama Anda!'**
  String get hr28bf10d443;

  /// Modul: shift. Audit: HR-ID-23BBD0C180
  ///
  /// In id, this message translates to:
  /// **'Kirim Request'**
  String get hr23bbd0c180;

  /// Modul: delivery. Audit: HR-ID-1A618C3406
  ///
  /// In id, this message translates to:
  /// **'Klik nomor referensi untuk melihat detail DO'**
  String get hr1a618c3406;

  /// Modul: delivery. Audit: HR-ID-200DB98BB0
  ///
  /// In id, this message translates to:
  /// **'Klik nomor referensi untuk melihat detail tagihan'**
  String get hr200db98bb0;

  /// Modul: login. Audit: HR-ID-24B32ED17D
  ///
  /// In id, this message translates to:
  /// **'Kode CAPTCHA'**
  String get hr24b32ed17d;

  /// Modul: apotek. Audit: HR-ID-A731B8BA49
  ///
  /// In id, this message translates to:
  /// **'Kode Outlet'**
  String get hra731b8ba49;

  /// Modul: apotek. Audit: HR-ID-997EB9526C
  ///
  /// In id, this message translates to:
  /// **'Kode outlet'**
  String get hr997eb9526c;

  /// Modul: chat. Audit: HR-ID-F038E599F9
  ///
  /// In id, this message translates to:
  /// **'Komunikasi aman dalam perusahaan'**
  String get hrf038e599f9;

  /// Modul: pesan & model bersama. Audit: HR-ID-628FCC3086
  ///
  /// In id, this message translates to:
  /// **'Koneksi berhasalah saat mencari Koordinat!'**
  String get hr628fcc3086;

  /// Modul: sistem & komponen umum. Audit: HR-ID-CBBEF2DFAE
  ///
  /// In id, this message translates to:
  /// **'Koneksi Gagal'**
  String get hrcbbef2dfae;

  /// Modul: pesan & model bersama. Audit: HR-ID-9E2407BA1D
  ///
  /// In id, this message translates to:
  /// **'Koneksi ke server terputus, silakan coba lagi nanti'**
  String get hr9e2407ba1d;

  /// Modul: pesan & model bersama. Audit: HR-ID-70971F85AF
  ///
  /// In id, this message translates to:
  /// **'Koneksi timeout, server tidak merespon'**
  String get hr70971f85af;

  /// Modul: pesan & model bersama. Audit: HR-ID-EA6EA73ED8
  ///
  /// In id, this message translates to:
  /// **'Koneksi Timeout, silakan reload Aplikasi!'**
  String get hrea6ea73ed8;

  /// Modul: delivery, home. Audit: HR-ID-67B7BD6433
  ///
  /// In id, this message translates to:
  /// **'Konfirmasi'**
  String get hr67b7bd6433;

  /// Modul: delivery. Audit: HR-ID-DBC8F39B98
  ///
  /// In id, this message translates to:
  /// **'Konfirmasi ({nilai1} tagihan)'**
  String hrdbc8f39b98(String nilai1);

  /// Modul: kpi. Audit: HR-ID-99364C7E5C
  ///
  /// In id, this message translates to:
  /// **'Konfirmasi bahwa Anda sudah membaca hasil KPI. Jika ada koreksi presensi yang disetujui, sistem dapat meminta review dan konfirmasi ulang.'**
  String get hr99364c7e5c;

  /// Modul: kpi. Audit: HR-ID-7508EB7D91
  ///
  /// In id, this message translates to:
  /// **'Konfirmasi KPI'**
  String get hr7508eb7d91;

  /// Modul: login, profile. Audit: HR-ID-C22263B98E
  ///
  /// In id, this message translates to:
  /// **'Konfirmasi Password'**
  String get hrc22263b98e;

  /// Modul: profile. Audit: HR-ID-A2374910C5
  ///
  /// In id, this message translates to:
  /// **'Konfirmasi password baru'**
  String get hra2374910c5;

  /// Modul: login. Audit: HR-ID-4187799A81
  ///
  /// In id, this message translates to:
  /// **'Konfirmasi Password minimal 8 karakter'**
  String get hr4187799a81;

  /// Modul: attendance. Audit: HR-ID-EC1948DD77
  ///
  /// In id, this message translates to:
  /// **'Konsistensi presensi'**
  String get hrec1948dd77;

  /// Modul: leave. Audit: HR-ID-81D99B9997
  ///
  /// In id, this message translates to:
  /// **'Kontak Darurat (Opsional)'**
  String get hr81d99b9997;

  /// Modul: delivery. Audit: HR-ID-F2AA34351A
  ///
  /// In id, this message translates to:
  /// **'Koordinat tidak sesuai?'**
  String get hrf2aa34351a;

  /// Modul: sistem & komponen umum. Audit: HR-ID-BD6C296CB1
  ///
  /// In id, this message translates to:
  /// **'Koordinat {nilai1}, {nilai2}'**
  String hrbd6c296cb1(String nilai1, String nilai2);

  /// Modul: profile. Audit: HR-ID-A7417D1A49
  ///
  /// In id, this message translates to:
  /// **'Koordinat: {nilai1}, {nilai2}'**
  String hra7417d1a49(String nilai1, String nilai2);

  /// Modul: attendance_request. Audit: HR-ID-D512DD68C2
  ///
  /// In id, this message translates to:
  /// **'Koreksi Jam'**
  String get hrd512dd68c2;

  /// Modul: sistem & komponen umum. Audit: HR-ID-D152599B92
  ///
  /// In id, this message translates to:
  /// **'Koreksi Masuk'**
  String get hrd152599b92;

  /// Modul: sistem & komponen umum. Audit: HR-ID-B8C6B95E88
  ///
  /// In id, this message translates to:
  /// **'Koreksi Masuk & Pulang'**
  String get hrb8c6b95e88;

  /// Modul: approval_center, home. Audit: HR-ID-4E1EDD373D
  ///
  /// In id, this message translates to:
  /// **'Koreksi presensi'**
  String get hr4e1edd373d;

  /// Modul: sistem & komponen umum. Audit: HR-ID-D6EC5715E2
  ///
  /// In id, this message translates to:
  /// **'Koreksi Waktu Istirahat'**
  String get hrd6ec5715e2;

  /// Modul: home. Audit: HR-ID-BFE8B8D109
  ///
  /// In id, this message translates to:
  /// **'KPI'**
  String get hrbfe8b8d109;

  /// Modul: kpi. Audit: HR-ID-D0877604F4
  ///
  /// In id, this message translates to:
  /// **'KPI Saya'**
  String get hrd0877604f4;

  /// Modul: sistem & komponen umum. Audit: HR-ID-9E61424138
  ///
  /// In id, this message translates to:
  /// **'KRW — Won Korea'**
  String get hr9e61424138;

  /// Modul: delivery, komponen umum, profile. Audit: HR-ID-7CC8B5A183
  ///
  /// In id, this message translates to:
  /// **'Kunjungan'**
  String get hr7cc8b5a183;

  /// Modul: delivery. Audit: HR-ID-E4C87D7D9D
  ///
  /// In id, this message translates to:
  /// **'Kunjungan berhasil ditambahkan'**
  String get hre4c87d7d9d;

  /// Modul: dashboard. Audit: HR-ID-24844C1988
  ///
  /// In id, this message translates to:
  /// **'Kunjungan Bulan Ini'**
  String get hr24844c1988;

  /// Modul: tasks. Audit: HR-ID-5F824EA10B
  ///
  /// In id, this message translates to:
  /// **'Kunjungan gagal diproses, silakan coba lagi'**
  String get hr5f824ea10b;

  /// Modul: sistem & komponen umum. Audit: HR-ID-75AA9CB643
  ///
  /// In id, this message translates to:
  /// **'Kunjungan hari ini telah selesai!'**
  String get hr75aa9cb643;

  /// Modul: delivery. Audit: HR-ID-413E4258C5
  ///
  /// In id, this message translates to:
  /// **'Kunjungan ini dikerjakan oleh {nilai1}.'**
  String hr413e4258c5(String nilai1);

  /// Modul: inventory. Audit: HR-ID-BFFDFCD17A
  ///
  /// In id, this message translates to:
  /// **'Kurangi Stok (Net Lost)'**
  String get hrbffdfcd17a;

  /// Modul: sistem & komponen umum. Audit: HR-ID-EB8F67E415
  ///
  /// In id, this message translates to:
  /// **'KWD — Dinar Kuwait'**
  String get hreb8f67e415;

  /// Modul: logbook. Audit: HR-ID-844F8A7234
  ///
  /// In id, this message translates to:
  /// **'Lainnya'**
  String get hr844f8a7234;

  /// Modul: leave. Audit: HR-ID-4B048B0EA1
  ///
  /// In id, this message translates to:
  /// **'Lampiran'**
  String get hr4b048b0ea1;

  /// Modul: attendance. Audit: HR-ID-245A9AF9E2
  ///
  /// In id, this message translates to:
  /// **'Lampiran (Opsional)'**
  String get hr245a9af9e2;

  /// Modul: profile. Audit: HR-ID-FFE94D4B5B
  ///
  /// In id, this message translates to:
  /// **'Langganan tidak tersedia'**
  String get hrffe94d4b5b;

  /// Modul: instansi. Audit: HR-ID-5BCBC797A7
  ///
  /// In id, this message translates to:
  /// **'Lanjutkan'**
  String get hr5bcbc797a7;

  /// Modul: login. Audit: HR-ID-ABF7CE4C10
  ///
  /// In id, this message translates to:
  /// **'Lanjutkan dengan Google'**
  String get hrabf7ce4c10;

  /// Modul: inventory. Audit: HR-ID-25FFE2C48A
  ///
  /// In id, this message translates to:
  /// **'Laporan gagal diproses, silakan coba lagi'**
  String get hr25ffe2c48a;

  /// Modul: inventory. Audit: HR-ID-72D3386F6D
  ///
  /// In id, this message translates to:
  /// **'Laporan insiden berhasil dibuat'**
  String get hr72d3386f6d;

  /// Modul: intro. Audit: HR-ID-E945841AFE
  ///
  /// In id, this message translates to:
  /// **'Laporan Lengkap'**
  String get hre945841afe;

  /// Modul: apotek. Audit: HR-ID-3CFCEDC0B8
  ///
  /// In id, this message translates to:
  /// **'Last Order'**
  String get hr3cfcedc0b8;

  /// Modul: instansi. Audit: HR-ID-CED3905EC8
  ///
  /// In id, this message translates to:
  /// **'Latitude'**
  String get hrced3905ec8;

  /// Modul: profile. Audit: HR-ID-5FCCCDCF1D
  ///
  /// In id, this message translates to:
  /// **'latitude'**
  String get hr5fcccdcf1d;

  /// Modul: instansi. Audit: HR-ID-6A811620D5
  ///
  /// In id, this message translates to:
  /// **'Latitude harus antara -90 dan 90'**
  String get hr6a811620d5;

  /// Modul: approval_center, home, overtime. Audit: HR-ID-37A85A234A
  ///
  /// In id, this message translates to:
  /// **'Lembur'**
  String get hr37a85a234a;

  /// Modul: pesan & model bersama. Audit: HR-ID-6FE6EF52E9
  ///
  /// In id, this message translates to:
  /// **'lembur'**
  String get hr6fe6ef52e9;

  /// Modul: home. Audit: HR-ID-74B7C9260E
  ///
  /// In id, this message translates to:
  /// **'Lembur dibatalkan'**
  String get hr74b7c9260e;

  /// Modul: home. Audit: HR-ID-2CF9134D4A
  ///
  /// In id, this message translates to:
  /// **'Lembur dimulai'**
  String get hr2cf9134d4a;

  /// Modul: app, home. Audit: HR-ID-1D99D868CE
  ///
  /// In id, this message translates to:
  /// **'Lembur setelah presensi pulang'**
  String get hr1d99d868ce;

  /// Modul: login. Audit: HR-ID-AA1EC1566C
  ///
  /// In id, this message translates to:
  /// **'Lengkapi akun Pantoo'**
  String get hraa1ec1566c;

  /// Modul: login. Audit: HR-ID-AD3F00A485
  ///
  /// In id, this message translates to:
  /// **'Lengkapi data berikut untuk membuat akun.'**
  String get hrad3f00a485;

  /// Modul: login. Audit: HR-ID-6FB687DF48
  ///
  /// In id, this message translates to:
  /// **'Lengkapi informasi akun untuk melanjutkan.'**
  String get hr6fb687df48;

  /// Modul: instansi. Audit: HR-ID-4D9339AF2B
  ///
  /// In id, this message translates to:
  /// **'Lengkapi Instansi'**
  String get hr4d9339af2b;

  /// Modul: komponen umum. Audit: HR-ID-AC5804B758
  ///
  /// In id, this message translates to:
  /// **'Lepas untuk memuat lagi'**
  String get hrac5804b758;

  /// Modul: komponen umum. Audit: HR-ID-EE28D1BC30
  ///
  /// In id, this message translates to:
  /// **'Level {nilai1}'**
  String hree28d1bc30(String nilai1);

  /// Modul: attendance. Audit: HR-ID-F55A0B8273
  ///
  /// In id, this message translates to:
  /// **'Libur'**
  String get hrf55a0b8273;

  /// Modul: profile. Audit: HR-ID-9EEF4ECFEF
  ///
  /// In id, this message translates to:
  /// **'Lihat daftar data offline yang belum terkirim ke server'**
  String get hr9eef4ecfef;

  /// Modul: payroll. Audit: HR-ID-2562CE6990
  ///
  /// In id, this message translates to:
  /// **'Lihat dan unduh slip gaji Anda'**
  String get hr2562ce6990;

  /// Modul: home. Audit: HR-ID-CBC5B9F17F
  ///
  /// In id, this message translates to:
  /// **'Lihat data offline'**
  String get hrcbc5b9f17f;

  /// Modul: apotek, kpi. Audit: HR-ID-A8F9F7A097
  ///
  /// In id, this message translates to:
  /// **'Lihat Detail'**
  String get hra8f9f7a097;

  /// Modul: komponen umum. Audit: HR-ID-0549D7646C
  ///
  /// In id, this message translates to:
  /// **'Lihat Lebih Sedikit'**
  String get hr0549d7646c;

  /// Modul: home. Audit: HR-ID-9527DD6545
  ///
  /// In id, this message translates to:
  /// **'Lihat semua'**
  String get hr9527dd6545;

  /// Modul: home. Audit: HR-ID-0854023F8B
  ///
  /// In id, this message translates to:
  /// **'Lihat {nilai1} aktivitas lainnya'**
  String hr0854023f8b(String nilai1);

  /// Modul: announcement. Audit: HR-ID-F55A6F9E6F
  ///
  /// In id, this message translates to:
  /// **'Link harus berupa URL http atau https yang lengkap'**
  String get hrf55a6f9e6f;

  /// Modul: announcement. Audit: HR-ID-6D12FA0200
  ///
  /// In id, this message translates to:
  /// **'Link Tujuan'**
  String get hr6d12fa0200;

  /// Modul: global. Audit: HR-ID-732D8287BE
  ///
  /// In id, this message translates to:
  /// **'Live tracking hanya menggunakan lokasi presisi saat sesi kerja aktif. Jika diperlukan, Pantoo akan meminta persetujuan Anda sebelum mengakses lokasi di latar belakang.'**
  String get hr732d8287be;

  /// Modul: sistem & komponen umum. Audit: HR-ID-D28A62B484
  ///
  /// In id, this message translates to:
  /// **'Live tracking Pantoo'**
  String get hrd28a62b484;

  /// Modul: sistem & komponen umum. Audit: HR-ID-B7E0E86BD6
  ///
  /// In id, this message translates to:
  /// **'Live tracking siap digunakan selama sesi kerja.'**
  String get hrb7e0e86bd6;

  /// Modul: intro. Audit: HR-ID-FC3B636C19
  ///
  /// In id, this message translates to:
  /// **'Live Tracking Transparan'**
  String get hrfc3b636c19;

  /// Modul: sistem & komponen umum. Audit: HR-ID-33B2D86200
  ///
  /// In id, this message translates to:
  /// **'Location service tidak aktif'**
  String get hr33b2d86200;

  /// Modul: home. Audit: HR-ID-78364E5D3D
  ///
  /// In id, this message translates to:
  /// **'Log Presensi Hari Ini'**
  String get hr78364e5d3d;

  /// Modul: home. Audit: HR-ID-A24404B3F7
  ///
  /// In id, this message translates to:
  /// **'Logbook'**
  String get hra24404b3f7;

  /// Modul: logbook. Audit: HR-ID-1D52AACAA1
  ///
  /// In id, this message translates to:
  /// **'Logbook berhasil dihapus'**
  String get hr1d52aacaa1;

  /// Modul: logbook. Audit: HR-ID-7814A13220
  ///
  /// In id, this message translates to:
  /// **'Logbook berhasil diperbarui'**
  String get hr7814a13220;

  /// Modul: logbook. Audit: HR-ID-10B915D28F
  ///
  /// In id, this message translates to:
  /// **'Logbook berhasil ditambahkan'**
  String get hr10b915d28f;

  /// Modul: home. Audit: HR-ID-0E28AE8EC4
  ///
  /// In id, this message translates to:
  /// **'Logbook Hari Ini'**
  String get hr0e28ae8ec4;

  /// Modul: home. Audit: HR-ID-9DD54C7BFA
  ///
  /// In id, this message translates to:
  /// **'Logbook hari ini belum dapat dimuat.'**
  String get hr9dd54c7bfa;

  /// Modul: logbook. Audit: HR-ID-1473E65000
  ///
  /// In id, this message translates to:
  /// **'Logbook Harian'**
  String get hr1473e65000;

  /// Modul: attendance. Audit: HR-ID-C58C55D060
  ///
  /// In id, this message translates to:
  /// **'Logbook Wajib Diisi'**
  String get hrc58c55d060;

  /// Modul: login. Audit: HR-ID-6706FA751E
  ///
  /// In id, this message translates to:
  /// **'Login gagal: {nilai1}'**
  String hr6706fa751e(String nilai1);

  /// Modul: login. Audit: HR-ID-B63F1D0BA8
  ///
  /// In id, this message translates to:
  /// **'Login Google belum berhasil. Coba lagi atau gunakan email dan password.'**
  String get hrb63f1d0ba8;

  /// Modul: login. Audit: HR-ID-FEBD44020F
  ///
  /// In id, this message translates to:
  /// **'Login Google belum berhasil. Silakan coba lagi.'**
  String get hrfebd44020f;

  /// Modul: login. Audit: HR-ID-604A057FBA
  ///
  /// In id, this message translates to:
  /// **'Login Google dibatalkan. Silakan pilih akun untuk melanjutkan.'**
  String get hr604a057fba;

  /// Modul: login. Audit: HR-ID-26B3E4142E
  ///
  /// In id, this message translates to:
  /// **'Login Google gagal. Silakan coba lagi.'**
  String get hr26b3e4142e;

  /// Modul: login. Audit: HR-ID-78A1383B4D
  ///
  /// In id, this message translates to:
  /// **'Login Google terlalu lama. Periksa koneksi lalu coba lagi.'**
  String get hr78a1383b4d;

  /// Modul: intro. Audit: HR-ID-4485B49941
  ///
  /// In id, this message translates to:
  /// **'Login sekarang dan rasakan kemudahannya'**
  String get hr4485b49941;

  /// Modul: login. Audit: HR-ID-532644563D
  ///
  /// In id, this message translates to:
  /// **'Login timeout. Periksa koneksi ke server.'**
  String get hr532644563d;

  /// Modul: sistem & komponen umum. Audit: HR-ID-E43D612E11
  ///
  /// In id, this message translates to:
  /// **'Logout'**
  String get hre43d612e11;

  /// Modul: login. Audit: HR-ID-623D2F7F2C
  ///
  /// In id, this message translates to:
  /// **'Logout gagal: {nilai1}'**
  String hr623d2f7f2c(String nilai1);

  /// Modul: login. Audit: HR-ID-DDAEC98595
  ///
  /// In id, this message translates to:
  /// **'Logout timeout. Sesi pada perangkat telah dibersihkan.'**
  String get hrddaec98595;

  /// Modul: activity, apotek, global. Audit: HR-ID-7E1AB5D94C
  ///
  /// In id, this message translates to:
  /// **'Lokasi'**
  String get hr7e1ab5d94c;

  /// Modul: pesan & model bersama. Audit: HR-ID-9C8096BB4C
  ///
  /// In id, this message translates to:
  /// **'lokasi'**
  String get hr9c8096bb4c;

  /// Modul: attendance. Audit: HR-ID-725F096543
  ///
  /// In id, this message translates to:
  /// **'Lokasi Anda Saat Ini'**
  String get hr725f096543;

  /// Modul: sistem & komponen umum. Audit: HR-ID-93F2E22FA1
  ///
  /// In id, this message translates to:
  /// **'Lokasi belum berhasil ditemukan. Pastikan layanan lokasi Windows aktif, lalu coba lagi.'**
  String get hr93f2e22fa1;

  /// Modul: attendance. Audit: HR-ID-87E924E135
  ///
  /// In id, this message translates to:
  /// **'Lokasi belum tersedia.'**
  String get hr87e924e135;

  /// Modul: global. Audit: HR-ID-2AF7C4DFAD
  ///
  /// In id, this message translates to:
  /// **'Lokasi dari browser ditemukan'**
  String get hr2af7c4dfad;

  /// Modul: sistem & komponen umum. Audit: HR-ID-5470F36A23
  ///
  /// In id, this message translates to:
  /// **'Lokasi dibagikan ke admin HR selama sesi kerja.'**
  String get hr5470f36a23;

  /// Modul: global. Audit: HR-ID-C625686EF2
  ///
  /// In id, this message translates to:
  /// **'Lokasi digunakan untuk presensi dan permintaan lokasi saat sesi kerja aktif. Browser dapat membatasi lokasi saat tab tidak aktif; pelacakan tidak berjalan setelah tab ditutup.'**
  String get hrc625686ef2;

  /// Modul: intro. Audit: HR-ID-852FAB3ACE
  ///
  /// In id, this message translates to:
  /// **'Lokasi hanya digunakan saat sesi kerja aktif dan setelah persetujuan Anda'**
  String get hr852fab3ace;

  /// Modul: instansi. Audit: HR-ID-F5DB63CC5E
  ///
  /// In id, this message translates to:
  /// **'Lokasi Instansi/Organisasi *'**
  String get hrf5db63cc5e;

  /// Modul: inventory. Audit: HR-ID-AA64823452
  ///
  /// In id, this message translates to:
  /// **'Lokasi Kejadian'**
  String get hraa64823452;

  /// Modul: inventory. Audit: HR-ID-5DEDCA6814
  ///
  /// In id, this message translates to:
  /// **'Lokasi stok'**
  String get hr5dedca6814;

  /// Modul: global. Audit: HR-ID-3EC3D6DBD8
  ///
  /// In id, this message translates to:
  /// **'Lokasi Terpilih'**
  String get hr3ec3d6dbd8;

  /// Modul: instansi. Audit: HR-ID-3068DF5C73
  ///
  /// In id, this message translates to:
  /// **'Lokasi tidak dapat diambil: {nilai1}'**
  String hr3068df5c73(String nilai1);

  /// Modul: attendance. Audit: HR-ID-C30D99A749
  ///
  /// In id, this message translates to:
  /// **'Lokasi wajib diisi'**
  String get hrc30d99a749;

  /// Modul: attendance. Audit: HR-ID-5157238409
  ///
  /// In id, this message translates to:
  /// **'Lokasi {nilai1}'**
  String hr5157238409(String nilai1);

  /// Modul: instansi. Audit: HR-ID-6F9F011C5D
  ///
  /// In id, this message translates to:
  /// **'Longitude'**
  String get hr6f9f011c5d;

  /// Modul: profile. Audit: HR-ID-D2A773AE81
  ///
  /// In id, this message translates to:
  /// **'longitude'**
  String get hrd2a773ae81;

  /// Modul: instansi. Audit: HR-ID-D023D3F1C8
  ///
  /// In id, this message translates to:
  /// **'Longitude harus antara -180 dan 180'**
  String get hrd023d3f1c8;

  /// Modul: delivery. Audit: HR-ID-E065B60384
  ///
  /// In id, this message translates to:
  /// **'Lunas'**
  String get hre065b60384;

  /// Modul: sistem & komponen umum. Audit: HR-ID-4A0F0CA9AC
  ///
  /// In id, this message translates to:
  /// **'Lupa Masuk'**
  String get hr4a0f0ca9ac;

  /// Modul: sistem & komponen umum. Audit: HR-ID-DAEE77C3A7
  ///
  /// In id, this message translates to:
  /// **'Lupa Masuk & Pulang'**
  String get hrdaee77c3a7;

  /// Modul: payroll. Audit: HR-ID-1D0244CEDA
  ///
  /// In id, this message translates to:
  /// **'Lupa Presensi'**
  String get hr1d0244ceda;

  /// Modul: sistem & komponen umum. Audit: HR-ID-911D4B1A7B
  ///
  /// In id, this message translates to:
  /// **'Lupa Presensi Masuk'**
  String get hr911d4b1a7b;

  /// Modul: sistem & komponen umum. Audit: HR-ID-76A5ED2DB5
  ///
  /// In id, this message translates to:
  /// **'Lupa Presensi Pulang'**
  String get hr76a5ed2db5;

  /// Modul: global. Audit: HR-ID-9340BA21A3
  ///
  /// In id, this message translates to:
  /// **'Maaf, Halaman ini dalam proses Pengembangan'**
  String get hr9340ba21a3;

  /// Modul: main. Audit: HR-ID-E396AC7CC1
  ///
  /// In id, this message translates to:
  /// **'Maaf, Notifikasi Anda tidak aktif'**
  String get hre396ac7cc1;

  /// Modul: global. Audit: HR-ID-BE730C0464
  ///
  /// In id, this message translates to:
  /// **'Maaf, pembaruan dibatalkan atau ditolak oleh pengguna. Silakan coba lagi nanti atau hubungi Pengembang.'**
  String get hrbe730c0464;

  /// Modul: global. Audit: HR-ID-B7DA9ACCBC
  ///
  /// In id, this message translates to:
  /// **'Maaf, terdapat kesalahan lain yang mencegah pengguna memberikan persetujuan atau pembaruan untuk dilanjutkan.'**
  String get hrb7da9accbc;

  /// Modul: attendance, attendance_request, leave, overtime, reimbursement. Audit: HR-ID-8B90A698E9
  ///
  /// In id, this message translates to:
  /// **'Maksimal {nilai1} file'**
  String hr8b90a698e9(String nilai1);

  /// Modul: intro. Audit: HR-ID-1B9BCD185F
  ///
  /// In id, this message translates to:
  /// **'Manajemen Presensi'**
  String get hr1b9bcd185f;

  /// Modul: attendance_request, common, leave, overtime, payroll, reimbursement, shift, sistem & komponen umum. Audit: HR-ID-6AC6938F30
  ///
  /// In id, this message translates to:
  /// **'Maret'**
  String get hr6ac6938f30;

  /// Modul: attendance, home, login. Audit: HR-ID-F2DD30734A. Presensi: Check In. Gunakan key signInAction untuk layar login.
  ///
  /// In id, this message translates to:
  /// **'Masuk'**
  String get hrf2dd30734a;

  /// Modul: login. Audit: HR-ID-6C19093E61
  ///
  /// In id, this message translates to:
  /// **'Masuk di sini'**
  String get hr6c19093e61;

  /// Modul: login. Audit: HR-ID-24707B514E
  ///
  /// In id, this message translates to:
  /// **'Masuk ke Akun Anda'**
  String get hr24707b514e;

  /// Modul: attendance, sistem & komponen umum. Audit: HR-ID-DDFC42B87B
  ///
  /// In id, this message translates to:
  /// **'Masuk Kerja'**
  String get hrddfc42b87b;

  /// Modul: attendance. Audit: HR-ID-C7C586F488
  ///
  /// In id, this message translates to:
  /// **'Masuk Standar'**
  String get hrc7c586f488;

  /// Modul: attendance_request. Audit: HR-ID-277964DC5C
  ///
  /// In id, this message translates to:
  /// **'Masuk: {nilai1}, Pulang: {nilai2}'**
  String hr277964dc5c(String nilai1, String nilai2);

  /// Modul: delivery. Audit: HR-ID-801044C2C1
  ///
  /// In id, this message translates to:
  /// **'Masukan Alasan Pembatalan'**
  String get hr801044c2c1;

  /// Modul: delivery. Audit: HR-ID-36D25904B7
  ///
  /// In id, this message translates to:
  /// **'Masukan Catatan (Optional)'**
  String get hr36d25904b7;

  /// Modul: apotek. Audit: HR-ID-984BA68103
  ///
  /// In id, this message translates to:
  /// **'Masukan detail alamat'**
  String get hr984ba68103;

  /// Modul: global. Audit: HR-ID-79209D2C65
  ///
  /// In id, this message translates to:
  /// **'Masukan lagi'**
  String get hr79209d2c65;

  /// Modul: apotek. Audit: HR-ID-BA5DEAC7E5
  ///
  /// In id, this message translates to:
  /// **'Masukan nama outlet'**
  String get hrba5deac7e5;

  /// Modul: apotek. Audit: HR-ID-51403E32DE
  ///
  /// In id, this message translates to:
  /// **'Masukan Nomor Telepon'**
  String get hr51403e32de;

  /// Modul: login. Audit: HR-ID-57B671DC16
  ///
  /// In id, this message translates to:
  /// **'Masukan password Anda'**
  String get hr57b671dc16;

  /// Modul: profile. Audit: HR-ID-D6C7540EB8
  ///
  /// In id, this message translates to:
  /// **'Masukan password baru'**
  String get hrd6c7540eb8;

  /// Modul: login. Audit: HR-ID-FC425423FC
  ///
  /// In id, this message translates to:
  /// **'Masukan URL server'**
  String get hrfc425423fc;

  /// Modul: login. Audit: HR-ID-91BB7A9081
  ///
  /// In id, this message translates to:
  /// **'Masukan username atau email Anda'**
  String get hr91bb7a9081;

  /// Modul: overtime. Audit: HR-ID-521105D5CE
  ///
  /// In id, this message translates to:
  /// **'Masukkan alasan lembur dan deskripsi pekerjaan yang akan dilakukan'**
  String get hr521105d5ce;

  /// Modul: shift. Audit: HR-ID-BD22D997EB
  ///
  /// In id, this message translates to:
  /// **'Masukkan alasan tukar shift'**
  String get hrbd22d997eb;

  /// Modul: attendance_request, leave. Audit: HR-ID-5E853912DB
  ///
  /// In id, this message translates to:
  /// **'Masukkan alasan untuk request ini'**
  String get hr5e853912db;

  /// Modul: attendance_request, leave, overtime, reimbursement, shift. Audit: HR-ID-F1A1583E07
  ///
  /// In id, this message translates to:
  /// **'Masukkan alasan...'**
  String get hrf1a1583e07;

  /// Modul: profile. Audit: HR-ID-5DB798CC87
  ///
  /// In id, this message translates to:
  /// **'Masukkan angka yang valid'**
  String get hr5db798cc87;

  /// Modul: attendance. Audit: HR-ID-7CBE658CB6
  ///
  /// In id, this message translates to:
  /// **'Masukkan catatan untuk kehadiran ini'**
  String get hr7cbe658cb6;

  /// Modul: attendance. Audit: HR-ID-DECA11BD55
  ///
  /// In id, this message translates to:
  /// **'Masukkan catatan untuk presensi ini'**
  String get hrdeca11bd55;

  /// Modul: reimbursement. Audit: HR-ID-75AD2239E5
  ///
  /// In id, this message translates to:
  /// **'Masukkan deskripsi'**
  String get hr75ad2239e5;

  /// Modul: delivery. Audit: HR-ID-827106C56E
  ///
  /// In id, this message translates to:
  /// **'Masukkan Diskon'**
  String get hr827106c56e;

  /// Modul: attendance_request. Audit: HR-ID-91EECF8F1F
  ///
  /// In id, this message translates to:
  /// **'Masukkan Jam Check In'**
  String get hr91eecf8f1f;

  /// Modul: attendance_request. Audit: HR-ID-6806CA3C81
  ///
  /// In id, this message translates to:
  /// **'Masukkan Jam Check Out'**
  String get hr6806ca3c81;

  /// Modul: overtime. Audit: HR-ID-C32D80BFEF
  ///
  /// In id, this message translates to:
  /// **'Masukkan Jam Mulai'**
  String get hrc32d80bfef;

  /// Modul: overtime. Audit: HR-ID-69B7A4BE1C
  ///
  /// In id, this message translates to:
  /// **'Masukkan Jam Selesai'**
  String get hr69b7a4be1c;

  /// Modul: reimbursement. Audit: HR-ID-2A90E1083F
  ///
  /// In id, this message translates to:
  /// **'Masukkan judul reimbursement'**
  String get hr2a90e1083f;

  /// Modul: login. Audit: HR-ID-CE86AF527C
  ///
  /// In id, this message translates to:
  /// **'Masukkan kode CAPTCHA'**
  String get hrce86af527c;

  /// Modul: login. Audit: HR-ID-E28ADBD35A
  ///
  /// In id, this message translates to:
  /// **'Masukkan kode pada gambar'**
  String get hre28adbd35a;

  /// Modul: login. Audit: HR-ID-8D71B8429F
  ///
  /// In id, this message translates to:
  /// **'Masukkan nama lengkap'**
  String get hr8d71b8429f;

  /// Modul: attendance. Audit: HR-ID-39066F8E78
  ///
  /// In id, this message translates to:
  /// **'Masukkan nama...'**
  String get hr39066f8e78;

  /// Modul: delivery, reimbursement. Audit: HR-ID-D6C3FFFE56
  ///
  /// In id, this message translates to:
  /// **'Masukkan nominal'**
  String get hrd6c3fffe56;

  /// Modul: delivery. Audit: HR-ID-C97714954B
  ///
  /// In id, this message translates to:
  /// **'Masukkan Nominal (Misal: 150000)'**
  String get hrc97714954b;

  /// Modul: loan. Audit: HR-ID-A4B94ECABD
  ///
  /// In id, this message translates to:
  /// **'Masukkan nominal minimal Rp 1.000'**
  String get hra4b94ecabd;

  /// Modul: leave. Audit: HR-ID-4862D84A0C
  ///
  /// In id, this message translates to:
  /// **'Masukkan nomor kontak darurat'**
  String get hr4862d84a0c;

  /// Modul: login. Audit: HR-ID-7844CE0F93
  ///
  /// In id, this message translates to:
  /// **'Masukkan nomor telepon 8–15 digit.'**
  String get hr7844ce0f93;

  /// Modul: login. Audit: HR-ID-90F49A0BFE
  ///
  /// In id, this message translates to:
  /// **'Masukkan username'**
  String get hr90f49a0bfe;

  /// Modul: profile. Audit: HR-ID-3DB7C11745
  ///
  /// In id, this message translates to:
  /// **'Masukkan {nilai1}'**
  String hr3db7c11745(String nilai1);

  /// Modul: instansi, reimbursement. Audit: HR-ID-34EB50DC01
  ///
  /// In id, this message translates to:
  /// **'Mata Uang'**
  String get hr34eb50dc01;

  /// Modul: reimbursement. Audit: HR-ID-A29C5D27E6
  ///
  /// In id, this message translates to:
  /// **'Mata Uang wajib diisi'**
  String get hra29c5d27e6;

  /// Modul: pesan & model bersama. Audit: HR-ID-34CCB673D7
  ///
  /// In id, this message translates to:
  /// **'Media tidak ditemukan'**
  String get hr34ccb673d7;

  /// Modul: attendance_request, common, leave, overtime, payroll, reimbursement, shift, sistem & komponen umum. Audit: HR-ID-ADAA5A858E
  ///
  /// In id, this message translates to:
  /// **'Mei'**
  String get hradaa5a858e;

  /// Modul: attendance. Audit: HR-ID-339AB7648E
  ///
  /// In id, this message translates to:
  /// **'Memperbarui izin presensi…'**
  String get hr339ab7648e;

  /// Modul: global. Audit: HR-ID-D1B4A76124
  ///
  /// In id, this message translates to:
  /// **'Memuat'**
  String get hrd1b4a76124;

  /// Modul: attendance. Audit: HR-ID-26B6FC553D
  ///
  /// In id, this message translates to:
  /// **'Memuat alamat...'**
  String get hr26b6fc553d;

  /// Modul: shift. Audit: HR-ID-9FDAB07722
  ///
  /// In id, this message translates to:
  /// **'Memuat jadwal shift tujuan...'**
  String get hr9fdab07722;

  /// Modul: apotek. Audit: HR-ID-7ACD84CCB3
  ///
  /// In id, this message translates to:
  /// **'Memuat kabupaten/kota...'**
  String get hr7acd84ccb3;

  /// Modul: apotek. Audit: HR-ID-4878B702DC
  ///
  /// In id, this message translates to:
  /// **'Memuat kode...'**
  String get hr4878b702dc;

  /// Modul: profile. Audit: HR-ID-DC10871FD5
  ///
  /// In id, this message translates to:
  /// **'Memuat langganan...'**
  String get hrdc10871fd5;

  /// Modul: inventory. Audit: HR-ID-2FA625FDF8
  ///
  /// In id, this message translates to:
  /// **'Memuat lokasi...'**
  String get hr2fa625fdf8;

  /// Modul: apotek. Audit: HR-ID-B3C8A58987
  ///
  /// In id, this message translates to:
  /// **'Memuat provinsi...'**
  String get hrb3c8a58987;

  /// Modul: komponen umum, leave. Audit: HR-ID-FBF20EAA3D
  ///
  /// In id, this message translates to:
  /// **'Memuat...'**
  String get hrfbf20eaa3d;

  /// Modul: activity. Audit: HR-ID-E5FF328645
  ///
  /// In id, this message translates to:
  /// **'Memvalidasi kehadiran...'**
  String get hre5ff328645;

  /// Modul: login. Audit: HR-ID-76C806883A
  ///
  /// In id, this message translates to:
  /// **'Memverifikasi akun ke Pantoo…'**
  String get hr76c806883a;

  /// Modul: global. Audit: HR-ID-3DFDC946A3
  ///
  /// In id, this message translates to:
  /// **'Mencari alamat...'**
  String get hr3dfdc946a3;

  /// Modul: attendance. Audit: HR-ID-2404B24191
  ///
  /// In id, this message translates to:
  /// **'Mencari lokasi anda...'**
  String get hr2404b24191;

  /// Modul: global. Audit: HR-ID-5D60C7067D
  ///
  /// In id, this message translates to:
  /// **'Mencari lokasi browser…'**
  String get hr5d60c7067d;

  /// Modul: global. Audit: HR-ID-B0D2F76C19
  ///
  /// In id, this message translates to:
  /// **'Mencari lokasi...'**
  String get hrb0d2f76c19;

  /// Modul: delivery. Audit: HR-ID-A2B71C80DA
  ///
  /// In id, this message translates to:
  /// **'menunggu'**
  String get hra2b71c80da;

  /// Modul: home, payroll. Audit: HR-ID-BCC4A60693
  ///
  /// In id, this message translates to:
  /// **'Menunggu'**
  String get hrbcc4a60693;

  /// Modul: profile. Audit: HR-ID-2B44BB2653
  ///
  /// In id, this message translates to:
  /// **'Menunggu dukungan sinkronisasi'**
  String get hr2b44bb2653;

  /// Modul: kpi. Audit: HR-ID-DA02F4FD04
  ///
  /// In id, this message translates to:
  /// **'Menunggu Konfirmasi'**
  String get hrda02f4fd04;

  /// Modul: login. Audit: HR-ID-53A70FE7D7
  ///
  /// In id, this message translates to:
  /// **'Menunggu pilihan akun Google…'**
  String get hr53a70fe7d7;

  /// Modul: kpi. Audit: HR-ID-34D9089374
  ///
  /// In id, this message translates to:
  /// **'Menunggu Review'**
  String get hr34d9089374;

  /// Modul: login. Audit: HR-ID-D821F108B3
  ///
  /// In id, this message translates to:
  /// **'Menyelesaikan login akun…'**
  String get hrd821f108b3;

  /// Modul: login. Audit: HR-ID-090296B76C
  ///
  /// In id, this message translates to:
  /// **'Menyiapkan login Google…'**
  String get hr090296b76c;

  /// Modul: profile. Audit: HR-ID-EC7CFC9498
  ///
  /// In id, this message translates to:
  /// **'Merk/Plat Nomor'**
  String get hrec7cfc9498;

  /// Modul: development. Audit: HR-ID-C110F6FB3E
  ///
  /// In id, this message translates to:
  /// **'Messaging Sender Id'**
  String get hrc110f6fb3e;

  /// Modul: delivery, order. Audit: HR-ID-2A5040BD10
  ///
  /// In id, this message translates to:
  /// **'Metode Pembayaran'**
  String get hr2a5040bd10;

  /// Modul: login. Audit: HR-ID-4A17A8955B
  ///
  /// In id, this message translates to:
  /// **'Minimal 8 karakter'**
  String get hr4a17a8955b;

  /// Modul: inventory. Audit: HR-ID-17B297A662
  ///
  /// In id, this message translates to:
  /// **'Mis: 10'**
  String get hr17b297a662;

  /// Modul: inventory. Audit: HR-ID-EEBAECFA37
  ///
  /// In id, this message translates to:
  /// **'Mis: 8'**
  String get hreebaecfa37;

  /// Modul: leave. Audit: HR-ID-218984EC57
  ///
  /// In id, this message translates to:
  /// **'Mode Cuti'**
  String get hr218984ec57;

  /// Modul: leave. Audit: HR-ID-D23BF0915E
  ///
  /// In id, this message translates to:
  /// **'Mode Cuti wajib dipilih'**
  String get hrd23bf0915e;

  /// Modul: delivery. Audit: HR-ID-3E0F043DEE
  ///
  /// In id, this message translates to:
  /// **'Mode Hybrid: Nominal transaksi & no referensi akan diinput manual saat pemeriksaan kunjungan.'**
  String get hr3e0f043dee;

  /// Modul: home. Audit: HR-ID-E823D4C5E0
  ///
  /// In id, this message translates to:
  /// **'Mode lembur akan dihentikan tanpa menyimpan request lembur.'**
  String get hre823d4c5e0;

  /// Modul: intro. Audit: HR-ID-1E136102E0
  ///
  /// In id, this message translates to:
  /// **'Monitor produktivitas tim'**
  String get hr1e136102e0;

  /// Modul: profile. Audit: HR-ID-F55D06444F
  ///
  /// In id, this message translates to:
  /// **'Muat ulang QR'**
  String get hrf55d06444f;

  /// Modul: intro. Audit: HR-ID-9EC2D52493
  ///
  /// In id, this message translates to:
  /// **'Mudah Digunakan'**
  String get hr9ec2d52493;

  /// Modul: announcement. Audit: HR-ID-66A1CDC217
  ///
  /// In id, this message translates to:
  /// **'Mulai *'**
  String get hr66a1cdc217;

  /// Modul: sistem & komponen umum. Audit: HR-ID-821CEA6E58
  ///
  /// In id, this message translates to:
  /// **'Mulai Kerja'**
  String get hr821cea6e58;

  /// Modul: intro. Audit: HR-ID-6ABCBEBC33
  ///
  /// In id, this message translates to:
  /// **'Mulai Lebih Cepat'**
  String get hr6abcbebc33;

  /// Modul: home, main. Audit: HR-ID-71877820D9
  ///
  /// In id, this message translates to:
  /// **'Mulai Lembur'**
  String get hr71877820d9;

  /// Modul: chat. Audit: HR-ID-797ED96581
  ///
  /// In id, this message translates to:
  /// **'Mulai percakapan baru dengan\nmenekan tombol pesan di bawah'**
  String get hr797ed96581;

  /// Modul: intro. Audit: HR-ID-7C4BD6C9B2
  ///
  /// In id, this message translates to:
  /// **'Mulai Sekarang'**
  String get hr7c4bd6c9b2;

  /// Modul: logbook. Audit: HR-ID-15677980E4
  ///
  /// In id, this message translates to:
  /// **'Mulai{nilai1}'**
  String hr15677980e4(String nilai1);

  /// Modul: sistem & komponen umum. Audit: HR-ID-D3977E1794
  ///
  /// In id, this message translates to:
  /// **'MXN — Peso Meksiko'**
  String get hrd3977e1794;

  /// Modul: sistem & komponen umum. Audit: HR-ID-82EA480BBE
  ///
  /// In id, this message translates to:
  /// **'MYR — Ringgit Malaysia'**
  String get hr82ea480bbe;

  /// Modul: pesan & model bersama. Audit: HR-ID-6C1FEC6E0D
  ///
  /// In id, this message translates to:
  /// **'nama'**
  String get hr6c1fec6e0d;

  /// Modul: login. Audit: HR-ID-59E1810978
  ///
  /// In id, this message translates to:
  /// **'Nama dan email menggunakan akun Google Anda. Tambahkan nomor telepon untuk melanjutkan.'**
  String get hr59e1810978;

  /// Modul: chat. Audit: HR-ID-B58CB660FB
  ///
  /// In id, this message translates to:
  /// **'Nama Grup (Wajib)'**
  String get hrb58cb660fb;

  /// Modul: chat. Audit: HR-ID-BF196F9FFA
  ///
  /// In id, this message translates to:
  /// **'Nama grup tidak boleh kosong'**
  String get hrbf196f9ffa;

  /// Modul: instansi, profile. Audit: HR-ID-4865DD906D
  ///
  /// In id, this message translates to:
  /// **'Nama Instansi/Organisasi'**
  String get hr4865dd906d;

  /// Modul: logbook. Audit: HR-ID-26C34B4E54
  ///
  /// In id, this message translates to:
  /// **'Nama Kategori Baru'**
  String get hr26c34b4e54;

  /// Modul: logbook. Audit: HR-ID-DF2D8B39A8
  ///
  /// In id, this message translates to:
  /// **'Nama kategori wajib diisi'**
  String get hrdf2d8b39a8;

  /// Modul: login, profile. Audit: HR-ID-A411FCE007
  ///
  /// In id, this message translates to:
  /// **'Nama Lengkap'**
  String get hra411fce007;

  /// Modul: login. Audit: HR-ID-51EBF3BF64
  ///
  /// In id, this message translates to:
  /// **'Nama Lengkap minimal 3 karakter'**
  String get hr51ebf3bf64;

  /// Modul: activity. Audit: HR-ID-C520325621
  ///
  /// In id, this message translates to:
  /// **'Nama lokasi'**
  String get hrc520325621;

  /// Modul: apotek. Audit: HR-ID-DC1089E9F1
  ///
  /// In id, this message translates to:
  /// **'Nama Outlet'**
  String get hrdc1089e9f1;

  /// Modul: apotek. Audit: HR-ID-7ED7F3B078
  ///
  /// In id, this message translates to:
  /// **'Nama Pemilik'**
  String get hr7ed7f3b078;

  /// Modul: profile. Audit: HR-ID-662805AEA4
  ///
  /// In id, this message translates to:
  /// **'Nama Resmi'**
  String get hr662805aea4;

  /// Modul: shift. Audit: HR-ID-69753307E4
  ///
  /// In id, this message translates to:
  /// **'Nama Shift'**
  String get hr69753307e4;

  /// Modul: main. Audit: HR-ID-B96E006284
  ///
  /// In id, this message translates to:
  /// **'Nanti'**
  String get hrb96e006284;

  /// Modul: inventory. Audit: HR-ID-8DBD58EDAB
  ///
  /// In id, this message translates to:
  /// **'Net Lost'**
  String get hr8dbd58edab;

  /// Modul: delivery. Audit: HR-ID-BCDC5E2CCF
  ///
  /// In id, this message translates to:
  /// **'Net Sales'**
  String get hrbcdc5e2ccf;

  /// Modul: sistem & komponen umum. Audit: HR-ID-FFA4DF9809
  ///
  /// In id, this message translates to:
  /// **'NGN — Naira Nigeria'**
  String get hrffa4df9809;

  /// Modul: kpi. Audit: HR-ID-C113455EA5
  ///
  /// In id, this message translates to:
  /// **'Nilai akhir KPI akan dihitung dan disimpan. Koreksi presensi yang disetujui dapat meminta review ulang.'**
  String get hrc113455ea5;

  /// Modul: kpi. Audit: HR-ID-0852015F74
  ///
  /// In id, this message translates to:
  /// **'Nilai pemeriksa: {nilai1} / 5 • Kontribusi: {nilai2}'**
  String hr0852015f74(String nilai1, String nilai2);

  /// Modul: sistem & komponen umum. Audit: HR-ID-74A40690E0
  ///
  /// In id, this message translates to:
  /// **'No address found for the given location'**
  String get hr74a40690e0;

  /// Modul: pesan & model bersama. Audit: HR-ID-51F5AF55EA
  ///
  /// In id, this message translates to:
  /// **'No data returned'**
  String get hr51f5af55ea;

  /// Modul: pesan & model bersama. Audit: HR-ID-549961947D
  ///
  /// In id, this message translates to:
  /// **'No Internet Connection'**
  String get hr549961947d;

  /// Modul: delivery. Audit: HR-ID-9557DF750E
  ///
  /// In id, this message translates to:
  /// **'No Order / Faktur'**
  String get hr9557df750e;

  /// Modul: delivery. Audit: HR-ID-05186B42EC
  ///
  /// In id, this message translates to:
  /// **'No Order Ref'**
  String get hr05186b42ec;

  /// Modul: delivery. Audit: HR-ID-6792F66E92
  ///
  /// In id, this message translates to:
  /// **'No Referensi / Faktur'**
  String get hr6792f66e92;

  /// Modul: delivery. Audit: HR-ID-61A2429FCD
  ///
  /// In id, this message translates to:
  /// **'No Referensi / Faktur / DO'**
  String get hr61a2429fcd;

  /// Modul: delivery. Audit: HR-ID-0D4CAF9AC1
  ///
  /// In id, this message translates to:
  /// **'No Referensi dari Admin:'**
  String get hr0d4caf9ac1;

  /// Modul: delivery. Audit: HR-ID-583F48CF75
  ///
  /// In id, this message translates to:
  /// **'No Referensi DO'**
  String get hr583f48cf75;

  /// Modul: delivery. Audit: HR-ID-53E547C617
  ///
  /// In id, this message translates to:
  /// **'No Telepon Outlet'**
  String get hr53e547c617;

  /// Modul: profile. Audit: HR-ID-0FFB8EF82A
  ///
  /// In id, this message translates to:
  /// **'No. Telepon'**
  String get hr0ffb8ef82a;

  /// Modul: sistem & komponen umum. Audit: HR-ID-8B25B4824B
  ///
  /// In id, this message translates to:
  /// **'NOK — Krone Norwegia'**
  String get hr8b25b4824b;

  /// Modul: reimbursement. Audit: HR-ID-1795D16338
  ///
  /// In id, this message translates to:
  /// **'Nominal'**
  String get hr1795d16338;

  /// Modul: delivery. Audit: HR-ID-475B15A97B
  ///
  /// In id, this message translates to:
  /// **'Nominal Berhasil Ditagih (Rp)'**
  String get hr475b15a97b;

  /// Modul: loan. Audit: HR-ID-5D2692798F
  ///
  /// In id, this message translates to:
  /// **'Nominal Pinjaman'**
  String get hr5d2692798f;

  /// Modul: delivery. Audit: HR-ID-0972BA7FB8
  ///
  /// In id, this message translates to:
  /// **'Nominal Transaksi (Rp)'**
  String get hr0972ba7fb8;

  /// Modul: reimbursement. Audit: HR-ID-0C2FB8F616
  ///
  /// In id, this message translates to:
  /// **'Nominal wajib diisi'**
  String get hr0c2fb8f616;

  /// Modul: loan. Audit: HR-ID-248F36068D
  ///
  /// In id, this message translates to:
  /// **'Nominal: Rp {nilai1}'**
  String hr248f36068d(String nilai1);

  /// Modul: loan. Audit: HR-ID-CC15A9A584
  ///
  /// In id, this message translates to:
  /// **'Nomor Pinjaman: {nilai1}'**
  String hrcc15a9a584(String nilai1);

  /// Modul: apotek, login. Audit: HR-ID-8826DED5E7
  ///
  /// In id, this message translates to:
  /// **'Nomor Telepon'**
  String get hr8826ded5e7;

  /// Modul: login. Audit: HR-ID-F2DF3517C2
  ///
  /// In id, this message translates to:
  /// **'Nomor telepon'**
  String get hrf2df3517c2;

  /// Modul: login. Audit: HR-ID-9EFB9DA8A1
  ///
  /// In id, this message translates to:
  /// **'Nomor telepon harus 8-15 digit angka'**
  String get hr9efb9da8a1;

  /// Modul: instansi, profile. Audit: HR-ID-4F5A1C08BB
  ///
  /// In id, this message translates to:
  /// **'Nomor Telepon Instansi/Organisasi'**
  String get hr4f5a1c08bb;

  /// Modul: apotek. Audit: HR-ID-609449CA31
  ///
  /// In id, this message translates to:
  /// **'Nonaktif'**
  String get hr609449ca31;

  /// Modul: delivery. Audit: HR-ID-A01E18E959
  ///
  /// In id, this message translates to:
  /// **'NOO (NEW OPEN OUTLET)'**
  String get hra01e18e959;

  /// Modul: notification, pesan & model bersama. Audit: HR-ID-624D215CD1
  ///
  /// In id, this message translates to:
  /// **'Notifikasi'**
  String get hr624d215cd1;

  /// Modul: pesan & model bersama. Audit: HR-ID-9FD3EA1D37
  ///
  /// In id, this message translates to:
  /// **'notifikasi'**
  String get hr9fd3ea1d37;

  /// Modul: sistem & komponen umum. Audit: HR-ID-C94F6DC9AA
  ///
  /// In id, this message translates to:
  /// **'Notifikasi utama aplikasi'**
  String get hrc94f6dc9aa;

  /// Modul: attendance_request, common, leave, overtime, payroll, reimbursement, shift, sistem & komponen umum. Audit: HR-ID-3C5BF776F5
  ///
  /// In id, this message translates to:
  /// **'November'**
  String get hr3c5bf776f5;

  /// Modul: sistem & komponen umum. Audit: HR-ID-7B6C3D2AEE
  ///
  /// In id, this message translates to:
  /// **'NZD — Dollar Selandia Baru'**
  String get hr7b6c3d2aee;

  /// Modul: attendance_request, common, leave, overtime, payroll, reimbursement, shift, sistem & komponen umum. Audit: HR-ID-EF2A598352
  ///
  /// In id, this message translates to:
  /// **'Oktober'**
  String get href2a598352;

  /// Modul: attendance. Audit: HR-ID-E4E002D5AA
  ///
  /// In id, this message translates to:
  /// **'On Call'**
  String get hre4e002d5aa;

  /// Modul: attendance. Audit: HR-ID-6F0550213E
  ///
  /// In id, this message translates to:
  /// **'oncall'**
  String get hr6f0550213e;

  /// Modul: survey. Audit: HR-ID-CF04876296
  ///
  /// In id, this message translates to:
  /// **'Opsional'**
  String get hrcf04876296;

  /// Modul: order. Audit: HR-ID-C590A4DAE6
  ///
  /// In id, this message translates to:
  /// **'Order Berhasil Dibuat'**
  String get hrc590a4dae6;

  /// Modul: order. Audit: HR-ID-0B804E5A19
  ///
  /// In id, this message translates to:
  /// **'Order gagal diproses, silakan coba lagi'**
  String get hr0b804e5a19;

  /// Modul: delivery, home. Audit: HR-ID-1C623FAE0B
  ///
  /// In id, this message translates to:
  /// **'Outlet'**
  String get hr1c623fae0b;

  /// Modul: order. Audit: HR-ID-BF3A533285
  ///
  /// In id, this message translates to:
  /// **'Outlet / Customer'**
  String get hrbf3a533285;

  /// Modul: apotek. Audit: HR-ID-500E0401AB
  ///
  /// In id, this message translates to:
  /// **'Outlet Baru berhasil dibuat'**
  String get hr500e0401ab;

  /// Modul: apotek. Audit: HR-ID-B586D1E85A
  ///
  /// In id, this message translates to:
  /// **'Outlet Tanpa Nama'**
  String get hrb586d1e85a;

  /// Modul: profile. Audit: HR-ID-E82856B423
  ///
  /// In id, this message translates to:
  /// **'Outlet Tidak Diketahui'**
  String get hre82856b423;

  /// Modul: apotek. Audit: HR-ID-48ED07B336
  ///
  /// In id, this message translates to:
  /// **'Outlet tidak ditemukan'**
  String get hr48ed07b336;

  /// Modul: profile. Audit: HR-ID-A81C113FD5
  ///
  /// In id, this message translates to:
  /// **'Panduan penggunaan aplikasi dan FAQ'**
  String get hra81c113fd5;

  /// Modul: home. Audit: HR-ID-B72B1C6E5C
  ///
  /// In id, this message translates to:
  /// **'Pantau aktivitas pekerjaanmu'**
  String get hrb72b1c6e5c;

  /// Modul: intro. Audit: HR-ID-909CFA74D2
  ///
  /// In id, this message translates to:
  /// **'Pantau rute dan pengantaran real-time'**
  String get hr909cfa74d2;

  /// Modul: sistem & komponen umum. Audit: HR-ID-8DD2000D4E
  ///
  /// In id, this message translates to:
  /// **'Pantoo - Pelacakan aktif'**
  String get hr8dd2000d4e;

  /// Modul: sistem & komponen umum. Audit: HR-ID-C658279346
  ///
  /// In id, this message translates to:
  /// **'Pantoo - Sesi kerja aktif'**
  String get hrc658279346;

  /// Modul: komponen umum. Audit: HR-ID-31E91320B1
  ///
  /// In id, this message translates to:
  /// **'Pantoo HR'**
  String get hr31e91320b1;

  /// Modul: sistem & komponen umum. Audit: HR-ID-2A58D55363
  ///
  /// In id, this message translates to:
  /// **'Pantoo HR [DEV]'**
  String get hr2a58d55363;

  /// Modul: sistem & komponen umum. Audit: HR-ID-A9C3DFD52B
  ///
  /// In id, this message translates to:
  /// **'Pantoo HR [STG]'**
  String get hra9c3dfd52b;

  /// Modul: sistem & komponen umum. Audit: HR-ID-8BAA1FA352
  ///
  /// In id, this message translates to:
  /// **'Pantoo HR belum dapat dibuka. Tutup lalu buka kembali aplikasi. Data tersimpan tidak dihapus.'**
  String get hr8baa1fa352;

  /// Modul: global. Audit: HR-ID-8E928ECF6B
  ///
  /// In id, this message translates to:
  /// **'Pantoo menggunakan dan mengirimkan lokasi presisi untuk presensi dan permintaan lokasi selama sesi kerja aktif. Lokasi dapat dilihat oleh admin HR perusahaan yang berwenang.\n\nBrowser dapat membatasi akses lokasi saat tab tidak aktif. Pelacakan tidak berjalan setelah tab ditutup. Untuk pelacakan latar belakang, gunakan aplikasi Android.\n\nLokasi tidak digunakan untuk iklan. Anda dapat menolak; fitur yang tidak memerlukan lokasi tetap dapat digunakan.'**
  String get hr8e928ecf6b;

  /// Modul: global. Audit: HR-ID-4280A55571
  ///
  /// In id, this message translates to:
  /// **'Pantoo mengumpulkan dan mengirimkan data lokasi presisi untuk mengaktifkan presensi serta live tracking sesi kerja dan lembur, termasuk saat aplikasi ditutup atau tidak sedang digunakan.\n\nLokasi dikirim secara aman ke server Pantoo dan dapat dilihat oleh admin HR perusahaan yang berwenang untuk memantau sesi kerja.\n\nLokasi tidak digunakan untuk iklan, tidak dibagikan untuk tujuan lain, dan pelacakan berhenti otomatis saat check-out atau logout. Anda dapat menolak; fitur Pantoo yang tidak memerlukan live tracking tetap dapat digunakan.'**
  String get hr4280a55571;

  /// Modul: sistem & komponen umum. Audit: HR-ID-1288380317
  ///
  /// In id, this message translates to:
  /// **'Pantoo Notifikasi'**
  String get hr1288380317;

  /// Modul: login. Audit: HR-ID-8BE3C943B1
  ///
  /// In id, this message translates to:
  /// **'Password'**
  String get hr8be3c943b1;

  /// Modul: profile. Audit: HR-ID-D07C832D6E
  ///
  /// In id, this message translates to:
  /// **'Password Baru'**
  String get hrd07c832d6e;

  /// Modul: login. Audit: HR-ID-AAF0A22FD3
  ///
  /// In id, this message translates to:
  /// **'Password minimal 8 karakter'**
  String get hraaf0a22fd3;

  /// Modul: sistem & komponen umum. Audit: HR-ID-146E135483
  ///
  /// In id, this message translates to:
  /// **'Password tidak sama!'**
  String get hr146e135483;

  /// Modul: common. Audit: HR-ID-49CE20F639
  ///
  /// In id, this message translates to:
  /// **'Pastikan hanya satu wajah berada di dalam kamera.'**
  String get hr49ce20f639;

  /// Modul: kpi. Audit: HR-ID-2412328830
  ///
  /// In id, this message translates to:
  /// **'Pastikan seluruh nilai sudah benar. Setelah dikirim, penilaian akan masuk ke tahap review manager.'**
  String get hr2412328830;

  /// Modul: common. Audit: HR-ID-67FFD43A27
  ///
  /// In id, this message translates to:
  /// **'Pastikan wajah anda terlihat jelas'**
  String get hr67ffd43a27;

  /// Modul: common. Audit: HR-ID-554FD93AAD
  ///
  /// In id, this message translates to:
  /// **'Pastikan wajah terlihat jelas, lalu ambil foto'**
  String get hr554fd93aad;

  /// Modul: payroll. Audit: HR-ID-CF29229A27
  ///
  /// In id, this message translates to:
  /// **'Payroll berhasil disetujui'**
  String get hrcf29229a27;

  /// Modul: payroll. Audit: HR-ID-47AE87716B
  ///
  /// In id, this message translates to:
  /// **'Payroll berhasil ditolak'**
  String get hr47ae87716b;

  /// Modul: payroll. Audit: HR-ID-4A7EED396D
  ///
  /// In id, this message translates to:
  /// **'PDF tidak dapat dibuka: {nilai1}'**
  String hr4a7eed396d(String nilai1);

  /// Modul: global. Audit: HR-ID-A13FCF12EA
  ///
  /// In id, this message translates to:
  /// **'Pdf Viewer'**
  String get hra13fcf12ea;

  /// Modul: profile. Audit: HR-ID-F0170824B8
  ///
  /// In id, this message translates to:
  /// **'Pekerjaan & Status'**
  String get hrf0170824b8;

  /// Modul: delivery. Audit: HR-ID-84A33C51CA
  ///
  /// In id, this message translates to:
  /// **'Pembatalan Kunjungan'**
  String get hr84a33c51ca;

  /// Modul: delivery. Audit: HR-ID-E027CF092A
  ///
  /// In id, this message translates to:
  /// **'Pembatalan Kunjungan Berhasil'**
  String get hre027cf092a;

  /// Modul: sistem & komponen umum. Audit: HR-ID-7F49A66F84
  ///
  /// In id, this message translates to:
  /// **'Pemberitahuan {par0} dihapus!'**
  String hr7f49a66f84(String par0);

  /// Modul: delivery. Audit: HR-ID-24E80C3C09
  ///
  /// In id, this message translates to:
  /// **'Pemeriksaan Kunjungan'**
  String get hr24e80c3c09;

  /// Modul: delivery. Audit: HR-ID-848EF9EDA8
  ///
  /// In id, this message translates to:
  /// **'Pemeriksaan Kunjungan Berhasil'**
  String get hr848ef9eda8;

  /// Modul: apotek. Audit: HR-ID-BE44A1E515
  ///
  /// In id, this message translates to:
  /// **'Pemilik'**
  String get hrbe44a1e515;

  /// Modul: delivery. Audit: HR-ID-CFACDA3535
  ///
  /// In id, this message translates to:
  /// **'Penagihan'**
  String get hrcfacda3535;

  /// Modul: apotek. Audit: HR-ID-977368B4E1
  ///
  /// In id, this message translates to:
  /// **'Penanggung Jawab'**
  String get hr977368b4e1;

  /// Modul: delivery. Audit: HR-ID-2578DAEEB2
  ///
  /// In id, this message translates to:
  /// **'Penawaran (SO)'**
  String get hr2578daeeb2;

  /// Modul: dashboard. Audit: HR-ID-4BBD4822EA
  ///
  /// In id, this message translates to:
  /// **'Pencapaian Target ({nilai1})'**
  String hr4bbd4822ea(String nilai1);

  /// Modul: sistem & komponen umum. Audit: HR-ID-9ADEEE11B8
  ///
  /// In id, this message translates to:
  /// **'Pencarian lokasi terlalu lama. Pastikan layanan lokasi Windows aktif, lalu coba lagi.'**
  String get hr9adeee11b8;

  /// Modul: payroll. Audit: HR-ID-E6613846F4
  ///
  /// In id, this message translates to:
  /// **'Pendapatan'**
  String get hre6613846f4;

  /// Modul: dashboard, leave. Audit: HR-ID-96F608C16C
  ///
  /// In id, this message translates to:
  /// **'Pending'**
  String get hr96f608c16c;

  /// Modul: attendance_request, leave, loan, overtime, reimbursement, shift. Audit: HR-ID-BAF17BA654
  ///
  /// In id, this message translates to:
  /// **'Pengajuan gagal diproses, silakan coba lagi'**
  String get hrbaf17ba654;

  /// Modul: overtime. Audit: HR-ID-9F2F7E2269
  ///
  /// In id, this message translates to:
  /// **'Pengajuan lembur berhasil dihapus'**
  String get hr9f2f7e2269;

  /// Modul: home, komponen umum, payroll. Audit: HR-ID-EFA80957EE
  ///
  /// In id, this message translates to:
  /// **'Pengajuan Saya'**
  String get hrefa80957ee;

  /// Modul: delivery. Audit: HR-ID-87D0361C2D
  ///
  /// In id, this message translates to:
  /// **'Pengajuan update koordinat berhasil dikirim.'**
  String get hr87d0361c2d;

  /// Modul: shift. Audit: HR-ID-9541149429
  ///
  /// In id, this message translates to:
  /// **'Pengajuan yang dibatalkan tidak dapat diproses kembali.'**
  String get hr9541149429;

  /// Modul: leave, overtime, reimbursement. Audit: HR-ID-F2A0673FF7
  ///
  /// In id, this message translates to:
  /// **'Pengajuan yang dihapus tidak dapat dikembalikan.'**
  String get hrf2a0673ff7;

  /// Modul: delivery. Audit: HR-ID-4976C22C7C
  ///
  /// In id, this message translates to:
  /// **'Pengantaran (DO)'**
  String get hr4976c22c7c;

  /// Modul: profile. Audit: HR-ID-8EAE390AA4
  ///
  /// In id, this message translates to:
  /// **'Pengaturan Akun'**
  String get hr8eae390aa4;

  /// Modul: main. Audit: HR-ID-65CB50272B
  ///
  /// In id, this message translates to:
  /// **'Pengaturan aplikasi tidak dapat dibuka.'**
  String get hr65cb50272b;

  /// Modul: attendance. Audit: HR-ID-8B95343303
  ///
  /// In id, this message translates to:
  /// **'Pengaturan belum dapat dimuat. Periksa koneksi lalu coba lagi.'**
  String get hr8b95343303;

  /// Modul: attendance. Audit: HR-ID-5B98BA7DC8
  ///
  /// In id, this message translates to:
  /// **'Pengaturan presensi belum tersedia'**
  String get hr5b98ba7dc8;

  /// Modul: chat, pesan & model bersama. Audit: HR-ID-B228A74129
  ///
  /// In id, this message translates to:
  /// **'Pengguna tidak ditemukan'**
  String get hrb228a74129;

  /// Modul: chat. Audit: HR-ID-AB86957E60
  ///
  /// In id, this message translates to:
  /// **'Pengguna tidak valid.'**
  String get hrab86957e60;

  /// Modul: profile. Audit: HR-ID-0033434D83
  ///
  /// In id, this message translates to:
  /// **'Pengingat Servis pada Kilometer'**
  String get hr0033434d83;

  /// Modul: kalender. Audit: HR-ID-AF31F821E5
  ///
  /// In id, this message translates to:
  /// **'Pengulangan mengikuti tanggal awal. Bulan atau tahun tanpa tanggal tersebut dilewati.'**
  String get hraf31f821e5;

  /// Modul: announcement, home. Audit: HR-ID-C02BAD0843
  ///
  /// In id, this message translates to:
  /// **'Pengumuman'**
  String get hrc02bad0843;

  /// Modul: announcement. Audit: HR-ID-2828442BA5
  ///
  /// In id, this message translates to:
  /// **'Pengumuman \"{nilai1}\" akan dihapus.'**
  String hr2828442ba5(String nilai1);

  /// Modul: announcement. Audit: HR-ID-1498F183C6
  ///
  /// In id, this message translates to:
  /// **'Pengumuman berhasil dihapus'**
  String get hr1498f183c6;

  /// Modul: announcement. Audit: HR-ID-03126BA56F
  ///
  /// In id, this message translates to:
  /// **'Pengumuman berhasil diperbarui'**
  String get hr03126ba56f;

  /// Modul: announcement. Audit: HR-ID-0DC98A64A8
  ///
  /// In id, this message translates to:
  /// **'Pengumuman berhasil ditambahkan'**
  String get hr0dc98a64a8;

  /// Modul: kpi. Audit: HR-ID-99CF1F1471
  ///
  /// In id, this message translates to:
  /// **'Penilaian Anda'**
  String get hr99cf1f1471;

  /// Modul: kpi. Audit: HR-ID-1001CE6AED
  ///
  /// In id, this message translates to:
  /// **'Penilaian Kinerja (KPI)'**
  String get hr1001ce6aed;

  /// Modul: kpi. Audit: HR-ID-E677141F7C
  ///
  /// In id, this message translates to:
  /// **'Penilaian pribadi sebelumnya'**
  String get hre677141f7c;

  /// Modul: attendance_request, leave, overtime, reimbursement. Audit: HR-ID-7174F518C9
  ///
  /// In id, this message translates to:
  /// **'Penolakan'**
  String get hr7174f518c9;

  /// Modul: attendance. Audit: HR-ID-032324AE7A
  ///
  /// In id, this message translates to:
  /// **'Perbarui'**
  String get hr032324ae7a;

  /// Modul: attendance. Audit: HR-ID-BDAC6ACAE8
  ///
  /// In id, this message translates to:
  /// **'Perbarui data terlebih dahulu sebelum melakukan presensi.'**
  String get hrbdac6acae8;

  /// Modul: profile. Audit: HR-ID-A94920E652
  ///
  /// In id, this message translates to:
  /// **'Perbarui Kendaraan'**
  String get hra94920e652;

  /// Modul: profile. Audit: HR-ID-F96DB57658
  ///
  /// In id, this message translates to:
  /// **'Perbarui kendaraan'**
  String get hrf96db57658;

  /// Modul: attendance. Audit: HR-ID-50B6D70710
  ///
  /// In id, this message translates to:
  /// **'Perbarui pengaturan presensi'**
  String get hr50b6d70710;

  /// Modul: chat. Audit: HR-ID-3E8D6389D7
  ///
  /// In id, this message translates to:
  /// **'Percakapan tidak dapat dibuat.'**
  String get hr3e8d6389d7;

  /// Modul: dashboard, home. Audit: HR-ID-EEE3EE65F9
  ///
  /// In id, this message translates to:
  /// **'Performa Sales'**
  String get hreee3ee65f9;

  /// Modul: kpi. Audit: HR-ID-5CBA9DE462
  ///
  /// In id, this message translates to:
  /// **'Periksa Lagi'**
  String get hr5cba9de462;

  /// Modul: approval_center. Audit: HR-ID-E1B70F6FA4
  ///
  /// In id, this message translates to:
  /// **'Periksa nominal dan bukti pengeluaran'**
  String get hre1b70f6fa4;

  /// Modul: approval_center. Audit: HR-ID-9535C5AD17
  ///
  /// In id, this message translates to:
  /// **'Periksa pengajuan perubahan kehadiran'**
  String get hr9535c5ad17;

  /// Modul: approval_center. Audit: HR-ID-C9F04F5816
  ///
  /// In id, this message translates to:
  /// **'Periksa pertukaran jadwal karyawan'**
  String get hrc9f04f5816;

  /// Modul: approval_center. Audit: HR-ID-69891323E0
  ///
  /// In id, this message translates to:
  /// **'Periksa waktu tambahan dan alasannya'**
  String get hr69891323e0;

  /// Modul: delivery. Audit: HR-ID-B7C6096FDD
  ///
  /// In id, this message translates to:
  /// **'Peringatan'**
  String get hrb7c6096fdd;

  /// Modul: survey. Audit: HR-ID-85E181B57A
  ///
  /// In id, this message translates to:
  /// **'Periode'**
  String get hr85e181b57a;

  /// Modul: payroll. Audit: HR-ID-B1EC78F5D8
  ///
  /// In id, this message translates to:
  /// **'Periode: {nilai1}'**
  String hrb1ec78f5d8(String nilai1);

  /// Modul: consignment. Audit: HR-ID-018A0D130D
  ///
  /// In id, this message translates to:
  /// **'Perjalanan'**
  String get hr018a0d130d;

  /// Modul: komponen umum. Audit: HR-ID-8CA8258A33
  ///
  /// In id, this message translates to:
  /// **'Permintaan Anda telah berhasil diproses.'**
  String get hr8ca8258a33;

  /// Modul: pesan & model bersama. Audit: HR-ID-E1F895E219
  ///
  /// In id, this message translates to:
  /// **'Permintaan ke server dibatalkan'**
  String get hre1f895e219;

  /// Modul: profile. Audit: HR-ID-94DDDAEE0C
  ///
  /// In id, this message translates to:
  /// **'Permintaan penghapusan akun Anda dari sistem'**
  String get hr94dddaee0c;

  /// Modul: attendance_request, leave, overtime, reimbursement. Audit: HR-ID-8D57FF22E8
  ///
  /// In id, this message translates to:
  /// **'Persetujuan'**
  String get hr8d57ff22e8;

  /// Modul: login. Audit: HR-ID-5FC71F5389
  ///
  /// In id, this message translates to:
  /// **'Persetujuan diperlukan untuk membuat akun.'**
  String get hr5fc71f5389;

  /// Modul: global, sistem & komponen umum. Audit: HR-ID-31481EEEB0
  ///
  /// In id, this message translates to:
  /// **'Persetujuan penggunaan lokasi belum diberikan'**
  String get hr31481eeeb0;

  /// Modul: kalender. Audit: HR-ID-E601D61457
  ///
  /// In id, this message translates to:
  /// **'Perubahan berlaku untuk seluruh rangkaian event. Tanggal di bawah adalah tanggal awal rangkaian.'**
  String get hre601d61457;

  /// Modul: sistem & komponen umum. Audit: HR-ID-FDE6FB9F3A
  ///
  /// In id, this message translates to:
  /// **'Pesan dari {nilai1}'**
  String hrfde6fb9f3a(String nilai1);

  /// Modul: activity. Audit: HR-ID-C02E51080D
  ///
  /// In id, this message translates to:
  /// **'Peserta memindai kode ini dari menu Kegiatan'**
  String get hrc02e51080d;

  /// Modul: apotek. Audit: HR-ID-222B5856E5
  ///
  /// In id, this message translates to:
  /// **'Peta Outlet'**
  String get hr222b5856e5;

  /// Modul: global. Audit: HR-ID-93D510F53F
  ///
  /// In id, this message translates to:
  /// **'Peta tidak ditampilkan. Presensi tetap memakai titik lokasi perangkat dan aturan lokasi perusahaan.'**
  String get hr93d510f53f;

  /// Modul: sistem & komponen umum. Audit: HR-ID-C5DDA7643C
  ///
  /// In id, this message translates to:
  /// **'PHP — Peso Filipina'**
  String get hrc5dda7643c;

  /// Modul: delivery, kalender. Audit: HR-ID-E137919915
  ///
  /// In id, this message translates to:
  /// **'Pilih'**
  String get hre137919915;

  /// Modul: delivery. Audit: HR-ID-067351A8A0
  ///
  /// In id, this message translates to:
  /// **'Pilih ({nilai1} DO)'**
  String hr067351a8a0(String nilai1);

  /// Modul: chat. Audit: HR-ID-5A43EA95A7
  ///
  /// In id, this message translates to:
  /// **'Pilih Anggota'**
  String get hr5a43ea95a7;

  /// Modul: attendance. Audit: HR-ID-273E6E6266
  ///
  /// In id, this message translates to:
  /// **'Pilih apakah kondisi ini berkaitan dengan pekerjaan'**
  String get hr273e6e6266;

  /// Modul: inventory. Audit: HR-ID-D7093DFA87
  ///
  /// In id, this message translates to:
  /// **'Pilih Barang'**
  String get hrd7093dfa87;

  /// Modul: inventory. Audit: HR-ID-62D3B100FD
  ///
  /// In id, this message translates to:
  /// **'Pilih barang terlebih dahulu'**
  String get hr62d3b100fd;

  /// Modul: attendance, attendance_request, overtime, reimbursement, shift. Audit: HR-ID-45284E79FF
  ///
  /// In id, this message translates to:
  /// **'Pilih Bulan'**
  String get hr45284e79ff;

  /// Modul: leave, payroll. Audit: HR-ID-E9F4780F3C
  ///
  /// In id, this message translates to:
  /// **'Pilih Bulan & Tahun'**
  String get hre9f4780f3c;

  /// Modul: activity. Audit: HR-ID-039A37BDE8
  ///
  /// In id, this message translates to:
  /// **'Pilih bulan kegiatan'**
  String get hr039a37bde8;

  /// Modul: instansi. Audit: HR-ID-1ABE5CF4AB
  ///
  /// In id, this message translates to:
  /// **'Pilih dari galeri'**
  String get hr1abe5cf4ab;

  /// Modul: leave. Audit: HR-ID-1E75D8147A
  ///
  /// In id, this message translates to:
  /// **'Pilih delegasi (opsional)'**
  String get hr1e75d8147a;

  /// Modul: chat. Audit: HR-ID-433E0FFF43
  ///
  /// In id, this message translates to:
  /// **'Pilih email untuk melihat detail'**
  String get hr433e0fff43;

  /// Modul: attendance_request. Audit: HR-ID-E89A836A95
  ///
  /// In id, this message translates to:
  /// **'Pilih Jadwal Shift'**
  String get hre89a836a95;

  /// Modul: shift. Audit: HR-ID-3EABD1078D
  ///
  /// In id, this message translates to:
  /// **'Pilih Jadwal Shift Tujuan'**
  String get hr3eabd1078d;

  /// Modul: leave. Audit: HR-ID-809C18DC3E
  ///
  /// In id, this message translates to:
  /// **'Pilih Jenis Cuti'**
  String get hr809c18dc3e;

  /// Modul: attendance_request. Audit: HR-ID-C31E4E329A
  ///
  /// In id, this message translates to:
  /// **'Pilih Jenis Presensi'**
  String get hrc31e4e329a;

  /// Modul: attendance_request. Audit: HR-ID-B614C42A5E
  ///
  /// In id, this message translates to:
  /// **'Pilih Jenis Request Presensi'**
  String get hrb614c42a5e;

  /// Modul: delivery. Audit: HR-ID-C7FE54626A
  ///
  /// In id, this message translates to:
  /// **'Pilih Jenis Transportasi'**
  String get hrc7fe54626a;

  /// Modul: delivery. Audit: HR-ID-3C61CD6CC1
  ///
  /// In id, this message translates to:
  /// **'Pilih Jumlah'**
  String get hr3c61cd6cc1;

  /// Modul: order. Audit: HR-ID-2B388F122D
  ///
  /// In id, this message translates to:
  /// **'Pilih Jumlah Cicilan'**
  String get hr2b388f122d;

  /// Modul: apotek. Audit: HR-ID-D29A167766
  ///
  /// In id, this message translates to:
  /// **'Pilih kabupaten/kota'**
  String get hrd29a167766;

  /// Modul: delivery, reimbursement. Audit: HR-ID-2C9D537FE2
  ///
  /// In id, this message translates to:
  /// **'Pilih Kategori'**
  String get hr2c9d537fe2;

  /// Modul: logbook. Audit: HR-ID-5322C62FBF
  ///
  /// In id, this message translates to:
  /// **'Pilih kategori'**
  String get hr5322c62fbf;

  /// Modul: delivery. Audit: HR-ID-89A1FF15C0
  ///
  /// In id, this message translates to:
  /// **'Pilih kendaraan untuk kunjungan.'**
  String get hr89a1ff15c0;

  /// Modul: global. Audit: HR-ID-B3C00997BB
  ///
  /// In id, this message translates to:
  /// **'Pilih Lokasi'**
  String get hrb3c00997bb;

  /// Modul: inventory. Audit: HR-ID-987935BF5F
  ///
  /// In id, this message translates to:
  /// **'Pilih lokasi'**
  String get hr987935bf5f;

  /// Modul: inventory. Audit: HR-ID-BE21964BC7
  ///
  /// In id, this message translates to:
  /// **'Pilih lokasi stok terlebih dahulu'**
  String get hrbe21964bc7;

  /// Modul: reimbursement. Audit: HR-ID-3313EEFF13
  ///
  /// In id, this message translates to:
  /// **'Pilih Mata Uang'**
  String get hr3313eeff13;

  /// Modul: delivery, order. Audit: HR-ID-BF9AB6BFD0
  ///
  /// In id, this message translates to:
  /// **'Pilih Metode'**
  String get hrbf9ab6bfd0;

  /// Modul: order. Audit: HR-ID-A86A647743
  ///
  /// In id, this message translates to:
  /// **'Pilih minimal satu produk'**
  String get hra86a647743;

  /// Modul: delivery. Audit: HR-ID-7ADC54CCB1
  ///
  /// In id, this message translates to:
  /// **'Pilih minimal satu tujuan kunjungan.'**
  String get hr7adc54ccb1;

  /// Modul: leave. Audit: HR-ID-9416A82CD8
  ///
  /// In id, this message translates to:
  /// **'Pilih Mode Cuti'**
  String get hr9416a82cd8;

  /// Modul: delivery, order. Audit: HR-ID-38677D2F3F
  ///
  /// In id, this message translates to:
  /// **'Pilih Outlet'**
  String get hr38677d2f3f;

  /// Modul: attendance. Audit: HR-ID-4C7E10FF5A
  ///
  /// In id, this message translates to:
  /// **'Pilih perasaan Anda terlebih dahulu'**
  String get hr4c7e10ff5a;

  /// Modul: chat. Audit: HR-ID-E26C4BADB2
  ///
  /// In id, this message translates to:
  /// **'Pilih percakapan untuk mulai melihat pesan'**
  String get hre26c4badb2;

  /// Modul: instansi. Audit: HR-ID-FBB30786A2
  ///
  /// In id, this message translates to:
  /// **'Pilih Peta'**
  String get hrfbb30786a2;

  /// Modul: delivery, inventory, order. Audit: HR-ID-20949FFA90
  ///
  /// In id, this message translates to:
  /// **'Pilih Produk'**
  String get hr20949ffa90;

  /// Modul: inventory. Audit: HR-ID-75ABB01DA9
  ///
  /// In id, this message translates to:
  /// **'Pilih produk'**
  String get hr75abb01da9;

  /// Modul: inventory. Audit: HR-ID-51E2335CCB
  ///
  /// In id, this message translates to:
  /// **'Pilih produk dulu'**
  String get hr51e2335ccb;

  /// Modul: apotek. Audit: HR-ID-BB460587C0
  ///
  /// In id, this message translates to:
  /// **'Pilih provinsi'**
  String get hrbb460587c0;

  /// Modul: attendance, attendance_request, overtime, reimbursement, shift. Audit: HR-ID-A29292DCBA
  ///
  /// In id, this message translates to:
  /// **'Pilih Rentang Waktu'**
  String get hra29292dcba;

  /// Modul: delivery. Audit: HR-ID-FA26C38F64
  ///
  /// In id, this message translates to:
  /// **'Pilih Status'**
  String get hrfa26c38f64;

  /// Modul: delivery. Audit: HR-ID-6EC2B8D585
  ///
  /// In id, this message translates to:
  /// **'Pilih Surat Jalan (DO)'**
  String get hr6ec2b8d585;

  /// Modul: delivery. Audit: HR-ID-50E0F77808
  ///
  /// In id, this message translates to:
  /// **'Pilih Tagihan'**
  String get hr50e0f77808;

  /// Modul: delivery, komponen umum, overtime, reimbursement. Audit: HR-ID-86C1839A7C
  ///
  /// In id, this message translates to:
  /// **'Pilih Tanggal'**
  String get hr86c1839a7c;

  /// Modul: komponen umum. Audit: HR-ID-B518250B51
  ///
  /// In id, this message translates to:
  /// **'Pilih Tanggal & Waktu'**
  String get hrb518250b51;

  /// Modul: leave. Audit: HR-ID-EC173F375D
  ///
  /// In id, this message translates to:
  /// **'Pilih tanggal mulai'**
  String get hrec173f375d;

  /// Modul: attendance_request. Audit: HR-ID-532921C746
  ///
  /// In id, this message translates to:
  /// **'Pilih Tanggal Presensi'**
  String get hr532921c746;

  /// Modul: leave. Audit: HR-ID-D9783A00C9
  ///
  /// In id, this message translates to:
  /// **'Pilih tanggal selesai'**
  String get hrd9783a00c9;

  /// Modul: shift. Audit: HR-ID-B9DD29FBCD
  ///
  /// In id, this message translates to:
  /// **'Pilih Tanggal Shift Tujuan'**
  String get hrb9dd29fbcd;

  /// Modul: delivery. Audit: HR-ID-A9A1C4DA22
  ///
  /// In id, this message translates to:
  /// **'Pilih Tipe Call'**
  String get hra9a1c4da22;

  /// Modul: delivery, order. Audit: HR-ID-280FB79E57
  ///
  /// In id, this message translates to:
  /// **'Pilih Tipe Order'**
  String get hr280fb79e57;

  /// Modul: kalender. Audit: HR-ID-5C2D4D5903
  ///
  /// In id, this message translates to:
  /// **'Pilih tipe pengulangan'**
  String get hr5c2d4d5903;

  /// Modul: activity. Audit: HR-ID-B21FD46888
  ///
  /// In id, this message translates to:
  /// **'Pilih titik lokasi'**
  String get hrb21fd46888;

  /// Modul: activity. Audit: HR-ID-F26021A9AB
  ///
  /// In id, this message translates to:
  /// **'Pilih titik lokasi kegiatan terlebih dahulu.'**
  String get hrf26021a9ab;

  /// Modul: komponen umum. Audit: HR-ID-C9FDE3FB1B
  ///
  /// In id, this message translates to:
  /// **'Pilih Waktu'**
  String get hrc9fde3fb1b;

  /// Modul: delivery, komponen umum. Audit: HR-ID-9D7C9AD392
  ///
  /// In id, this message translates to:
  /// **'Pilih {nilai1}'**
  String hr9d7c9ad392(String nilai1);

  /// Modul: home, loan. Audit: HR-ID-F3D84261C1
  ///
  /// In id, this message translates to:
  /// **'Pinjaman'**
  String get hrf3d84261c1;

  /// Modul: loan. Audit: HR-ID-63B9453BD4
  ///
  /// In id, this message translates to:
  /// **'Pinjaman (Loan)'**
  String get hr63b9453bd4;

  /// Modul: apotek, home. Audit: HR-ID-E7615F6F4A
  ///
  /// In id, this message translates to:
  /// **'Piutang'**
  String get hre7615f6f4a;

  /// Modul: sistem & komponen umum. Audit: HR-ID-7E24B80C1D
  ///
  /// In id, this message translates to:
  /// **'PKR — Rupee Pakistan'**
  String get hr7e24b80c1d;

  /// Modul: sistem & komponen umum. Audit: HR-ID-E23C824A55
  ///
  /// In id, this message translates to:
  /// **'PLN — Zloty Polandia'**
  String get hre23c824a55;

  /// Modul: sistem & komponen umum. Audit: HR-ID-02F267DE1E
  ///
  /// In id, this message translates to:
  /// **'Posisi tidak tersedia. Pastikan layanan lokasi Windows aktif dan perangkat terhubung ke internet.'**
  String get hr02f267de1e;

  /// Modul: common. Audit: HR-ID-F9FE6AC98A
  ///
  /// In id, this message translates to:
  /// **'Posisikan dokumen dalam bingkai'**
  String get hrf9fe6ac98a;

  /// Modul: payroll. Audit: HR-ID-B9F3CD7699
  ///
  /// In id, this message translates to:
  /// **'Potongan'**
  String get hrb9f3cd7699;

  /// Modul: pesan & model bersama. Audit: HR-ID-5FBE885E04
  ///
  /// In id, this message translates to:
  /// **'potongan'**
  String get hr5fbe885e04;

  /// Modul: payroll. Audit: HR-ID-EA152AB77C
  ///
  /// In id, this message translates to:
  /// **'PPh 21'**
  String get hrea152ab77c;

  /// Modul: activity, attendance, home, komponen umum, profile. Audit: HR-ID-FC8A0FEA4F
  ///
  /// In id, this message translates to:
  /// **'Presensi'**
  String get hrfc8a0fea4f;

  /// Modul: pesan & model bersama. Audit: HR-ID-E9A7440C10
  ///
  /// In id, this message translates to:
  /// **'presensi'**
  String get hre9a7440c10;

  /// Modul: attendance. Audit: HR-ID-81709F1104
  ///
  /// In id, this message translates to:
  /// **'Presensi berhasil dikirim'**
  String get hr81709f1104;

  /// Modul: attendance. Audit: HR-ID-406A149C0B
  ///
  /// In id, this message translates to:
  /// **'Presensi Hari Ini'**
  String get hr406a149c0b;

  /// Modul: app. Audit: HR-ID-05383CF764
  ///
  /// In id, this message translates to:
  /// **'Presensi hari ini belum dapat dimuat. Silakan coba lagi.'**
  String get hr05383cf764;

  /// Modul: intro. Audit: HR-ID-A0987BE7E0
  ///
  /// In id, this message translates to:
  /// **'Presensi Mobile'**
  String get hra0987be7e0;

  /// Modul: app. Audit: HR-ID-F45291ED50
  ///
  /// In id, this message translates to:
  /// **'Presensi pulang hari ini belum ditemukan. Lakukan presensi pulang sebelum memulai lembur.'**
  String get hrf45291ed50;

  /// Modul: attendance. Audit: HR-ID-408A62DDAB
  ///
  /// In id, this message translates to:
  /// **'Presensi Saya'**
  String get hr408a62ddab;

  /// Modul: pesan & model bersama. Audit: HR-ID-D47F51BC74
  ///
  /// In id, this message translates to:
  /// **'Presensi tidak tersedia atau aksesnya dibatasi oleh admin.'**
  String get hrd47f51bc74;

  /// Modul: attendance. Audit: HR-ID-7788C8215D
  ///
  /// In id, this message translates to:
  /// **'Presensi Tim'**
  String get hr7788c8215d;

  /// Modul: attendance. Audit: HR-ID-1887135F94
  ///
  /// In id, this message translates to:
  /// **'Presensi tim tidak diizinkan oleh admin.'**
  String get hr1887135f94;

  /// Modul: development. Audit: HR-ID-91CC5984B4
  ///
  /// In id, this message translates to:
  /// **'Print Response'**
  String get hr91cc5984b4;

  /// Modul: announcement. Audit: HR-ID-51CB5D20E6
  ///
  /// In id, this message translates to:
  /// **'Prioritas'**
  String get hr51cb5d20e6;

  /// Modul: intro. Audit: HR-ID-13DA982EF4
  ///
  /// In id, this message translates to:
  /// **'Privasi dan keamanan terjamin'**
  String get hr13da982ef4;

  /// Modul: delivery. Audit: HR-ID-B1FB2FDC56
  ///
  /// In id, this message translates to:
  /// **'Produk Pesanan'**
  String get hrb1fb2fdc56;

  /// Modul: inventory. Audit: HR-ID-CE695834F0
  ///
  /// In id, this message translates to:
  /// **'Produk tidak ditemukan'**
  String get hrce695834f0;

  /// Modul: profile. Audit: HR-ID-22CB048BE6
  ///
  /// In id, this message translates to:
  /// **'Profil Pengguna'**
  String get hr22cb048be6;

  /// Modul: komponen umum, profile. Audit: HR-ID-FF4FC0276E
  ///
  /// In id, this message translates to:
  /// **'Profile'**
  String get hrff4fc0276e;

  /// Modul: delivery. Audit: HR-ID-1579412F2B
  ///
  /// In id, this message translates to:
  /// **'Progress Hari Ini'**
  String get hr1579412f2b;

  /// Modul: development. Audit: HR-ID-4196CA3C9A
  ///
  /// In id, this message translates to:
  /// **'Project Id'**
  String get hr4196ca3c9a;

  /// Modul: app. Audit: HR-ID-A93CEBFF8E
  ///
  /// In id, this message translates to:
  /// **'Proses lembur gagal, silakan coba lagi'**
  String get hra93cebff8e;

  /// Modul: app. Audit: HR-ID-9F38FA058B
  ///
  /// In id, this message translates to:
  /// **'Proses lembur sedang berjalan'**
  String get hr9f38fa058b;

  /// Modul: apotek. Audit: HR-ID-7A5B1014EC
  ///
  /// In id, this message translates to:
  /// **'Provinsi'**
  String get hr7a5b1014ec;

  /// Modul: attendance, home. Audit: HR-ID-8855C56636
  ///
  /// In id, this message translates to:
  /// **'Pulang'**
  String get hr8855c56636;

  /// Modul: payroll. Audit: HR-ID-646BA188E4
  ///
  /// In id, this message translates to:
  /// **'Pulang Awal'**
  String get hr646ba188e4;

  /// Modul: attendance. Audit: HR-ID-2C8D56B94A
  ///
  /// In id, this message translates to:
  /// **'Pulang Kerja'**
  String get hr2c8d56b94a;

  /// Modul: attendance. Audit: HR-ID-2698FF1B31
  ///
  /// In id, this message translates to:
  /// **'Pulang Standar'**
  String get hr2698ff1b31;

  /// Modul: payroll. Audit: HR-ID-2862C2D01D
  ///
  /// In id, this message translates to:
  /// **'Punishment Absen'**
  String get hr2862c2d01d;

  /// Modul: payroll. Audit: HR-ID-00AB83D6CF
  ///
  /// In id, this message translates to:
  /// **'Punishment Lupa Presensi'**
  String get hr00ab83d6cf;

  /// Modul: payroll. Audit: HR-ID-07EE581886
  ///
  /// In id, this message translates to:
  /// **'Punishment Pulang Awal'**
  String get hr07ee581886;

  /// Modul: payroll. Audit: HR-ID-21C025293B
  ///
  /// In id, this message translates to:
  /// **'Punishment Terlambat'**
  String get hr21c025293b;

  /// Modul: profile. Audit: HR-ID-91B7A165CB
  ///
  /// In id, this message translates to:
  /// **'Pusat Bantuan'**
  String get hr91b7a165cb;

  /// Modul: approval_center. Audit: HR-ID-96ADADC0D0
  ///
  /// In id, this message translates to:
  /// **'Pusat Persetujuan'**
  String get hr96adadc0d0;

  /// Modul: sistem & komponen umum. Audit: HR-ID-10671C982A
  ///
  /// In id, this message translates to:
  /// **'QAR — Riyal Qatar'**
  String get hr10671c982a;

  /// Modul: activity. Audit: HR-ID-717864DF09
  ///
  /// In id, this message translates to:
  /// **'QR aktif'**
  String get hr717864df09;

  /// Modul: activity. Audit: HR-ID-B5762B38E2
  ///
  /// In id, this message translates to:
  /// **'QR tidak tersedia'**
  String get hrb5762b38e2;

  /// Modul: activity. Audit: HR-ID-C532996EF2
  ///
  /// In id, this message translates to:
  /// **'QR {nilai1}'**
  String hrc532996ef2(String nilai1);

  /// Modul: activity. Audit: HR-ID-17B6B260FC
  ///
  /// In id, this message translates to:
  /// **'Radius validasi'**
  String get hr17b6b260fc;

  /// Modul: kpi. Audit: HR-ID-4BDD91F7BC
  ///
  /// In id, this message translates to:
  /// **'Rating otomatis: {nilai1} / 5. Nilai akhir mengikuti penilaian pemeriksa.'**
  String hr4bdd91f7bc(String nilai1);

  /// Modul: login. Audit: HR-ID-CC2049F586
  ///
  /// In id, this message translates to:
  /// **'Registrasi Berhasil'**
  String get hrcc2049f586;

  /// Modul: login. Audit: HR-ID-E0B5DDEA97
  ///
  /// In id, this message translates to:
  /// **'Registrasi Gagal'**
  String get hre0b5ddea97;

  /// Modul: home, reimbursement. Audit: HR-ID-63DE972B4D
  ///
  /// In id, this message translates to:
  /// **'Reimbursement'**
  String get hr63de972b4d;

  /// Modul: attendance, attendance_request, overtime, reimbursement, shift. Audit: HR-ID-234C365AE6
  ///
  /// In id, this message translates to:
  /// **'Rentang Waktu'**
  String get hr234c365ae6;

  /// Modul: home. Audit: HR-ID-36C401C785
  ///
  /// In id, this message translates to:
  /// **'Request\nPresensi'**
  String get hr36c401c785;

  /// Modul: leave. Audit: HR-ID-57282D6F91
  ///
  /// In id, this message translates to:
  /// **'Request Cuti'**
  String get hr57282d6f91;

  /// Modul: leave. Audit: HR-ID-574AFAB818
  ///
  /// In id, this message translates to:
  /// **'Request Cuti berhasil diajukan'**
  String get hr574afab818;

  /// Modul: leave. Audit: HR-ID-D4C9930324
  ///
  /// In id, this message translates to:
  /// **'Request Cuti berhasil diperbarui'**
  String get hrd4c9930324;

  /// Modul: attendance. Audit: HR-ID-68C5FD1FD8
  ///
  /// In id, this message translates to:
  /// **'Request Edit Presensi'**
  String get hr68c5fd1fd8;

  /// Modul: attendance_request. Audit: HR-ID-F3EA6C3749
  ///
  /// In id, this message translates to:
  /// **'Request Presensi'**
  String get hrf3ea6c3749;

  /// Modul: shift. Audit: HR-ID-43DF76C18F
  ///
  /// In id, this message translates to:
  /// **'Request Tukar Shift'**
  String get hr43df76c18f;

  /// Modul: attendance_request. Audit: HR-ID-82F7B3ACA8
  ///
  /// In id, this message translates to:
  /// **'Request yang dihapus tidak dapat dikembalikan.'**
  String get hr82f7b3aca8;

  /// Modul: pesan & model bersama. Audit: HR-ID-684A163BC2
  ///
  /// In id, this message translates to:
  /// **'Resource tidak ditemukan'**
  String get hr684a163bc2;

  /// Modul: kpi. Audit: HR-ID-11C4397C72
  ///
  /// In id, this message translates to:
  /// **'Review KPI'**
  String get hr11c4397c72;

  /// Modul: kpi. Audit: HR-ID-BEDC407C85
  ///
  /// In id, this message translates to:
  /// **'Review KPI Tim'**
  String get hrbedc407c85;

  /// Modul: home. Audit: HR-ID-46BBFCE02B
  ///
  /// In id, this message translates to:
  /// **'Ringkasan belum berhasil dimuat. Buka jenis pengajuan atau coba lagi.'**
  String get hr46bbfce02b;

  /// Modul: attendance. Audit: HR-ID-F6ACCE5251
  ///
  /// In id, this message translates to:
  /// **'Ringkasan dan riwayat kehadiran Anda.'**
  String get hrf6acce5251;

  /// Modul: attendance, payroll. Audit: HR-ID-709FCFE307
  ///
  /// In id, this message translates to:
  /// **'Ringkasan Kehadiran'**
  String get hr709fcfe307;

  /// Modul: logbook. Audit: HR-ID-B56E89E859
  ///
  /// In id, this message translates to:
  /// **'Riwayat Logbook'**
  String get hrb56e89e859;

  /// Modul: apotek. Audit: HR-ID-2AA7644660
  ///
  /// In id, this message translates to:
  /// **'Riwayat Order'**
  String get hr2aa7644660;

  /// Modul: shift. Audit: HR-ID-1BEE54FFCD
  ///
  /// In id, this message translates to:
  /// **'Riwayat Persetujuan'**
  String get hr1bee54ffcd;

  /// Modul: delivery. Audit: HR-ID-75A23AFC8D
  ///
  /// In id, this message translates to:
  /// **'Rp {nilai1} / {nilai2}'**
  String hr75a23afc8d(String nilai1, String nilai2);

  /// Modul: instansi. Audit: HR-ID-FA46569AA6
  ///
  /// In id, this message translates to:
  /// **'Ruang kerja Anda siap'**
  String get hrfa46569aa6;

  /// Modul: sistem & komponen umum. Audit: HR-ID-ED56C37B25
  ///
  /// In id, this message translates to:
  /// **'RUB — Rubel Rusia'**
  String get hred56c37b25;

  /// Modul: delivery, sistem & komponen umum. Audit: HR-ID-71DFEF2B6B
  ///
  /// In id, this message translates to:
  /// **'Salah memilih Kunjungan'**
  String get hr71dfef2b6b;

  /// Modul: profile. Audit: HR-ID-F4F688E47F
  ///
  /// In id, this message translates to:
  /// **'Sales Order'**
  String get hrf4f688e47f;

  /// Modul: order. Audit: HR-ID-A6939D47BA
  ///
  /// In id, this message translates to:
  /// **'Sales Order untuk {nilai1} berhasil disimpan.'**
  String hra6939d47ba(String nilai1);

  /// Modul: sistem & komponen umum. Audit: HR-ID-26809D52F2
  ///
  /// In id, this message translates to:
  /// **'SAR — Riyal Saudi'**
  String get hr26809d52f2;

  /// Modul: login. Audit: HR-ID-DE676C9146
  ///
  /// In id, this message translates to:
  /// **'Saya Mengerti'**
  String get hrde676c9146;

  /// Modul: login. Audit: HR-ID-44E0630B4E
  ///
  /// In id, this message translates to:
  /// **'Saya menyetujui Kebijakan Privasi dan Ketentuan Layanan Pantoo.'**
  String get hr44e0630b4e;

  /// Modul: global. Audit: HR-ID-6F658CEAE3
  ///
  /// In id, this message translates to:
  /// **'Saya Yakin'**
  String get hr6f658ceae3;

  /// Modul: activity. Audit: HR-ID-C7B936AACE
  ///
  /// In id, this message translates to:
  /// **'Scan Karyawan'**
  String get hrc7b936aace;

  /// Modul: activity. Audit: HR-ID-1AF1325B7B
  ///
  /// In id, this message translates to:
  /// **'Scan QR Kegiatan'**
  String get hr1af1325b7b;

  /// Modul: activity. Audit: HR-ID-1EFCAB76CC
  ///
  /// In id, this message translates to:
  /// **'Scan {nilai1}'**
  String hr1efcab76cc(String nilai1);

  /// Modul: attendance. Audit: HR-ID-EEF74F939B
  ///
  /// In id, this message translates to:
  /// **'Sebagian'**
  String get hreef74f939b;

  /// Modul: approval_center. Audit: HR-ID-5B95D9CD60
  ///
  /// In id, this message translates to:
  /// **'Sebagian akses belum berhasil diperiksa. Coba lagi untuk memperbarui daftar.'**
  String get hr5b95d9cd60;

  /// Modul: home. Audit: HR-ID-74B8C39FAB
  ///
  /// In id, this message translates to:
  /// **'Sebagian jenis pengajuan belum berhasil dimuat.'**
  String get hr74b8c39fab;

  /// Modul: home. Audit: HR-ID-F41B8910CD
  ///
  /// In id, this message translates to:
  /// **'Sedang Kerja'**
  String get hrf41b8910cd;

  /// Modul: home, main. Audit: HR-ID-FC73B12E05
  ///
  /// In id, this message translates to:
  /// **'Sedang Lembur'**
  String get hrfc73b12e05;

  /// Modul: sistem & komponen umum. Audit: HR-ID-4EBE9D53D0
  ///
  /// In id, this message translates to:
  /// **'Sedang mencari lokasi!'**
  String get hr4ebe9d53d0;

  /// Modul: pesan & model bersama. Audit: HR-ID-262C42CC7B
  ///
  /// In id, this message translates to:
  /// **'Sedang Mencari Posisi'**
  String get hr262c42cc7b;

  /// Modul: kalender. Audit: HR-ID-35B2349534
  ///
  /// In id, this message translates to:
  /// **'Seharian'**
  String get hr35b2349534;

  /// Modul: sistem & komponen umum. Audit: HR-ID-202F8B0059
  ///
  /// In id, this message translates to:
  /// **'SEK — Krona Swedia'**
  String get hr202f8b0059;

  /// Modul: intro. Audit: HR-ID-2587DCEB3E
  ///
  /// In id, this message translates to:
  /// **'Selanjutnya'**
  String get hr2587dceb3e;

  /// Modul: dashboard. Audit: HR-ID-94388531AB
  ///
  /// In id, this message translates to:
  /// **'Selesai'**
  String get hr94388531ab;

  /// Modul: kpi. Audit: HR-ID-C754F3BB8D
  ///
  /// In id, this message translates to:
  /// **'Selesaikan'**
  String get hrc754f3bb8d;

  /// Modul: pesan & model bersama. Audit: HR-ID-DF1B466C3B
  ///
  /// In id, this message translates to:
  /// **'Selesaikan CAPTCHA untuk melanjutkan login'**
  String get hrdf1b466c3b;

  /// Modul: sistem & komponen umum. Audit: HR-ID-D6DF7FC4B9
  ///
  /// In id, this message translates to:
  /// **'Selesaikan Kunjungan hari ini!'**
  String get hrd6df7fc4b9;

  /// Modul: kpi. Audit: HR-ID-8A4188A8A3
  ///
  /// In id, this message translates to:
  /// **'Selesaikan Review'**
  String get hr8a4188a8a3;

  /// Modul: kpi. Audit: HR-ID-25F7FAFA44
  ///
  /// In id, this message translates to:
  /// **'Selesaikan review?'**
  String get hr25f7fafa44;

  /// Modul: logbook. Audit: HR-ID-808D8EF870
  ///
  /// In id, this message translates to:
  /// **'Selesai{nilai1}'**
  String hr808d8ef870(String nilai1);

  /// Modul: kpi. Audit: HR-ID-97B6EC533D
  ///
  /// In id, this message translates to:
  /// **'Self Assessment'**
  String get hr97b6ec533d;

  /// Modul: kpi. Audit: HR-ID-0A2B1B2EC8
  ///
  /// In id, this message translates to:
  /// **'Self Assessment Karyawan'**
  String get hr0a2b1b2ec8;

  /// Modul: attendance. Audit: HR-ID-C6AA7CFE10
  ///
  /// In id, this message translates to:
  /// **'Selisih Jam Masuk'**
  String get hrc6aa7cfe10;

  /// Modul: attendance. Audit: HR-ID-5A36A3906C
  ///
  /// In id, this message translates to:
  /// **'Selisih Jam Pulang'**
  String get hr5a36a3906c;

  /// Modul: kalender. Audit: HR-ID-337881DFED
  ///
  /// In id, this message translates to:
  /// **'Seluruh rangkaian \"{nilai1}\" akan dihapus.'**
  String hr337881dfed(String nilai1);

  /// Modul: announcement. Audit: HR-ID-35DE2D55DD
  ///
  /// In id, this message translates to:
  /// **'Sematkan Pengumuman'**
  String get hr35de2d55dd;

  /// Modul: apotek. Audit: HR-ID-7A3F6C8CC3
  ///
  /// In id, this message translates to:
  /// **'Sembunyikan Detail'**
  String get hr7a3f6c8cc3;

  /// Modul: apotek, attendance, attendance_request, leave, overtime, reimbursement. Audit: HR-ID-42C76592CD
  ///
  /// In id, this message translates to:
  /// **'Semua'**
  String get hr42c76592cd;

  /// Modul: kpi. Audit: HR-ID-B73E40E85B
  ///
  /// In id, this message translates to:
  /// **'Semua indikator harus diberi nilai sebelum dikirim.'**
  String get hrb73e40e85b;

  /// Modul: kpi. Audit: HR-ID-678B554924
  ///
  /// In id, this message translates to:
  /// **'Semua indikator harus diberi nilai sebelum review diselesaikan.'**
  String get hr678b554924;

  /// Modul: attendance_request, common, leave, overtime, payroll, reimbursement, shift, sistem & komponen umum. Audit: HR-ID-1C542E79C9
  ///
  /// In id, this message translates to:
  /// **'September'**
  String get hr1c542e79c9;

  /// Modul: sistem & komponen umum. Audit: HR-ID-418E05534D
  ///
  /// In id, this message translates to:
  /// **'Server Google berubah. Tutup dan buka kembali aplikasi.'**
  String get hr418e05534d;

  /// Modul: pesan & model bersama. Audit: HR-ID-D5881DA611
  ///
  /// In id, this message translates to:
  /// **'Server tidak mengonfirmasi bahwa data cuti berhasil disimpan.'**
  String get hrd5881da611;

  /// Modul: pesan & model bersama. Audit: HR-ID-71706C79BA
  ///
  /// In id, this message translates to:
  /// **'Server tidak mengonfirmasi pengajuan lembur berhasil diproses.'**
  String get hr71706c79ba;

  /// Modul: pesan & model bersama. Audit: HR-ID-2775D49255
  ///
  /// In id, this message translates to:
  /// **'Server tidak mengonfirmasi perubahan request presensi.'**
  String get hr2775d49255;

  /// Modul: pesan & model bersama. Audit: HR-ID-BB18666751
  ///
  /// In id, this message translates to:
  /// **'Server tidak mengonfirmasi reimbursement berhasil diproses.'**
  String get hrbb18666751;

  /// Modul: pesan & model bersama. Audit: HR-ID-1E928A3C2C
  ///
  /// In id, this message translates to:
  /// **'Server tidak mengonfirmasi request presensi berhasil disimpan.'**
  String get hr1e928a3c2c;

  /// Modul: pesan & model bersama. Audit: HR-ID-CD159A33A4
  ///
  /// In id, this message translates to:
  /// **'Server tidak mengonfirmasi request tukar shift berhasil diproses.'**
  String get hrcd159a33a4;

  /// Modul: pesan & model bersama. Audit: HR-ID-5AEF88F041
  ///
  /// In id, this message translates to:
  /// **'Server tidak merespon, hubungi admin'**
  String get hr5aef88f041;

  /// Modul: pesan & model bersama. Audit: HR-ID-F263CFB270
  ///
  /// In id, this message translates to:
  /// **'Server tidak merespons. Sesi lokal telah dihapus.'**
  String get hrf263cfb270;

  /// Modul: home. Audit: HR-ID-7DD6562917
  ///
  /// In id, this message translates to:
  /// **'Sesi Presensi Aktif'**
  String get hr7dd6562917;

  /// Modul: leave. Audit: HR-ID-DD026D06F4
  ///
  /// In id, this message translates to:
  /// **'Setengah Hari'**
  String get hrdd026d06f4;

  /// Modul: global. Audit: HR-ID-6922149BDE
  ///
  /// In id, this message translates to:
  /// **'Setuju & lanjutkan'**
  String get hr6922149bde;

  /// Modul: attendance_request, leave, overtime, payroll, reimbursement, shift. Audit: HR-ID-1F9CE43818
  ///
  /// In id, this message translates to:
  /// **'Setujui'**
  String get hr1f9ce43818;

  /// Modul: payroll. Audit: HR-ID-8BA26A7C8A
  ///
  /// In id, this message translates to:
  /// **'Setujui payroll?'**
  String get hr8ba26a7c8a;

  /// Modul: sistem & komponen umum. Audit: HR-ID-E61B7C141A
  ///
  /// In id, this message translates to:
  /// **'SGD — Dollar Singapura'**
  String get hre61b7c141a;

  /// Modul: home, shift. Audit: HR-ID-469D5B183F
  ///
  /// In id, this message translates to:
  /// **'Shift'**
  String get hr469d5b183f;

  /// Modul: shift. Audit: HR-ID-DD215558C3
  ///
  /// In id, this message translates to:
  /// **'Shift Saya'**
  String get hrdd215558c3;

  /// Modul: shift. Audit: HR-ID-6A0CDA2740
  ///
  /// In id, this message translates to:
  /// **'Shift Saya (Requester)'**
  String get hr6a0cda2740;

  /// Modul: shift. Audit: HR-ID-3BD98E4431
  ///
  /// In id, this message translates to:
  /// **'Shift Tujuan (Target)'**
  String get hr3bd98e4431;

  /// Modul: intro. Audit: HR-ID-EC0A910A0F
  ///
  /// In id, this message translates to:
  /// **'Siap Digunakan'**
  String get hrec0a910a0f;

  /// Modul: profile. Audit: HR-ID-6402830093
  ///
  /// In id, this message translates to:
  /// **'Siap dikirim otomatis'**
  String get hr6402830093;

  /// Modul: sistem & komponen umum. Audit: HR-ID-86DB9E2D63
  ///
  /// In id, this message translates to:
  /// **'Silakan ambil gambar!'**
  String get hr86db9e2d63;

  /// Modul: sistem & komponen umum. Audit: HR-ID-3AB8D6E5FA
  ///
  /// In id, this message translates to:
  /// **'Silakan foto Selfie'**
  String get hr3ab8d6e5fa;

  /// Modul: pesan & model bersama. Audit: HR-ID-5FE6528DF0
  ///
  /// In id, this message translates to:
  /// **'Silakan login kembali'**
  String get hr5fe6528df0;

  /// Modul: pesan & model bersama. Audit: HR-ID-3F1F5D8AE3
  ///
  /// In id, this message translates to:
  /// **'Silakan Login Kembali!'**
  String get hr3f1f5d8ae3;

  /// Modul: sistem & komponen umum. Audit: HR-ID-A3C4D4438E
  ///
  /// In id, this message translates to:
  /// **'Silakan tunggu sebentar!'**
  String get hra3c4d4438e;

  /// Modul: chat. Audit: HR-ID-186DBFABEB
  ///
  /// In id, this message translates to:
  /// **'Silakan pilih minimal 1 anggota'**
  String get hr186dbfabeb;

  /// Modul: apotek, delivery, profile. Audit: HR-ID-87DD92D740
  ///
  /// In id, this message translates to:
  /// **'Simpan'**
  String get hr87dd92d740;

  /// Modul: instansi. Audit: HR-ID-2099793AF7
  ///
  /// In id, this message translates to:
  /// **'Simpan dan Lanjutkan'**
  String get hr2099793af7;

  /// Modul: kalender. Audit: HR-ID-15F61A07FB
  ///
  /// In id, this message translates to:
  /// **'Simpan Event'**
  String get hr15f61a07fb;

  /// Modul: activity. Audit: HR-ID-F341A81ADA
  ///
  /// In id, this message translates to:
  /// **'Simpan Kegiatan'**
  String get hrf341a81ada;

  /// Modul: delivery. Audit: HR-ID-ED29E893C1
  ///
  /// In id, this message translates to:
  /// **'Simpan Kunjungan'**
  String get hred29e893c1;

  /// Modul: inventory. Audit: HR-ID-A5AD369D5B
  ///
  /// In id, this message translates to:
  /// **'Simpan Laporan'**
  String get hra5ad369d5b;

  /// Modul: home. Audit: HR-ID-CC40EA1D95
  ///
  /// In id, this message translates to:
  /// **'Simpan Lembur'**
  String get hrcc40ea1d95;

  /// Modul: logbook. Audit: HR-ID-4C14EDE5E6
  ///
  /// In id, this message translates to:
  /// **'Simpan Logbook'**
  String get hr4c14ede5e6;

  /// Modul: announcement. Audit: HR-ID-B46075E875
  ///
  /// In id, this message translates to:
  /// **'Simpan Pengumuman'**
  String get hrb46075e875;

  /// Modul: announcement, kalender, logbook, overtime, profile. Audit: HR-ID-03F7DDA53D
  ///
  /// In id, this message translates to:
  /// **'Simpan Perubahan'**
  String get hr03f7dda53d;

  /// Modul: profile. Audit: HR-ID-7FC2F3670C
  ///
  /// In id, this message translates to:
  /// **'Sinkronisasi Data'**
  String get hr7fc2f3670c;

  /// Modul: profile. Audit: HR-ID-980A0950D7
  ///
  /// In id, this message translates to:
  /// **'Sinkronisasi otomatis tersedia untuk Sales Order dan checkout offline. Data akan dikirim setelah server kembali. Check-in, istirahat, dan kunjungan masih menunggu dukungan sinkronisasi. Profil terakhir, daftar apotek, dan katalog produk adalah cache baca sehingga tidak tampil sebagai antrean.'**
  String get hr980a0950d7;

  /// Modul: profile. Audit: HR-ID-BD9DDD6E6F
  ///
  /// In id, this message translates to:
  /// **'Sinkronisasi Sekarang'**
  String get hrbd9ddd6e6f;

  /// Modul: delivery. Audit: HR-ID-BD9DC71565
  ///
  /// In id, this message translates to:
  /// **'Sisa Harus Dibayar'**
  String get hrbd9dc71565;

  /// Modul: loan. Audit: HR-ID-26141D3B73
  ///
  /// In id, this message translates to:
  /// **'Sisa Pinjaman'**
  String get hr26141d3b73;

  /// Modul: home. Audit: HR-ID-D6A75F06D0
  ///
  /// In id, this message translates to:
  /// **'Sisa Waktu'**
  String get hrd6a75f06d0;

  /// Modul: intro. Audit: HR-ID-F4904A2AA3
  ///
  /// In id, this message translates to:
  /// **'Sistem lengkap dengan berbagai fitur andalan.'**
  String get hrf4904a2aa3;

  /// Modul: inventory. Audit: HR-ID-EB5478895A
  ///
  /// In id, this message translates to:
  /// **'SKU: {nilai1}'**
  String hreb5478895a(String nilai1);

  /// Modul: payroll. Audit: HR-ID-DBCEF45F9C
  ///
  /// In id, this message translates to:
  /// **'Slip Gaji'**
  String get hrdbcef45f9c;

  /// Modul: intro. Audit: HR-ID-FC14A000FC
  ///
  /// In id, this message translates to:
  /// **'Solusi absensi modern untuk perusahaan Anda'**
  String get hrfc14a000fc;

  /// Modul: sistem & komponen umum. Audit: HR-ID-CCA3AD210B
  ///
  /// In id, this message translates to:
  /// **'Staff Pajak'**
  String get hrcca3ad210b;

  /// Modul: apotek. Audit: HR-ID-B8C721539F
  ///
  /// In id, this message translates to:
  /// **'Statistik & CRM'**
  String get hrb8c721539f;

  /// Modul: attendance, consignment. Audit: HR-ID-BAE7D5BE70
  ///
  /// In id, this message translates to:
  /// **'Status'**
  String get hrbae7d5be70;

  /// Modul: profile. Audit: HR-ID-9EF50DDB09
  ///
  /// In id, this message translates to:
  /// **'Status Karyawan'**
  String get hr9ef50ddb09;

  /// Modul: profile. Audit: HR-ID-8CA7F1CA17
  ///
  /// In id, this message translates to:
  /// **'Status Langganan'**
  String get hr8ca7f1ca17;

  /// Modul: delivery. Audit: HR-ID-44A9F64EDD
  ///
  /// In id, this message translates to:
  /// **'Status Pengantaran'**
  String get hr44a9f64edd;

  /// Modul: app. Audit: HR-ID-E7F5F792D9
  ///
  /// In id, this message translates to:
  /// **'Status presensi belum dapat diverifikasi. Silakan muat ulang.'**
  String get hre7f5f792d9;

  /// Modul: inventory. Audit: HR-ID-A482A528F1
  ///
  /// In id, this message translates to:
  /// **'Stok: {nilai1}\n{nilai2}'**
  String hra482a528f1(String nilai1, String nilai2);

  /// Modul: development. Audit: HR-ID-35D3785730
  ///
  /// In id, this message translates to:
  /// **'Storage Bucket'**
  String get hr35d3785730;

  /// Modul: shift. Audit: HR-ID-D4811B4664
  ///
  /// In id, this message translates to:
  /// **'submit request tukar shift berhasil'**
  String get hrd4811b4664;

  /// Modul: delivery. Audit: HR-ID-D8A3EEE670
  ///
  /// In id, this message translates to:
  /// **'Subtotal: Rp {nilai1}'**
  String hrd8a3eee670(String nilai1);

  /// Modul: pesan & model bersama. Audit: HR-ID-984898CC99
  ///
  /// In id, this message translates to:
  /// **'Success save Token FCM'**
  String get hr984898cc99;

  /// Modul: sistem & komponen umum. Audit: HR-ID-C9606EF1A6
  ///
  /// In id, this message translates to:
  /// **'Sudah Ditukar'**
  String get hrc9606ef1a6;

  /// Modul: home. Audit: HR-ID-033D1C7AC4
  ///
  /// In id, this message translates to:
  /// **'Sudah Presensi hari ini'**
  String get hr033d1c7ac4;

  /// Modul: home. Audit: HR-ID-D8909B9350
  ///
  /// In id, this message translates to:
  /// **'Sudah Pulang'**
  String get hrd8909b9350;

  /// Modul: login. Audit: HR-ID-59342AA97B
  ///
  /// In id, this message translates to:
  /// **'Sudah punya akun? '**
  String get hr59342aa97b;

  /// Modul: delivery. Audit: HR-ID-8AB08DA0DA
  ///
  /// In id, this message translates to:
  /// **'Surat Jalan (DO)'**
  String get hr8ab08da0da;

  /// Modul: home, survey. Audit: HR-ID-C6CA4E2C87
  ///
  /// In id, this message translates to:
  /// **'Survey Saya'**
  String get hrc6ca4e2c87;

  /// Modul: delivery. Audit: HR-ID-F303963068
  ///
  /// In id, this message translates to:
  /// **'Tagihan / Invoice'**
  String get hrf303963068;

  /// Modul: komponen umum. Audit: HR-ID-8A35587A29
  ///
  /// In id, this message translates to:
  /// **'Tahun'**
  String get hr8a35587a29;

  /// Modul: pesan & model bersama. Audit: HR-ID-5FFDFFF1F7
  ///
  /// In id, this message translates to:
  /// **'tahun'**
  String get hr5ffdfff1f7;

  /// Modul: komponen umum. Audit: HR-ID-6AD5100DB8
  ///
  /// In id, this message translates to:
  /// **'Tahun Ini'**
  String get hr6ad5100db8;

  /// Modul: home, intro, order. Audit: HR-ID-1D3E230FBD
  ///
  /// In id, this message translates to:
  /// **'Taking Order'**
  String get hr1d3e230fbd;

  /// Modul: global. Audit: HR-ID-06D0C1F5B5
  ///
  /// In id, this message translates to:
  /// **'Tambah baru'**
  String get hr06d0c1f5b5;

  /// Modul: kalender. Audit: HR-ID-F9F3F8BCB7
  ///
  /// In id, this message translates to:
  /// **'Tambah Event'**
  String get hrf9f3f8bcb7;

  /// Modul: activity. Audit: HR-ID-D4A11DA9B4
  ///
  /// In id, this message translates to:
  /// **'Tambah Kegiatan'**
  String get hrd4a11da9b4;

  /// Modul: delivery. Audit: HR-ID-D0D75A1028
  ///
  /// In id, this message translates to:
  /// **'Tambah Kunjungan Baru'**
  String get hrd0d75a1028;

  /// Modul: logbook. Audit: HR-ID-8E1334C178
  ///
  /// In id, this message translates to:
  /// **'Tambah Logbook'**
  String get hr8e1334c178;

  /// Modul: apotek. Audit: HR-ID-029B123563
  ///
  /// In id, this message translates to:
  /// **'Tambah Outlet Baru'**
  String get hr029b123563;

  /// Modul: announcement. Audit: HR-ID-725BA70A2A
  ///
  /// In id, this message translates to:
  /// **'Tambah Pengumuman'**
  String get hr725ba70a2a;

  /// Modul: delivery. Audit: HR-ID-F486E634CF
  ///
  /// In id, this message translates to:
  /// **'Tambahan'**
  String get hrf486e634cf;

  /// Modul: reimbursement. Audit: HR-ID-F66DD93B63
  ///
  /// In id, this message translates to:
  /// **'Tambahkan catatan (opsional)'**
  String get hrf66dd93b63;

  /// Modul: kpi. Audit: HR-ID-88FBA7D8F9
  ///
  /// In id, this message translates to:
  /// **'Tambahkan catatan keseluruhan (opsional)'**
  String get hr88fba7d8f9;

  /// Modul: reimbursement. Audit: HR-ID-AB8C6350D6
  ///
  /// In id, this message translates to:
  /// **'Tambahkan foto atau dokumen'**
  String get hrab8c6350d6;

  /// Modul: attendance, attendance_request, home, leave, overtime. Audit: HR-ID-937D6DF8BA
  ///
  /// In id, this message translates to:
  /// **'Tambahkan foto atau dokumen pendukung'**
  String get hr937d6df8ba;

  /// Modul: home. Audit: HR-ID-7236565E91
  ///
  /// In id, this message translates to:
  /// **'Tambahkan logbook pekerjaan hari ini'**
  String get hr7236565e91;

  /// Modul: logbook. Audit: HR-ID-876FEEF575
  ///
  /// In id, this message translates to:
  /// **'Tampilkan aksi'**
  String get hr876feef575;

  /// Modul: activity. Audit: HR-ID-40DD50CF32
  ///
  /// In id, this message translates to:
  /// **'Tampilkan Code'**
  String get hr40dd50cf32;

  /// Modul: announcement. Audit: HR-ID-8216310C87
  ///
  /// In id, this message translates to:
  /// **'Tampilkan di bagian teratas'**
  String get hr8216310c87;

  /// Modul: home. Audit: HR-ID-9E315E2BBA
  ///
  /// In id, this message translates to:
  /// **'Tampilkan jadwal kerja'**
  String get hr9e315e2bba;

  /// Modul: profile. Audit: HR-ID-952577DB0E
  ///
  /// In id, this message translates to:
  /// **'Tampilkan kartu identitas'**
  String get hr952577db0e;

  /// Modul: home. Audit: HR-ID-DD59E3399A
  ///
  /// In id, this message translates to:
  /// **'Tampilkan masuk dan pulang'**
  String get hrdd59e3399a;

  /// Modul: profile. Audit: HR-ID-86B0411003
  ///
  /// In id, this message translates to:
  /// **'Tampilkan QR untuk dipindai petugas presensi kegiatan'**
  String get hr86b0411003;

  /// Modul: announcement. Audit: HR-ID-15D80A173E
  ///
  /// In id, this message translates to:
  /// **'Tampilkan sebagai Popup'**
  String get hr15d80a173e;

  /// Modul: activity, attendance, attendance_request, delivery, komponen umum, overtime, reimbursement, shift. Audit: HR-ID-807151F245
  ///
  /// In id, this message translates to:
  /// **'Tanggal'**
  String get hr807151f245;

  /// Modul: pesan & model bersama. Audit: HR-ID-01F353F22E
  ///
  /// In id, this message translates to:
  /// **'tanggal'**
  String get hr01f353f22e;

  /// Modul: announcement. Audit: HR-ID-1A109B7675
  ///
  /// In id, this message translates to:
  /// **'Tanggal berakhir tidak boleh lebih awal dari tanggal mulai'**
  String get hr1a109b7675;

  /// Modul: profile. Audit: HR-ID-61DE15EA41
  ///
  /// In id, this message translates to:
  /// **'Tanggal Berdiri'**
  String get hr61de15ea41;

  /// Modul: profile. Audit: HR-ID-75A8F94D75
  ///
  /// In id, this message translates to:
  /// **'Tanggal Bergabung'**
  String get hr75a8f94d75;

  /// Modul: leave. Audit: HR-ID-81275C0D27
  ///
  /// In id, this message translates to:
  /// **'Tanggal Izin'**
  String get hr81275c0d27;

  /// Modul: profile. Audit: HR-ID-05750E9BE5
  ///
  /// In id, this message translates to:
  /// **'tanggal jatuh tempo pajak'**
  String get hr05750e9be5;

  /// Modul: activity. Audit: HR-ID-B458062C95
  ///
  /// In id, this message translates to:
  /// **'Tanggal kegiatan *'**
  String get hrb458062c95;

  /// Modul: delivery. Audit: HR-ID-C99FE29E6B
  ///
  /// In id, this message translates to:
  /// **'Tanggal Kunjungan'**
  String get hrc99fe29e6b;

  /// Modul: profile. Audit: HR-ID-E5DD910653
  ///
  /// In id, this message translates to:
  /// **'Tanggal Lahir'**
  String get hre5dd910653;

  /// Modul: van_stock. Audit: HR-ID-EAD7D5656F
  ///
  /// In id, this message translates to:
  /// **'Tanggal Load: {nilai1}'**
  String hread7d5656f(String nilai1);

  /// Modul: leave. Audit: HR-ID-9E528278C1
  ///
  /// In id, this message translates to:
  /// **'Tanggal Masuk'**
  String get hr9e528278c1;

  /// Modul: leave. Audit: HR-ID-BB48601D72
  ///
  /// In id, this message translates to:
  /// **'Tanggal Mulai'**
  String get hrbb48601d72;

  /// Modul: kalender. Audit: HR-ID-D218863ED7
  ///
  /// In id, this message translates to:
  /// **'Tanggal Mulai *'**
  String get hrd218863ed7;

  /// Modul: leave. Audit: HR-ID-80C6F91B09
  ///
  /// In id, this message translates to:
  /// **'Tanggal mulai tidak boleh sebelum hari ini'**
  String get hr80c6f91b09;

  /// Modul: leave. Audit: HR-ID-44E5DD7DB4
  ///
  /// In id, this message translates to:
  /// **'Tanggal mulai wajib diisi'**
  String get hr44e5dd7db4;

  /// Modul: profile. Audit: HR-ID-60C9202E93
  ///
  /// In id, this message translates to:
  /// **'Tanggal Pembayaran'**
  String get hr60c9202e93;

  /// Modul: komponen umum, leave, loan, reimbursement. Audit: HR-ID-44EE44527E
  ///
  /// In id, this message translates to:
  /// **'Tanggal Pengajuan'**
  String get hr44ee44527e;

  /// Modul: shift. Audit: HR-ID-5193C7EF5F
  ///
  /// In id, this message translates to:
  /// **'Tanggal Penugasan'**
  String get hr5193c7ef5f;

  /// Modul: attendance_request. Audit: HR-ID-C64B35922A
  ///
  /// In id, this message translates to:
  /// **'Tanggal Presensi'**
  String get hrc64b35922a;

  /// Modul: attendance_request. Audit: HR-ID-6FEBCA39C0
  ///
  /// In id, this message translates to:
  /// **'Tanggal Presensi wajib diisi'**
  String get hr6febca39c0;

  /// Modul: profile. Audit: HR-ID-4E6764EF3C
  ///
  /// In id, this message translates to:
  /// **'Tanggal Resign'**
  String get hr4e6764ef3c;

  /// Modul: kalender, leave. Audit: HR-ID-19DC5A1626
  ///
  /// In id, this message translates to:
  /// **'Tanggal Selesai'**
  String get hr19dc5a1626;

  /// Modul: leave. Audit: HR-ID-C68F52D57E
  ///
  /// In id, this message translates to:
  /// **'Tanggal selesai tidak boleh sebelum hari ini'**
  String get hrc68f52d57e;

  /// Modul: leave. Audit: HR-ID-8E9B80DCE8
  ///
  /// In id, this message translates to:
  /// **'Tanggal selesai tidak boleh sebelum tanggal mulai'**
  String get hr8e9b80dce8;

  /// Modul: leave. Audit: HR-ID-96A7543319
  ///
  /// In id, this message translates to:
  /// **'Tanggal selesai wajib diisi'**
  String get hr96a7543319;

  /// Modul: profile. Audit: HR-ID-510EA7EB18
  ///
  /// In id, this message translates to:
  /// **'Tanggal Servis Terakhir'**
  String get hr510ea7eb18;

  /// Modul: profile. Audit: HR-ID-7594CAEE96
  ///
  /// In id, this message translates to:
  /// **'tanggal servis terakhir'**
  String get hr7594caee96;

  /// Modul: shift. Audit: HR-ID-32A97D5114
  ///
  /// In id, this message translates to:
  /// **'Tanggal Shift Tujuan'**
  String get hr32a97d5114;

  /// Modul: reimbursement. Audit: HR-ID-13E3F117B7
  ///
  /// In id, this message translates to:
  /// **'Tanggal Transaksi'**
  String get hr13e3f117b7;

  /// Modul: overtime, reimbursement, shift. Audit: HR-ID-64C3893CD9
  ///
  /// In id, this message translates to:
  /// **'Tanggal wajib diisi'**
  String get hr64c3893cd9;

  /// Modul: activity. Audit: HR-ID-61AB858665
  ///
  /// In id, this message translates to:
  /// **'Tanpa presensi'**
  String get hr61ab858665;

  /// Modul: global. Audit: HR-ID-5AA0D2449A
  ///
  /// In id, this message translates to:
  /// **'Tap to Check In'**
  String get hr5aa0d2449a;

  /// Modul: global. Audit: HR-ID-57C3316E06
  ///
  /// In id, this message translates to:
  /// **'Tap to Check Out'**
  String get hr57c3316e06;

  /// Modul: home. Audit: HR-ID-CBE9460B45
  ///
  /// In id, this message translates to:
  /// **'Target Kerja'**
  String get hrcbe9460b45;

  /// Modul: komponen umum. Audit: HR-ID-84C7685053
  ///
  /// In id, this message translates to:
  /// **'Tarik untuk muat lagi'**
  String get hr84c7685053;

  /// Modul: apotek. Audit: HR-ID-396DC0E297
  ///
  /// In id, this message translates to:
  /// **'Telepon'**
  String get hr396dc0e297;

  /// Modul: delivery, order. Audit: HR-ID-DABA20F95A
  ///
  /// In id, this message translates to:
  /// **'Tempo / Kredit 14 Hari'**
  String get hrdaba20f95a;

  /// Modul: delivery, order. Audit: HR-ID-7231ACA16D
  ///
  /// In id, this message translates to:
  /// **'Tempo / Kredit 30 Hari'**
  String get hr7231aca16d;

  /// Modul: delivery, order. Audit: HR-ID-321D9F49EA
  ///
  /// In id, this message translates to:
  /// **'Tempo / Kredit 7 Hari'**
  String get hr321d9f49ea;

  /// Modul: loan. Audit: HR-ID-526CB657BA
  ///
  /// In id, this message translates to:
  /// **'Tenor (Bulan)'**
  String get hr526cb657ba;

  /// Modul: loan. Audit: HR-ID-A1EA6565AB
  ///
  /// In id, this message translates to:
  /// **'Tenor: {nilai1} Bulan'**
  String hra1ea6565ab(String nilai1);

  /// Modul: attendance, attendance_request, leave, overtime, payroll, reimbursement, shift. Audit: HR-ID-9FF8760B6D
  ///
  /// In id, this message translates to:
  /// **'Terapkan'**
  String get hr9ff8760b6d;

  /// Modul: delivery, order. Audit: HR-ID-733D0882AA
  ///
  /// In id, this message translates to:
  /// **'Terjadi kesalahan'**
  String get hr733d0882aa;

  /// Modul: pesan & model bersama. Audit: HR-ID-AE8C26595C
  ///
  /// In id, this message translates to:
  /// **'Terjadi kesalahan koneksi, coba lagi nanti'**
  String get hrae8c26595c;

  /// Modul: logbook. Audit: HR-ID-E239555E46
  ///
  /// In id, this message translates to:
  /// **'Terjadi kesalahan saat memproses logbook'**
  String get hre239555e46;

  /// Modul: komponen umum. Audit: HR-ID-B732A3D1A6
  ///
  /// In id, this message translates to:
  /// **'Terjadi kesalahan saat memproses permintaan Anda.'**
  String get hrb732a3d1a6;

  /// Modul: pesan & model bersama. Audit: HR-ID-3D2B302113
  ///
  /// In id, this message translates to:
  /// **'Terjadi kesalahan server internal'**
  String get hr3d2b302113;

  /// Modul: sistem & komponen umum. Audit: HR-ID-927C2F90B8
  ///
  /// In id, this message translates to:
  /// **'Terjadi kesalahan sistem!'**
  String get hr927c2f90b8;

  /// Modul: email. Audit: HR-ID-D851D69B35
  ///
  /// In id, this message translates to:
  /// **'Terjadi kesalahan tidak terduga'**
  String get hrd851d69b35;

  /// Modul: pesan & model bersama. Audit: HR-ID-54C47527B1
  ///
  /// In id, this message translates to:
  /// **'Terjadi Kesalahan, Silakan hubungi Tim Pengembang!'**
  String get hr54c47527b1;

  /// Modul: attendance, payroll. Audit: HR-ID-AD4E2E7E44
  ///
  /// In id, this message translates to:
  /// **'Terlambat'**
  String get hrad4e2e7e44;

  /// Modul: delivery, order. Audit: HR-ID-E72DF40E9D
  ///
  /// In id, this message translates to:
  /// **'Termin (Cicilan Berjangka)'**
  String get hre72df40e9d;

  /// Modul: delivery. Audit: HR-ID-941231C10C
  ///
  /// In id, this message translates to:
  /// **'Termin {nilai1} ({nilai2})'**
  String hr941231c10c(String nilai1, String nilai2);

  /// Modul: delivery. Audit: HR-ID-C204A18E7A
  ///
  /// In id, this message translates to:
  /// **'Tgl Kirim'**
  String get hrc204a18e7a;

  /// Modul: order. Audit: HR-ID-6D789CDDE9
  ///
  /// In id, this message translates to:
  /// **'Tgl Order: {nilai1}'**
  String hr6d789cdde9(String nilai1);

  /// Modul: sistem & komponen umum. Audit: HR-ID-2E62526A49
  ///
  /// In id, this message translates to:
  /// **'THB — Baht Thailand'**
  String get hr2e62526a49;

  /// Modul: delivery. Audit: HR-ID-93E1B3ED1E
  ///
  /// In id, this message translates to:
  /// **'Tiba ditempat'**
  String get hr93e1b3ed1e;

  /// Modul: attendance, home. Audit: HR-ID-39C991DBD3
  ///
  /// In id, this message translates to:
  /// **'Tidak'**
  String get hr39c991dbd3;

  /// Modul: profile. Audit: HR-ID-1D6C1667B2
  ///
  /// In id, this message translates to:
  /// **'Tidak ada antrean Kunjungan'**
  String get hr1d6c1667b2;

  /// Modul: profile. Audit: HR-ID-F11F5DB100
  ///
  /// In id, this message translates to:
  /// **'Tidak ada antrean Presensi'**
  String get hrf11f5db100;

  /// Modul: profile. Audit: HR-ID-F6EB943C44
  ///
  /// In id, this message translates to:
  /// **'Tidak ada antrean Sales Order'**
  String get hrf6eb943c44;

  /// Modul: komponen umum. Audit: HR-ID-2850971B54
  ///
  /// In id, this message translates to:
  /// **'Tidak ada data lagi'**
  String get hr2850971b54;

  /// Modul: logbook. Audit: HR-ID-D258B8AE99
  ///
  /// In id, this message translates to:
  /// **'Tidak ada data pada tanggal ini'**
  String get hrd258b8ae99;

  /// Modul: pesan & model bersama. Audit: HR-ID-3C51ED37E9
  ///
  /// In id, this message translates to:
  /// **'Tidak ada data yang ditampilkan'**
  String get hr3c51ed37e9;

  /// Modul: delivery. Audit: HR-ID-0443F59B1F
  ///
  /// In id, this message translates to:
  /// **'Tidak ada DO ditemukan'**
  String get hr0443f59b1f;

  /// Modul: kalender. Audit: HR-ID-D599539AF1
  ///
  /// In id, this message translates to:
  /// **'Tidak ada event bulan ini'**
  String get hrd599539af1;

  /// Modul: kalender. Audit: HR-ID-EB04D1DD64
  ///
  /// In id, this message translates to:
  /// **'Tidak ada event pada {nilai1}'**
  String hreb04d1dd64(String nilai1);

  /// Modul: delivery. Audit: HR-ID-4FDF5C734C
  ///
  /// In id, this message translates to:
  /// **'Tidak ada item tercatat.'**
  String get hr4fdf5c734c;

  /// Modul: pesan & model bersama. Audit: HR-ID-B7EA570E9C
  ///
  /// In id, this message translates to:
  /// **'Tidak ada jadwal efektif hari ini'**
  String get hrb7ea570e9c;

  /// Modul: logbook. Audit: HR-ID-29CAF588D1
  ///
  /// In id, this message translates to:
  /// **'Tidak ada kategori aktif'**
  String get hr29caf588d1;

  /// Modul: pesan & model bersama. Audit: HR-ID-249114AC9B
  ///
  /// In id, this message translates to:
  /// **'Tidak ada koneksi internet'**
  String get hr249114ac9b;

  /// Modul: pesan & model bersama. Audit: HR-ID-9D0E3DED95
  ///
  /// In id, this message translates to:
  /// **'Tidak ada koneksi internet dan data cache kosong.'**
  String get hr9d0e3ded95;

  /// Modul: pesan & model bersama. Audit: HR-ID-0706B75FC4
  ///
  /// In id, this message translates to:
  /// **'Tidak ada koneksi internet dan data produk cache kosong.'**
  String get hr0706b75fc4;

  /// Modul: home. Audit: HR-ID-AFE6E3CCA3
  ///
  /// In id, this message translates to:
  /// **'Tidak Ada Kunjungan'**
  String get hrafe6e3cca3;

  /// Modul: apotek. Audit: HR-ID-30B5792CFF
  ///
  /// In id, this message translates to:
  /// **'Tidak ada outlet ditemukan.'**
  String get hr30b5792cff;

  /// Modul: payroll. Audit: HR-ID-EF4F883C9E
  ///
  /// In id, this message translates to:
  /// **'Tidak ada payroll yang menunggu approval'**
  String get href4f883c9e;

  /// Modul: chat. Audit: HR-ID-AF84D1215A
  ///
  /// In id, this message translates to:
  /// **'Tidak ada pengguna tersedia'**
  String get hraf84d1215a;

  /// Modul: order. Audit: HR-ID-92D528B981
  ///
  /// In id, this message translates to:
  /// **'Tidak ada piutang saat ini.'**
  String get hr92d528b981;

  /// Modul: pesan & model bersama. Audit: HR-ID-AF1A406FC7
  ///
  /// In id, this message translates to:
  /// **'Tidak ada presensi aktif'**
  String get hraf1a406fc7;

  /// Modul: delivery. Audit: HR-ID-2E96F54D61
  ///
  /// In id, this message translates to:
  /// **'Tidak ada produk tersedia'**
  String get hr2e96f54d61;

  /// Modul: van_stock. Audit: HR-ID-F59D55DDBC
  ///
  /// In id, this message translates to:
  /// **'Tidak ada stok di kendaraan Anda saat ini.'**
  String get hrf59d55ddbc;

  /// Modul: delivery. Audit: HR-ID-D16E026E4A
  ///
  /// In id, this message translates to:
  /// **'Tidak ada tagihan tersedia'**
  String get hrd16e026e4a;

  /// Modul: logbook. Audit: HR-ID-1F851E5AC5
  ///
  /// In id, this message translates to:
  /// **'Tidak ada task pada filter ini.'**
  String get hr1f851e5ac5;

  /// Modul: sistem & komponen umum. Audit: HR-ID-786216DAF0
  ///
  /// In id, this message translates to:
  /// **'Tidak Aktif'**
  String get hr786216daf0;

  /// Modul: delivery. Audit: HR-ID-EA8C68B789
  ///
  /// In id, this message translates to:
  /// **'Tidak bisa membatalkan Kunjungan, status kerja anda masih Istirahat'**
  String get hrea8c68b789;

  /// Modul: delivery. Audit: HR-ID-AAFB0A454A
  ///
  /// In id, this message translates to:
  /// **'Tidak bisa membuat Kunjungan, status kerja anda masih Istirahat'**
  String get hraafb0a454a;

  /// Modul: delivery, home. Audit: HR-ID-75E99E1683
  ///
  /// In id, this message translates to:
  /// **'Tidak bisa memeriksa Kunjungan, status kerja anda masih Istirahat'**
  String get hr75e99e1683;

  /// Modul: global. Audit: HR-ID-4E3117EC09
  ///
  /// In id, this message translates to:
  /// **'Tidak dapat membuka Google Maps'**
  String get hr4e3117ec09;

  /// Modul: attendance. Audit: HR-ID-D13AFAB8CB
  ///
  /// In id, this message translates to:
  /// **'Tidak dapat mengambil lokasi. Pastikan izin lokasi aktif lalu coba lagi.'**
  String get hrd13afab8cb;

  /// Modul: activity. Audit: HR-ID-BD5CEFC9A6
  ///
  /// In id, this message translates to:
  /// **'Tidak diaktifkan'**
  String get hrbd5cefc9a6;

  /// Modul: profile. Audit: HR-ID-8827E76F82
  ///
  /// In id, this message translates to:
  /// **'Tidak diketahui'**
  String get hr8827e76f82;

  /// Modul: announcement. Audit: HR-ID-DE69B6FE65
  ///
  /// In id, this message translates to:
  /// **'Tidak ditentukan'**
  String get hrde69b6fe65;

  /// Modul: attendance. Audit: HR-ID-5F98FAE2DC
  ///
  /// In id, this message translates to:
  /// **'Tidak Hadir'**
  String get hr5f98fae2dc;

  /// Modul: global. Audit: HR-ID-8F9DFC77D2
  ///
  /// In id, this message translates to:
  /// **'Tidak setuju'**
  String get hr8f9dfc77d2;

  /// Modul: pesan & model bersama. Audit: HR-ID-D299E9170A
  ///
  /// In id, this message translates to:
  /// **'Tidak terhubung ke Internet'**
  String get hrd299e9170a;

  /// Modul: profile. Audit: HR-ID-FC2B991587
  ///
  /// In id, this message translates to:
  /// **'Tidak tersedia'**
  String get hrfc2b991587;

  /// Modul: delivery. Audit: HR-ID-F30827BD5B
  ///
  /// In id, this message translates to:
  /// **'Tidak, pilih lewat peta'**
  String get hrf30827bd5b;

  /// Modul: inventory. Audit: HR-ID-4C20E74480
  ///
  /// In id, this message translates to:
  /// **'Tindakan'**
  String get hr4c20e74480;

  /// Modul: intro. Audit: HR-ID-6ACCE24D59
  ///
  /// In id, this message translates to:
  /// **'Tingkatkan produktivitas tim Anda sekarang juga.'**
  String get hr6acce24d59;

  /// Modul: leave. Audit: HR-ID-AAE3472FB2
  ///
  /// In id, this message translates to:
  /// **'Tinjau pengajuan cuti karyawan'**
  String get hraae3472fb2;

  /// Modul: attendance_request. Audit: HR-ID-E664A96B63
  ///
  /// In id, this message translates to:
  /// **'Tinjau pengajuan koreksi presensi karyawan'**
  String get hre664a96b63;

  /// Modul: overtime. Audit: HR-ID-081CD34D88
  ///
  /// In id, this message translates to:
  /// **'Tinjau pengajuan lembur karyawan'**
  String get hr081cd34d88;

  /// Modul: payroll. Audit: HR-ID-0C7D81500C
  ///
  /// In id, this message translates to:
  /// **'Tinjau pengajuan payroll karyawan'**
  String get hr0c7d81500c;

  /// Modul: reimbursement. Audit: HR-ID-0435155646
  ///
  /// In id, this message translates to:
  /// **'Tinjau pengajuan reimbursement karyawan'**
  String get hr0435155646;

  /// Modul: home. Audit: HR-ID-8499989CB2
  ///
  /// In id, this message translates to:
  /// **'Tinjau pengajuan sesuai kewenangan'**
  String get hr8499989cb2;

  /// Modul: approval_center. Audit: HR-ID-457692A836
  ///
  /// In id, this message translates to:
  /// **'Tinjau pengajuan sesuai kewenangan Anda. Setiap jenis memiliki antrean dan filter sendiri.'**
  String get hr457692a836;

  /// Modul: shift. Audit: HR-ID-8F99501D46
  ///
  /// In id, this message translates to:
  /// **'Tinjau pengajuan tukar shift karyawan'**
  String get hr8f99501d46;

  /// Modul: approval_center. Audit: HR-ID-2FA1CE6EB1
  ///
  /// In id, this message translates to:
  /// **'Tinjau tanggal, durasi, dan tahap persetujuan'**
  String get hr2fa1ce6eb1;

  /// Modul: apotek. Audit: HR-ID-D809B1515D
  ///
  /// In id, this message translates to:
  /// **'Tipe'**
  String get hrd809b1515d;

  /// Modul: delivery. Audit: HR-ID-106113711A
  ///
  /// In id, this message translates to:
  /// **'Tipe Call'**
  String get hr106113711a;

  /// Modul: delivery. Audit: HR-ID-7763252A1E
  ///
  /// In id, this message translates to:
  /// **'Tipe Call wajib diisi untuk kunjungan penawaran'**
  String get hr7763252a1e;

  /// Modul: kalender. Audit: HR-ID-8E1E2C7019
  ///
  /// In id, this message translates to:
  /// **'Tipe Event *'**
  String get hr8e1e2c7019;

  /// Modul: delivery, order. Audit: HR-ID-1F70DE9D48
  ///
  /// In id, this message translates to:
  /// **'Tipe Order'**
  String get hr1f70de9d48;

  /// Modul: order. Audit: HR-ID-E5F5AA182F
  ///
  /// In id, this message translates to:
  /// **'Tipe Order: {nilai1}'**
  String hre5f5aa182f(String nilai1);

  /// Modul: apotek. Audit: HR-ID-F7EDDC760D
  ///
  /// In id, this message translates to:
  /// **'Tipe Outlet'**
  String get hrf7eddc760d;

  /// Modul: kalender. Audit: HR-ID-05153620DA
  ///
  /// In id, this message translates to:
  /// **'Tipe Pengulangan *'**
  String get hr05153620da;

  /// Modul: loan. Audit: HR-ID-D47E9C4989
  ///
  /// In id, this message translates to:
  /// **'Tipe Pinjaman'**
  String get hrd47e9c4989;

  /// Modul: attendance. Audit: HR-ID-9746140067
  ///
  /// In id, this message translates to:
  /// **'Tipe Presensi'**
  String get hr9746140067;

  /// Modul: profile. Audit: HR-ID-40F0C6A918
  ///
  /// In id, this message translates to:
  /// **'Tipe: {nilai1} • Item: {nilai2}'**
  String hr40f0c6a918(String nilai1, String nilai2);

  /// Modul: survey. Audit: HR-ID-C14A84B0E6
  ///
  /// In id, this message translates to:
  /// **'Token login tidak ditemukan. Silakan login ulang.'**
  String get hrc14a84b0e6;

  /// Modul: profile. Audit: HR-ID-07614C70A5
  ///
  /// In id, this message translates to:
  /// **'Token QR tidak tersedia'**
  String get hr07614c70a5;

  /// Modul: attendance_request, leave, overtime, payroll, reimbursement, shift. Audit: HR-ID-E2F73DAF8A
  ///
  /// In id, this message translates to:
  /// **'Tolak'**
  String get hre2f73daf8a;

  /// Modul: payroll. Audit: HR-ID-6C71FBC6AF
  ///
  /// In id, this message translates to:
  /// **'Tolak payroll?'**
  String get hr6c71fbc6af;

  /// Modul: attendance, dashboard. Audit: HR-ID-B25928C699
  ///
  /// In id, this message translates to:
  /// **'Total'**
  String get hrb25928c699;

  /// Modul: kpi. Audit: HR-ID-A6388B1AD0
  ///
  /// In id, this message translates to:
  /// **'Total Anggota'**
  String get hra6388b1ad0;

  /// Modul: consignment. Audit: HR-ID-B8634BEB9E
  ///
  /// In id, this message translates to:
  /// **'Total Biaya Estimasi'**
  String get hrb8634beb9e;

  /// Modul: apotek. Audit: HR-ID-B3D9E371D7
  ///
  /// In id, this message translates to:
  /// **'Total Data Dimuat'**
  String get hrb3d9e371d7;

  /// Modul: home. Audit: HR-ID-39F61FDF43
  ///
  /// In id, this message translates to:
  /// **'Total durasi'**
  String get hr39f61fdf43;

  /// Modul: leave. Audit: HR-ID-DA858457DD
  ///
  /// In id, this message translates to:
  /// **'Total Durasi'**
  String get hrda858457dd;

  /// Modul: attendance. Audit: HR-ID-2AC67F6BB4
  ///
  /// In id, this message translates to:
  /// **'Total Hadir'**
  String get hr2ac67f6bb4;

  /// Modul: payroll. Audit: HR-ID-CC0009FCD7
  ///
  /// In id, this message translates to:
  /// **'Total Insentif'**
  String get hrcc0009fcd7;

  /// Modul: attendance. Audit: HR-ID-68CFD9CB60
  ///
  /// In id, this message translates to:
  /// **'Total Istirahat'**
  String get hr68cfd9cb60;

  /// Modul: overtime. Audit: HR-ID-6995B9B606
  ///
  /// In id, this message translates to:
  /// **'Total Jam'**
  String get hr6995b9b606;

  /// Modul: dashboard. Audit: HR-ID-5531085EBB
  ///
  /// In id, this message translates to:
  /// **'Total Jarak'**
  String get hr5531085ebb;

  /// Modul: consignment. Audit: HR-ID-371D38EA0C
  ///
  /// In id, this message translates to:
  /// **'Total Jarak Estimasi'**
  String get hr371d38ea0c;

  /// Modul: attendance. Audit: HR-ID-651AD45B5C
  ///
  /// In id, this message translates to:
  /// **'Total Kerja'**
  String get hr651ad45b5c;

  /// Modul: payroll. Audit: HR-ID-BEA3D65923
  ///
  /// In id, this message translates to:
  /// **'Total Lembur'**
  String get hrbea3d65923;

  /// Modul: delivery. Audit: HR-ID-0792DBEFCB
  ///
  /// In id, this message translates to:
  /// **'Total Order'**
  String get hr0792dbefcb;

  /// Modul: payroll. Audit: HR-ID-726468B7DE
  ///
  /// In id, this message translates to:
  /// **'Total payroll'**
  String get hr726468b7de;

  /// Modul: delivery. Audit: HR-ID-0EDBC4A83D
  ///
  /// In id, this message translates to:
  /// **'Total Pembayaran'**
  String get hr0edbc4a83d;

  /// Modul: apotek. Audit: HR-ID-60B5AF4635
  ///
  /// In id, this message translates to:
  /// **'Total Pembelian'**
  String get hr60b5af4635;

  /// Modul: payroll. Audit: HR-ID-90E244D2F6
  ///
  /// In id, this message translates to:
  /// **'Total Pendapatan'**
  String get hr90e244d2f6;

  /// Modul: delivery. Audit: HR-ID-91644886F9
  ///
  /// In id, this message translates to:
  /// **'Total Pesanan'**
  String get hr91644886f9;

  /// Modul: order. Audit: HR-ID-71E3693022
  ///
  /// In id, this message translates to:
  /// **'Total Piutang'**
  String get hr71e3693022;

  /// Modul: payroll. Audit: HR-ID-02F7EDDC5B
  ///
  /// In id, this message translates to:
  /// **'Total Potongan'**
  String get hr02f7eddc5b;

  /// Modul: order. Audit: HR-ID-8396D25439
  ///
  /// In id, this message translates to:
  /// **'Total Produk'**
  String get hr8396d25439;

  /// Modul: delivery. Audit: HR-ID-2686B981EA
  ///
  /// In id, this message translates to:
  /// **'Total Qty Item'**
  String get hr2686b981ea;

  /// Modul: delivery. Audit: HR-ID-58762E13DC
  ///
  /// In id, this message translates to:
  /// **'Total Sisa Tagihan'**
  String get hr58762e13dc;

  /// Modul: delivery. Audit: HR-ID-0FC983ED2D
  ///
  /// In id, this message translates to:
  /// **'Total Tagihan'**
  String get hr0fc983ed2d;

  /// Modul: payroll. Audit: HR-ID-DAAF0DC350
  ///
  /// In id, this message translates to:
  /// **'Total Tunjangan'**
  String get hrdaaf0dc350;

  /// Modul: apotek. Audit: HR-ID-4949C4C8F4
  ///
  /// In id, this message translates to:
  /// **'Total Value'**
  String get hr4949c4c8f4;

  /// Modul: consignment. Audit: HR-ID-46A803F75D
  ///
  /// In id, this message translates to:
  /// **'Total Waktu Estimasi'**
  String get hr46a803f75d;

  /// Modul: consignment. Audit: HR-ID-387FBD82D6
  ///
  /// In id, this message translates to:
  /// **'Total Waktu Istirahat'**
  String get hr387fbd82d6;

  /// Modul: consignment. Audit: HR-ID-D5533A0A1C
  ///
  /// In id, this message translates to:
  /// **'Total Waktu Realita'**
  String get hrd5533a0a1c;

  /// Modul: logbook. Audit: HR-ID-16774D86F2
  ///
  /// In id, this message translates to:
  /// **'Total: {nilai1}'**
  String hr16774d86f2(String nilai1);

  /// Modul: delivery. Audit: HR-ID-023CA4AA9D
  ///
  /// In id, this message translates to:
  /// **'Total: {nilai1} item'**
  String hr023ca4aa9d(String nilai1);

  /// Modul: apotek. Audit: HR-ID-B653B31B8E
  ///
  /// In id, this message translates to:
  /// **'Transaksi Terakhir'**
  String get hrb653b31b8e;

  /// Modul: sistem & komponen umum. Audit: HR-ID-D575F734E2
  ///
  /// In id, this message translates to:
  /// **'TRY — Lira Turki'**
  String get hrd575f734e2;

  /// Modul: delivery. Audit: HR-ID-4D07789BB3
  ///
  /// In id, this message translates to:
  /// **'Tujuan Kunjungan'**
  String get hr4d07789bb3;

  /// Modul: loan. Audit: HR-ID-D3E71F026B
  ///
  /// In id, this message translates to:
  /// **'Tujuan Pinjaman'**
  String get hrd3e71f026b;

  /// Modul: home. Audit: HR-ID-506B418D7E
  ///
  /// In id, this message translates to:
  /// **'Tukar shift'**
  String get hr506b418d7e;

  /// Modul: shift. Audit: HR-ID-57C2C219B1
  ///
  /// In id, this message translates to:
  /// **'Tukar Shift'**
  String get hr57c2c219b1;

  /// Modul: delivery, order. Audit: HR-ID-010A32E0C3
  ///
  /// In id, this message translates to:
  /// **'Tulis Catatan (Optional)'**
  String get hr010a32e0c3;

  /// Modul: home. Audit: HR-ID-9DF9B10D7B
  ///
  /// In id, this message translates to:
  /// **'Tuliskan alasan/kegiatan lembur...'**
  String get hr9df9b10d7b;

  /// Modul: pesan & model bersama. Audit: HR-ID-14F9AA96C3
  ///
  /// In id, this message translates to:
  /// **'Tunggu sebentar'**
  String get hr14f9aa96c3;

  /// Modul: profile. Audit: HR-ID-5A32F84F33
  ///
  /// In id, this message translates to:
  /// **'Tunjukkan QR ini kepada petugas kegiatan.'**
  String get hr5a32f84f33;

  /// Modul: activity, announcement, attendance, attendance_request, global, home, komponen umum, leave, logbook, login, overtime, profile, reimbursement, shift, sistem & komponen umum. Audit: HR-ID-06CDE76B08
  ///
  /// In id, this message translates to:
  /// **'Tutup'**
  String get hr06cde76b08;

  /// Modul: logbook. Audit: HR-ID-22DA71065F
  ///
  /// In id, this message translates to:
  /// **'Tutup aksi'**
  String get hr22da71065f;

  /// Modul: activity. Audit: HR-ID-F4D8026A57
  ///
  /// In id, this message translates to:
  /// **'Tutup presensi'**
  String get hrf4d8026a57;

  /// Modul: sistem & komponen umum. Audit: HR-ID-EFC4CFAAB0
  ///
  /// In id, this message translates to:
  /// **'TWD — Dollar Taiwan Baru'**
  String get hrefc4cfaab0;

  /// Modul: global. Audit: HR-ID-0D4E86DD43
  ///
  /// In id, this message translates to:
  /// **'Ubah'**
  String get hr0d4e86dd43;

  /// Modul: global. Audit: HR-ID-7E4C07C4FE
  ///
  /// In id, this message translates to:
  /// **'Ubah gambar'**
  String get hr7e4c07c4fe;

  /// Modul: overtime. Audit: HR-ID-56FBBFB208
  ///
  /// In id, this message translates to:
  /// **'Ubah Lembur'**
  String get hr56fbbfb208;

  /// Modul: global. Audit: HR-ID-2D03AB8EFC
  ///
  /// In id, this message translates to:
  /// **'Ubah Lokasi'**
  String get hr2d03ab8efc;

  /// Modul: profile. Audit: HR-ID-0C2B587770
  ///
  /// In id, this message translates to:
  /// **'Ubah password dan pengaturan keamanan akun'**
  String get hr0c2b587770;

  /// Modul: login. Audit: HR-ID-7A81E1CA36
  ///
  /// In id, this message translates to:
  /// **'Ulangi password'**
  String get hr7a81e1ca36;

  /// Modul: apotek, profile. Audit: HR-ID-2DD33EB6ED
  ///
  /// In id, this message translates to:
  /// **'Umum'**
  String get hr2dd33eb6ed;

  /// Modul: payroll. Audit: HR-ID-9E7C4F9F09
  ///
  /// In id, this message translates to:
  /// **'Unduh Slip PDF'**
  String get hr9e7c4f9f09;

  /// Modul: payroll. Audit: HR-ID-FC71AA8981
  ///
  /// In id, this message translates to:
  /// **'Unduhan Slip Gaji'**
  String get hrfc71aa8981;

  /// Modul: instansi. Audit: HR-ID-95192962C2
  ///
  /// In id, this message translates to:
  /// **'Unggah Logo Instansi/Organisasi (opsional)'**
  String get hr95192962c2;

  /// Modul: delivery. Audit: HR-ID-9BC3991C79
  ///
  /// In id, this message translates to:
  /// **'Unvisited / Missed'**
  String get hr9bc3991c79;

  /// Modul: pesan & model bersama. Audit: HR-ID-C817821627
  ///
  /// In id, this message translates to:
  /// **'Upload file dibatalkan'**
  String get hrc817821627;

  /// Modul: delivery. Audit: HR-ID-6BC5962424
  ///
  /// In id, this message translates to:
  /// **'Upload File Optional'**
  String get hr6bc5962424;

  /// Modul: sistem & komponen umum. Audit: HR-ID-007655B30F
  ///
  /// In id, this message translates to:
  /// **'US Dollar (USD)'**
  String get hr007655b30f;

  /// Modul: sistem & komponen umum. Audit: HR-ID-0B46CA1883
  ///
  /// In id, this message translates to:
  /// **'USD — Dollar Amerika'**
  String get hr0b46ca1883;

  /// Modul: login, profile. Audit: HR-ID-84C29015DE
  ///
  /// In id, this message translates to:
  /// **'Username'**
  String get hr84c29015de;

  /// Modul: pesan & model bersama. Audit: HR-ID-AC4C64510E
  ///
  /// In id, this message translates to:
  /// **'Username atau password salah'**
  String get hrac4c64510e;

  /// Modul: pesan & model bersama. Audit: HR-ID-633CC28B6B
  ///
  /// In id, this message translates to:
  /// **'Username atau Password salah'**
  String get hr633cc28b6b;

  /// Modul: login. Audit: HR-ID-3DA4232CAD
  ///
  /// In id, this message translates to:
  /// **'Username minimal 3 karakter'**
  String get hr3da4232cad;

  /// Modul: login. Audit: HR-ID-45585CE958
  ///
  /// In id, this message translates to:
  /// **'Username sudah digunakan'**
  String get hr45585ce958;

  /// Modul: login. Audit: HR-ID-EA5D8413FF
  ///
  /// In id, this message translates to:
  /// **'Username tersedia'**
  String get hrea5d8413ff;

  /// Modul: login. Audit: HR-ID-A171DD2DAE
  ///
  /// In id, this message translates to:
  /// **'Username/Email'**
  String get hra171dd2dae;

  /// Modul: activity. Audit: HR-ID-F38B7F15B9
  ///
  /// In id, this message translates to:
  /// **'Validasi lokasi petugas'**
  String get hrf38b7f15b9;

  /// Modul: home, van_stock. Audit: HR-ID-DAB129641A
  ///
  /// In id, this message translates to:
  /// **'Van Stock'**
  String get hrdab129641a;

  /// Modul: login. Audit: HR-ID-48C0247CF3
  ///
  /// In id, this message translates to:
  /// **'Verifikasi CAPTCHA'**
  String get hr48c0247cf3;

  /// Modul: profile. Audit: HR-ID-D7315F4B90
  ///
  /// In id, this message translates to:
  /// **'Versi Aplikasi'**
  String get hrd7315f4b90;

  /// Modul: login. Audit: HR-ID-009733FF8F
  ///
  /// In id, this message translates to:
  /// **'Versi Aplikasi {nilai1}+{nilai2} {nilai3} {nilai4}'**
  String hr009733ff8f(
    String nilai1,
    String nilai2,
    String nilai3,
    String nilai4,
  );

  /// Modul: delivery. Audit: HR-ID-662BE3BDBB
  ///
  /// In id, this message translates to:
  /// **'Visited (Selesai)'**
  String get hr662be3bdbb;

  /// Modul: sistem & komponen umum. Audit: HR-ID-E927161B59
  ///
  /// In id, this message translates to:
  /// **'VND — Dong Vietnam'**
  String get hre927161b59;

  /// Modul: sistem & komponen umum. Audit: HR-ID-D9338C7DAA
  ///
  /// In id, this message translates to:
  /// **'Wajah tidak terdeteksi!'**
  String get hrd9338c7daa;

  /// Modul: common. Audit: HR-ID-7B5EE930C9
  ///
  /// In id, this message translates to:
  /// **'Wajah tidak terdeteksi. Pastikan wajah terlihat jelas dan pencahayaan cukup.'**
  String get hr7b5ee930c9;

  /// Modul: inventory, survey. Audit: HR-ID-E6BC023EAB
  ///
  /// In id, this message translates to:
  /// **'Wajib'**
  String get hre6bc023eab;

  /// Modul: instansi, loan. Audit: HR-ID-484B0AA0BD
  ///
  /// In id, this message translates to:
  /// **'Wajib diisi'**
  String get hr484b0aa0bd;

  /// Modul: activity, komponen umum, logbook, shift. Audit: HR-ID-D546C40C22
  ///
  /// In id, this message translates to:
  /// **'Waktu'**
  String get hrd546c40c22;

  /// Modul: delivery. Audit: HR-ID-4ECCB5F822
  ///
  /// In id, this message translates to:
  /// **'Waktu dibatalkan'**
  String get hr4eccb5f822;

  /// Modul: attendance_request. Audit: HR-ID-A0F736B9BE
  ///
  /// In id, this message translates to:
  /// **'Waktu Diminta'**
  String get hra0f736b9be;

  /// Modul: consignment. Audit: HR-ID-9987520D2E
  ///
  /// In id, this message translates to:
  /// **'Waktu Estimasi'**
  String get hr9987520d2e;

  /// Modul: pesan & model bersama. Audit: HR-ID-496B78FCDE
  ///
  /// In id, this message translates to:
  /// **'Waktu habis saat mengirim data'**
  String get hr496b78fcde;

  /// Modul: inventory. Audit: HR-ID-C6191F34D2
  ///
  /// In id, this message translates to:
  /// **'Waktu Kejadian'**
  String get hrc6191f34d2;

  /// Modul: shift. Audit: HR-ID-7E48B53765
  ///
  /// In id, this message translates to:
  /// **'Waktu Kerja'**
  String get hr7e48b53765;

  /// Modul: pesan & model bersama. Audit: HR-ID-CABBFBB2E7
  ///
  /// In id, this message translates to:
  /// **'Waktu koneksi habis'**
  String get hrcabbfbb2e7;

  /// Modul: delivery. Audit: HR-ID-D69710A1D8
  ///
  /// In id, this message translates to:
  /// **'Waktu kunjungan'**
  String get hrd69710a1d8;

  /// Modul: kalender, overtime. Audit: HR-ID-03198EE236
  ///
  /// In id, this message translates to:
  /// **'Waktu Mulai'**
  String get hr03198ee236;

  /// Modul: kalender. Audit: HR-ID-BA6906E597
  ///
  /// In id, this message translates to:
  /// **'Waktu mulai dan selesai harus diisi'**
  String get hrba6906e597;

  /// Modul: app. Audit: HR-ID-B9BEBEC37D
  ///
  /// In id, this message translates to:
  /// **'Waktu mulai lembur tidak ditemukan'**
  String get hrb9bebec37d;

  /// Modul: app. Audit: HR-ID-F3A36331E2
  ///
  /// In id, this message translates to:
  /// **'Waktu mulai lembur tidak valid'**
  String get hrf3a36331e2;

  /// Modul: consignment. Audit: HR-ID-232BBBA697
  ///
  /// In id, this message translates to:
  /// **'Waktu Realita'**
  String get hr232bbba697;

  /// Modul: home, kalender, overtime. Audit: HR-ID-347E7EBA24
  ///
  /// In id, this message translates to:
  /// **'Waktu Selesai'**
  String get hr347e7eba24;

  /// Modul: kalender. Audit: HR-ID-89F8A7D3AB
  ///
  /// In id, this message translates to:
  /// **'Waktu selesai harus setelah waktu mulai'**
  String get hr89f8a7d3ab;

  /// Modul: attendance. Audit: HR-ID-AC77C5E7A6
  ///
  /// In id, this message translates to:
  /// **'Waktu Standar'**
  String get hrac77c5e7a6;

  /// Modul: delivery. Audit: HR-ID-54F5276872
  ///
  /// In id, this message translates to:
  /// **'Waktu tiba'**
  String get hr54f5276872;

  /// Modul: activity. Audit: HR-ID-644C94F245
  ///
  /// In id, this message translates to:
  /// **'Waktu tutup presensi harus setelah waktu buka.'**
  String get hr644c94f245;

  /// Modul: activity. Audit: HR-ID-9DB8F18716
  ///
  /// In id, this message translates to:
  /// **'Waktu tutup presensi tidak boleh lebih awal dari waktu selesai kegiatan.'**
  String get hr9db8f18716;

  /// Modul: attendance_request. Audit: HR-ID-05F09A3C56
  ///
  /// In id, this message translates to:
  /// **'Waktu yang Diminta'**
  String get hr05f09a3c56;

  /// Modul: attendance. Audit: HR-ID-FB063BB60C
  ///
  /// In id, this message translates to:
  /// **'Waktu {nilai1}'**
  String hrfb063bb60c(String nilai1);

  /// Modul: profile. Audit: HR-ID-2E8A57CC5C
  ///
  /// In id, this message translates to:
  /// **'Website'**
  String get hr2e8a57cc5c;

  /// Modul: apotek. Audit: HR-ID-B336FC5587
  ///
  /// In id, this message translates to:
  /// **'WhatsApp'**
  String get hrb336fc5587;

  /// Modul: sistem & komponen umum. Audit: HR-ID-29F06F10BE
  ///
  /// In id, this message translates to:
  /// **'Work From Home'**
  String get hr29f06f10be;

  /// Modul: home. Audit: HR-ID-667B6180BE
  ///
  /// In id, this message translates to:
  /// **'Ya, Batalkan'**
  String get hr667b6180be;

  /// Modul: delivery. Audit: HR-ID-769FF9CD75
  ///
  /// In id, this message translates to:
  /// **'Ya, saya sudah di lokasi'**
  String get hr769ff9cd75;

  /// Modul: sistem & komponen umum. Audit: HR-ID-2CE99E80DA
  ///
  /// In id, this message translates to:
  /// **'ZAR — Rand Afrika Selatan'**
  String get hr2ce99e80da;

  /// Modul: sistem & komponen umum. Audit: HR-ID-F246F1F587
  ///
  /// In id, this message translates to:
  /// **'Zera HRMS QA'**
  String get hrf246f1f587;

  /// Modul: instansi. Audit: HR-ID-B46C9D6441
  ///
  /// In id, this message translates to:
  /// **'Zona Waktu Operasional'**
  String get hrb46c9d6441;

  /// Modul: delivery. Audit: HR-ID-A44E7CF1B2
  ///
  /// In id, this message translates to:
  /// **'{nilai1} ({nilai2} dipilih)'**
  String hra44e7cf1b2(String nilai1, String nilai2);

  /// Modul: payroll. Audit: HR-ID-3D9303A340
  ///
  /// In id, this message translates to:
  /// **'{nilai1} ({nilai2} menit)'**
  String hr3d9303a340(String nilai1, String nilai2);

  /// Modul: loan, profile. Audit: HR-ID-B8797FD7A6
  ///
  /// In id, this message translates to:
  /// **'{nilai1} Bulan'**
  String hrb8797fd7a6(String nilai1);

  /// Modul: order. Audit: HR-ID-EB070ACC1E
  ///
  /// In id, this message translates to:
  /// **'{nilai1} Bulan / Termin'**
  String hreb070acc1e(String nilai1);

  /// Modul: payroll. Audit: HR-ID-76223649C2
  ///
  /// In id, this message translates to:
  /// **'{nilai1} dari {nilai2}'**
  String hr76223649c2(String nilai1, String nilai2);

  /// Modul: home. Audit: HR-ID-3ACDA2F4B7
  ///
  /// In id, this message translates to:
  /// **'{nilai1} data offline menunggu sinkronisasi'**
  String hr3acda2f4b7(String nilai1);

  /// Modul: leave. Audit: HR-ID-8B901C2099
  ///
  /// In id, this message translates to:
  /// **'{nilai1} Hari'**
  String hr8b901c2099(String nilai1);

  /// Modul: leave. Audit: HR-ID-3326D6000B
  ///
  /// In id, this message translates to:
  /// **'{nilai1} hari'**
  String hr3326d6000b(String nilai1);

  /// Modul: profile. Audit: HR-ID-262774E396
  ///
  /// In id, this message translates to:
  /// **'{nilai1} hari tersisa'**
  String hr262774e396(String nilai1);

  /// Modul: sistem & komponen umum. Audit: HR-ID-36EF2477C2
  ///
  /// In id, this message translates to:
  /// **'{nilai1} hari yang lalu'**
  String hr36ef2477c2(String nilai1);

  /// Modul: delivery. Audit: HR-ID-1D26476266
  ///
  /// In id, this message translates to:
  /// **'{nilai1} item produk'**
  String hr1d26476266(String nilai1);

  /// Modul: sistem & komponen umum. Audit: HR-ID-AE81476AEE
  ///
  /// In id, this message translates to:
  /// **'{nilai1} jam'**
  String hrae81476aee(String nilai1);

  /// Modul: overtime, sistem & komponen umum. Audit: HR-ID-87FC2C293F
  ///
  /// In id, this message translates to:
  /// **'{nilai1} Jam'**
  String hr87fc2c293f(String nilai1);

  /// Modul: sistem & komponen umum. Audit: HR-ID-9E32B239BA
  ///
  /// In id, this message translates to:
  /// **'{nilai1} Jam '**
  String hr9e32b239ba(String nilai1);

  /// Modul: sistem & komponen umum. Audit: HR-ID-9361AA08B2
  ///
  /// In id, this message translates to:
  /// **'{nilai1} jam yang lalu'**
  String hr9361aa08b2(String nilai1);

  /// Modul: home. Audit: HR-ID-FC0F564DFA
  ///
  /// In id, this message translates to:
  /// **'{nilai1} Jam {nilai2} Menit'**
  String hrfc0f564dfa(String nilai1, String nilai2);

  /// Modul: payroll. Audit: HR-ID-F2E8DA4BD7
  ///
  /// In id, this message translates to:
  /// **'{nilai1} karyawan'**
  String hrf2e8da4bd7(String nilai1);

  /// Modul: sistem & komponen umum. Audit: HR-ID-6BB06B165D
  ///
  /// In id, this message translates to:
  /// **'{nilai1} menit yang lalu'**
  String hr6bb06b165d(String nilai1);

  /// Modul: delivery. Audit: HR-ID-79EFED64F2
  ///
  /// In id, this message translates to:
  /// **'{nilai1} produk'**
  String hr79efed64f2(String nilai1);

  /// Modul: delivery. Audit: HR-ID-630BA35E7D
  ///
  /// In id, this message translates to:
  /// **'{nilai1} surat jalan tersedia'**
  String hr630ba35e7d(String nilai1);

  /// Modul: delivery. Audit: HR-ID-C825D96CF7
  ///
  /// In id, this message translates to:
  /// **'{nilai1} tagihan tersedia'**
  String hrc825d96cf7(String nilai1);

  /// Modul: profile. Audit: HR-ID-6BA6249C6C
  ///
  /// In id, this message translates to:
  /// **'{nilai1} Tahun'**
  String hr6ba6249c6c(String nilai1);

  /// Modul: logbook. Audit: HR-ID-09E8C0EA11
  ///
  /// In id, this message translates to:
  /// **'{nilai1} task · {nilai2}'**
  String hr09e8c0ea11(String nilai1, String nilai2);

  /// Modul: delivery. Audit: HR-ID-E9139D2A90
  ///
  /// In id, this message translates to:
  /// **'{nilai1} x Cicilan'**
  String hre9139d2a90(String nilai1);

  /// Modul: order. Audit: HR-ID-6A1A2C0A22
  ///
  /// In id, this message translates to:
  /// **'{nilai1} {nilai2} x Rp {nilai3}'**
  String hr6a1a2c0a22(String nilai1, String nilai2, String nilai3);

  /// Modul: profile. Audit: HR-ID-9647D1AB22
  ///
  /// In id, this message translates to:
  /// **'{nilai1} · {nilai2} ({nilai3} hari)'**
  String hr9647d1ab22(String nilai1, String nilai2, String nilai3);

  /// Modul: inventory. Audit: HR-ID-62D024E6D5
  ///
  /// In id, this message translates to:
  /// **'{nilai1} • Stok: {nilai2} {nilai3}'**
  String hr62d024e6d5(String nilai1, String nilai2, String nilai3);

  /// Modul: home. Audit: HR-ID-BA24854F16
  ///
  /// In id, this message translates to:
  /// **'{nilai1}, Waktu Saat Ini'**
  String hrba24854f16(String nilai1);

  /// Modul: attendance. Audit: HR-ID-A0E07D7EA7
  ///
  /// In id, this message translates to:
  /// **'{nilai1}{nilai2}j {nilai3}m {nilai4}d'**
  String hra0e07d7ea7(
    String nilai1,
    String nilai2,
    String nilai3,
    String nilai4,
  );

  /// Modul: sistem & komponen umum. Audit: HR-ID-950620546C
  ///
  /// In id, this message translates to:
  /// **'{par0} harus diisi!'**
  String hr950620546c(String par0);

  /// Modul: sistem & komponen umum. Audit: HR-ID-2FDD92A577
  ///
  /// In id, this message translates to:
  /// **'{par0} harus dipilih!'**
  String hr2fdd92a577(String par0);

  /// Modul: sistem & komponen umum. Audit: HR-ID-359858F8F0
  ///
  /// In id, this message translates to:
  /// **'{par0} tidak benar!'**
  String hr359858f8f0(String par0);

  /// Modul: sistem & komponen umum. Audit: HR-ID-46AF3DD302
  ///
  /// In id, this message translates to:
  /// **'{par0} untuk Mulai kerja!'**
  String hr46af3dd302(String par0);

  /// Modul: login. Audit: CONTEXT-LOGIN-MASUK. Khusus autentikasi; jangan dipakai untuk presensi.
  ///
  /// In id, this message translates to:
  /// **'Masuk'**
  String get signInAction;

  /// No description provided for @languageTitle.
  ///
  /// In id, this message translates to:
  /// **'Bahasa'**
  String get languageTitle;

  /// No description provided for @languageSystem.
  ///
  /// In id, this message translates to:
  /// **'Ikuti perangkat'**
  String get languageSystem;

  /// No description provided for @languageSaveFailed.
  ///
  /// In id, this message translates to:
  /// **'Pilihan bahasa belum dapat disimpan. Coba lagi.'**
  String get languageSaveFailed;

  /// Additional UI label reviewed during integration
  ///
  /// In id, this message translates to:
  /// **'Aksi Cepat'**
  String get uib439f6253a;

  /// Additional UI label reviewed during integration
  ///
  /// In id, this message translates to:
  /// **'Approval Payroll'**
  String get uibfa0c94608;

  /// Additional UI label reviewed during integration
  ///
  /// In id, this message translates to:
  /// **'Bulanan'**
  String get ui079614fbe6;

  /// Additional UI label reviewed during integration
  ///
  /// In id, this message translates to:
  /// **'Catatan Global'**
  String get ui2537c26b18;

  /// Additional UI label reviewed during integration
  ///
  /// In id, this message translates to:
  /// **'Daftar Item'**
  String get ui5d28f5d747;

  /// Additional UI label reviewed during integration
  ///
  /// In id, this message translates to:
  /// **'Daftar Produk'**
  String get ui39762aae2a;

  /// Additional UI label reviewed during integration
  ///
  /// In id, this message translates to:
  /// **'Data Kendaraan'**
  String get ui38e41ab8e2;

  /// Additional UI label reviewed during integration
  ///
  /// In id, this message translates to:
  /// **'Data Order'**
  String get ui8ada697c03;

  /// Additional UI label reviewed during integration
  ///
  /// In id, this message translates to:
  /// **'Data Outlet'**
  String get uicf14c7add2;

  /// Additional UI label reviewed during integration
  ///
  /// In id, this message translates to:
  /// **'Data Penagihan'**
  String get ui5ac7a77dea;

  /// Additional UI label reviewed during integration
  ///
  /// In id, this message translates to:
  /// **'Data Pengantaran'**
  String get ui1925d70ff8;

  /// Additional UI label reviewed during integration
  ///
  /// In id, this message translates to:
  /// **'Deskripsi Task'**
  String get ui5dbc544b24;

  /// Additional UI label reviewed during integration
  ///
  /// In id, this message translates to:
  /// **'Dibuat oleh'**
  String get ui1216355f2e;

  /// Additional UI label reviewed during integration
  ///
  /// In id, this message translates to:
  /// **'Filter Reimbursement'**
  String get uia57642e0a2;

  /// Additional UI label reviewed during integration
  ///
  /// In id, this message translates to:
  /// **'Filter Shift'**
  String get ui696951041c;

  /// Additional UI label reviewed during integration
  ///
  /// In id, this message translates to:
  /// **'Ganti Password'**
  String get ui91919fefc2;

  /// Additional UI label reviewed during integration
  ///
  /// In id, this message translates to:
  /// **'Identitas Diri'**
  String get ui4f8825c47a;

  /// Additional UI label reviewed during integration
  ///
  /// In id, this message translates to:
  /// **'Identitas Outlet'**
  String get uif20510b7fe;

  /// Additional UI label reviewed during integration
  ///
  /// In id, this message translates to:
  /// **'KARTU IDENTITAS'**
  String get ui6161ab11d6;

  /// Additional UI label reviewed during integration
  ///
  /// In id, this message translates to:
  /// **'Kadaluarsa'**
  String get ui6417dc96dd;

  /// Additional UI label reviewed during integration
  ///
  /// In id, this message translates to:
  /// **'Kecelakaan'**
  String get uib8d7ca3842;

  /// Additional UI label reviewed during integration
  ///
  /// In id, this message translates to:
  /// **'Kehilangan'**
  String get ui3fe01f3abb;

  /// Additional UI label reviewed during integration
  ///
  /// In id, this message translates to:
  /// **'Kerusakan'**
  String get ui2c6a4b3925;

  /// Additional UI label reviewed during integration
  ///
  /// In id, this message translates to:
  /// **'Keuangan'**
  String get ui0a8204b732;

  /// Additional UI label reviewed during integration
  ///
  /// In id, this message translates to:
  /// **'Kode'**
  String get ui3e25d43ab0;

  /// Additional UI label reviewed during integration
  ///
  /// In id, this message translates to:
  /// **'Koordinat Outlet'**
  String get uic4ca0ae931;

  /// Additional UI label reviewed during integration
  ///
  /// In id, this message translates to:
  /// **'Lampiran Bukti'**
  String get ui7516ce151d;

  /// Additional UI label reviewed during integration
  ///
  /// In id, this message translates to:
  /// **'Langganan'**
  String get uidf5e01f370;

  /// Additional UI label reviewed during integration
  ///
  /// In id, this message translates to:
  /// **'Lihat PDF'**
  String get ui42f797f733;

  /// Additional UI label reviewed during integration
  ///
  /// In id, this message translates to:
  /// **'Memeriksa...'**
  String get ui2e34c11916;

  /// Additional UI label reviewed during integration
  ///
  /// In id, this message translates to:
  /// **'Memproses...'**
  String get ui5f2061cbdf;

  /// Additional UI label reviewed during integration
  ///
  /// In id, this message translates to:
  /// **'Mencair/Rusak'**
  String get uif2a0a18820;

  /// Additional UI label reviewed during integration
  ///
  /// In id, this message translates to:
  /// **'Mingguan'**
  String get ui80ac23034d;

  /// Additional UI label reviewed during integration
  ///
  /// In id, this message translates to:
  /// **'Nilai:'**
  String get ui8be606bd6a;

  /// Additional UI label reviewed during integration
  ///
  /// In id, this message translates to:
  /// **'Nominal Transaksi/Penagihan'**
  String get uibb323b9592;

  /// Additional UI label reviewed during integration
  ///
  /// In id, this message translates to:
  /// **'Omzet'**
  String get ui4e970421d3;

  /// Additional UI label reviewed during integration
  ///
  /// In id, this message translates to:
  /// **'Operasional'**
  String get ui425f343568;

  /// Additional UI label reviewed during integration
  ///
  /// In id, this message translates to:
  /// **'Penilaian Manager'**
  String get ui643b2b3f56;

  /// Additional UI label reviewed during integration
  ///
  /// In id, this message translates to:
  /// **'Periode pengumuman'**
  String get ui029b2503df;

  /// Additional UI label reviewed during integration
  ///
  /// In id, this message translates to:
  /// **'Pesan Internal'**
  String get ui29d698c180;

  /// Additional UI label reviewed during integration
  ///
  /// In id, this message translates to:
  /// **'Rangkuman Perjalanan'**
  String get ui8e9e3014e4;

  /// Additional UI label reviewed during integration
  ///
  /// In id, this message translates to:
  /// **'Recycle (Sebagian/Semua)'**
  String get uia50e93a3af;

  /// Additional UI label reviewed during integration
  ///
  /// In id, this message translates to:
  /// **'Rendah'**
  String get uiafc56343d4;

  /// Additional UI label reviewed during integration
  ///
  /// In id, this message translates to:
  /// **'Sedang'**
  String get uiff9bb4f031;

  /// Additional UI label reviewed during integration
  ///
  /// In id, this message translates to:
  /// **'Sisa Tagihan'**
  String get uif10e195d9d;

  /// Additional UI label reviewed during integration
  ///
  /// In id, this message translates to:
  /// **'Sisa:'**
  String get ui28c1cbd86e;

  /// Additional UI label reviewed during integration
  ///
  /// In id, this message translates to:
  /// **'Tahunan'**
  String get ui9ee1ff1f6e;

  /// Additional UI label reviewed during integration
  ///
  /// In id, this message translates to:
  /// **'Thread Balasan'**
  String get ui83e5414a03;

  /// Additional UI label reviewed during integration
  ///
  /// In id, this message translates to:
  /// **'Tinggi'**
  String get uidc1b96ce5d;

  /// Additional UI label reviewed during integration
  ///
  /// In id, this message translates to:
  /// **'Tumpah/Bocor'**
  String get ui8478736bdd;

  /// Additional UI label reviewed during integration
  ///
  /// In id, this message translates to:
  /// **'Warna'**
  String get ui8f62a74dc3;

  /// Additional UI label reviewed during integration
  ///
  /// In id, this message translates to:
  /// **'Ya'**
  String get uic42a91c13d;

  /// UI label found in follow-up source audit
  ///
  /// In id, this message translates to:
  /// **'Informasi Aplikasi'**
  String get uib7a351e7c0;

  /// UI label found in follow-up source audit
  ///
  /// In id, this message translates to:
  /// **'Informasi Firebase'**
  String get uie2a96a7536;

  /// UI label found in follow-up source audit
  ///
  /// In id, this message translates to:
  /// **'Informasi GraphQL'**
  String get ui555ecc1acb;

  /// UI label found in follow-up source audit
  ///
  /// In id, this message translates to:
  /// **'PRESENSI MASUK'**
  String get ui8ba4666889;

  /// UI label found in follow-up source audit
  ///
  /// In id, this message translates to:
  /// **'PRESENSI PULANG'**
  String get ui981dbc6b9e;

  /// UI label found in follow-up source audit
  ///
  /// In id, this message translates to:
  /// **'Nilai Akhir'**
  String get uib076b8e169;

  /// UI label found in follow-up source audit
  ///
  /// In id, this message translates to:
  /// **'Predikat'**
  String get uiaecc49c153;

  /// UI label found in follow-up source audit
  ///
  /// In id, this message translates to:
  /// **'Maks:'**
  String get ui52d0a59a32;

  /// UI label found in follow-up source audit
  ///
  /// In id, this message translates to:
  /// **'Atur Ulang'**
  String get ui44c57abd88;

  /// UI label found in follow-up source audit
  ///
  /// In id, this message translates to:
  /// **'Mendesak'**
  String get uiecb26f46e3;

  /// UI label found in follow-up source audit
  ///
  /// In id, this message translates to:
  /// **'Halo, {nilai1}!'**
  String uia50e425dd3(String nilai1);

  /// UI label found in follow-up source audit
  ///
  /// In id, this message translates to:
  /// **'{nilai1} balasan'**
  String ui32832fa625(String nilai1);

  /// UI label found in follow-up source audit
  ///
  /// In id, this message translates to:
  /// **'Berulang mingguan'**
  String get ui583a2fd18f;

  /// UI label found in follow-up source audit
  ///
  /// In id, this message translates to:
  /// **'Berulang bulanan'**
  String get ui641f96bc5f;

  /// UI label found in follow-up source audit
  ///
  /// In id, this message translates to:
  /// **'Berulang tahunan'**
  String get uic080a6b934;

  /// UI label found in follow-up source audit
  ///
  /// In id, this message translates to:
  /// **'Event berulang'**
  String get ui14913a0ed1;

  /// UI label found in follow-up source audit
  ///
  /// In id, this message translates to:
  /// **'Tanpa Subjek'**
  String get ui1c783594c3;

  /// UI label found in follow-up source audit
  ///
  /// In id, this message translates to:
  /// **'{nilai1} meter'**
  String uic1358280a6(String nilai1);

  /// Short dynamic UI copy found during follow-up audit
  ///
  /// In id, this message translates to:
  /// **'Buruk'**
  String get ui2b9fad539b;

  /// Short dynamic UI copy found during follow-up audit
  ///
  /// In id, this message translates to:
  /// **'Kurang'**
  String get ui8e2ee674a7;

  /// Short dynamic UI copy found during follow-up audit
  ///
  /// In id, this message translates to:
  /// **'Biasa'**
  String get uib7d7ce3d8b;

  /// Short dynamic UI copy found during follow-up audit
  ///
  /// In id, this message translates to:
  /// **'Baik'**
  String get ui04f5b5ce05;

  /// Short dynamic UI copy found during follow-up audit
  ///
  /// In id, this message translates to:
  /// **'Sangat baik'**
  String get uie90dcd5d96;

  /// Short dynamic UI copy found during follow-up audit
  ///
  /// In id, this message translates to:
  /// **'{nilai1} Outlet'**
  String uibbc77d07a3(String nilai1);

  /// Short dynamic UI copy found during follow-up audit
  ///
  /// In id, this message translates to:
  /// **'{nilai1} Dipilih'**
  String uia6259df7a3(String nilai1);

  /// Short dynamic UI copy found during follow-up audit
  ///
  /// In id, this message translates to:
  /// **'DIAJUKAN {nilai1}'**
  String ui9d10d95a2b(String nilai1);

  /// Short dynamic UI copy found during follow-up audit
  ///
  /// In id, this message translates to:
  /// **'Stok: {nilai1}'**
  String ui9990e2eee5(String nilai1);

  /// Short dynamic UI copy found during follow-up audit
  ///
  /// In id, this message translates to:
  /// **'Habis'**
  String get ui1d846b91a0;

  /// Short dynamic UI copy found during follow-up audit
  ///
  /// In id, this message translates to:
  /// **'Catatan: {nilai1}'**
  String uiedd5120e58(String nilai1);

  /// Short dynamic UI copy found during follow-up audit
  ///
  /// In id, this message translates to:
  /// **'Tujuan: {nilai1}'**
  String uiab83fd5766(String nilai1);

  /// Short dynamic UI copy found during follow-up audit
  ///
  /// In id, this message translates to:
  /// **'{nilai1} aktivitas'**
  String ui299c51d314(String nilai1);

  /// Reviewed HR short label and attendance clock copy, 10 November 2026
  ///
  /// In id, this message translates to:
  /// **'Pengaju payroll'**
  String get uie1083c81f8;

  /// Reviewed HR short label and attendance clock copy, 10 November 2026
  ///
  /// In id, this message translates to:
  /// **'Tanpa kategori'**
  String get ui4ef7d73c1a;

  /// Short dynamic UI copy found during follow-up audit
  ///
  /// In id, this message translates to:
  /// **'Terlambat'**
  String get uiad4e2e7e44;

  /// Relative timestamp displayed in the selected application language
  ///
  /// In id, this message translates to:
  /// **'baru saja'**
  String get relativeJustNow;

  /// Relative timestamp displayed in the selected application language
  ///
  /// In id, this message translates to:
  /// **'{count} menit yang lalu'**
  String relativeMinutes(int count);

  /// Relative timestamp displayed in the selected application language
  ///
  /// In id, this message translates to:
  /// **'{count} jam yang lalu'**
  String relativeHours(int count);

  /// Relative timestamp displayed in the selected application language
  ///
  /// In id, this message translates to:
  /// **'{count} hari yang lalu'**
  String relativeDays(int count);

  /// Reviewed display label; keep underlying enum/API value unchanged
  ///
  /// In id, this message translates to:
  /// **'Diproses'**
  String get ui54dfaef699;

  /// Reviewed display label; keep underlying enum/API value unchanged
  ///
  /// In id, this message translates to:
  /// **'Dibatalkan'**
  String get ui1ed2b478dc;

  /// Reviewed display label; keep underlying enum/API value unchanged
  ///
  /// In id, this message translates to:
  /// **'Istirahat'**
  String get ui6305999358;

  /// Reviewed display label; keep underlying enum/API value unchanged
  ///
  /// In id, this message translates to:
  /// **'Galat'**
  String get ui08a868a780;

  /// Reviewed display label; keep underlying enum/API value unchanged
  ///
  /// In id, this message translates to:
  /// **'Diajukan'**
  String get ui2c509d5332;

  /// Reviewed display label; keep underlying enum/API value unchanged
  ///
  /// In id, this message translates to:
  /// **'Diterima'**
  String get ui64643bb547;

  /// Reviewed display label; keep underlying enum/API value unchanged
  ///
  /// In id, this message translates to:
  /// **'Mobil'**
  String get ui6e1dffe991;

  /// Reviewed display label; keep underlying enum/API value unchanged
  ///
  /// In id, this message translates to:
  /// **'Motor'**
  String get uiceaed7978d;

  /// Reviewed display label; keep underlying enum/API value unchanged
  ///
  /// In id, this message translates to:
  /// **'Truk Ekspedisi'**
  String get ui28911d9fee;

  /// Reviewed display label; keep underlying enum/API value unchanged
  ///
  /// In id, this message translates to:
  /// **'Reguler'**
  String get ui75182e45d2;

  /// Reviewed display label; keep underlying enum/API value unchanged
  ///
  /// In id, this message translates to:
  /// **'Koreksi Pulang'**
  String get ui9febdf15f5;

  /// Reviewed display label; keep underlying enum/API value unchanged
  ///
  /// In id, this message translates to:
  /// **'Koreksi Istirahat'**
  String get uib56784c123;

  /// Reviewed display label; keep underlying enum/API value unchanged
  ///
  /// In id, this message translates to:
  /// **'Dinas Luar'**
  String get uic92d89cca6;

  /// Reviewed display label; keep underlying enum/API value unchanged
  ///
  /// In id, this message translates to:
  /// **'Disetujui'**
  String get ui41b81eb8db;

  /// Reviewed display label; keep underlying enum/API value unchanged
  ///
  /// In id, this message translates to:
  /// **'Ditolak'**
  String get ui27eeb7a291;

  /// Reviewed display label; keep underlying enum/API value unchanged
  ///
  /// In id, this message translates to:
  /// **'Dibatalkan'**
  String get uia1bf92eff4;

  /// Reviewed display label; keep underlying enum/API value unchanged
  ///
  /// In id, this message translates to:
  /// **'Draf'**
  String get ui23d33e22ac;

  /// Reviewed display label; keep underlying enum/API value unchanged
  ///
  /// In id, this message translates to:
  /// **'Lunas'**
  String get uidc9d4584a5;

  /// Reviewed display label; keep underlying enum/API value unchanged
  ///
  /// In id, this message translates to:
  /// **'Tidak diketahui'**
  String get uibc7819b34f;

  /// Reviewed display label; keep underlying enum/API value unchanged
  ///
  /// In id, this message translates to:
  /// **'Satu Orang'**
  String get uidd2f7d8584;

  /// Reviewed display label; keep underlying enum/API value unchanged
  ///
  /// In id, this message translates to:
  /// **'Bertahap'**
  String get ui8ae1c10984;

  /// Reviewed display label; keep underlying enum/API value unchanged
  ///
  /// In id, this message translates to:
  /// **'Paralel'**
  String get uiafc129571b;

  /// Reviewed display label; keep underlying enum/API value unchanged
  ///
  /// In id, this message translates to:
  /// **'Sedang Berlangsung'**
  String get uif61eadaf15;

  /// Reviewed display label; keep underlying enum/API value unchanged
  ///
  /// In id, this message translates to:
  /// **'Terjadwal'**
  String get ui05a0b38c95;

  /// Reviewed display label; keep underlying enum/API value unchanged
  ///
  /// In id, this message translates to:
  /// **'Request Tukar'**
  String get ui5dcadd26d7;

  /// Reviewed display label; keep underlying enum/API value unchanged
  ///
  /// In id, this message translates to:
  /// **'Lupa Absen'**
  String get uia1a3a1f941;

  /// Reviewed display label; keep underlying enum/API value unchanged
  ///
  /// In id, this message translates to:
  /// **'Ambil Foto'**
  String get ui24e4c73c4c;

  /// Reviewed display label; keep underlying enum/API value unchanged
  ///
  /// In id, this message translates to:
  /// **'Sehari Penuh'**
  String get ui657c14012c;

  /// Reviewed display label; keep underlying enum/API value unchanged
  ///
  /// In id, this message translates to:
  /// **'Akan datang'**
  String get ui04bf2f39d7;

  /// Reviewed display label; keep underlying enum/API value unchanged
  ///
  /// In id, this message translates to:
  /// **'Isi Survei'**
  String get ui84de6eabea;

  /// Reviewed display label; keep underlying enum/API value unchanged
  ///
  /// In id, this message translates to:
  /// **'Opsi'**
  String get ui69e55a8d5b;

  /// Reviewed display label; keep underlying enum/API value unchanged
  ///
  /// In id, this message translates to:
  /// **'Laki-laki'**
  String get uiafdcb56438;

  /// Reviewed display label; keep underlying enum/API value unchanged
  ///
  /// In id, this message translates to:
  /// **'Perempuan'**
  String get uibc79719db2;

  /// Reviewed display label; keep underlying enum/API value unchanged
  ///
  /// In id, this message translates to:
  /// **'WFH'**
  String get uicdbb88ed18;

  /// Reviewed display label; keep underlying enum/API value unchanged
  ///
  /// In id, this message translates to:
  /// **'Rupiah (IDR)'**
  String get uia0573d02e7;

  /// Reviewed display label; keep underlying enum/API value unchanged
  ///
  /// In id, this message translates to:
  /// **'Euro (EUR)'**
  String get ui34085cff4c;

  /// Organization subscription display label
  ///
  /// In id, this message translates to:
  /// **'Uji Coba'**
  String get ui5f7537cf06;

  /// Organization subscription display label
  ///
  /// In id, this message translates to:
  /// **'Masa Tenggang'**
  String get uic204800f43;

  /// Organization subscription display label
  ///
  /// In id, this message translates to:
  /// **'Ditangguhkan'**
  String get uiea69f53a3c;

  /// Displayed travel duration in minutes
  ///
  /// In id, this message translates to:
  /// **'{nilai1} Menit'**
  String uifce3b58906(String nilai1);

  /// Reviewed HR short label and attendance clock copy, 10 November 2026
  ///
  /// In id, this message translates to:
  /// **'Pagi'**
  String get clockPeriodMorning;

  /// Reviewed HR short label and attendance clock copy, 10 November 2026
  ///
  /// In id, this message translates to:
  /// **'Siang'**
  String get clockPeriodMidday;

  /// Reviewed HR short label and attendance clock copy, 10 November 2026
  ///
  /// In id, this message translates to:
  /// **'Sore'**
  String get clockPeriodAfternoon;

  /// Reviewed HR short label and attendance clock copy, 10 November 2026
  ///
  /// In id, this message translates to:
  /// **'Malam'**
  String get clockPeriodNight;

  /// Reviewed HR short label and attendance clock copy, 10 November 2026
  ///
  /// In id, this message translates to:
  /// **'{period}, Waktu Saat Ini'**
  String attendanceClockLabel(String period);

  /// Reviewed HR short label and attendance clock copy, 10 November 2026
  ///
  /// In id, this message translates to:
  /// **'Ringkasan'**
  String get uid28feba121;

  /// Reviewed HR short label and attendance clock copy, 10 November 2026
  ///
  /// In id, this message translates to:
  /// **'Persetujuan payroll'**
  String get uid6d10bb273;

  /// Reviewed HR short label and attendance clock copy, 10 November 2026
  ///
  /// In id, this message translates to:
  /// **'No DO'**
  String get ui98658ffaa2;

  /// Reviewed HR short label and attendance clock copy, 10 November 2026
  ///
  /// In id, this message translates to:
  /// **'Status Pembayaran'**
  String get ui46dc607a5a;

  /// Reviewed HR short label and attendance clock copy, 10 November 2026
  ///
  /// In id, this message translates to:
  /// **'Bobot'**
  String get ui65a52414fb;

  /// Reviewed HR short label and attendance clock copy, 10 November 2026
  ///
  /// In id, this message translates to:
  /// **'Target'**
  String get ui61ad50a9b9;

  /// Reviewed HR short label and attendance clock copy, 10 November 2026
  ///
  /// In id, this message translates to:
  /// **'Aktual'**
  String get ui8c5da973dc;

  /// Reviewed HR short label and attendance clock copy, 10 November 2026
  ///
  /// In id, this message translates to:
  /// **'Rata-rata Skor'**
  String get ui97b17538e0;

  /// Reviewed HR short label and attendance clock copy, 10 November 2026
  ///
  /// In id, this message translates to:
  /// **'Tenor'**
  String get uie16b401bc4;

  /// Reviewed HR short label and attendance clock copy, 10 November 2026
  ///
  /// In id, this message translates to:
  /// **'Tujuan'**
  String get ui60d46377c7;

  /// Reviewed HR short label and attendance clock copy, 10 November 2026
  ///
  /// In id, this message translates to:
  /// **'Umur'**
  String get ui133cb71a5c;

  /// Reviewed HR short label and attendance clock copy, 10 November 2026
  ///
  /// In id, this message translates to:
  /// **'Tipe Identitas'**
  String get ui86f305a53f;

  /// Reviewed HR short label and attendance clock copy, 10 November 2026
  ///
  /// In id, this message translates to:
  /// **'No. Identitas'**
  String get ui0cf3f492b3;

  /// Reviewed HR short label and attendance clock copy, 10 November 2026
  ///
  /// In id, this message translates to:
  /// **'Domisili'**
  String get ui89bfdb640a;

  /// Reviewed HR short label and attendance clock copy, 10 November 2026
  ///
  /// In id, this message translates to:
  /// **'Kode Pos'**
  String get ui7357598871;

  /// Reviewed HR short label and attendance clock copy, 10 November 2026
  ///
  /// In id, this message translates to:
  /// **'Perusahaan'**
  String get ui8de8b44967;

  /// Reviewed HR short label and attendance clock copy, 10 November 2026
  ///
  /// In id, this message translates to:
  /// **'Lama Bergabung'**
  String get ui24e5162e96;

  /// Reviewed HR short label and attendance clock copy, 10 November 2026
  ///
  /// In id, this message translates to:
  /// **'Catatan Pengaju'**
  String get ui0d2e50dcb9;

  /// Reviewed HR short label and attendance clock copy, 10 November 2026
  ///
  /// In id, this message translates to:
  /// **'Catatan Finance'**
  String get ui2db9ce05be;

  /// Reviewed HR short label and attendance clock copy, 10 November 2026
  ///
  /// In id, this message translates to:
  /// **'Awal'**
  String get ui14a5b176af;

  /// Reviewed HR short label and attendance clock copy, 10 November 2026
  ///
  /// In id, this message translates to:
  /// **'Terjual'**
  String get ui82bfa5912a;

  /// Reviewed HR short label and attendance clock copy, 10 November 2026
  ///
  /// In id, this message translates to:
  /// **'Retur'**
  String get ui7a82f9e98c;

  /// Reviewed HR short label and attendance clock copy, 10 November 2026
  ///
  /// In id, this message translates to:
  /// **'Sisa'**
  String get ui861b9e3950;

  /// Reviewed HR short label and attendance clock copy, 10 November 2026
  ///
  /// In id, this message translates to:
  /// **'Menit'**
  String get uidb6e63dbeb;

  /// Reviewed HR short label and attendance clock copy, 10 November 2026
  ///
  /// In id, this message translates to:
  /// **'No Referensi'**
  String get ui9f22d2d2ea;

  /// Reviewed HR short label and attendance clock copy, 10 November 2026
  ///
  /// In id, this message translates to:
  /// **'Call'**
  String get ui291a0a58df;

  /// Reviewed HR short label and attendance clock copy, 10 November 2026
  ///
  /// In id, this message translates to:
  /// **'Ringkasan {period}'**
  String homeRequestsMonthlySummary(String period);

  /// Reviewed HR short label and attendance clock copy, 10 November 2026
  ///
  /// In id, this message translates to:
  /// **'Omzet: {amount}'**
  String dailyRevenueSummary(String amount);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'id'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'id':
      return AppLocalizationsId();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
