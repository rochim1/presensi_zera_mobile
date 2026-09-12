class ChatGraphQL {
  static const String getConversations = r'''
    query GetConversations($page: Int, $limit: Int, $search: String, $type: String) {
      GetConversations(page: $page, limit: $limit, search: $search, type: $type) {
        total
        conversations {
          _id
          type
          group_name
          group_avatar
          group_description
          participants {
            _id
            name
            username
            url_foto
          }
          admin_ids
          instansi_id
          unread_count
          status
          createdAt
          updatedAt
          last_message {
            content
            sender_id
            sent_at
            type
          }
        }
      }
    }
  ''';

  static const String getMessages = r'''
    query GetMessages($conversation_id: String!, $page: Int, $limit: Int) {
      GetMessages(conversation_id: $conversation_id, page: $page, limit: $limit) {
        total
        hasMore
        messages {
          _id
          conversation_id
          sender_id
          sender {
            _id
            name
            username
            url_foto
          }
          content
          type
          attachment {
            filename
            url
            mimetype
            size
          }
          read_by {
            user_id
            read_at
          }
          reply_to {
            _id
            sender_id
            content
            type
          }
          parent_message_id
          thread_count
          status
          createdAt
          updatedAt
        }
      }
    }
  ''';

  static const String getThreadMessages = r'''
    query GetThreadMessages($parent_message_id: String!, $page: Int, $limit: Int) {
      GetThreadMessages(parent_message_id: $parent_message_id, page: $page, limit: $limit) {
        total
        hasMore
        messages {
          _id
          conversation_id
          sender_id
          sender {
            _id
            name
            username
            url_foto
          }
          content
          type
          read_by {
            user_id
            read_at
          }
          parent_message_id
          thread_count
          status
          createdAt
          updatedAt
        }
      }
    }
  ''';


  static const String searchChatUsers = r'''
    query SearchChatUsers($search: String!, $limit: Int) {
      SearchChatUsers(search: $search, limit: $limit) {
        _id
        name
        username
        url_foto
      }
    }
  ''';

  static const String getOrCreatePrivateConversation = r'''
    query GetOrCreatePrivateConversation($target_user_id: String!) {
      GetOrCreatePrivateConversation(target_user_id: $target_user_id) {
        _id
        type
        participants {
          _id
          name
          username
          url_foto
        }
        status
        createdAt
        updatedAt
      }
    }
  ''';

  static const String sendMessage = r'''
    mutation SendMessage($input: SendMessageInput!) {
      SendMessage(input: $input) {
        _id
        conversation_id
        sender_id
        content
        type
        createdAt
      }
    }
  ''';

  static const String createConversation = r'''
    mutation CreateConversation($input: CreateConversationInput!) {
      CreateConversation(input: $input) {
        _id
        type
        group_name
        group_avatar
        group_description
        participants {
          _id
          name
          username
          url_foto
        }
        status
        createdAt
        updatedAt
      }
    }
  ''';

  static const String markMessagesAsRead = r'''
    mutation MarkMessagesAsRead($conversation_id: String!) {
      MarkMessagesAsRead(conversation_id: $conversation_id)
    }
  ''';
}
