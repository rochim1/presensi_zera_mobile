mixin OvertimeGraphQl {
  String getOvertimeRequestsQuery = r'''
query GetOvertimeRequestsQuery($filter: FilterLembur, $pagination: pagination) {
  GetAllLembur(filter: $filter, pagination: $pagination) {
    lembur {
      _id
      jam_mulai
      jam_selesai
      tanggal
      status
      createdAt
      durasi_jam
      alasan
      user {
        _id
        name
        divisi_id {
          _id
          nama_divisi
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
}
''';

  String getOvertimeRequestByIdQuery = r'''
  query GetOneLembur($lemburId: ID!) {
  GetOneLembur(lembur_id: $lemburId) {
    _id
    jam_mulai
    jam_selesai
    tanggal
    status
    createdAt
    durasi_jam
    alasan
    user {
      _id
      name
      divisi_id {
        _id
        nama_divisi
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

  String createOvertimeRequestMutation = r'''
mutation CreateLembur($input: LemburInput!, $file: Upload) {
  CreateLembur(input: $input, file: $file) {
    _id
    bukti_lembur
  }
}
''';

  String updateOvertimeRequestMutation = r'''
mutation UpdateLembur($lemburId: ID!, $input: LemburInput!, $file: Upload) {
  UpdateLembur(lembur_id: $lemburId, input: $input, file: $file) {
    _id
    bukti_lembur
  }
}
''';

  String deleteOvertimeRequestMutation = r'''
mutation DeleteLembur($lemburId: ID!) {
  DeleteLembur(lembur_id: $lemburId) {
    _id
  }
}
''';

  String getActiveOvertimeSessionQuery = r'''
query GetActiveLembur {
  GetActiveLembur {
    _id
    jam_mulai
    jam_selesai
    tanggal
    status
    createdAt
    durasi_jam
    alasan
    user {
      _id
      name
      divisi_id {
        _id
        nama_divisi
      }
    }
  }
}
''';

  String startOvertimeSessionMutation = r'''
mutation StartLemburSession($input: StartLemburSessionInput!) {
  StartLemburSession(input: $input) {
    _id
    jam_mulai
    jam_selesai
    tanggal
    status
    createdAt
    durasi_jam
    alasan
    user {
      _id
      name
      divisi_id {
        _id
        nama_divisi
      }
    }
  }
}
''';

  String finishOvertimeSessionMutation = r'''
mutation FinishLemburSession($input: FinishLemburSessionInput!, $file: Upload) {
  FinishLemburSession(input: $input, file: $file) {
    _id
    jam_mulai
    jam_selesai
    tanggal
    status
    createdAt
    durasi_jam
    alasan
    user {
      _id
      name
      divisi_id {
        _id
        nama_divisi
      }
    }
  }
}
''';

  String cancelOvertimeSessionMutation = r'''
mutation CancelLemburSession($lemburId: ID!) {
  CancelLemburSession(lembur_id: $lemburId) {
    _id
  }
}
''';
}
