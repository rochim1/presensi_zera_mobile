class InventoryGraphQL {
  static const getIncidentalReports = r'''
    query GetAllInventoryScraps($filter: ScrapFilterInput, $pagination: PaginationInput) {
      GetAllInventoryScraps(filter: $filter, pagination: $pagination) {
        items {
          _id
          no_scrap
          jenis_insiden
          lokasi_kejadian
          tanggal_scrap
          alasan_detail
          catatan
          status
          diajukan_oleh {
            _id
            name
          }
          items {
            inventaris_id
            kode_inventaris
            nama_inventaris
            unit
            tindakan
            qty
            jumlah_hasil_recycle
            jumlah_hilang
            stok_sebelum
            stok_sesudah
          }
        }
      }
    }
  ''';

  static const addIncidentalReport = r'''
    mutation CreateInventoryScrap($input: InventoryScrapInput!) {
      CreateInventoryScrap(input: $input) {
        _id
        no_scrap
      }
    }
  ''';

  static const getInventarisUmum = r'''
    query GetAllInventarisUmum($filter: InventarisUmumFilter, $sorting: InventarisUmumSorting, $pagination: pagination) {
      GetAllInventarisUmum(filter: $filter, sorting: $sorting, pagination: $pagination) {
        items {
          _id
          kode_inventaris
          nama_inventaris
          unit
          kategori_id
          kategori_nama
          total_stok
        }
      }
    }
  ''';

  static const getInventoryLocationBalances = r'''
    query GetInventoryLocationBalances($inventoryId: ID!, $pagination: pagination) {
      GetInventoryLocationBalances(inventaris_id: $inventoryId, pagination: $pagination) {
        items {
          _id
          lokasi_cabang_id
          lokasi_cabang_nama
          lokasi_gedung_nama
          lokasi_ruangan_nama
          lokasi_rak_nama
          qty
        }
      }
    }
  ''';
}
