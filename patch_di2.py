import sys

def inject(path):
    with open(path, 'r') as f:
        lines = f.readlines()

    # 1. Imports
    import_idx = 0
    for i, line in enumerate(lines):
        if "import 'package:presensi_mobile/presentation/_presentation.dart';" in line:
            import_idx = i
            break
    
    imports = """import 'package:presensi_mobile/presentation/bloc/chat/chat_list_cubit.dart';
import 'package:presensi_mobile/presentation/bloc/chat/chat_room_cubit.dart';
import 'package:presensi_mobile/presentation/bloc/chat/chat_search_user_cubit.dart';
import 'package:presensi_data/src/datasources/remote/chat_remote_datasource.dart';
import 'package:presensi_data/src/repositories/chat_repository_impl.dart';

import 'package:presensi_data/src/datasources/remote/inventory_remote_datasource.dart';
import 'package:presensi_data/src/repositories/inventory_repository_impl.dart';
import 'package:presensi_domain/src/repositories/inventory_repository.dart';
import 'package:presensi_domain/src/usecases/inventory/get_incidental_reports.dart';
import 'package:presensi_domain/src/usecases/inventory/add_incidental_report.dart';
import 'package:presensi_domain/src/usecases/inventory/get_inventaris_umum.dart';
import 'package:presensi_mobile/presentation/pages/inventory/incidental/bloc/incidental_report_cubit.dart';
import 'package:presensi_mobile/presentation/pages/inventory/incidental/bloc/incidental_report_form_cubit.dart';

import 'package:presensi_mobile/presentation/bloc/order/order_create_cubit.dart';
import 'package:presensi_mobile/presentation/bloc/order/product_get_all_cubit.dart';
import 'package:presensi_mobile/presentation/bloc/order/order_get_all_sales_orders_cubit.dart';
import 'package:presensi_data/src/datasources/remote/order_remote_datasource.dart';
import 'package:presensi_data/src/repositories/order_repository_impl.dart';
"""
    lines.insert(import_idx, imports)
    
    # 2. Cubits
    for i, line in enumerate(lines):
        if "sl.registerFactory<ApotekQueryCubit>(" in line:
            for j in range(i, len(lines)):
                if ");" in lines[j]:
                    lines.insert(j + 1, """
  // Order
  sl.registerFactory<OrderCreateCubit>(() => OrderCreateCubit(sl()));
  sl.registerFactory<ProductGetAllCubit>(() => ProductGetAllCubit(sl()));
  sl.registerFactory<OrderGetAllSalesOrdersCubit>(() => OrderGetAllSalesOrdersCubit(usecase: sl()));

  // Chat
  sl.registerFactory<ChatListCubit>(() => ChatListCubit(getConversationsUseCase: sl()));
  sl.registerFactory<ChatRoomCubit>(() => ChatRoomCubit(
      getMessagesUseCase: sl(),
      getThreadMessagesUseCase: sl(),
      sendMessageUseCase: sl(),
      markMessagesAsReadUseCase: sl(),
      connectWebSocketUseCase: sl(),
      disconnectWebSocketUseCase: sl(),
  ));
  sl.registerFactory<ChatSearchUserCubit>(() => ChatSearchUserCubit(searchUsersUseCase: sl()));

  // Inventory
  sl.registerFactory<IncidentalReportCubit>(() => IncidentalReportCubit(sl()));
  sl.registerFactory<IncidentalReportFormCubit>(() => IncidentalReportFormCubit(sl(), sl()));
""")
                    break
            break

    # 3. UseCases
    for i, line in enumerate(lines):
        if "sl.registerLazySingleton(() => ApotekPostQuery(sl()));" in line:
            lines.insert(i + 1, """
  // Order
  sl.registerLazySingleton(() => OrderCreateSalesOrder(sl()));
  sl.registerLazySingleton(() => OrderGetAllProducts(sl()));
  sl.registerLazySingleton(() => OrderGetAllSalesOrdersUsecase(sl()));

  // Chat
  sl.registerLazySingleton(() => ChatGetConversationsUseCase(repository: sl()));
  sl.registerLazySingleton(() => ChatGetMessagesUseCase(repository: sl()));
  sl.registerLazySingleton(() => ChatGetThreadMessagesUseCase(repository: sl()));
  sl.registerLazySingleton(() => ChatSearchUsersUseCase(repository: sl()));
  sl.registerLazySingleton(() => ChatGetOrCreatePrivateConversationUseCase(repository: sl()));
  sl.registerLazySingleton(() => ChatSendMessageUseCase(repository: sl()));
  sl.registerLazySingleton(() => ChatMarkMessagesAsReadUseCase(repository: sl()));
  sl.registerLazySingleton(() => ChatConnectWebSocketUseCase(repository: sl()));
  sl.registerLazySingleton(() => ChatDisconnectWebSocketUseCase(repository: sl()));

  // Inventory
  sl.registerLazySingleton(() => GetIncidentalReportsUseCase(sl()));
  sl.registerLazySingleton(() => AddIncidentalReportUseCase(sl()));
  sl.registerLazySingleton(() => GetInventarisUmumUseCase(sl()));
""")
            break

    # 4. Repositories
    for i, line in enumerate(lines):
        if "sl.registerLazySingleton<ApotekRepository>(" in line:
            lines.insert(i - 1, """
  // Order
  sl.registerLazySingleton<OrderRepository>(() => OrderRepositoryImpl(remoteDatasource: sl(), networkInfo: sl(), localCacheService: sl()));

  // Chat
  sl.registerLazySingleton<ChatRepository>(() => ChatRepositoryImpl(remoteDataSource: sl()));

  // Inventory
  sl.registerLazySingleton<InventoryRepository>(() => InventoryRepositoryImpl(remoteDataSource: sl(), logger: sl()));
""")
            break

    # 5. DataSources
    for i, line in enumerate(lines):
        if "sl.registerLazySingleton<ApotekRemoteDatasource>(" in line:
            lines.insert(i - 1, """
  // Order
  sl.registerLazySingleton<OrderRemoteDatasource>(() => OrderRemoteDatasourceImpl(graphQlService: sl()));

  // Chat
  sl.registerLazySingleton<ChatRemoteDataSource>(() => ChatRemoteDataSourceImpl(gql: sl(), logger: sl()));

  // Inventory
  sl.registerLazySingleton<InventoryRemoteDataSource>(() => InventoryRemoteDataSourceImpl(graphQLService: sl(), logger: sl()));
""")
            break

    with open(path, 'w') as f:
        f.writelines(lines)

if __name__ == '__main__':
    inject(sys.argv[1])
