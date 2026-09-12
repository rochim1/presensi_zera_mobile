mixin ApotekGraphQl {
  /// query to get all apotek
  String get getAllApotik =>
      r'''query GetAllOutlet($pagination: pagination, $filter: FilterOutlet) {
  GetAllOutlet(pagination: $pagination, filter: $filter) {
    outlet {
      _id
      kode_outlet
      nama_outlet
      nama_resmi
      nama_owner
      logo
      email
      alamat
      kode_pos
      maps
      longitude
      latitude
      provinsi
      kabupaten
      kecamatan
      kelurahan
      telpon_number
      note
      status
      tipe_outlet
      kategori_produk
      total_value
      last_order_date
      nama_PIC
      user_created {
        name
      }
    }
  }
}''';

  String get createApotek => r'''mutation CreateOutlet($input: OutletInput) {
  CreateOutlet(input: $input) {
    _id
  }
}''';
}
