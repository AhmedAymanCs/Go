import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  final FlutterLocalNotificationsPlugin _notificationsPlugin;

  LocalNotificationService(this._notificationsPlugin);
  Future<void> init() async {
    const AndroidInitializationSettings android = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const InitializationSettings settings = InitializationSettings(
      android: android,
    );
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'Go Notification', // channel id
      'Trip Reminder', // channel name
      importance: Importance.max,
    );
    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);

    _notificationsPlugin.initialize(settings: settings);
  }

  Future<void> showNotification(RemoteMessage message) async {
    await _notificationsPlugin.show(
      id: 0,
      title: message.notification?.title ?? '',
      body: message.notification?.body ?? '',
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          'Go Notification', // channel id
          'Trip Reminder', // channel name
          icon: '@mipmap/ic_launcher',
          importance: Importance.max,
          priority: Priority.max,
        ),
      ),
    );
  }
}
