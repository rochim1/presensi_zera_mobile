import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presensi_domain/src/entities/sales_target/sales_target.dart';
import 'package:presensi_domain/src/repositories/sales_target_repository.dart';
import 'package:intl/intl.dart';

part 'sales_target_state.dart';

class SalesTargetCubit extends Cubit<SalesTargetState> {
  final SalesTargetRepository repository;

  SalesTargetCubit(this.repository) : super(SalesTargetInitial());

  Future<void> loadMyTarget({String? periode}) async {
    emit(SalesTargetLoading());
    try {
      // Default to current month "YYYY-MM"
      final targetPeriode = periode ?? DateFormat('yyyy-MM').format(DateTime.now());
      final result = await repository.getMySalesTarget(periode: targetPeriode);

      if (result != null) {
        emit(SalesTargetLoaded(result, targetPeriode));
      } else {
        emit(SalesTargetEmpty(targetPeriode));
      }
    } catch (e) {
      emit(SalesTargetError(e.toString()));
    }
  }
}
