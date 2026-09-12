part of 'chat_list_cubit.dart';

class ChatListState {
  final BasePaginatedState<ConversationEntity> conversations;

  const ChatListState({
    this.conversations = const BasePaginatedState.initial(),
  });

  ChatListState copyWith({
    BasePaginatedState<ConversationEntity>? conversations,
  }) {
    return ChatListState(
      conversations: conversations ?? this.conversations,
    );
  }
}
