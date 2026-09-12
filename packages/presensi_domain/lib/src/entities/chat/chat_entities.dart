import 'package:equatable/equatable.dart';

class ChatParticipantEntity extends Equatable {
  final String? id;
  final String? name;
  final String? username;
  final String? urlFoto;

  const ChatParticipantEntity({this.id, this.name, this.username, this.urlFoto});

  @override
  List<Object?> get props => [id, name, username, urlFoto];
}

class ChatAttachmentEntity extends Equatable {
  final String? filename;
  final String? url;
  final String? mimetype;
  final int? size;

  const ChatAttachmentEntity({this.filename, this.url, this.mimetype, this.size});

  @override
  List<Object?> get props => [filename, url, mimetype, size];
}

class ChatLastMessageEntity extends Equatable {
  final String? content;
  final String? senderId;
  final String? sentAt;
  final String? type;

  const ChatLastMessageEntity({this.content, this.senderId, this.sentAt, this.type});

  @override
  List<Object?> get props => [content, senderId, sentAt, type];
}

class ConversationEntity extends Equatable {
  final String? id;
  final String? type;
  final String? groupName;
  final String? groupAvatar;
  final String? groupDescription;
  final List<ChatParticipantEntity>? participants;
  final List<String>? adminIds;
  final String? instansiId;
  final ChatLastMessageEntity? lastMessage;
  final int? unreadCount;
  final String? status;
  final String? createdAt;
  final String? updatedAt;

  const ConversationEntity({
    this.id,
    this.type,
    this.groupName,
    this.groupAvatar,
    this.groupDescription,
    this.participants,
    this.adminIds,
    this.instansiId,
    this.lastMessage,
    this.unreadCount,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        type,
        groupName,
        groupAvatar,
        groupDescription,
        participants,
        adminIds,
        instansiId,
        lastMessage,
        unreadCount,
        status,
        createdAt,
        updatedAt,
      ];
}

class MessageEntity extends Equatable {
  final String? id;
  final String? conversationId;
  final String? senderId;
  final ChatParticipantEntity? sender;
  final String? content;
  final String? type;
  final ChatAttachmentEntity? attachment;
  final String? parentMessageId;
  final int? threadCount;
  final String? status;
  final String? createdAt;
  final String? updatedAt;

  const MessageEntity({
    this.id,
    this.conversationId,
    this.senderId,
    this.sender,
    this.content,
    this.type,
    this.attachment,
    this.parentMessageId,
    this.threadCount,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        conversationId,
        senderId,
        sender,
        content,
        type,
        attachment,
        parentMessageId,
        threadCount,
        status,
        createdAt,
        updatedAt,
      ];
}
