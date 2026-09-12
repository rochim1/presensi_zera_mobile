import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:presensi_data/core/_core.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'van_stock_state.dart';

class VanStockCubit extends Cubit<VanStockState> {
  final Logger logger;
  final GetVanStockList getVanStockList;
  final UserGetLocal getUserLocal;

  int _currentPage = 1;
  bool _isFetching = false;
  List<VanStock> _currentStocks = [];
  bool _hasReachedMax = false;

  VanStockCubit({
    required this.logger,
    required this.getVanStockList,
    required this.getUserLocal,
  }) : super(const VanStockState.initial());

  Future<void> loadStocks({bool isRefresh = false}) async {
    if (_isFetching) return;
    if (_hasReachedMax && !isRefresh) return;

    try {
      _isFetching = true;
      if (isRefresh) {
        _currentPage = 1;
        _currentStocks = [];
        _hasReachedMax = false;
        emit(const VanStockState.loading());
      } else if (_currentStocks.isEmpty) {
        emit(const VanStockState.loading());
      }

      final userResult = await getUserLocal(NoParams());
      final localFailure = userResult.fold((failure) => failure, (_) => null);
      if (localFailure != null) {
        emit(VanStockState.error(message: localFailure.message));
        return;
      }
      final salesmanId = userResult.fold<String?>(
        (_) => null,
        (user) => user.userId,
      );
      if (salesmanId == null || salesmanId.isEmpty) {
        emit(
          const VanStockState.error(
            message: 'Identitas pengguna tidak ditemukan. Silakan login ulang.',
          ),
        );
        return;
      }

      final result = await getVanStockList(
        VanStockFilterParams(
          salesmanId: salesmanId,
          page: _currentPage,
          limit: 15,
        ),
      );

      result.fold(
        (failure) {
          emit(VanStockState.error(message: failure.message));
        },
        (stocks) {
          _currentPage++;
          _hasReachedMax = stocks.isEmpty || stocks.length < 15;
          _currentStocks.addAll(stocks);
          emit(
            VanStockState.loaded(
              stocks: List.from(_currentStocks),
              hasReachedMax: _hasReachedMax,
            ),
          );
        },
      );
    } catch (e) {
      logger.e('VanStockCubit.loadStocks: $e');
      emit(VanStockState.error(message: e.toString()));
    } finally {
      _isFetching = false;
    }
  }

  void refresh() {
    loadStocks(isRefresh: true);
  }
}
