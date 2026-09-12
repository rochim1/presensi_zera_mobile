mixin ShiftGraphQl {
  String createShiftSwapRequestMutation = r'''
mutation CreateShiftSwapRequest($input: CreateShiftSwapRequestInput!) {
  createShiftSwapRequest(input: $input) {
    _id
    status
  }
}
''';

  String cancelShiftSwapRequestMutation = r'''
mutation CancelShiftSwapRequest($id: ID!) {
  cancelShiftSwapRequest(swap_request_id: $id) { _id status }
}''';

  String updateShiftSwapRequestMutation = r'''
mutation UpdateShiftSwapRequest($id: ID!, $input: CreateShiftSwapRequestInput!) {
  updateShiftSwapRequest(swap_request_id: $id, input: $input) { _id status }
}''';

  String getShiftSchedulesQuery = r'''
query GetUserShiftSchedule($endDate: String!, $startDate: String!, $userId: ID!) {
  GetUserShiftSchedule(end_date: $endDate, start_date: $startDate, user_id: $userId) {
    _id
    assigned_date
    status
    shift {
      _id
      jam_masuk
      jam_pulang
      nama_shift
    }
  }
}
''';

  String getShiftScheduleByIdQuery = r'''
  query GetOneShiftSchedule($shiftScheduleId: ID!) {
  GetOneShiftSchedule(shift_schedule_id: $shiftScheduleId) {
    _id
      assigned_date
      status
      notes
      shift {
        _id
        nama_shift
        jam_masuk
        jam_pulang
        total_kerja
        durasi_istirahat
      }
      user {
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
      createdAt
      updatedAt
  }
}
  ''';

  String getMyShiftSchedulesQuery = r'''
query GetMyShiftSchedules($month: String, $page: Int, $limit: Int) {
  GetMyShiftSchedules(month: $month, page: $page, limit: $limit) {
    shift_schedules {
      _id
      assigned_date
      status
      notes
      shift {
        _id
        nama_shift
        jam_masuk
        jam_pulang
        total_kerja
        durasi_istirahat
      }
      createdAt
      updatedAt
    }
  }
}
''';

  String getMyShiftSwapRequestsQuery = r'''
  query GetMyShiftSwapRequests($page: Int, $limit: Int, $status: String, $startDate: String, $endDate: String) {
  getMyShiftSwapRequests(page: $page, limit: $limit, status: $status, start_date: $startDate, end_date: $endDate) {
    data {
      _id
      alasan
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
      status
      updatedAt
      createdAt
      cancelled_reason
      rejected_reason
      target_schedule_id {
        _id
      assigned_date
      status
      notes
      shift {
        _id
        nama_shift
        jam_masuk
        jam_pulang
        total_kerja
        durasi_istirahat
      }
      createdAt
      updatedAt
      }
      requester_schedule_id {
        _id
      assigned_date
      status
      notes
      shift {
        _id
        nama_shift
        jam_masuk
        jam_pulang
        total_kerja
        durasi_istirahat
      }
      createdAt
      updatedAt
      }
      requester_id {
        _id
        name
        foto {
          url_path
        }
      }
      target_user_id {
        _id
        name
        foto {
          url_path
        }
      }
    }
  }
}
  ''';

  String getShiftSwapRequestsQuery = r'''
  query GetAllShiftSwapRequests($page: Int, $limit: Int, $status: String, $startDate: String, $endDate: String) {
  getAllShiftSwapRequests(page: $page, limit: $limit, status: $status, start_date: $startDate, end_date: $endDate) {
    _id
      alasan
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
      status
      updatedAt
      createdAt
      cancelled_reason
      rejected_reason
      target_schedule_id {
        _id
      assigned_date
      status
      notes
      shift {
        _id
        nama_shift
        jam_masuk
        jam_pulang
        total_kerja
        durasi_istirahat
      }
      createdAt
      updatedAt
      }
      requester_schedule_id {
        _id
      assigned_date
      status
      notes
      shift {
        _id
        nama_shift
        jam_masuk
        jam_pulang
        total_kerja
        durasi_istirahat
      }
      createdAt
      updatedAt
      }
      requester_id {
        _id
        name
        foto {
          url_path
        }
      }
      target_user_id {
        _id
        name
        foto {
          url_path
        }
      }
  }
}
  ''';

  String createShiftSwapRequestApprovalMutation = r'''
mutation UpdateShiftSwapRequestStatus($input: UpdateShiftSwapRequestStatusInput!) {
  updateShiftSwapRequestStatus(input: $input) {
    _id
  }
}
''';

  String getAvailableShiftsForSwapQuery = r'''
  query GetAvailableUsersForSwap($shiftDate: String!) {
  getAvailableUsersForSwap(shift_date: $shiftDate) {
    _id
    current_shift {
      _id
      assigned_date
      status
      shift_id {
        _id
        nama_shift
        jam_masuk
        jam_pulang
        total_kerja
        durasi_istirahat
      }
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
  }
}
  ''';
}
