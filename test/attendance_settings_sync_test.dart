import 'package:presensi_mobile/presentation/pages/attendance/check_in/bloc/check_in_state.dart';
import 'package:presensi_mobile/presentation/pages/attendance/check_out/bloc/check_out_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_mobile/presentation/bloc/app/app_cubit.dart';
import 'package:presensi_mobile/presentation/bloc/app/app_state.dart';
import 'package:presensi_mobile/presentation/pages/attendance/tabs/attendances/attendances_page.dart';
import 'package:presensi_mobile/presentation/pages/attendance/formz/attachment_input.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:dartz/dartz.dart';
import 'package:presensi_data/presensi_data.dart';
import 'package:presensi_data/core/mapper/app_mappr.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/presentation/pages/attendance/bloc/attendance_cubit.dart';

class RecordingStatistics implements GetAttendanceStatistics {
  GetAttendancesParams? params;
  @override
  Future<Either<Failure, List<AttendanceStatistic>>> call(
    GetAttendancesParams input,
  ) async {
    params = input;
    return const Right([]);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class PersonalPolicyCubit extends Cubit<AppState> implements AppCubit {
  PersonalPolicyCubit()
    : super(
        AppState(
          setting: BaseState.success(
            const Setting(id: 's', canViewTeamAttendance: false),
          ),
        ),
      );
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class EffectiveScheduleGraphql implements GraphQlService {
  final queries = <String>[];
  @override
  Future<dynamic> query({
    required String query,
    Map<String, dynamic>? variables,
  }) async {
    queries.add(query);
    if (query.contains('GetOneSetting'))
      return {
        'GetOneSetting': {
          '_id': 'setting',
          'jam_masuk': '09:00',
          'jam_pulang': '17:00',
          'can_view_team_attendance': true,
          'employee_attendance_visibility': 'team',
        },
      };
    expect(query.contains('GetEffectiveScheduleToday'), true);
    expect(variables?['userId'], 'staff');
    return {
      'GetEffectiveScheduleToday': {
        'is_shift': true,
        'effective_jam_masuk': '22:00',
        'effective_jam_pulang': '06:00',
      },
    };
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  test(
    'mandatory evidence changes the form state instead of being discarded as equal',
    () {
      const required = AttachmentInput.pure(isRequired: true);
      expect(required, isNot(const AttachmentInput.pure()));
      const checkIn = CheckInState();
      final nextIn = checkIn.copyWith(
        form: checkIn.form.copyWith(attachment: required),
      );
      expect(nextIn, isNot(checkIn));
      expect(nextIn.form.attachment.isRequired, true);
      const checkOut = CheckOutState();
      final nextOut = checkOut.copyWith(
        form: checkOut.form.copyWith(attachment: required),
      );
      expect(nextOut, isNot(checkOut));
      expect(nextOut.form.attachment.isRequired, true);
    },
  );
  test(
    'mobile uses the effective server schedule rather than device weekday selection',
    () async {
      final gql = EffectiveScheduleGraphql();
      final remote = SettingRemoteDatasourceImpl(
        gql: gql,
        logger: Logger(level: Level.off),
      );
      final setting = await remote.getSettingByOrganizationId(
        'tenant',
        'staff',
      );
      expect(setting.jamMasuk?.hour, 22);
      expect(setting.jamPulang?.hour, 6);
      expect(setting.canViewTeamAttendance, true);
      expect(gql.queries.length, 2);
    },
  );
  test(
    'API and Hive permission model lists do not crash permission checks',
    () {
      const user = User(
        id: 'qa',
        name: 'QA',
        rolePermissions: LoginRolePermissionsModel(
          isFullAccess: false,
          permissions: [
            RolePermissionModel(module: 'kpi', actions: ['view']),
          ],
        ),
      );
      expect(user.hasPermission('kpi', action: 'view'), true);
      expect(user.hasPermission('kpi', action: 'update'), false);
      expect(user.hasPermission('other', action: 'view'), false);
    },
  );
  testWidgets(
    'direct team route does not request data when admin limits access',
    (tester) async {
      final app = PersonalPolicyCubit();
      await tester.pumpWidget(
        BlocProvider<AppCubit>.value(
          value: app,
          child: const MaterialApp(home: AttendancesPage()),
        ),
      );
      expect(
        find.text('Presensi tim tidak diizinkan oleh admin.'),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
      await app.close();
    },
  );
  test(
    'mandatory supporting evidence rejects empty attachments but optional remains valid',
    () {
      expect(const AttachmentInput.dirty([], isRequired: true).isValid, false);
      expect(const AttachmentInput.dirty([]).isValid, true);
      final file = PlatformFile(name: 'bukti.jpg', size: 100);
      expect(AttachmentInput.dirty([file], isRequired: true).isValid, true);
    },
  );
  test(
    'server team access and web settings survive mobile decoding and mapping',
    () {
      for (final allowed in [true, false]) {
        final response = SettingResponse.fromJson({
          '_id': 'setting',
          'can_view_team_attendance': allowed,
          'employee_attendance_visibility': allowed ? 'team' : 'self',
          'mode_presensi': 'foto',
          'attendance_types': ['shift', 'reguler'],
          'is_mandatory_foto_pendukung_presensi': true,
          'logbook_required_for_checkout': true,
        });
        final value = AppMappr().convert<SettingResponse, Setting>(response);
        expect(value.canViewTeamAttendance, allowed);
        expect(value.employeeAttendanceVisibility, allowed ? 'team' : 'self');
        expect(value.attendanceMode, SettingAttendanceMode.foto);
        expect(value.allowShiftAttendance, true);
        expect(value.isMandatorySupportingEvidence, true);
        expect(value.logbookRequiredForCheckout, true);
      }
      expect(
        SettingResponse.fromJson({'_id': 'legacy'}).canViewTeamAttendance,
        false,
      );
    },
  );
  test('personal statistics remain personal with a shift filter', () async {
    final service = RecordingStatistics();
    final cubit = AttendanceCubit(
      logger: Logger(),
      getAttendanceStatisticsUseCase: service,
    )..currentUserId = 'employee';
    cubit.applyFilters(
      startDate: DateTime(2026, 10, 1),
      endDate: DateTime(2026, 10, 31),
      typePresensi: 'shift',
    );
    await Future<void>.delayed(Duration.zero);
    expect(service.params?.userId, 'employee');
    expect(service.params?.typePresensi, 'shift');
    await cubit.close();
  });
  test(
    'statistics without a logged in employee never request team data',
    () async {
      final service = RecordingStatistics();
      final cubit = AttendanceCubit(
        logger: Logger(),
        getAttendanceStatisticsUseCase: service,
      );
      cubit.init();
      await Future<void>.delayed(Duration.zero);
      expect(service.params, isNull);
      await cubit.close();
    },
  );
}
