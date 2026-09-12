mixin KpiGraphQl {
  String get getMyKpiAssignmentsQuery => r'''
    query GetMyKpiAssignments($filter: KpiFilterInput, $pagination: PaginationInput) {
      GetMyKpiAssignments(filter: $filter, pagination: $pagination) {
        data {
          _id
          user_id {
            _id
            name
            username
            foto {
              url_path
            }
          }
          template_id {
            _id
            nama_template
            allow_self_assessment
          }
          periode_label
          tanggal_mulai
          tanggal_selesai
          status
          final_score
          final_grade
          self_submitted_at
          manager_reviewed_at
          acknowledged_at
          scores {
            self_rating
            bobot
          }
          createdAt
          updatedAt
        }
        total
      }
    }
  ''';

  String get getMyKpiAssignmentDetailQuery => r'''
    query GetMyKpiAssignmentDetail($_id: ID!) {
      GetMyKpiAssignmentDetail(_id: $_id) {
        _id
        user_id {
          _id
          name
          username
          foto {
            url_path
          }
          divisi_id {
            _id
            nama_divisi
          }
          jabatan_id {
            _id
            nama_jabatan
          }
        }
        template_id {
          _id
          nama_template
          allow_self_assessment
          anonymous_peer_review
        }
        periode_label
        tanggal_mulai
        tanggal_selesai
        status
        final_score
        final_grade
        catatan_karyawan_global
        catatan_reviewer_global
        self_submitted_at
        manager_reviewed_at
        acknowledged_at
        scores {
          indicator_id {
            _id
            nama_indikator
            deskripsi
            tipe_data
            satuan
            category_id {
              _id
              nama_kategori
            }
          }
          bobot
          target
          target_minimum
          target_max
          nilai_aktual
          sumber
          self_rating
          catatan_karyawan
          manager_rating
          catatan_reviewer
          nilai_rating
          nilai_terbobot
          auto_data
        }
        createdAt
        updatedAt
      }
    }
  ''';

  String get getTeamKpiAssignmentsQuery => r'''
    query GetTeamKpiAssignments($filter: KpiFilterInput, $pagination: PaginationInput) {
      GetTeamKpiAssignments(filter: $filter, pagination: $pagination) {
        data {
          _id
          user_id {
            _id
            name
            username
            foto {
              url_path
            }
            divisi_id {
              _id
              nama_divisi
            }
          }
          template_id {
            _id
            nama_template
          }
          periode_label
          tanggal_mulai
          tanggal_selesai
          status
          final_score
          final_grade
          self_submitted_at
          manager_reviewed_at
          acknowledged_at
          createdAt
        }
        total
      }
    }
  ''';

  String get getTeamKpiSummaryQuery => r'''
    query GetTeamKpiSummary($filter: KpiFilterInput) {
      GetTeamKpiSummary(filter: $filter) {
        total_karyawan
        completed
        in_progress
        not_started
        avg_score
        grade_distribution {
          grade
          label
          count
          warna
        }
      }
    }
  ''';

  String get submitSelfAssessmentMutation => r'''
    mutation SubmitSelfAssessment($input: SelfAssessmentInput!) {
      SubmitSelfAssessment(input: $input) {
        _id
        status
        self_submitted_at
        catatan_karyawan_global
      }
    }
  ''';

  String get submitManagerReviewMutation => r'''
    mutation SubmitManagerReview($input: ManagerReviewInput!) {
      SubmitManagerReview(input: $input) {
        _id
        status
        final_score
        final_grade
        manager_reviewed_at
        catatan_reviewer_global
      }
    }
  ''';

  String get acknowledgeKpiMutation => r'''
    mutation AcknowledgeKpi($assignment_id: ID!) {
      AcknowledgeKpi(assignment_id: $assignment_id) {
        _id
        status
        acknowledged_at
      }
    }
  ''';
}
