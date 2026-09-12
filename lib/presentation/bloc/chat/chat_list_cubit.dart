import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';
import 'package:presensi_data/core/failure/failure.dart';

part 'chat_list_state.dart';

class ChatListCubit extends Cubit<ChatListState> {
  final ChatGetConversationsUseCase getConversationsUseCase;

  ChatListCubit({required this.getConversationsUseCase})
    : super(const ChatListState());

  static const int _limit = 20;

  Future<void> fetchConversations({
    String? search,
    String? type,
    bool refresh = false,
  }) async {
    if (refresh) {
      emit(const ChatListState(conversations: BasePaginatedState.loading()));
    } else {
      if (state.conversations.isLoading ||
          state.conversations.isLoadingNext ||
          state.conversations.hasReachedMax)
        return;
      emit(
        state.copyWith(
          conversations: BasePaginatedState.loadingNext(
            data: state.conversations.data,
            page: state.conversations.currentPage,
            hasReachedMax: state.conversations.hasReachedMax,
          ),
        ),
      );
    }

    final currentPage = refresh ? 1 : state.conversations.currentPage;

    try {
      final result = await getConversationsUseCase(
        page: currentPage,
        limit: _limit,
        search: search,
        type: type,
      );

      result.fold(
        (failure) {
          emit(
            state.copyWith(conversations: BasePaginatedState.failure(failure)),
          );
        },
        (data) {
          final allData = refresh
              ? data
              : [...state.conversations.data, ...data];
          emit(
            state.copyWith(
              conversations: BasePaginatedState.success(
                data: allData,
                page: currentPage + 1,
                hasReachedMax: data.length < _limit,
              ),
            ),
          );
        },
      );
    } catch (e) {
      emit(
        state.copyWith(
          conversations: BasePaginatedState.failure(
            ServerFailure(message: e.toString()),
          ),
        ),
      );
    }
  }
}
