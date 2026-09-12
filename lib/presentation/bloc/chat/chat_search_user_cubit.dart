import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_mobile/core/_core.dart';

class ChatSearchUserState {
  final BaseState<List<ChatParticipantEntity>> users;

  const ChatSearchUserState({
    this.users = const BaseState.initial(),
  });

  ChatSearchUserState copyWith({
    BaseState<List<ChatParticipantEntity>>? users,
  }) {
    return ChatSearchUserState(
      users: users ?? this.users,
    );
  }
}

class ChatSearchUserCubit extends Cubit<ChatSearchUserState> {
  final ChatSearchUsersUseCase searchUsersUseCase;

  ChatSearchUserCubit({required this.searchUsersUseCase})
      : super(const ChatSearchUserState());

  Future<void> searchUsers(String query) async {
    // Removed empty query check to show all users by default

    emit(state.copyWith(users: const BaseState.loading()));

    final result = await searchUsersUseCase(query);

    result.fold(
      (failure) {
        emit(state.copyWith(users: BaseState.failure(failure)));
      },
      (data) {
        emit(state.copyWith(users: BaseState.success(data)));
      },
    );
  }
}
