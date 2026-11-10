"""Assemble reviewed ID/EN translation batches; preserve interpolation contracts."""
import collections
import csv
import json
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT.parent / 'output/hr-translation-20261109'
entries = json.loads((ROOT.parent / 'output/hr-id-text-inventory-20261109/catalog.json').read_text(encoding='utf-8'))['entries']
translations = {}
for batch in sorted((OUT / 'batches').glob('*.txt')):
    start = int(batch.stem)
    for offset, translation in enumerate(batch.read_text(encoding='utf-8').splitlines()):
        index = start + offset
        assert index not in translations, f'Duplicate batch entry {index}'
        translations[index] = translation
assert set(translations) == set(range(len(entries))), 'Translation batch missing or out of range'

def placeholders(text):
    return collections.Counter(re.findall(r'\{\{?\w+\}?\}|\$\{[^}]+\}|\$[a-zA-Z_]\w*', text))

def technical(text):
    return text.startswith(('Mapping ', '\n|---', 'No {nilai1} ->')) or text in {
        'id', 'description', 'message', 'title',
        'Either itemBuilder or itemBuilderWithIndex must be provided',
        'PanelController must be attached to a SlidingUpPanel',
        'SlidingUpPanel snapPoint property must not be null',
        'Please dont use this model, the relation has been moved to user model',
        'Please use `AppModalBottom.hadleError` for showing error',
        'Please use `AppModalBottom.showConfirm` for showing error',
    }

def arb_text(text):
    # Standardize legacy placeholders without exposing expressions in ARB.
    text = re.sub(r'\{\{(par\d+)\}\}', r'{\1}', text)
    text = text.replace('${e.message}', '{message}').replace('$message', '{message}')
    return text

def normalize_id(text):
    return text.replace('Silahkan', 'Silakan').replace('silahkan', 'silakan').replace('Silahkah', 'Silakan').replace('tedeteksi', 'terdeteksi')

rows, excluded = [], []
for i, entry in enumerate(entries):
    original = entry['text']
    translation = translations[i]
    english = original if translation == '__KEEP__' else translation.replace('\\n', '\n')
    assert placeholders(original) == placeholders(english), f'Placeholder mismatch at {i}: {entry["id"]}'
    if technical(original):
        excluded.append({'id': entry['id'], 'text': original, 'reason': 'Diagnostik/identifier internal; tidak dimasukkan ke ARB', 'sources': entry['sources']})
        continue
    key = 'hr' + entry['id'].removeprefix('HR-ID-').lower()
    notes = ''
    if original == 'Masuk':
        english = 'Check In'
        notes = 'Presensi: Check In. Gunakan key signInAction untuk layar login.'
    if original == 'Izin':
        english = 'Time Off'
    if original == 'Cuti & izin':
        english = 'Leave & time off'
    rows.append({'key': key, 'auditId': entry['id'], 'sourceText': original, 'id': normalize_id(arb_text(original)), 'en': arb_text(english), 'modules': entry['modules'], 'sources': entry['sources'], 'notes': notes})

