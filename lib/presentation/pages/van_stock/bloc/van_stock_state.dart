import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:presensi_domain/presensi_domain.dart';

part 'van_stock_state.freezed.dart';

@freezed
abstract class VanStockState with _$VanStockState {
  const factory VanStockState.initial() = _Initial;
  const factory VanStockState.loading() = _Loading;
  const factory VanStockState.loaded({
    required List<VanStock> stocks,
    required bool hasReachedMax,
  }) = _Loaded;
  const factory VanStockState.error({required String message}) = _Error;
}
