mixin AttendanceGraphQl {
  String getEffectiveScheduleTodayQuery = r'''query GetEffectiveScheduleToday($userId: ID!) {
  GetEffectiveScheduleToday(user_id: $userId) {
    is_shift
    is_regular
    effective_jam_masuk
    effective_jam_pulang
    effective_jadwal_name
  }
}''';

  String getHomeAlertQuery = r'''query GetHomeAlert($userId: ID) {
  GetHomeAlert(user_id: $userId) {
    greeting
    alert_type
    alert_message
  }
}''';

  String getActiveAttendanceQuery = r'''query GetActiveAttendance($userId: ID) {
  GetActiveAttendance(user_id: $userId) {
    _id
    instansi_id
    type_presensi
    status_kerja
    tanggal_presensi
    jam_masuk
    jam_pulang
    total_kerja
    total_istirahat
  }
}''';

  String getAttendancesQuery =
      r'''query Query($pagination: pagination, $filter: PresensiFilter) {
  GetAllPresensi(pagination: $pagination, filter: $filter) {
    presensi {
      _id
      tanggal_presensi
      jam_masuk
      jam_pulang
      total_kerja
      keterangan
      type_presensi
      location_check_in {
        longitude
        latitude
      }
      location_check_out {
        longitude
        latitude
      }
      user_id {
        _id
        name
        divisi_id {
          _id
          nama_divisi
        }
        foto {
          url_path
        }
      }
      total_istirahat
      keterangan
      status_kerja
      aktivitas {
        aktivitas
        jam_mulai
        is_late
      }
    }
  }
}''';

  String getAttendanceByIdQuery = r'''query Query($presensiId: ID) {
  GetOnePresensi(presensi_id: $presensiId) {
    _id
      tanggal_presensi
      jam_masuk
      jam_pulang
      total_kerja
      keterangan
      type_presensi
      location_check_in {
        longitude
        latitude
      }
      location_check_out {
        longitude
        latitude
      }
      user_id {
        _id
        name
        jam_masuk_divisi
        jam_pulang_divisi
        divisi_id {
          _id
          nama_divisi
        }
        foto {
          url_path
        }
      }
      total_istirahat
      keterangan
      status_kerja
      jarak_checkIn_toStandar
      jarak_checkOut_toStandar
      current_setting {
        jam_masuk
        jam_pulang
      }
      foto_presensi {
        filePath_In
        filePath_Out
      }
      foto_pendukung {
        filePath_In
        filePath_Out
      }
      aktivitas {
        aktivitas
        jam_mulai
        format_local {
          full
        }
        is_late
        keterangan
      }
  }
}''';
  String getAttendanceStatisticsQuery =
      r'''query Query($filter: PresensiFilter) {
  GetPresensiStatisticByType(filter: $filter) {
    type_presensi
    total_hari_kerja
    total_hadir
    total_terlambat
    total_tidak_hadir
    total_cuti_izin
    total_libur
    konsistensi
  }
}''';
}
