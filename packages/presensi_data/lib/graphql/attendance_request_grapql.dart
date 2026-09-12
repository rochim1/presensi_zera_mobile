mixin AttendanceRequestGraphQl {
  String getAttendanceRequestsQuery = r'''
query GetListRequestPresensi(
  $filter: RequestPresensiFilter,
  $pagination: RequestPresensiPagination
) {
  getListRequestPresensi(
    filter: $filter,
    pagination: $pagination
  ) {
    data {
      _id
      jenis_request
      tanggal_presensi
      waktu_yang_diminta
      alasan
      status
      user {
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
            divisi_id {
              _id
              nama_divisi
              }
            foto {
              url_path
            }
          }
        }
        _id
        approval_type
        current_level
        status
        total_levels
      }
      createdAt
      catatan_reviewer
      updatedAt
      bukti_pendukung
    }
  }
}
''';

  String createAttendanceRequestMutation = r'''
mutation CreateRequestPresensi($input: CreateRequestPresensiInput!, $files: [Upload]) {
  createRequestPresensi(input: $input, files: $files) {
    _id
    bukti_pendukung
  }
}
''';

  String updateAttendanceRequestMutation = r'''
mutation UpdateRequestPresensi($id: ID!, $input: UpdateRequestPresensiInput!, $files: [Upload]) {
  updateRequestPresensi(id: $id, input: $input, files: $files) {
    _id
    bukti_pendukung
  }
}''';

  String deleteAttendanceRequestMutation = r'''
mutation DeleteRequestPresensi($id: ID!) { deleteRequestPresensi(id: $id) }
''';
}
