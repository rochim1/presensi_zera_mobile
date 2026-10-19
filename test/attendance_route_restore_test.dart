import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_mobile/presentation/bloc/app/app_cubit.dart';
import 'package:presensi_mobile/presentation/bloc/app/app_state.dart';
import 'package:presensi_mobile/presentation/pages/attendance/check_in/check_in_page.dart';

class RestoringAccount extends Cubit<AppState> implements AppCubit {
  RestoringAccount() : super(const AppState());
  final ready = Completer<void>();
  var prematureSettingCalls = 0;
  @override
  Future<void> init() => ready.future;
  @override
  Future<bool> getSetting() async {
    if (!state.user.isSuccess) prematureSettingCalls++;
    return state.setting.isSuccess;
  }

  @override
  Future<void> loadSettingCache() async {
    prematureSettingCalls++;
  }

  void finish() {
    emit(
      state.copyWith(
        user: BaseState.success(
          const User(id: 'employee', name: 'QA Employee'),
        ),
        setting: BaseState.success(const Setting(id: 'policy')),
      ),
    );
    ready.complete();
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  testWidgets(
    'deep attendance route waits for employee restoration without a false warning',
    (tester) async {
      final account = RestoringAccount();
      bool? result;
      await tester.pumpWidget(
        BlocProvider<AppCubit>.value(
          value: account,
          child: MaterialApp(
            home: Builder(
              builder: (context) => TextButton(
                onPressed: () async {
                  result = await ensureAttendanceSettingAvailable(context);
                },
                child: const Text('Open attendance'),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Open attendance'));
      await tester.pump(const Duration(seconds: 2));
      expect(result, isNull);
      expect(account.prematureSettingCalls, 0);
      expect(find.text('Pengaturan presensi belum tersedia'), findsNothing);
      account.finish();
      await tester.pump();
      expect(result, true);
      expect(account.prematureSettingCalls, 0);
      await account.close();
    },
  );
}
