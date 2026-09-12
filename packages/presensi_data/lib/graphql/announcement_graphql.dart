mixin AnnouncementGraphql {
  String get createAnnouncementMutation => r'''
mutation CreatePengumuman($input: PengumumanInput!) {
  CreatePengumuman(input: $input) { _id judul }
}''';
  String get updateAnnouncementMutation => r'''
mutation UpdatePengumuman($id: ID!, $input: PengumumanInput!) {
  UpdatePengumuman(_id: $id, input: $input) { _id judul }
}''';
  String get deleteAnnouncementMutation => r'''
mutation DeletePengumuman($id: ID!) {
  DeletePengumuman(_id: $id) { _id }
}''';

  String get getAnnouncementsQuery =>
      r'''query GetAllPengumuman($pagination: pagination) {
  GetAllPengumuman(pagination: $pagination) {
    pengumuman {
      _id
      judul
      isi
      kategori
      prioritas
      tanggal_mulai
      tanggal_berakhir
      is_pinned
      show_popup
      banner_image
      link_url
      lampiran {
        nama_file
        url
      }
      created_by {
        _id
        name
      }
      instansi_id
      status
      createdAt
      updatedAt
    }
  }
}''';
}
