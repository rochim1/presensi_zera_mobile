part of 'global_post_fcm_cubit.dart';

class GlobalPostFcmState extends Equatable {
  final AuthorizationStatus? authorizationStatus;
  final String? appId;
  final Map<String, dynamic>? dataMessage;
  final RemoteNotification? notification;
  final String? message;
  final NotificationType? notificationType;
  final NotificationState notificationState;

  const GlobalPostFcmState({
    this.authorizationStatus,
    this.appId,
    this.dataMessage,
    this.notification,
    this.message,
    this.notificationType,
    this.notificationState = NotificationState.other,
  });

  @override
  List<Object?> get props => [
    authorizationStatus,
    appId,
    dataMessage,
    message,
    notificationType,
    notificationState,
  ];

  GlobalPostFcmState copyWith({
    AuthorizationStatus? authorizationStatus,
    String? appId,
    Map<String, dynamic>? dataMessage,
    RemoteNotification? notification,
    String? message,
    NotificationType? notificationType,
    NotificationState? notificationState,
  }) {
    return GlobalPostFcmState(
      authorizationStatus: authorizationStatus ?? this.authorizationStatus,
      dataMessage: dataMessage ?? this.dataMessage,
      notification: notification ?? this.notification,
      message: message ?? this.message,
      appId: appId ?? this.appId,
      notificationType: notificationType ?? this.notificationType,
      notificationState: notificationState ?? this.notificationState,
    );
  }
}
