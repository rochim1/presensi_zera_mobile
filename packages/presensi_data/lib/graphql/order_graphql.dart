mixin OrderGraphQl {
  String get getAllProductsQuery => r'''query GetAllInventarisUmum($filter: InventarisUmumFilter, $sorting: InventarisUmumSorting, $pagination: pagination) {
    GetAllInventarisUmum(filter: $filter, sorting: $sorting, pagination: $pagination) {
      items {
        _id
        kode_inventaris
        nama_inventaris
        kategori
        stok
        unit
        harga_jual
        sku
        base_unit
        harga_beli
        price_floor
        quantity_tiers {
          min_qty
          max_qty
          harga_jual
          diskon_persen
        }
        price_levels {
          level_nama
          harga_jual
        }
        unit_conversions {
          unit
          factor
        }
      }
      info_page {
        count
      }
    }
  }''';

  String get createSalesOrderMutation => r'''mutation CreateSalesOrder($input: SalesOrderInput!) {
    CreateSalesOrder(input: $input) {
      _id
      no_order
      status
    }
  }''';

  String get getAllSalesOrdersQuery => r'''query GetAllSalesOrders($filter: FilterSalesOrder, $sorting: SortingSalesOrder, $pagination: pagination) {
    GetAllSalesOrders(filter: $filter, sorting: $sorting, pagination: $pagination) {
      orders {
        _id
        no_order
        tanggal
        tipe_order
        status
        status_pembayaran
        metode_pembayaran
        net_sales
        total_order
        sisa_tagihan
        outlet_nama
        salesman_nama
      }
      info_page {
        count
      }
    }
  }''';

  String get recordSalesPaymentMutation => r'''mutation RecordSalesPayment($order_id: ID!, $jumlah_bayar: Float!, $catatan: String) {
    RecordSalesPayment(order_id: $order_id, jumlah_bayar: $jumlah_bayar, catatan: $catatan) {
      _id
      no_order
      status_pembayaran
      sisa_tagihan
      total_order
      net_sales
    }
  }''';
}
