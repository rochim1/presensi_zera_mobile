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
    
    imports = """import 'package:presensi_data/src/datasources/remote/sales_target_remote_datasource.dart';
import 'package:presensi_data/src/datasources/remote/task_report_remote_datasource.dart';
import 'package:presensi_data/src/repositories/sales_target_repository_impl.dart';
import 'package:presensi_data/src/repositories/task_report_repository_impl.dart';
import 'package:presensi_domain/src/repositories/sales_target_repository.dart';
import 'package:presensi_domain/src/repositories/task_report_repository.dart';
import 'package:presensi_mobile/presentation/cubits/sales_target/sales_target_cubit.dart';
import 'package:presensi_mobile/presentation/cubits/task_report/task_report_cubit.dart';\n"""
    lines.insert(import_idx, imports)
    
    # 2. Cubits
    for i, line in enumerate(lines):
        if "sl.registerFactory<TasksGetAllPerjalananCubit>(" in line:
            for j in range(i, len(lines)):
                if ");" in lines[j]:
                    lines.insert(j + 1, """
  // Sales Target & Task Report
  sl.registerFactory<SalesTargetCubit>(() => SalesTargetCubit(sl()));
  sl.registerFactory<TaskReportCubit>(() => TaskReportCubit(sl()));\n""")
                    break
            break

    # 3. Repositories
    for i, line in enumerate(lines):
        if "sl.registerLazySingleton<TasksRepository>(" in line:
            for j in range(i, len(lines)):
                if ");" in lines[j]:
                    lines.insert(j + 1, """
  // Sales Target & Task Report
  sl.registerLazySingleton<SalesTargetRepository>(
    () => SalesTargetRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<TaskReportRepository>(
    () => TaskReportRepositoryImpl(sl()),
  );\n""")
                    break
            break

    # 4. DataSources
    for i, line in enumerate(lines):
        if "sl.registerLazySingleton<TasksRemoteDatasource>(" in line:
            for j in range(i, len(lines)):
                if ");" in lines[j]:
                    lines.insert(j + 1, """
  // Sales Target & Task Report
  sl.registerLazySingleton<SalesTargetRemoteDatasource>(
    () => SalesTargetRemoteDatasourceImpl(sl()),
  );
  sl.registerLazySingleton<TaskReportRemoteDatasource>(
    () => TaskReportRemoteDatasourceImpl(sl()),
  );\n""")
                    break
            break

    with open(path, 'w') as f:
        f.writelines(lines)

if __name__ == '__main__':
    inject(sys.argv[1])
