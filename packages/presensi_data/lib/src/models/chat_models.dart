import 'package:json_annotation/json_annotation.dart';

part 'chat_models.g.dart';

@JsonSerializable()
class ChatParticipantModel {
  @JsonKey(name: '_id')
  final String? id;
  final String? name;
  final String? username;
  @JsonKey(name: 'url_foto')
  final String? urlFoto;

  ChatParticipantModel({this.id, this.name, this.username, this.urlFoto});

  factory ChatParticipantModel.fromJson(Map<String, dynamic> json) =>
      _$ChatParticipantModelFromJson(json);
  Map<String, dynamic> toJson() => _$ChatParticipantModelToJson(this);
}

@JsonSerializable()
class ChatAttachmentModel {
  final String? filename;
  final String? url;
  final String? mimetype;
  final int? size;

  ChatAttachmentModel({this.filename, this.url, this.mimetype, this.size});

  factory ChatAttachmentModel.fromJson(Map<String, dynamic> json) =>
      _$ChatAttachmentModelFromJson(json);
  Map<String, dynamic> toJson() => _$ChatAttachmentModelToJson(this);
}

@JsonSerializable()
class ChatLastMessageModel {
  final String? content;
  @JsonKey(name: 'sender_id')
  final String? senderId;
  @JsonKey(name: 'sent_at')
  final String? sentAt;
  final String? type;

  ChatLastMessageModel({this.content, this.senderId, this.sentAt, this.type});

  factory ChatLastMessageModel.fromJson(Map<String, dynamic> json) =>
      _$ChatLastMessageModelFromJson(json);
  Map<String, dynamic> toJson() => _$ChatLastMessageModelToJson(this);
}

@JsonSerializable()
class ConversationModel {
  @JsonKey(name: '_id')
  final String? id;
  final String? type;
  @JsonKey(name: 'group_name')
  final String? groupName;
  @JsonKey(name: 'group_avatar')
  final String? groupAvatar;
  @JsonKey(name: 'group_description')
  final String? groupDescription;
  final List<ChatParticipantModel>? participants;
  @JsonKey(name: 'admin_ids')
  final List<String>? adminIds;
  @JsonKey(name: 'instansi_id')
  final String? instansiId;
  @JsonKey(name: 'last_message')
  final ChatLastMessageModel? lastMessage;
  @JsonKey(name: 'unread_count')
  final int? unreadCount;
  final String? status;
  final String? createdAt;
  final String? updatedAt;

  ConversationModel({
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

  factory ConversationModel.fromJson(Map<String, dynamic> json) =>
      _$ConversationModelFromJson(json);
  Map<String, dynamic> toJson() => _$ConversationModelToJson(this);
}

@JsonSerializable()
class MessageModel {
  @JsonKey(name: '_id')
  final String? id;
  @JsonKey(name: 'conversation_id')
  final String? conversationId;
  @JsonKey(name: 'sender_id')
  final String? senderId;
  final ChatParticipantModel? sender;
  final String? content;
  final String? type;
  final ChatAttachmentModel? attachment;
  @JsonKey(name: 'parent_message_id')
  final String? parentMessageId;
  @JsonKey(name: 'thread_count')
  final int? threadCount;
  final String? status;
  final String? createdAt;
  final String? updatedAt;

  MessageModel({
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

  factory MessageModel.fromJson(Map<String, dynamic> json) =>
      _$MessageModelFromJson(json);
  Map<String, dynamic> toJson() => _$MessageModelToJson(this);
}
