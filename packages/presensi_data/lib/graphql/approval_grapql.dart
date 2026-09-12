mixin ApprovalGraphQl {
  String createApprovalMutation = r'''
mutation ProcessApproval($input: ProcessApprovalInput!) {
  ProcessApproval(input: $input) {
    _id
  }
}
''';

  String getMyPendingApprovalsQuery = r'''
query GetMyPendingApprovals($requestType: String, $startDate: String, $endDate: String, $pagination: pagination) {
  GetMyPendingApprovals(request_type: $requestType, start_date: $startDate, end_date: $endDate, pagination: $pagination) {
    _id
    request_id
    request_type
    approval_type
    current_level
    total_levels
    status

    requester_id {
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

    payroll_batch {
      _id
      periode
      total_slips
      total_amount
      status
    }

    approvers {
      _id
      level
      level_name
      status
      catatan
      acted_at

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

    createdAt
    request_presensi {
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
          }
        }
        _id
        approval_type
        current_level
        status
        total_levels
      }
      createdAt
    }
  }
}
''';

  String testWorkflowUserQuery = r'''
query TestWorkflowUser($module: String, $testUserId: ID!) {
  TestWorkflowUser(module: $module, test_user_id: $testUserId) {
    is_auto_approved
    levels {
      user_is_approver
    }
  }
}
''';
}
