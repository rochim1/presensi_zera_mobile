// Read-only UI text audit. Uses the existing analyzer dependency; no app changes.
import 'dart:convert';
import 'dart:io';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';

final rows = <Map<String, Object?>>[];
final excluded = <String, int>{};
void skip(String reason) => excluded.update(reason, (n) => n + 1, ifAbsent: () => 1);

class Strings extends RecursiveAstVisitor<void> {
  Strings(this.path, this.source);
  final String path, source;
  void record(StringLiteral node, String text) {
    if (node.parent is AdjacentStrings) return;
    final value = text.trim();
    if (value.isEmpty || !RegExp(r'[A-Za-zÀ-ž]').hasMatch(value.replaceAll(RegExp(r'\{(?:nilai\d+|\{?par\d+\}?)\}'), ''))) { skip('kosong_simbol_angka'); return; }
    final ancestors = <AstNode>[];
    for (AstNode? p = node.parent; p != null; p = p.parent) { ancestors.add(p); }
    if (ancestors.any((p) => p is Directive)) { skip('directive'); return; }
    if (node.parent is MapLiteralEntry && identical((node.parent as MapLiteralEntry).key, node)) { skip('map_key'); return; }
    final calls = ancestors.whereType<MethodInvocation>().map((p) => p.methodName.name).toList();
    if (calls.contains('TextEditingController') || ancestors.whereType<MethodDeclaration>().any((p) => p.name.lexeme == 'toString')) { skip('controller_or_debug_representation'); return; }
    if (calls.any((n) => ['print','debugPrint','log','logError','logDebug','logInfo','logWarning','logEvent','logLogin','setString','getString','remove','containsKey','getBool','setBool','getInt','setInt','write','read','replaceAll','replaceFirst','split','startsWith','endsWith','contains','format','parse','tryParse','fromJson'].contains(n)) ||
        ancestors.whereType<MethodInvocation>().any((p) => ['log','logger','appLogger'].contains(p.target?.toSource()))) {
      skip('log_cache_parsing'); return;
    }
    if (calls.contains('RegExp') || ancestors.whereType<InstanceCreationExpression>().any((p) => p.constructorName.type.toSource() == 'RegExp')) { skip('regex'); return; }
    if (RegExp(r'^(https?:|package:|assets/|images/|icons/|data:|Bearer |/|\./|\.\./)').hasMatch(value) ||
        RegExp(r'^\s*(query|mutation|subscription|fragment)\b').hasMatch(value) ||
        value.contains('__typename') || value.contains('<html') || value.contains('CREATE TABLE')) { skip('url_asset_query'); return; }
    final nearestNamed = ancestors.whereType<NamedExpression>().firstOrNull?.name.label.name ?? '';
    if (['password','passwordOrigin','token','idToken','clientId','serverClientId','apiKey','appId','macAddress','captchaId'].contains(nearestNamed)) { skip('identifiants_secrets'); return; }
    final variable = ancestors.whereType<VariableDeclaration>().firstOrNull?.name.lexeme ?? '';
    if (RegExp(r'password|secret|apikey|clientid|defaultlat|defaultlong',caseSensitive:false).hasMatch(variable) ||
        RegExp(r'^[A-Za-z0-9_-]{28,}$').hasMatch(value)) { skip('identifiants_secrets'); return; }
    final constructors = ancestors.whereType<InstanceCreationExpression>().map((p) => p.constructorName.type.toSource()).toList();
    if (constructors.contains('TextEditingController')) { skip('controller_initial_value'); return; }
    final uiNames = RegExp(r'^(title|subtitle|label|hint|hintText|labelText|helperText|errorText|message|description|tooltip|semanticLabel|contentTitle|contentSubtitle|yesOkLabel|noCancelLabel|text|emptyMessage|emptyText|buttonText|titleText|subTitle|caption)$');
    final ui = uiNames.hasMatch(nearestNamed) || constructors.any((n) => ['Text','TextSpan','Tooltip','SnackBar','ServerFailure','UnknownFailure','NetworkFailure','CacheFailure','GeneralException','GraphQlException'].contains(n)) ||
        calls.any((n) => ['_showError','showError','showSnackBar','_showMessage'].contains(n));
    final indonesian = RegExp(r'\b(anda|saya|kami|silakan|silahkan|silahkah|masuk|keluar|simpan|batal|hapus|ubah|pilih|pilihan|tambah|cari|pencarian|kembali|lanjutkan|selanjutnya|belum|tidak|sudah|berhasil|gagal|tunggu|muat|memuat|halaman|pengguna|akun|karyawan|pegawai|instansi|organisasi|presensi|kehadiran|izin|cuti|lembur|gaji|penggajian|pinjaman|tunjangan|potongan|pajak|jabatan|divisi|cabang|jadwal|kerja|tugas|kunjungan|laporan|riwayat|pengaturan|pemberitahuan|notifikasi|surat|dokumen|lokasi|alamat|nomor|telepon|tanggal|waktu|jam|hari|bulan|tahun|dari|dengan|untuk|pada|yang|dan|atau|ke|di|harus|wajib|dapat|perlu|ditolak|disetujui|menunggu|total|jumlah|saldo|rincian|detail|informasi|nama|jenis|alasan|berakhir|perbarui|terbaru|terpilih|tersedia|ditemukan|terjadi|kesalahan|koneksi|kirim|terkirim|unggah|unduh|verifikasi|aktif|nonaktif|januari|februari|maret|april|mei|juni|juli|agustus|september|oktober|november|desember|senin|selasa|rabu|kamis|jumat|sabtu|minggu)\b',caseSensitive:false).hasMatch(value);
    if (RegExp(r'^[a-z][a-z0-9]*[_./][a-z0-9_./-]+$').hasMatch(value) || RegExp(r'^[A-Z][A-Z0-9_]{3,}$').hasMatch(value)) { skip('technical_identifier'); return; }
    // Keep unclassified prose separately: a reviewer can catch custom widgets.
    final prose = value.split(RegExp(r'\s+')).length >= 3 && !value.contains('=>') && !value.contains('SELECT ');
    if (!ui && !indonesian && !prose) { skip('non_ui_or_unclassified_short'); return; }
    final category = indonesian ? 'indonesia' : ui ? 'perlu_review_bahasa' : 'perlu_review_konteks';
    final line = '\n'.allMatches(source.substring(0,node.offset)).length + 1;
    rows.add({'text':text,'category':category,'file':path,'line':line,'context':nearestNamed.isNotEmpty ? nearestNamed : constructors.firstOrNull ?? calls.firstOrNull ?? variable});
  }
  @override
  void visitSimpleStringLiteral(SimpleStringLiteral node) { record(node,node.value); super.visitSimpleStringLiteral(node); }
  @override
  void visitStringInterpolation(StringInterpolation node) {
    var i=0;
    record(node,node.elements.map((e) => e is InterpolationString ? e.value : '{nilai${++i}}').join());
    super.visitStringInterpolation(node);
  }
  @override
  void visitAdjacentStrings(AdjacentStrings node) {
    var i=0;
    String render(StringLiteral n) => n is SimpleStringLiteral ? n.value : n is StringInterpolation ? n.elements.map((e)=> e is InterpolationString ? e.value : '{nilai${++i}}').join() : n.toSource();
    record(node,node.strings.map(render).join());
    super.visitAdjacentStrings(node);
  }
}
void main() {
  var files=0;
  final errors=<String>[];
  for (final root in ['lib','packages/presensi_data/lib','packages/presensi_domain/lib']) {
    for (final f in Directory(root).listSync(recursive:true).whereType<File>()) {
      if (!f.path.endsWith('.dart') || RegExp(r'\.(g|freezed|gr)\.dart$').hasMatch(f.path)) continue;
      files++;
      final source=f.readAsStringSync();
      final result=parseString(content:source,throwIfDiagnostics:false);
      if(result.errors.isNotEmpty)errors.add(f.path);
      result.unit.accept(Strings(f.path.replaceAll('\\','/'),source));
    }
  }
  final out=Directory('../output/hr-id-text-inventory-20261109')..createSync(recursive:true);
  File('${out.path}/extracted.json').writeAsStringSync(const JsonEncoder.withIndent('  ').convert({'files':files,'parseWarnings':errors,'excluded':excluded,'rows':rows}));
  print('Scanned $files files; ${rows.length} candidate occurrences; ${errors.length} parse warnings.');
}
