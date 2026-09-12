mixin PayrollGraphQl {
  String getPayrollSlipsQuery = r'''
query GetAllPayrollSlips($filter: PayrollSlipFilter, $pagination: pagination) {
  GetAllPayrollSlips(filter: $filter, pagination: $pagination) {
    data {
      _id
      user_id {
        _id
        name
        email
        divisi_id {
          nama_divisi
        }
        jabatan_id {
          nama_jabatan
        }
      }
      periode
      bulan
      tahun
      status
      gaji_pokok
      total_tunjangan
      total_lembur
      total_insentif
      total_pendapatan
      total_potongan
      gaji_bersih
      total_adjustment_pendapatan
      total_adjustment_potongan
    }
  }
}
''';

  String getPayrollSlipByIdQuery = r'''
query GetPayrollSlipById($id: ID!, $myOnly: Boolean) {
  GetPayrollSlipById(id: $id, my_only: $myOnly) {
    _id
    user_id {
      _id
      name
      email
      divisi_id {
        nama_divisi
      }
      jabatan_id {
        nama_jabatan
      }
    }
    periode
    bulan
    tahun
    status
    kehadiran {
      total_hari_kerja
      total_hadir
      total_izin
      total_cuti
      total_alpha
      total_terlambat
      total_menit_terlambat
      total_pulang_awal
      total_lupa_presensi
    }
    gaji_pokok
    total_tunjangan
    total_lembur
    total_insentif
    total_pendapatan
    potongan {
      bpjs_kesehatan
      bpjs_ketenagakerjaan_jht
      bpjs_ketenagakerjaan_jp
      pajak_pph21
      punishment_keterlambatan
      punishment_absen_tanpa_ijin
      punishment_pulang_awal
      punishment_lupa_presensi
    }
    total_potongan
    gaji_bersih
    total_adjustment_pendapatan
    total_adjustment_potongan
    catatan
    cancel_reason
  }
}
''';
}