# Separate semantic keys for text that means different things across screens.
rows.append({'key': 'signInAction', 'auditId': 'CONTEXT-LOGIN-MASUK', 'sourceText': 'Masuk', 'id': 'Masuk', 'en': 'Sign In', 'modules': ['login'], 'sources': [s for e in entries if e['text'] == 'Masuk' for s in e['sources'] if '/login/' in s['file']], 'notes': 'Khusus autentikasi; jangan dipakai untuk presensi.'})
catalog_dir = OUT / 'arb'
catalog_dir.mkdir(exist_ok=True)
for locale in ['id', 'en']:
    arb = {'@@locale': locale}
    for row in rows:
        arb[row['key']] = row[locale]
        metadata = {'description': 'Modul: ' + ', '.join(row['modules']) + '. Audit: ' + row['auditId'] + ('. ' + row['notes'] if row['notes'] else '')}
        names = sorted(set(re.findall(r'\{([A-Za-z_]\w*)\}', row[locale])))
        if names:
            metadata['placeholders'] = {name: {'type': 'String'} for name in names}
        arb['@' + row['key']] = metadata
    (catalog_dir / f'app_{locale}.arb').write_text(json.dumps(arb, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')

with (OUT / 'TRANSLATION-ID-EN.csv').open('w', encoding='utf-8-sig', newline='') as f:
    writer = csv.writer(f)
    writer.writerow(['Key ARB', 'ID Audit', 'Teks Sumber', 'Indonesia', 'English', 'Modul', 'Catatan Konteks', 'Lokasi Sumber'])
    for row in rows:
        writer.writerow([row['key'], row['auditId'], row['sourceText'], row['id'], row['en'], ', '.join(row['modules']), row['notes'], '\n'.join(f'{s["file"]}:{s["line"]}' for s in row['sources'])])
(OUT / 'translations.json').write_text(json.dumps({'entries': rows, 'excluded': excluded}, ensure_ascii=False, indent=2), encoding='utf-8')

def esc(s):
    return s.replace('|', '\\|').replace('\n', '<br>')

groups = collections.defaultdict(list)
for row in rows:
    groups[row['modules'][0]].append(row)
doc = f'''# Terjemahan Pantoo HR — Indonesia / English

Tanggal: 9 November 2026.

- {len(entries)} entri inventaris telah ditangani.
- {len(rows)} pasangan ID–EN disiapkan (termasuk satu variasi konteks login).
- {len(excluded)} diagnostik/identifier internal dikeluarkan dari ARB dan dicatat pada `translations.json`.
- Terjemahan ditulis per kalimat dengan mempertahankan placeholder, nominal, batas karakter, dan aturan proses.
- `app_id.arb` dan `app_en.arb` berada di folder `arb/`. Ini snapshot katalog awal; sumber aktif yang telah dihubungkan ke aplikasi ada di `mobile_zera/lib/l10n/`.

## Catatan integrasi

- Key `hr…` stabil mengikuti ID audit. Alias semantik dapat diberikan saat migrasi widget.
- Kata **Masuk** dibedakan: `signInAction` untuk login (**Sign In**); key inventaris asal untuk presensi (**Check In**).
- **Izin** pada rincian kehadiran/payroll diterjemahkan **Time Off**, bukan izin akses perangkat (**Permission**).
- Placeholder `nilai1` dst. dipertahankan sementara sebagai `String` agar tidak mengubah formatter data yang ada. Nama bermakna, tipe angka/tanggal, serta ICU plural perlu disesuaikan saat migrasi pemanggil, khususnya jam/hari/bulan/jumlah.
- Placeholder lama `{{{{par0}}}}` menjadi `{{par0}}` pada ARB. Teks sumber asli tetap tersedia di CSV.
- Nama produk, singkatan (KPI, HRMS, BPJS, PPh 21), identifier teknis yang memang menjadi label, dan kode mata uang tidak diterjemahkan sembarangan. Rupiah tidak diubah menjadi dolar.
- Ejaan “Silahkan/Silahkah” dan “tedeteksi” dibakukan pada berkas Indonesia; file source aplikasi tidak diganti.
- Bahasa Indonesia pada berkas ini mempertahankan istilah campuran yang sudah dipakai aplikasi; pembakuan seluruh istilah Inggris di sisi Indonesia merupakan tahap editorial tersendiri.
- Teks server dinamis dan SDK/OS di luar inventaris statis tidak termasuk.

## Glosarium

| Indonesia | English |
|---|---|
| Presensi / Kehadiran | Attendance |
| Masuk kerja / Pulang kerja | Check In / Check Out |
| Masuk akun / Keluar akun | Sign In / Sign Out |
| Cuti | Leave |
| Izin (ketidakhadiran) | Time Off |
| Izin akses | Permission |
| Lembur | Overtime |
| Pengajuan | Request |
| Persetujuan | Approval |
| Slip Gaji | Payslip |
| Potongan | Deduction |
| Tunjangan | Allowance |
| Pinjaman | Loan |
| Sisa Pinjaman | Outstanding Loan Balance |
| Piutang / Utang | Receivables / Payables |
| Instansi / Organisasi | Organization |
| Tukar Shift | Shift Swap |

## Katalog lengkap
'''
for module, entries_in_module in sorted(groups.items()):
    doc += f'\n### {module}\n\n| Key | Indonesia | English |\n|---|---|---|\n'
    doc += '\n'.join(f'| `{r["key"]}` | {esc(r["id"])} | {esc(r["en"])} |' for r in entries_in_module) + '\n'
(OUT / 'TRANSLATION-ID-EN.md').write_text(doc, encoding='utf-8')
(OUT / 'summary.json').write_text(json.dumps({'inventoryEntries': len(entries), 'translationPairs': len(rows), 'excludedInternal': len(excluded), 'contextVariants': 1}, indent=2), encoding='utf-8')
print(f'{len(rows)} ID/EN pairs; {len(excluded)} internal entries excluded; all placeholders preserved.')
