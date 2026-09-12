mixin LoginGraphQl {
  /// query login and return data user with token.
  /// NOTE : IF YOU CHANGE THE MUTATION MAKE SURE CHANGE THE [getUserQuery] too
  String signInMutation = r'''mutation Mutation($input: LoginInput) {
  Login(input: $input) {
    token
    user {
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
      url_foto
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
  }
}''';

  String registerMutation = r'''mutation CreateUser($input: UserInput) {
  CreateUser(input: $input) {
    _id
    name
    email
    username
  }
}''';

  String checkEmailAvailableQuery =
      r'''query CheckEmailAvailable($email: String) {
  CheckEmailAvailable(email: $email)
}''';

  String checkUsernameAvailableQuery =
      r'''query CheckUsernameAvailable($username: String) {
  CheckUsernameAvailable(username: $username)
}''';

  String signOutMutation = r'''mutation {
    Logout {
         is_successed
         message
    }
}''';
}
