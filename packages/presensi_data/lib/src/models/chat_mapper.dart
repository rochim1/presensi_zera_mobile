import 'package:presensi_data/src/models/chat_models.dart';
import 'package:presensi_domain/src/entities/chat/chat_entities.dart';

extension ChatParticipantModelMapper on ChatParticipantModel {
  ChatParticipantEntity toEntity() => ChatParticipantEntity(
        id: id,
        name: name,
        username: username,
        urlFoto: urlFoto,
      );
}

extension ChatAttachmentModelMapper on ChatAttachmentModel {
  ChatAttachmentEntity toEntity() => ChatAttachmentEntity(
        filename: filename,
        url: url,
        mimetype: mimetype,
        size: size,
      );
}

extension ChatLastMessageModelMapper on ChatLastMessageModel {
  ChatLastMessageEntity toEntity() => ChatLastMessageEntity(
        content: content,
        senderId: senderId,
        sentAt: sentAt,
        type: type,
      );
}

extension ConversationModelMapper on ConversationModel {
  ConversationEntity toEntity() => ConversationEntity(
        id: id,
        type: type,
        groupName: groupName,
        groupAvatar: groupAvatar,
        groupDescription: groupDescription,
        participants: participants?.map((e) => e.toEntity()).toList(),
        adminIds: adminIds,
        instansiId: instansiId,
        lastMessage: lastMessage?.toEntity(),
        unreadCount: unreadCount,
        status: status,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}

extension MessageModelMapper on MessageModel {
  MessageEntity toEntity() => MessageEntity(
        id: id,
        conversationId: conversationId,
        senderId: senderId,
        sender: sender?.toEntity(),
        content: content,
        type: type,
        attachment: attachment?.toEntity(),
        parentMessageId: parentMessageId,
        threadCount: threadCount,
        status: status,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}
