import 'package:dartz/dartz.dart';
import 'package:presensi_data/core/failure/failure.dart';
import 'package:presensi_domain/src/entities/chat/chat_entities.dart';
import 'package:presensi_domain/src/repositories/chat_repository.dart';

class ChatGetConversationsUseCase {
  final ChatRepository repository;
  ChatGetConversationsUseCase({required this.repository});
  Future<Either<Failure, List<ConversationEntity>>> call({int page = 1, int limit = 20, String? search, String? type}) =>
      repository.getConversations(page: page, limit: limit, search: search, type: type);
}

class ChatGetMessagesUseCase {
  final ChatRepository repository;
  ChatGetMessagesUseCase({required this.repository});
  Future<Either<Failure, List<MessageEntity>>> call(String conversationId, {int page = 1, int limit = 50}) =>
      repository.getMessages(conversationId, page: page, limit: limit);
}

class ChatGetThreadMessagesUseCase {
  final ChatRepository repository;
  ChatGetThreadMessagesUseCase({required this.repository});
  Future<Either<Failure, List<MessageEntity>>> call(String parentMessageId, {int page = 1, int limit = 50}) =>
      repository.getThreadMessages(parentMessageId, page: page, limit: limit);
}
class ChatSearchUsersUseCase {
  final ChatRepository repository;
  ChatSearchUsersUseCase({required this.repository});
  Future<Either<Failure, List<ChatParticipantEntity>>> call(String search, {int limit = 20}) =>
      repository.searchChatUsers(search, limit: limit);
}

class ChatGetOrCreatePrivateConversationUseCase {
  final ChatRepository repository;
  ChatGetOrCreatePrivateConversationUseCase({required this.repository});
  Future<Either<Failure, ConversationEntity>> call(String targetUserId) =>
      repository.getOrCreatePrivateConversation(targetUserId);
}

class ChatCreateConversationUseCase {
  final ChatRepository repository;
  ChatCreateConversationUseCase({required this.repository});
  Future<Either<Failure, ConversationEntity>> call({
    required String type,
    String? groupName,
    String? groupDescription,
    required List<String> participantIds,
  }) =>
      repository.createConversation(
        type: type,
        groupName: groupName,
        groupDescription: groupDescription,
        participantIds: participantIds,
      );
}

class ChatSendMessageUseCase {
  final ChatRepository repository;
  ChatSendMessageUseCase({required this.repository});
  Future<Either<Failure, MessageEntity>> call({
    required String conversationId,
    required String content,
    String? type,
    String? replyToId,
    String? parentMessageId,
  }) =>
      repository.sendMessage(
        conversationId: conversationId,
        content: content,
        type: type,
        replyToId: replyToId,
        parentMessageId: parentMessageId,
      );
}

class ChatMarkMessagesAsReadUseCase {
  final ChatRepository repository;
  ChatMarkMessagesAsReadUseCase({required this.repository});
  Future<Either<Failure, bool>> call(String conversationId) =>
      repository.markMessagesAsRead(conversationId);
}

class ChatConnectWebSocketUseCase {
  final ChatRepository repository;
  ChatConnectWebSocketUseCase({required this.repository});
  Stream<dynamic> call(String token, String baseUrl) =>
      repository.connectWebSocket(token, baseUrl);
}

class ChatDisconnectWebSocketUseCase {
  final ChatRepository repository;
  ChatDisconnectWebSocketUseCase({required this.repository});
  void call() => repository.disconnectWebSocket();
}
