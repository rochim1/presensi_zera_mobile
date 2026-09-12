import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'incidental_report_form_state.dart';

class IncidentalReportFormCubit extends Cubit<IncidentalReportFormState> {
  final AddIncidentalReportUseCase addIncidentalReportUseCase;
  final GetInventarisUmumUseCase getInventarisUmumUseCase;

  IncidentalReportFormCubit(
    this.addIncidentalReportUseCase,
    this.getInventarisUmumUseCase,
  ) : super(const IncidentalReportFormState());

  Future<List<InventarisItem>> searchInventaris(String query) async {
    final result = await getInventarisUmumUseCase(
      GetInventarisUmumParams(limit: 15, search: query),
    );

    return result.fold(
      (failure) => [],
      (items) => items,
    );
  }

  Future<void> submitReport(Map<String, dynamic> input) async {
    emit(state.copyWith(isSubmitting: true, failure: null));

    final result = await addIncidentalReportUseCase(
      AddIncidentalReportParams(input: input),
    );

    result.fold(
      (failure) => emit(state.copyWith(isSubmitting: false, failure: failure)),
      (_) => emit(state.copyWith(isSubmitting: false, isSuccess: true)),
    );
  }
}
