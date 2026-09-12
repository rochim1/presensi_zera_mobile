mixin SettingGrapql {
  String getSettingQuery = r'''
query GetSettingQuery($instansiId: ID) {
  GetOneSetting(instansi_id: $instansiId) {
    _id
    jam_masuk
    jam_pulang
    mode_presensi
    mode_order_sales
    allow_mobile_change_visit_vehicle
    allow_overtime_cross_day
    overtime_auto_close_next_day
    overtime_auto_close_time
    max_overtime_active_hours
    is_mandatory_foto_pendukung_presensi
    allow_presensi_on_call
    on_call_require_location_policy
    on_call_require_location
    allow_on_call_after_checkout
    allow_on_call_cross_day
    on_call_auto_close_next_day
    on_call_auto_close_time
    max_on_call_active_hours
    attendance_types
    logbook_required_for_checkout
    logbook_require_start_end_time
    logbook_require_description
    logbook_require_category
    logbook_use_default_time_when_empty
    logbook_default_start_time
    logbook_default_end_time
    logbook_default_duration_minutes
  }
}
''';

  String testUserAgainstJamKerjaQuery = r'''
query TestUserAgainstJamKerja($userId: ID!) {
  TestUserAgainstJamKerja(user_id: $userId) {
    day_number
    jam_masuk
    jam_pulang
  }
}
''';

  String getAllJamKerjaQuery = r'''
query GetAllJamKerja($filter: FilterJamKerja, $pagination: pagination, $sorting: SortingJamKerja) {
  getAllJamKerja(filter: $filter, pagination: $pagination, sorting: $sorting) {
    jam_kerja {
      day_number
      jam_masuk
      jam_pulang
    }
  }
}
''';
}
