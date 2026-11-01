import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:presensi_data/presensi_data.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_mobile/presentation/bloc/app/app_cubit.dart';
import 'package:presensi_mobile/presentation/bloc/app/app_state.dart';
import 'package:presensi_mobile/presentation/pages/kalender/bloc/kalender_cubit.dart';
import 'package:presensi_mobile/presentation/pages/kalender/kalender_page.dart';

class CalendarPolicy extends Cubit<AppState> implements AppCubit {
  CalendarPolicy():super(AppState(user:BaseState.success(const User(id:'qa',name:'QA',isAdmin:true))));
  @override dynamic noSuchMethod(Invocation invocation)=>super.noSuchMethod(invocation);
}
class CalendarSource implements KalenderRemoteDatasource {
  final rows = <KalenderEvent>[
    const KalenderEvent(id:'w',title:'Mingguan QA',startDate:'2026-12-28',isRecurring:true,recurringType:'weekly',allDay:false,startTime:'09:00',endTime:'10:00'),
    const KalenderEvent(id:'m',title:'Bulanan QA',startDate:'2026-12-31',isRecurring:true,recurringType:'monthly'),
    const KalenderEvent(id:'y',title:'Tahunan QA',startDate:'2025-12-31',isRecurring:true,recurringType:'yearly'),
    const KalenderEvent(id:'l',title:'Kabisat QA',startDate:'2024-02-29',isRecurring:true,recurringType:'yearly'),
  ];
  @override Future<List<KalenderEvent>> getEventsByDateRange(String start,String end)async=>rows;
  @override dynamic noSuchMethod(Invocation invocation)=>super.noSuchMethod(invocation);
}
void main(){
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('Native calendar renders weekly monthly yearly and leap occurrences across periods',(tester)async{
    await initializeDateFormatting('id_ID');
    final cubit=KalenderCubit(remoteDatasource:CalendarSource(),initialMonth:DateTime(2027,1));
    final policy=CalendarPolicy(); await cubit.init();
    await tester.pumpWidget(ScreenUtilInit(designSize:const Size(360,800),builder:(_,_)=>MaterialApp(home:MultiBlocProvider(providers:[BlocProvider<AppCubit>.value(value:policy),BlocProvider<KalenderCubit>.value(value:cubit)],child:const KalenderView()))));
    await tester.pumpAndSettle();
    expect(find.text('Januari 2027'),findsOneWidget);
    expect(cubit.state.events.where((e)=>e.startDate.startsWith('2027-01')&&e.id=='w'),hasLength(4));
    await cubit.onDateSelected(DateTime(2027,1,31),DateTime(2027,1)); await tester.pumpAndSettle();
    expect(find.text('Bulanan QA'),findsOneWidget);
    await cubit.onMonthChanged(DateTime(2027,2));await tester.pumpAndSettle();
    await cubit.onDateSelected(DateTime(2027,2,28),DateTime(2027,2));await tester.pumpAndSettle();
    expect(find.text('Bulanan QA'),findsNothing);expect(find.text('Kabisat QA'),findsNothing);
    await cubit.onMonthChanged(DateTime(2027,3));await tester.pumpAndSettle();
    await cubit.onDateSelected(DateTime(2027,3,31),DateTime(2027,3));await tester.pumpAndSettle();
    expect(find.text('Bulanan QA'),findsOneWidget);
    await cubit.onMonthChanged(DateTime(2027,12));await tester.pumpAndSettle();
    await cubit.onDateSelected(DateTime(2027,12,31),DateTime(2027,12));await tester.pumpAndSettle();
    expect(find.text('Tahunan QA'),findsOneWidget);
    await cubit.onMonthChanged(DateTime(2028,2));await tester.pumpAndSettle();
    await cubit.onDateSelected(DateTime(2028,2,29),DateTime(2028,2));await tester.pumpAndSettle();
    expect(find.text('Kabisat QA'),findsOneWidget);expect(tester.takeException(),isNull);
    await tester.pumpWidget(const SizedBox());await cubit.close();await policy.close();
  });
}
