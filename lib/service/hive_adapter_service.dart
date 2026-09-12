import 'package:hive_flutter/hive_flutter.dart';
import 'package:presensi_data/presensi_data.dart';

class HiveAdapterService {
  HiveAdapterService._();

  static void init() {
    //! Register Hive
    // Login
    Hive.registerAdapter(LoginUserModelAdapter());
    Hive.registerAdapter(UserModelAdapter());
    Hive.registerAdapter(UserTypeIdModelAdapter());
    Hive.registerAdapter(DivisiIdModelAdapter());
    Hive.registerAdapter(AdditionalContactModelAdapter());
    Hive.registerAdapter(InstansiModelAdapter());
    Hive.registerAdapter(InventarisModelAdapter());
    Hive.registerAdapter(GlobalQueryModelAdapter());
    Hive.registerAdapter(RolePermissionModelAdapter());
    Hive.registerAdapter(LoginRolePermissionsModelAdapter());
  }
}
