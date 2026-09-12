mixin TasksGraphQl {
  /// Query GetAllVisitPlans — sama dengan web admin (QUERY_GET_ALL_KUNJUNGAN_V2)
  String get getAllTask =>
      r'''query GetAllVisitPlans($filter: AllVisitPlanFilter, $pagination: pagination) {
  GetAllVisitPlans(filter: $filter, pagination: $pagination) {
    visitPlans {
      _id
      task_date_assigned
      task_date_done
      aktivitas {
        _id
        outlet_id {
          _id
          nama_outlet
          kode_outlet
          alamat
          telpon_number
        }
        status_task
        is_completed_by_other
        completed_by_name
        tipe_call
        tujuan_penawaran
        tujuan_pengantaran
        tujuan_penagihan
        no_referensi
        note
        order_value
        note_before_done
        from {
          longitude
          latitude
          name
        }
        destination {
          longitude
          latitude
          name
        }
        jam_istirahat {
          mulai_istirahat
          selesai_istirahat
        }
        foto_bukti {
          base64
          filename
        }
        completed_time
        foto_plakat {
          base64
          filename
        }
        start_time
        estimasi_waktu_tempuh
        estimasi_biaya_per_task
        distance_from_attendance
        estimasi_waktu_gmaps
        status_task_before
      }
      keterangan
      total_waktu_tempuh
      is_all_done
      inventaris_id {
        _id
        jenis_kendaraan
        merk
        plat_nomer
        jadwal_servis_terakhir
        kilometer_terakhir
        kilometer_kembali_servis
        tanggal_pembayaran_pajak
        total_biaya_pajak
        is_cycle_office
      }
      biaya_actually
      count_jarak_from_attendance
      is_assigned
    }
  }
}''';

  /// Query GetAllVisitPlans untuk Perjalanan (summary/resume)
  String get getAllDataPerjalanan =>
      r'''query GetAllVisitPlans($filter: AllVisitPlanFilter, $pagination: pagination) {
  GetAllVisitPlans(filter: $filter, pagination: $pagination) {
    visitPlans {
      _id
      task_date_assigned
      task_date_done
      aktivitas {
        _id
        status_task
        is_completed_by_other
        completed_by_name
        status_task_before
        start_time
        completed_time
        estimasi_waktu_tempuh
        estimasi_biaya_per_task
        distance_from_attendance
        estimasi_waktu_gmaps
        outlet_id {
          _id
          nama_outlet
        }
        from {
          longitude
          latitude
          name
        }
        destination {
          longitude
          latitude
          name
        }
        jam_istirahat {
          mulai_istirahat
          selesai_istirahat
        }
      }
      is_all_done
      inventaris_id {
        _id
        jenis_kendaraan
        merk
      }
      total_waktu_istirahat
      total_waktu_tempuh
      biaya_actually
      count_jarak_from_attendance
      count_jarak_from_office
      is_assigned
      total_waktu_gmaps
    }
  }
}''';

  /// mutation for create new visit plan
  String get createTask => r'''mutation($input: VisitPlanInput){
  CreateVisitPlan(input: $input){
    _id
  }
}''';

  /// query to get all apotek (legacy — dipakai di modul apotek)
  String get getAllApotekData => r'''query GetAllApotik {
    GetAllApotik: GetAllOutlet(pagination: { limit: 100, page: 1 }) {
      apotik: outlet {
        _id
        kode_outlet
        nama_outlet
        nama_resmi
        nama_PIC
        no_ijin
        nama_owner
        logo
        email
        alamat
        kode_pos
        maps
        longitude
        latitude
        provinsi
        kabupaten
        kecamatan
        kelurahan
        telpon_number
      }
    }
  }''';

  String get completedOrCanceledATask =>
      r'''mutation($aktivitasId: ID!, $fotoBukti: [Upload], $input: CompletedTaskActivity, $id: ID!){
  CompletedATask(aktivitas_id: $aktivitasId, foto_bukti: $fotoBukti, input: $input, _id: $id) {
    _id
  }
}''';
}
