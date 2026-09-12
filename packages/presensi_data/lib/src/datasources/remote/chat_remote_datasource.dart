import 'dart:convert';
import 'package:presensi_data/core/failure/failure.dart';
import 'package:presensi_data/graphql/chat_graphql.dart';
import 'package:presensi_data/src/models/chat_models.dart';
import 'package:presensi_data/service/graphql/graphql_service.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

abstract class ChatRemoteDataSource {
  Future<List<ConversationModel>> getConversations({int page = 1, int limit = 20, String? search, String? type});
  Future<List<MessageModel>> getMessages(String conversationId, {int page = 1, int limit = 50});
  Future<List<MessageModel>> getThreadMessages(String parentMessageId, {int page = 1, int limit = 50});
  Future<List<ChatParticipantModel>> searchChatUsers(String search, {int limit = 20});
  Future<ConversationModel> getOrCreatePrivateConversation(String targetUserId);
  Future<ConversationModel> createConversation({
    required String type,
    String? groupName,
    String? groupDescription,
    required List<String> participantIds,
  });
  Future<MessageModel> sendMessage({
    required String conversationId,
    required String content,
    String? type,
    String? replyToId,
    String? parentMessageId,
  });
  Future<bool> markMessagesAsRead(String conversationId);
  Stream<dynamic> connectWebSocket(String token, String baseUrl);
  void disconnectWebSocket();
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final GraphQlService graphQlService;
  WebSocketChannel? _wsChannel;

  ChatRemoteDataSourceImpl({required this.graphQlService});

  @override
  Future<List<ConversationModel>> getConversations({int page = 1, int limit = 20, String? search, String? type}) async {
    final data = await graphQlService.query(
      query: ChatGraphQL.getConversations,
      variables: {
        'page': page,
        'limit': limit,
        if (search != null) 'search': search,
        if (type != null) 'type': type,
      },
    );

    final listData = data['GetConversations']?['conversations'] as List?;
    if (listData == null) return [];

    return listData.map((e) => ConversationModel.fromJson(e)).toList();
  }

  @override
  Future<List<MessageModel>> getMessages(String conversationId, {int page = 1, int limit = 50}) async {
    final data = await graphQlService.query(
      query: ChatGraphQL.getMessages,
      variables: {
        'conversation_id': conversationId,
        'page': page,
        'limit': limit,
      },
    );

    final listData = data['GetMessages']?['messages'] as List?;
    if (listData == null) return [];

    return listData.map((e) => MessageModel.fromJson(e)).toList();
  }

  @override
  Future<List<MessageModel>> getThreadMessages(String parentMessageId, {int page = 1, int limit = 50}) async {
    final data = await graphQlService.query(
      query: ChatGraphQL.getThreadMessages,
      variables: {
        'parent_message_id': parentMessageId,
        'page': page,
        'limit': limit,
      },
    );

    final listData = data['GetThreadMessages']?['messages'] as List?;
    if (listData == null) return [];

    return listData.map((e) => MessageModel.fromJson(e)).toList();
  }

  @override
  Future<List<ChatParticipantModel>> searchChatUsers(String search, {int limit = 20}) async {
    final data = await graphQlService.query(
      query: ChatGraphQL.searchChatUsers,
      variables: {
        'search': search,
        'limit': limit,
      },
    );

    final listData = data['SearchChatUsers'] as List?;
    if (listData == null) return [];

    return listData.map((e) => ChatParticipantModel.fromJson(e)).toList();
  }

  @override
  Future<ConversationModel> getOrCreatePrivateConversation(String targetUserId) async {
    final data = await graphQlService.query(
      query: ChatGraphQL.getOrCreatePrivateConversation,
      variables: {
        'target_user_id': targetUserId,
      },
    );

    final convData = data['GetOrCreatePrivateConversation'];
    if (convData == null) throw const ServerFailure(message: 'No data returned');

    return ConversationModel.fromJson(convData);
  }

  @override
  Future<ConversationModel> createConversation({
    required String type,
    String? groupName,
    String? groupDescription,
    required List<String> participantIds,
  }) async {
    final data = await graphQlService.mutation(
      mutation: ChatGraphQL.createConversation,
      variables: {
        'input': {
          'type': type,
          if (groupName != null) 'group_name': groupName,
          if (groupDescription != null) 'group_description': groupDescription,
          'participant_ids': participantIds,
        }
      },
    );

    final convData = data['CreateConversation'];
    if (convData == null) throw const ServerFailure(message: 'No data returned');

    return ConversationModel.fromJson(convData);
  }

  @override
  Future<MessageModel> sendMessage({
    required String conversationId,
    required String content,
    String? type,
    String? replyToId,
    String? parentMessageId,
  }) async {
    final data = await graphQlService.mutation(
      mutation: ChatGraphQL.sendMessage,
      variables: {
        'input': {
          'conversation_id': conversationId,
          'content': content,
          if (type != null) 'type': type,
          if (replyToId != null) 'reply_to_id': replyToId,
          if (parentMessageId != null) 'parent_message_id': parentMessageId,
        }
      },
    );

    final msgData = data['SendMessage'];
    if (msgData == null) throw const ServerFailure(message: 'No data returned');

    return MessageModel.fromJson(msgData);
  }

  @override
  Future<bool> markMessagesAsRead(String conversationId) async {
    final data = await graphQlService.mutation(
      mutation: ChatGraphQL.markMessagesAsRead,
      variables: {
        'conversation_id': conversationId,
      },
    );

    return data['MarkMessagesAsRead'] ?? false;
  }

  @override
  Stream<dynamic> connectWebSocket(String token, String baseUrl) {
    disconnectWebSocket(); // Close existing if any

    // Convert http(s):// to ws(s)://
    var cleanBase = baseUrl.replaceAll(RegExp(r'/graphql/?$'), '');
    if (cleanBase.endsWith('/')) {
      cleanBase = cleanBase.substring(0, cleanBase.length - 1);
    }
    final wsUrl = '${cleanBase.replaceFirst(RegExp(r'^http'), 'ws')}/notifications';
    
    _wsChannel = WebSocketChannel.connect(Uri.parse(wsUrl));
    
    // Send auth message
    _wsChannel!.sink.add(jsonEncode({
      'type': 'auth',
      'token': token,
    }));

    return _wsChannel!.stream;
  }

  @override
  void disconnectWebSocket() {
    _wsChannel?.sink.close();
    _wsChannel = null;
  }
}
