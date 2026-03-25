import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:go/core/di/service_locator.dart';
import 'package:go/core/services/local_notification_service.dart';

class FCMService {
  static FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  static Future<void> init() async {
    await firebaseMessaging.requestPermission();
    FirebaseMessaging.onBackgroundMessage(_handlerBackgroundMessage);
    _handlerForegroundMessage();
  }

  static Future<String> getDeviceToken() async {
    final token = await firebaseMessaging.getToken();
    return token ?? '';
  }

  static Future<void> _handlerBackgroundMessage(RemoteMessage message) async {}
  static void _handlerForegroundMessage() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      getIt<LocalNotificationService>().showNotification(message);
    });
  }
}
