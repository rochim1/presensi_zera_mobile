mixin UserGraphQl {
  /// query to get user by id.
  /// NOTE : IF YOU CHANGE THE QUERY MAKE SURE CHANGE THE [signInMutation] too
  String getUserQuery = r'''query GetOneUser($id: ID) {
  GetOneUser(_id: $id) {
    _id
    no_identitas
    name
    username
    gender
    email
    id_presensi {
      _id
    }
		divisi_id {
      _id
      nama_divisi
      induk_divisi {
        _id
        nama_divisi
      }
      job_desk
    }
    jabatan_id {
      _id
      nama_jabatan
    }
    level_id {
      _id
      nama_level
    }
    instansi_id {
      _id
      nama_instansi
      nama_resmi
      logo
      website
      telpon_number
      tahun_berdiri
      alamat
      kegiatan_usaha
      dasar_hukum_pendirian
      subscription_status
    }
    address
    domisili
    pos_code
    date_of_birth
    telp_number
    date_join
    date_resign
    status
    additional_contact {
      name
      relation
      telpon_number
      address
      email
    }
    is_cuti
    inventaris_kendaraan_id {
      _id
      jenis_kendaraan
      merk
      plat_nomer
      jadwal_servis_terakhir
      kilometer_terakhir
      kilometer_kembali_servis
      tanggal_pembayaran_pajak
      total_biaya_pajak
      is_cycle_office
    }
    role_permissions {
      is_full_access
      permissions {
        module
        actions
      }
    }
  }
}''';

  /// mutation for update user by id
  String updateUserMutation =
      r'''mutation UpdateProfile($input: UserUpdateInput, $id: ID) {
  UpdateProfile(input: $input, _id: $id) {
    message
    is_successed
  }
}''';

  /// mutation for create/update user image (file)
  String updateUserImageMutation = r'''
  mutation UpdateProfile($input: UserUpdateInput, $id: ID) {
    UpdateProfile(input: $input, _id: $id) {
      is_successed
    }
  }
''';

  String getUserByIdQuery = r'''
  query GetOneUser($id: ID) {
  GetOneUser(_id: $id) {
    _id
    name
    is_admin
    divisi_id {
      _id
      nama_divisi
      }
    foto {
      url_path
    }
    instansi_id {
      _id
      nama_resmi
      nama_instansi
    }
    role_permissions {
      is_full_access
      permissions {
        module
        actions
      }
    }
  }
}
  ''';

  String getUsersQuery = r'''
  query GetAllUser($filter: FilterUser) {
  GetAllUser(filter: $filter) {
    users {
      _id
    name
    divisi_id {
      _id
      nama_divisi
      }
    foto {
      url_path
    }
    instansi_id {
      _id
      nama_resmi
      nama_instansi
    }
    }
  }
}
  ''';
}

/// get all data inventaris kendaraan
String getAllInventarisKendaraan =
    r'''query Inventaris($pagination: pagination, $filter: VehicleFilter) {
  GetAllInventarisKendaraan: GetAllVehicle(pagination: $pagination, filter: $filter) {
    inventaris: vehicles {
      _id
      jenis_kendaraan
      merk
      plat_nomer
      jadwal_servis_terakhir
      kilometer_terakhir
      kilometer_kembali_servis
      tanggal_pembayaran_pajak
      total_biaya_pajak
      is_cycle_office
    }
  }
}''';

String getImageProfile = r'''query GetProfileImage($id: ID) {
  GetProfileImage(_id: $id) {
    url_foto
  }
}''';

String deleteImageProfile =
    r'''mutation UpdateProfile($input: UserUpdateInput, $id: ID) {
  UpdateProfile(input: $input, _id: $id) {
    is_successed
  }
}''';
