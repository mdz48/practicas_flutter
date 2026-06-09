import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'firebase_options.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (_) {}
}

class NotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    try {
      if (!kIsWeb) {
        FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
      }

      await _firebaseMessaging.requestPermission();

      final token = await _firebaseMessaging.getToken();
      print('FCM Token: $token');

      await subscribeToTopic('general');

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        if (message.notification != null) {
          print(message.notification?.title);
          print(message.notification?.body);
        }
      });

      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        print(message.data);
      });

      final initialMessage = await _firebaseMessaging.getInitialMessage();
      if (initialMessage != null) {
        print(initialMessage.data);
      }
    } catch (e) {
      print('Error initializing notifications: $e');
    }
  }

  Future<void> subscribeToTopic(String topic) async {
    try {
      await _firebaseMessaging.subscribeToTopic(topic);
    } catch (e) {
      print('Error subscribing to topic: $e');
    }
  }

  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _firebaseMessaging.unsubscribeFromTopic(topic);
    } catch (e) {
      print('Error unsubscribing from topic: $e');
    }
  }
}
