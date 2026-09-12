import 'package:bloc/bloc.dart';
import 'package:logger/logger.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';

import 'announcement_state.dart';

class AnnouncementCubit extends Cubit<AnnouncementState> {
  final Logger logger;
  final GetAnnouncements getAnnouncementsUseCase;

  AnnouncementCubit({
    required this.logger,
    required this.getAnnouncementsUseCase,
  }) : super(const AnnouncementState());

  static const int _limit = 10;

  GetAnnouncementsParams _params({int page = 0}) {
    return GetAnnouncementsParams(page: page, limit: _limit);
  }

  Future<void> getAnnouncements() async {
    if (state.announcements.isLoading) return;

    emit(state.copyWith(announcements: const BasePaginatedState.loading()));

    final result = await getAnnouncementsUseCase.call(_params());

    result.fold(
      (failure) {
        emit(
          state.copyWith(announcements: BasePaginatedState.failure(failure)),
        );
      },
      (value) {
        emit(
          state.copyWith(
            announcements: BasePaginatedState.success(
              data: value,
              page: 0,
              hasReachedMax: value.length < _limit,
            ),
          ),
        );
      },
    );
  }

  Future<void> fetchNextPage() async {
    final current = state.announcements;
    if (current.hasReachedMax || current.isLoadingNext || current.isLoading) {
      return;
    }
    if (current.data.isEmpty) return;

    final nextPage = current.currentPage + 1;

    emit(
      state.copyWith(
        announcements: BasePaginatedState.loadingNext(
          data: current.data,
          page: nextPage,
          hasReachedMax: current.hasReachedMax,
        ),
      ),
    );

    final result = await getAnnouncementsUseCase.call(_params(page: nextPage));

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            announcements: BasePaginatedState.success(
              data: current.data,
              page: current.currentPage,
              hasReachedMax: current.hasReachedMax,
            ),
          ),
        );
      },
      (value) {
        final newList = List<Announcement>.from(current.data)..addAll(value);
        emit(
          state.copyWith(
            announcements: BasePaginatedState.success(
              data: newList,
              page: nextPage,
              hasReachedMax: value.length < _limit,
            ),
          ),
        );
      },
    );
  }

  void init() {
    getAnnouncements();
  }

  Future<void> onRefresh() async {
    await getAnnouncements();
  }
}
