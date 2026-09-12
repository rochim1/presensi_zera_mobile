import 'package:dartz/dartz.dart';
import 'package:presensi_data/core/failure/failure.dart';
import 'package:presensi_domain/src/entities/chat/chat_entities.dart';

abstract class ChatRepository {
  Future<Either<Failure, List<ConversationEntity>>> getConversations({int page = 1, int limit = 20, String? search, String? type});
  Future<Either<Failure, List<MessageEntity>>> getMessages(String conversationId, {int page = 1, int limit = 50});
  Future<Either<Failure, List<MessageEntity>>> getThreadMessages(String parentMessageId, {int page = 1, int limit = 50});
  Future<Either<Failure, List<ChatParticipantEntity>>> searchChatUsers(String search, {int limit = 20});
  Future<Either<Failure, ConversationEntity>> getOrCreatePrivateConversation(String targetUserId);
  Future<Either<Failure, ConversationEntity>> createConversation({
    required String type,
    String? groupName,
    String? groupDescription,
    required List<String> participantIds,
  });
  Future<Either<Failure, MessageEntity>> sendMessage({
    required String conversationId,
    required String content,
    String? type,
    String? replyToId,
    String? parentMessageId,
  });
  Future<Either<Failure, bool>> markMessagesAsRead(String conversationId);
  Stream<dynamic> connectWebSocket(String token, String baseUrl);
  void disconnectWebSocket();
}
