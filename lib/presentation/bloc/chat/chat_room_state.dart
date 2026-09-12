part of 'chat_room_cubit.dart';

class ChatRoomState {
  final BasePaginatedState<MessageEntity> messages;
  final BasePaginatedState<MessageEntity> threadMessages;
  final MessageEntity? activeThread;

  const ChatRoomState({
    this.messages = const BasePaginatedState.initial(),
    this.threadMessages = const BasePaginatedState.initial(),
    this.activeThread,
  });

  ChatRoomState copyWith({
    BasePaginatedState<MessageEntity>? messages,
    BasePaginatedState<MessageEntity>? threadMessages,
    MessageEntity? activeThread,
  }) {
    return ChatRoomState(
      messages: messages ?? this.messages,
      threadMessages: threadMessages ?? this.threadMessages,
      activeThread: activeThread ?? this.activeThread,
    );
  }
}
