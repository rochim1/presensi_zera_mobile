import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presensi_domain/presensi_domain.dart';
import 'package:presensi_data/presensi_data.dart';
import 'package:presensi_mobile/core/_core.dart';

class ChatCreateGroupState {
  final BaseState<List<ChatParticipantEntity>> users;
  final List<ChatParticipantEntity> selectedUsers;
  final BaseState<ConversationEntity> createStatus;

  const ChatCreateGroupState({
    this.users = const BaseState.initial(),
    this.selectedUsers = const [],
    this.createStatus = const BaseState.initial(),
  });

  ChatCreateGroupState copyWith({
    BaseState<List<ChatParticipantEntity>>? users,
    List<ChatParticipantEntity>? selectedUsers,
    BaseState<ConversationEntity>? createStatus,
  }) {
    return ChatCreateGroupState(
      users: users ?? this.users,
      selectedUsers: selectedUsers ?? this.selectedUsers,
      createStatus: createStatus ?? this.createStatus,
    );
  }
}

class ChatCreateGroupCubit extends Cubit<ChatCreateGroupState> {
  final ChatSearchUsersUseCase searchUsersUseCase;
  final ChatCreateConversationUseCase createConversationUseCase;

  ChatCreateGroupCubit({
    required this.searchUsersUseCase,
    required this.createConversationUseCase,
  }) : super(const ChatCreateGroupState());

  Future<void> searchUsers(String query) async {
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

  void toggleUserSelection(ChatParticipantEntity user) {
    final currentSelected = List<ChatParticipantEntity>.from(state.selectedUsers);
    
    final existingIndex = currentSelected.indexWhere((element) => element.id == user.id);
    if (existingIndex != -1) {
      currentSelected.removeAt(existingIndex);
    } else {
      currentSelected.add(user);
    }
    
    emit(state.copyWith(selectedUsers: currentSelected));
  }

  Future<void> createGroup({
    required String groupName,
    String? groupDescription,
  }) async {
    if (state.selectedUsers.isEmpty) {
      emit(state.copyWith(createStatus: BaseState.failure(CustomFailure(message: 'Silakan pilih minimal 1 anggota'))));
      return;
    }
    
    if (groupName.trim().isEmpty) {
      emit(state.copyWith(createStatus: BaseState.failure(CustomFailure(message: 'Nama grup tidak boleh kosong'))));
      return;
    }

    emit(state.copyWith(createStatus: const BaseState.loading()));

    final participantIds = state.selectedUsers.map((e) => e.id ?? '').where((id) => id.isNotEmpty).toList();

    final result = await createConversationUseCase(
      type: 'group',
      groupName: groupName,
      groupDescription: groupDescription,
      participantIds: participantIds,
    );

    result.fold(
      (failure) {
        emit(state.copyWith(createStatus: BaseState.failure(failure)));
      },
      (data) {
        emit(state.copyWith(createStatus: BaseState.success(data)));
      },
    );
  }
}
