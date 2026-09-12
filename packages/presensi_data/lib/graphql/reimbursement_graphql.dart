mixin ReimbursementGraphQl {
  String getReimbursementsQuery = r'''
  query GetAllReimbursement($filter: FilterReimbursement, $pagination: pagination) {
    GetAllReimbursement(filter: $filter, pagination: $pagination) {
      reimbursement {
        _id
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
        kategori
        judul
        deskripsi
        tanggal
        nominal
        mata_uang
        bukti_pembayaran
        filename
        catatan_pengaju
        status_reimbursement
        tanggal_pengajuan
        tanggal_aksi
        aktor_aksi {
          _id
          name
          username
        }
        catatan_finance
        is_response_by_admin
        approval_history_id
        status
        createdAt
        updatedAt
      }
    }
  }
''';

  String getReimbursementByIdQuery = r'''
  query GetOneReimbursement($reimbursementId: ID!) {
    GetOneReimbursement(reimbursement_id: $reimbursementId) {
      _id
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
      kategori
      judul
      deskripsi
      tanggal
      nominal
      mata_uang
      bukti_pembayaran
      filename
      catatan_pengaju
      status_reimbursement
      tanggal_pengajuan
      tanggal_aksi
      aktor_aksi {
        _id
        name
        username
      }
      catatan_finance
      is_response_by_admin
      approval_history {
        _id
        approval_type
        current_level
        status
        total_levels
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
          }
        }
      }
      status
      createdAt
      updatedAt
    }
  }
''';

  String getReimbursementCategoriesQuery = r'''
  query GetAllJenisReimbursement($filter: FilterJenisReimbursement) {
  GetAllJenisReimbursement(filter: $filter) {
    jenisReimbursement {
      value
      label
    }
  }
}
''';

  String createReimbursementMutation = r'''
  mutation CreateReimbursement($input: ReimbursementInput, $file: Upload) {
  CreateReimbursement(input: $input, file: $file) {
    _id
    bukti_pembayaran
    filename
  }
}
''';

  String updateReimbursementMutation = r'''
mutation UpdateReimbursement($id: ID!, $input: ReimbursementInput, $file: Upload) {
  UpdateReimbursement(reimbursement_id: $id, input: $input, file: $file) { _id bukti_pembayaran filename }
}''';

  String deleteReimbursementMutation = r'''
mutation DeleteReimbursement($id: ID!) {
  DeleteReimbursement(reimbursement_id: $id) { _id }
}''';
}
