import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:presensi_mobile/core/_core.dart';

abstract class LocalNotificationService {
  void init(BuildContext context);
  Future<void> selectNotification(BuildContext context, String? payload);
  Future<void> showNotification(RemoteMessage payload);
  Future<void> showLocalNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  });
}

class LocalNotificationServiceImpl extends LocalNotificationService {
  final FlutterLocalNotificationsPlugin localNotification;

  LocalNotificationServiceImpl(this.localNotification);

  @override
  void init(BuildContext context) async {
    const InitializationSettings initializationSettings =
        InitializationSettings(
          android: AndroidInitializationSettings('ic_notif'),
        );

    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'pantoo', // id
      'Pantoo Notifikasi', // name
      description: 'Notifikasi utama aplikasi',
      importance: Importance.max,
      playSound: true,
      sound: RawResourceAndroidNotificationSound('notification'),
    );

    await localNotification
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);

    initializeLocalNotificationsPlugin(context, initializationSettings);
  }

  void initializeLocalNotificationsPlugin(
    BuildContext context,
    InitializationSettings initializationSettings,
  ) async {
    await localNotification.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: (c) =>
          selectNotification(context, c.payload),
    );
  }

  @override
  Future showNotification(RemoteMessage payload) async {
    final Map<String, dynamic> data = payload.data;
    final RemoteNotification? notification = payload.notification;

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
          'pantoo',
          'Pantoo Notifikasi',
          importance: Importance.max,
          priority: Priority.high,
          ticker: 'ticker',
          color: AppColors.primary,
          sound: RawResourceAndroidNotificationSound('notification'),
        );

    await localNotification.show(
      id: payload.hashCode,
      title: notification?.title,
      body: notification?.body,
      notificationDetails: const NotificationDetails(
        android: androidPlatformChannelSpecifics,
      ),
      payload: data['type_notif'],
    );
  }

  @override
  Future<void> showLocalNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
          'pantoo',
          'Pantoo Notifikasi',
          importance: Importance.max,
          priority: Priority.high,
          ticker: 'ticker',
          color: AppColors.primary,
          playSound: true,
          sound: RawResourceAndroidNotificationSound('notification'),
        );

    await localNotification.show(
      id: id,
      title: title,
      body: body,
      notificationDetails: const NotificationDetails(
        android: androidPlatformChannelSpecifics,
      ),
      payload: payload,
    );
  }

  @override
  Future<void> selectNotification(BuildContext context, String? payload) async {
    final typeNotif = payload?.toNotification;
    AppUtility.routeNotification(context, typeNotif);
  }
}
