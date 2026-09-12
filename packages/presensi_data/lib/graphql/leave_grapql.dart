mixin LeaveGraphQl {
  String getLeaveCategoriesQuery = r'''query KategoriCuti {
  GetAllKategoriCuti {
    kategoriCuti {
      _id
      nama_kategori_cuti
      is_special
      sugested_day_off
      allow_half_day
      allow_exceed_annually
      number_of_exceed
      max_duration_days
      keterangan
      need_upload_file
      allow_min_gap
      min_gap_before_cuti
      status
    }
  }
}''';

  String getLeaveRequestsQuery = r'''
  query LeaveRequestsQuery($filter: FilterAllCuti, $pagination: pagination) {
  GetAllCuti(filter: $filter, pagination: $pagination) {
    cuti {
      _id
      user_id {
        _id
        name
        foto {
          url_path
        }
        divisi_id {
        _id
        nama_divisi
        }
      }
      alasan
      tanggal_pengajuan
      status_izin
      tanggal_izin
      tanggal_masuk
      is_half_day
      half_day_type
      file_izin
      tipe_cuti {
        _id
        nama_kategori_cuti
      }
      approval_history {
        approvers {
          _id
          acted_at
          catatan
          level
          level_name
          status
          user_id {
            _id
            name
            foto {
              url_path
            }
            divisi_id {
            _id
            nama_divisi
            }
          }
        }
        _id
        approval_type
        current_level
        status
        total_levels
      }
    }
  }
}''';

  String getLeaveRequestByIdQuery = r'''
  query GetOneCuti($cutiId: ID!) {
    GetOneCuti(cuti_id: $cutiId) {
      _id
      user_id {
        _id
        name
        foto {
          url_path
        }
        divisi_id {
          _id
          nama_divisi
        }
      }
      alasan
      tanggal_pengajuan
      status_izin
      tanggal_izin
      tanggal_masuk
      is_half_day
      half_day_type
      file_izin
      tipe_cuti {
        _id
        nama_kategori_cuti
      }
      approval_history {
        approvers {
          _id
          acted_at
          catatan
          level
          level_name
          status
          user_id {
            _id
            name
            foto {
              url_path
            }
            divisi_id {
              _id
              nama_divisi
            }
          }
        }
        _id
        approval_type
        current_level
        status
        total_levels
      }
    }
  }
''';

  String createLeaveRequestMutation = r'''
  mutation CreateCuti($input: CutiInput, $file: Upload) {
    CreateCuti(input: $input, file: $file) {
      _id
      file_izin
      filename
    }
  }
''';

  String updateLeaveRequestMutation = r'''
mutation UpdateCuti($id: ID!, $input: CutiInput, $file: Upload) {
  UpdateCuti(cuti_id: $id, input: $input, file: $file) { _id file_izin filename }
}''';

  String deleteLeaveRequestMutation = r'''
mutation DeleteCuti($id: ID!) { DeleteCuti(cuti_id: $id) { _id } }
''';

  String getMyCutiQuotaQuery = r'''
  query GetMyCutiQuota {
    GetMyCutiQuota {
      kuota_cuti
      sisa_cuti
      terpakai
      is_cuti
    }
  }
''';
}
