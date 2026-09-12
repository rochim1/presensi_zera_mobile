mixin PresensiGraphQl {
  /// query for get all presensi
  /// NOTE : IF YOU CHANGE THE QUERY MAKE SURE CHANGE THE [createPresensi] too
  String getAllPresensi =
      r'''query Query($pagination: pagination, $filter: PresensiFilter) {
  GetAllPresensi(pagination: $pagination, filter: $filter) {
    presensi {
      _id
      instansi_id
      tanggal_presensi
      jam_masuk
      jam_pulang
      total_kerja
      is_permit_in_working_time
      sisa_istirahat
      is_all_tasks_done
      keterangan
      foto_pendukung {
        base64_checkIn
        base64_checkOut
        keterangan_checkIn
        keterangan_checkOut
      }
      location_check_in {
        longitude
        latitude
      }
      location_check_out {
        longitude
        latitude
      }
      total_istirahat
      status_kerja
      jam_istirahat {
        mulai_istirahat
        selesai_istirahat
      }
      isJoin_work
      format_waktu {
        jam_masuk_kerja
        jam_istirahat_kerja
        jam_kembali_kerja
        jam_pulang_kerja
      }
      aktivitas {
        aktivitas
        jam_mulai
        lokasi {
          longitude
          latitude
        }
        is_late
      }
      has_task_today
      type_presensi
    }
  }
}''';

  /// query for get one presensi
  String getOnePresensi =
      r'''query Query($tanggalPresensi: String, $userId: ID, $presensiId: ID) {
  GetOnePresensi(tanggal_presensi: $tanggalPresensi, user_id: $userId, presensi_id: $presensiId) {
    _id
    instansi_id
    tanggal_presensi
    jam_masuk
    jam_pulang
    total_kerja
    is_permit_in_working_time
    sisa_istirahat
    is_all_tasks_done
    keterangan
    foto_presensi {
      filePath_In
      filePath_Out
      keterangan_checkIn
      keterangan_checkOut
    }
    foto_pendukung {
      filePath_In
      filePath_Out
      keterangan_checkIn
      keterangan_checkOut
    }
    location_check_in {
      longitude
      latitude
    }
    location_check_out {
      longitude
      latitude
    }
    total_istirahat
    status_kerja
    jam_istirahat {
      mulai_istirahat
      selesai_istirahat
    }
    isJoin_work
    format_waktu {
      jam_masuk_kerja
      jam_istirahat_kerja
      jam_kembali_kerja
      jam_pulang_kerja
    }
    aktivitas {
      aktivitas
      jam_mulai
      lokasi {
        longitude
        latitude
      }
      is_late
    }
    has_task_today
    type_presensi
  }
}''';

  /// mutation for save image selfie [ChackIn, ChackOut, BreakIn, BreakOut]
  String createPresensi =
      r'''mutation CreatePresensi($input: PresensiInput, $fotoPresensiUpload: [Upload], $fotoPendukungUpload: [Upload]) {
  CreatePresensi(input: $input, foto_presensi_upload: $fotoPresensiUpload, foto_pendukung_upload: $fotoPendukungUpload) {
    _id
  }
}''';
}
