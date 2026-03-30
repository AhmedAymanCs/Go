import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:go/core/services/local_notification_service.dart';

class FCMService {
  final LocalNotificationService _localNotificationService;
  FCMService(this._localNotificationService);
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  Future<void> init() async {
    await firebaseMessaging.requestPermission();
    FirebaseMessaging.onBackgroundMessage(_handlerBackgroundMessage);
    _handlerForegroundMessage();
  }

  Future<String> getDeviceToken() async {
    final token = await firebaseMessaging.getToken();
    return token ?? '';
  }

  Future<void> _handlerBackgroundMessage(RemoteMessage message) async {}
  void _handlerForegroundMessage() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _localNotificationService.showNotification(message);
    });
  }
}
