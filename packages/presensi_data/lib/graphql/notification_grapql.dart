mixin NotificationGrapql {
  String getUnreadNotificationsCountQuery = r'''
query Query {
  CountUnreadNotifikasi
}
''';

  String get getNotificationsQuery =>
      r'''query($filter: FilterNotif, $pagination: pagination){
  GetAllNotifikasi(filter: $filter, pagination: $pagination) {
    notifikasi {
      _id
      is_read
      tipe_notif
      title
      body
      createdAt
    }
  }
}''';

  String get markAsReadByIdMutation => r'''mutation ReadThisNotif($id: ID!) {
  readThisNotif(_id: $id)
}''';

  String get deleteByIdMutation => r'''mutation DeleteNotifikasi($id: ID!) {
  DeleteNotifikasi(_id: $id)
}''';
}
