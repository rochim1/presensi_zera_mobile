import 'package:presensi_domain/presensi_domain.dart';

class AppNotification {
  final String id;
  final bool isRead;
  final NotificationNewType type;
  final String title;
  final String body;
  final DateTime? createdAt;

  const AppNotification({
    required this.id,
    required this.isRead,
    required this.type,
    required this.title,
    required this.body,
    this.createdAt,
  });

  AppNotification copyWith({
    String? id,
    bool? isRead,
    NotificationNewType? type,
    String? title,
    String? body,
    DateTime? createdAt,
  }) {
    return AppNotification(
      id: id ?? this.id,
      isRead: isRead ?? this.isRead,
      type: type ?? this.type,
      title: title ?? this.title,
      body: body ?? this.body,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
