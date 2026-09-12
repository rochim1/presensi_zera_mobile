class EmailGraphQL {
  static const String countUnreadEmail = r'''
    query CountUnreadEmail {
        CountUnreadEmail
    }
  ''';

  static const String getAllEmail = r'''
    query GetAllEmail($filter: FilterEmail, $limit: Int, $offset: Int) {
        GetAllEmail(filter: $filter, limit: $limit, offset: $offset) {
            _id
            title
            tipe_email
            body
            is_read
            is_draft
            is_starred
            is_archived
            is_trash
            sent_batch_id
            recipient_type
            tanggal_email
            createdAt
            user_id {
                _id
                name
                email
                url_foto
            }
            sender_id {
                _id
                name
                email
                url_foto
            }
            instansi_id {
                _id
                nama_instansi
            }
        }
    }
  ''';

  static const String readEmail = r'''
    mutation ReadEmail($_id: ID!) {
        ReadEmail(_id: $_id) {
            _id
            is_read
        }
    }
  ''';
}
