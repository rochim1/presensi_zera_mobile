mixin DeliveryOrderGraphQl {
  String get getAllDeliveryOrdersQuery => r'''
    query GetAllSalesDeliveryOrders($filter: FilterSalesDeliveryOrder, $sorting: SortingSalesDeliveryOrder, $pagination: pagination) {
      GetAllSalesDeliveryOrders(filter: $filter, sorting: $sorting, pagination: $pagination) {
        items {
          _id
          no_do
          no_order
          outlet_nama
          alamat_kirim
          driver_nama
          no_kendaraan
          tanggal_kirim
          status
          items {
            nama_produk
            qty
            satuan
          }
          total_item
        }
        totalCount
      }
    }
  ''';
}
