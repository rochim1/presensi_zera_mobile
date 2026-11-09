"""Build reviewable Indonesian UI inventory from the Dart AST extraction."""
import collections
import csv
import hashlib
import json
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT.parent / 'output/hr-id-text-inventory-20261109'
source = json.loads((OUT / 'extracted.json').read_text(encoding='utf-8'))

# Supplement single-word labels and product vocabulary missed by prose detection.
ID_WORDS = set('tutup buka buat selesai hadir libur pulang terlambat catatan persetujuan penolakan tolak setujui terapkan sebagian ya isi daftar aktivitas perjalanan biaya pengantaran penawaran penagihan tagihan tambahan tulis pendukung konfirmasi tiba ditempat nominal masukkan masukan tipe kategori metode pembayaran produk pesanan diskon faktur bukti nota coba stample peringatan lunas batalkan katalog kasbon lihat semua gunakan mata uang mulai absensi produktivitas mudah digunakan terpadu lebih cepat kinerja aman siap tindakan hasil contoh mis rusak jml deskripsi seharian pengulangan berulang penilaian tambahkan selesaikan periksa akui kontak darurat durasi lampiran jatuh tempo penempatan pendidikan kota kabupaten provinsi kecamatan kelurahan laki perempuan menikah hubungan telepon telpon rekening atas pilih ulang ambil unggah unduh temukan duplikat dimuat diperbarui tagihan ketik transportasi pemesanan berjangka cicilan kendaraan komunikasi perusahaan pastikan wajah terlihat jelas objek penjualan pendapatan jumlah bersih total pajak rupiah jabatan rincian ringkasan pemilik usaha kecuali wajib perlu antrian antrean pelanggaran perhitungan pengajuan tunai kiriman pembelian pembatalan pengurangan hapus hapuskan data tidak pegawai tgl keterangan ulangi lanjut ulang simpan keluarkan pemuatan syarat ketentuan layanan kebijakan privasi penanggung sanksi perubahan bantuan riwayat lampiran kembali muat perusahaan'.split())
ID_WORDS.update('ajukan tukar aksi barang dibuat dikerjakan ditambahkan oleh ganti gambar dibatalkan galeri pagi siang hutang utang jarak estimasi judul kamera kartu identitas kegiatan kilometer kilomenter kode koordinat kurangi lainnya maksimal pengingat servis dasar hukum link tujuan'.split())
ID_PHRASES = ['Rupiah', 'Dirham UEA', 'Dollar Australia', 'Dollar Kanada', 'Franc Swiss', 'Yen Jepang', 'Pound Inggris', 'Dollar Amerika', 'Dollar Selandia Baru', 'Dollar Hong Kong', 'Dollar Taiwan Baru', 'Peso Filipina', 'Yuan Tiongkok', 'Won Korea', 'Riyal Saudi', 'Riyal Qatar', 'Dinar Kuwait', 'Dinar Bahrain', 'Ringgit Malaysia', 'Rupee India', 'Baht Thailand', 'Krona Swedia', 'Krone Norwegia', 'Krone Denmark', 'Lira Turki', 'Laki-laki', 'Perempuan']

def module(path):
    parts = path.split('/')
    for marker in ('pages', 'widgets', 'bloc'):
        if marker in parts:
            i = parts.index(marker)
            return parts[i + 1] if i + 1 < len(parts) - 1 else 'komponen umum'
    if path.startswith('packages/'):
        return 'pesan & model bersama'
    return 'sistem & komponen umum'

entries = {}
for row in source['rows']:
    text = row['text']
    visible = re.sub(r'\{[^{}]*\}', '', text).strip()
    if not re.search(r'[A-Za-z]', visible):
        continue
    if re.fullmatch(r'[dDMmyYHhmsaE/,:.\-\s]+', visible) or '\\d' in text:
        continue
    if re.match(r'^\s*(query|mutation|fragment)\b', text) or any(x in text for x in ['__typename', 'SELECT ', 'CREATE TABLE']):
        continue
    words = set(re.findall(r'[a-z]+', visible.lower()))
    indonesia = row['category'] == 'indonesia' or bool(words & ID_WORDS) or any(x.lower() in visible.lower() for x in ID_PHRASES)
    category = 'Indonesia / campuran istilah' if indonesia else 'Perlu tinjauan bahasa' if row['category'] != 'perlu_review_konteks' else 'Perlu tinjauan konteks'
    e = entries.setdefault(text, {'text': text, 'category': category, 'sources': [], 'modules': set()})
    if indonesia:
        e['category'] = category
    ref = {'file': row['file'], 'line': row['line'], 'context': row['context']}
    if ref not in e['sources']:
        e['sources'].append(ref)
    e['modules'].add(module(row['file']))

catalog = []
for text, entry in sorted(entries.items(), key=lambda pair: pair[0].casefold()):
    catalog.append({'id': 'HR-ID-' + hashlib.sha1(text.encode()).hexdigest()[:10].upper(), **entry, 'modules': sorted(entry['modules'])})
main = [e for e in catalog if e['category'].startswith('Indonesia')]
review = [e for e in catalog if e not in main]
counts = collections.Counter(m for e in main for m in e['modules'])

with (OUT / 'catalog.csv').open('w', encoding='utf-8-sig', newline='') as f:
    w = csv.writer(f)
    w.writerow(['ID', 'Teks asli', 'Kategori', 'Modul', 'Jumlah lokasi', 'Lokasi sumber'])
    for e in catalog:
        w.writerow([e['id'], e['text'], e['category'], '; '.join(e['modules']), len(e['sources']), '\n'.join(f"{s['file']}:{s['line']} ({s['context']})" for s in e['sources'])])
