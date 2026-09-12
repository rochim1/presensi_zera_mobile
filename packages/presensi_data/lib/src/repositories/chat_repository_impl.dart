import 'package:dartz/dartz.dart';
import 'package:presensi_data/core/failure/failure.dart';
import 'package:presensi_data/src/datasources/remote/chat_remote_datasource.dart';
import 'package:presensi_data/src/models/chat_mapper.dart';
import 'package:presensi_domain/src/entities/chat/chat_entities.dart';
import 'package:presensi_domain/src/repositories/chat_repository.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remoteDataSource;

  ChatRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<ConversationEntity>>> getConversations({int page = 1, int limit = 20, String? search, String? type}) async {
    try {
      final models = await remoteDataSource.getConversations(page: page, limit: limit, search: search, type: type);
      return Right(models.map((e) => e.toEntity()).toList());
    } catch (e) {
      if (e is Failure) return Left(e);
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<MessageEntity>>> getMessages(String conversationId, {int page = 1, int limit = 50}) async {
    try {
      final models = await remoteDataSource.getMessages(conversationId, page: page, limit: limit);
      return Right(models.map((e) => e.toEntity()).toList());
    } catch (e) {
      if (e is Failure) return Left(e);
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<MessageEntity>>> getThreadMessages(String parentMessageId, {int page = 1, int limit = 50}) async {
    try {
      final models = await remoteDataSource.getThreadMessages(parentMessageId, page: page, limit: limit);
      return Right(models.map((e) => e.toEntity()).toList());
    } catch (e) {
      if (e is Failure) return Left(e);
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ChatParticipantEntity>>> searchChatUsers(String search, {int limit = 20}) async {
    try {
      final models = await remoteDataSource.searchChatUsers(search, limit: limit);
      return Right(models.map((e) => e.toEntity()).toList());
    } catch (e) {
      if (e is Failure) return Left(e);
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ConversationEntity>> getOrCreatePrivateConversation(String targetUserId) async {
    try {
      final model = await remoteDataSource.getOrCreatePrivateConversation(targetUserId);
      return Right(model.toEntity());
    } catch (e) {
      if (e is Failure) return Left(e);
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ConversationEntity>> createConversation({
    required String type,
    String? groupName,
    String? groupDescription,
    required List<String> participantIds,
  }) async {
    try {
      final model = await remoteDataSource.createConversation(
        type: type,
        groupName: groupName,
        groupDescription: groupDescription,
        participantIds: participantIds,
      );
      return Right(model.toEntity());
    } catch (e) {
      if (e is Failure) return Left(e);
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, MessageEntity>> sendMessage({
    required String conversationId,
    required String content,
    String? type,
    String? replyToId,
    String? parentMessageId,
  }) async {
    try {
      final model = await remoteDataSource.sendMessage(
        conversationId: conversationId,
        content: content,
        type: type,
        replyToId: replyToId,
        parentMessageId: parentMessageId,
      );
      return Right(model.toEntity());
    } catch (e) {
      if (e is Failure) return Left(e);
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> markMessagesAsRead(String conversationId) async {
    try {
      final result = await remoteDataSource.markMessagesAsRead(conversationId);
      return Right(result);
    } catch (e) {
      if (e is Failure) return Left(e);
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Stream<dynamic> connectWebSocket(String token, String baseUrl) {
    return remoteDataSource.connectWebSocket(token, baseUrl);
  }

  @override
  void disconnectWebSocket() {
    remoteDataSource.disconnectWebSocket();
  }
}
