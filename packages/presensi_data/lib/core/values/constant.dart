// ignore_for_file: constant_identifier_names

//! limit of list
const int LIMIT = 20;
const int LAST_DATA = 5;

//! Hive BOX
const String BOX_LOGIN = 'box_auth';
const String BOX_USER = 'box_user';
const String BOX_QUERY = 'box_query';
const String BOX_APOTEK_CACHE = 'box_apotek_cache';
const String BOX_PRODUCT_CACHE = 'box_product_cache';
const String BOX_ORDER_QUEUE = 'box_order_queue';
const String BOX_PRESENSI_QUEUE = 'box_presensi_queue';
const String BOX_VISIT_QUEUE = 'box_visit_queue';

//! Hive KEY
const String BOX_KEY_LOGIN = 'box_key_auth';
const String BOX_KEY_USER = 'box_key_user';
const String KEY_QUERY_APOTEK = 'key_query_apotek';

//! Failure Messages
const String FAILURE_UNKNOWN =
    'Terjadi Kesalahan, Silahkan hubungi Tim Pengembang!';
const String FAILURE_UNKNOWN_DATA =
    'Data tidak berhasil diperbaharui, Silahkan hubungi Tim Pengembang';
const String FAILURE_NOT_FOUND = 'Tidak ada data yang ditampilkan';
const String FAILURE_UPLOAD_FILE = 'Upload file dibatalkan';
const String FAILURE_IMAGE_FILE = 'Ganti gambar dibatalkan';
const String FAILURE_MAP_NOTFOUND = 'Sedang Mencari Posisi';
const String FAILURE_WAIT = 'Tunggu sebentar';
const String FAILURE_FILE_UKNOWN = 'File tidak bisa dibuka';
const String FAILURE_NOT_FOUND_INV = 'Data Inventaris Kosong';
const String FAILURE_IO_ERROR = 'Koneksi berhasalah saat mencari Koordinat!';

//! Exception Messages
const String EXCEPTION_CANCEL = 'Permintaan ke server dibatalkan';
const String EXCEPTION_ABORT =
    'Koneksi ke server terputus, silahkan coba lagi nanti';
const String EXCEPTION_CONNECTION_RTO = 'Waktu koneksi habis';
const String EXCEPTION_RECEIVE_RTO =
    'Koneksi Timeout, silahkan reload Aplikasi!';
const String EXCEPTION_SEND_RTO = 'Waktu habis saat mengirim data';
const String EXCEPTION_OTHER = 'Gagal terhubung ke server';
const String EXCEPTION_NOT_FOUND = 'Data tidak ditemukan';
const String EXCEPTION_METHOD = 'Resource tidak ditemukan';
const String EXCEPTION_MEDIA_TYPE = 'Media tidak ditemukan';
const String EXCEPTION_ISE = 'Terjadi kesalahan server internal';
const String EXCEPTION_UNAUTHORIZED = 'Silahkan login kembali';
const String EXCEPTION_UNKNOWN =
    'Terjadi Kesalahan, Silahkan hubungi Tim Pengembang!';
const String EXCEPTION_AUTH_INVALID = 'Username atau password salah';
const String EXCEPTION_CODE_NOT_FOUND = 'Pengguna tidak ditemukan';
const String EXCEPTION_USER_INPUT = 'Kesalahan input data';
const String EXCEPTION_FILE_NOT_FOUND = 'File tidak ditemukan';

const String EXCEPTION_LOGIN = 'Silahkan Login Kembali!';
const String EXCEPTION_LOGIN_INVALID = 'Username atau Password salah';
const String EXCEPTION_LOGIN_ERROR = 'Error while getting contacts ';

//! Network Info
const String MESSAGE_UNCONNECTED = 'Tidak terhubung ke Internet';
const String MESSAGE_CONNECTED = 'Connect to Internet';
const String MESSAGE_TOKEN_SUCCESS = 'Success save Token FCM';

//! Permission Messages
const String PERMISSION_STORAGE_DENIED = 'Akses penyimpanan ditolak';
const String PERMISSION_STORAGE_DISABLE =
    'Akses penyimpanan ditolak, silahkan buka pengaturan Aplikasi';
const String PERMISSION_CAMERA_DENIED = 'Akses kamera ditolak';
const String PERMISSION_LOCATION_DENIED = 'Akses lokasi ditolak';
const String PERMISSION_LOCATION_DISABLE =
    'Akses lokasi ditolak, silahkan buka pengaturan Aplikasi';

//! Successed
const String SUCCESS_IMAGE_CHANGE = 'Gambar berhasil diganti';
const String SUCCESS_IMAGE_DELETE = 'Gambar berhasil hapus';
const String SUCCESS_CREATE_DATA = 'Data berhasil di tambahkan';
const String SUCCESS_UPDATE_DATA = 'Data berhasil di ubah';
const String SUCCESS_UPDATE_PASSWORD = 'Kata sandi berhasil di ubah';
const String SUCCESS_DELETE_DATA = 'Data berhasil di hapus';

//! Failed
const String FAILED_IMAGE_DELETE = 'Gambar gagal dihapus';
const String FAILED_ADD_DATA = 'Data gagal ditambahkan';

//! GraphQl Code Error
/// data tidak ditemukan atau kosong
const String NOT_FOUND = 'NOT_FOUND';

/// kesalahan sintaksis dalam query atau permintaan yang tidak valid
const String BAD_REQUEST = 'BAD_REQUEST';

/// query yang tidak sesuai dengan sintaksis GraphQL
const String GRAPHQL_PARSE_FAILED = 'GRAPHQL_PARSE_FAILED';

/// query GraphQL telah berhasil diurai, tetapi tidak lulus validasi skema GraphQL
const String GRAPHQL_VALIDATION_FAILED = 'GRAPHQL_VALIDATION_FAILED';

/// permintaan GraphQL tidak valid karena input pengguna
const String BAD_USER_INPUT = 'BAD_USER_INPUT';

/// query dengan ID yang diberikan tidak ditemukan.
const String PERSISTED_QUERY_NOT_FOUND = 'PERSISTED_QUERY_NOT_FOUND';

/// mengindikasikan bahwa server GraphQL tidak mendukung penggunaan query yang tersimpan
const String PERSISTED_QUERY_NOT_SUPPORTED = 'PERSISTED_QUERY_NOT_SUPPORTED';

/// kesalahan di sisi server saat mengeksekusi resolusi
const String OPERATION_RESOLUTION_FAILURE = 'OPERATION_RESOLUTION_FAILURE';

/// terjadi kesalahan internal di server
const String INTERNAL_SERVER_ERROR = 'INTERNAL_SERVER_ERROR';
const String MISDIRECTED_REQUEST = 'MISDIRECTED_REQUEST';

//ERROR CODE
/// failure code in 'UnknownFailure'
const String E000 = '[E000] ';
const String E001 = '[E001] ';
const String E002 = '[E002] ';
const String E003 = '[E003] ';
const String E004 = '[E004] ';
const String E005 = '[E005] ';
const String E006 = '[E006] ';
const String E007 = '[E007] ';
const String E008 = '[E008] ';
const String E009 = '[E009] ';
const String E010 = '[E010] ';