(OUT / 'catalog.json').write_text(json.dumps({'scannedFiles': source['files'], 'parseWarnings': source['parseWarnings'], 'entries': catalog}, ensure_ascii=False, indent=2), encoding='utf-8')

def esc(value):
    return value.replace('|', '\\|').replace('\r', '').replace('\n', '<br>')

def table(items):
    lines = ['| ID | Teks asli | Lokasi sumber pertama |', '|---|---|---|']
    for e in items:
        s = e['sources'][0]
        lines.append(f"| {e['id']} | {esc(e['text'])} | `{s['file']}:{s['line']}` |")
    return '\n'.join(lines)

header = f'''# Inventaris teks Indonesia — Pantoo HR

Tanggal: 9 November 2026. Daftar ini untuk peninjauan sebelum implementasi multi bahasa, bukan file terjemahan runtime.

## Hasil pemindaian

- **{source['files']:,} file Dart** dipindai dari `lib`, `packages/presensi_data/lib`, dan `packages/presensi_domain/lib`.
- **{len(main):,} teks unik Indonesia/campuran istilah** tercantum di dokumen ini.
- **{len(review):,} kandidat lain** dicatat pada [REVIEW-TEKS.md](REVIEW-TEKS.md), termasuk bahasa Inggris, singkatan, nama produk, dan konteks teknis yang perlu dicek manusia.
- Total katalog: **{len(catalog):,} teks unik**, dengan **{sum(len(e['sources']) for e in catalog):,} lokasi sumber**; kemunculan berulang digabung berdasarkan teks yang sama persis.
- Parser Dart tidak melaporkan kesalahan pada file yang dipindai.

## Cara membaca

- Kolom teks mempertahankan ejaan, kapitalisasi, dan tanda baca sumber agar mudah dicocokkan. Belum dilakukan penggantian kata pada aplikasi.
- `{{nilai1}}`, `{{nilai2}}`, dan seterusnya menandai interpolasi Dart. Nama placeholder final baru ditentukan ketika membuat ARB; nilai aktual seperti nama, tanggal, nominal, dan isi pesan tidak dimasukkan.
- Placeholder lama `{{{{par0}}}}` tetap dicatat; nanti perlu diseragamkan ke format ARB.
- ID `HR-ID-…` adalah identitas audit stabil berdasarkan teks; bukan nama key ARB final.
- CSV/JSON memuat semua lokasi dan modul, sedangkan tabel Markdown menampilkan lokasi pertama untuk menghindari daftar terlalu panjang.
- Nama modul mengikuti direktori kode. Satu teks dapat dipakai pada beberapa modul; jumlah per modul tidak dijumlahkan sebagai jumlah teks unik aplikasi.

## Batas cakupan

Ini adalah inventaris **statis dari source aplikasi**, dengan seleksi konteks UI dan kosakata. Teks dari backend, push notification server, nama/status master yang disimpan di database, data pengguna, serta teks bawaan SDK/OS belum dapat dinyatakan lengkap dari pemindaian ini. File generated, query GraphQL, URL, path aset, log, identifier teknis, dan nilai awal controller tidak dimasukkan. Kandidat yang ambigu dipisahkan untuk review; daftar ini perlu dicocokkan dengan layar nyata saat implementasi.

## Keputusan ejaan yang perlu disepakati

| Variasi sekarang | Usulan standar Indonesia |
|---|---|
| Silahkan / Silahkah / Silakan | Silakan |
| Masukan (instruksi input) / Masukkan | Masukkan |
| tidak tedeteksi | tidak terdeteksi |
| Logout | Keluar |
| Login / Sign In | Masuk |
| Register / Sign Up | Daftar |
| Submit | Kirim / Ajukan, sesuai konteks |
| Upload / Download | Unggah / Unduh |
| History | Riwayat |
| Optional | Opsional |
| Staff | Staf |
| Check-in / Check-out | Presensi masuk / Presensi pulang, sesuai konteks |

Usulan ini belum mengubah teks sumber. Nama fitur, singkatan seperti KPI/HRMS, merek, mata uang, dan istilah domain perlu ditinjau agar maknanya tetap sesuai.

## Ringkasan per modul

| Modul | Teks unik yang dipakai |
|---|---:|
'''
header += '\n'.join(f'| {m} | {n} |' for m,n in sorted(counts.items()))
header += '\n\n## Daftar lengkap teks Indonesia\n'
groups = collections.defaultdict(list)
for e in main:
    groups[e['modules'][0]].append(e)
for group, items in sorted(groups.items()):
    header += f'\n### {group}\n\n' + table(items) + '\n'
(OUT / 'DAFTAR-TEKS-INDONESIA.md').write_text(header, encoding='utf-8')
(OUT / 'REVIEW-TEKS.md').write_text('# Kandidat teks untuk tinjauan\n\nKandidat ini belum dinyatakan sebagai teks Indonesia final. Termasuk Inggris, nama/istilah, placeholder bertulisan, dan kemungkinan teks teknis. Jangan otomatis menerjemahkan atau memasukkannya ke ARB tanpa memeriksa konteks sumber.\n\n' + table(review) + '\n', encoding='utf-8')
summary = {'files': source['files'], 'indonesiaUnique': len(main), 'reviewUnique': len(review), 'catalogUnique': len(catalog), 'sourceLocations': sum(len(e['sources']) for e in catalog)}
(OUT / 'summary.json').write_text(json.dumps(summary, indent=2), encoding='utf-8')
print(json.dumps(summary))
