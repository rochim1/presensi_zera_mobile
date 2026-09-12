mixin LogbookGraphQl {
  String get getAllLogbookQuery =>
      r'''query GetAllLogbook($page: Int, $limit: Int, $userId: ID, $startDate: String, $endDate: String, $allUsers: Boolean) {
  GetAllLogbook(page: $page, limit: $limit, user_id: $userId, startDate: $startDate, endDate: $endDate, allUsers: $allUsers) {
    total
    data {
      _id
      tanggal_log
      judul_tugas
      deskripsi
      kategori_tugas
      jam_mulai
      jam_selesai
      durasi_menit
      user_id {
        _id
        name
        username
      }
    }
  }
}''';

  String get getLogbookUserSummariesQuery =>
      r'''query GetLogbookUserSummaries($startDate: String, $endDate: String) {
  GetLogbookUserSummaries(startDate: $startDate, endDate: $endDate) {
    user_id {
      _id
      name
      username
    }
    total_task
    total_durasi_menit
  }
}''';

  String get createLogbookMutation =>
      r'''mutation CreateLogbook($input: CreateLogbookInput!) {
  CreateLogbook(input: $input) {
    _id
    tanggal_log
    judul_tugas
  }
}''';

  String get updateLogbookMutation =>
      r'''mutation UpdateLogbook($input: UpdateLogbookInput!) {
  UpdateLogbook(input: $input) {
    _id
    tanggal_log
    judul_tugas
  }
}''';

  String get deleteLogbookMutation => r'''mutation DeleteLogbook($id: ID!) {
  DeleteLogbook(id: $id) {
    _id
  }
}''';

  String get getAllKategoriLogbookQuery =>
      r'''query GetAllKategoriLogbook($page: Int, $limit: Int, $status: String) {
  GetAllKategoriLogbook(page: $page, limit: $limit, status: $status) {
    data {
      _id
      nama_kategori
      warna
    }
  }
}''';

  String get createKategoriLogbookMutation =>
      r'''mutation CreateKategoriLogbook($input: KategoriLogbookInput!) {
  CreateKategoriLogbook(input: $input) {
    _id
    nama_kategori
  }
}''';

  String get testUserLogbookCheckoutPolicyQuery =>
      r'''query TestUserLogbookCheckoutPolicy($userId: ID!) {
  TestUserLogbookCheckoutPolicy(user_id: $userId) {
    user_id
    is_required
    policy_name
    reason
    logbook_count_today
    min_logbook_entries
    is_blocked
    message
  }
}''';
}
