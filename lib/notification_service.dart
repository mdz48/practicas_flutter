import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'firebase_options.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart'; // Importamos la llave global

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    
    if (message.data['action'] == 'delete') {
      final prefs = await SharedPreferences.getInstance();
      await prefs.reload();
      await prefs.remove('hashed_nombre');
      await prefs.remove('hashed_apellido');
      await prefs.remove('hashed_ciudad');
      await prefs.remove('hashed_telefono');
      await prefs.clear();
    }
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
      // print('FCM Token: $token');

      await subscribeToTopic('general');
      await subscribeToTopic('delete');

      FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
        if (message.data['action'] == 'delete') {
          final prefs = await SharedPreferences.getInstance();
          await prefs.reload();

          await prefs.remove('hashed_nombre');
          await prefs.remove('hashed_apellido');
          await prefs.remove('hashed_ciudad');
          await prefs.remove('hashed_telefono');
          await prefs.clear();

          await prefs.reload();

          scaffoldMessengerKey.currentState?.showSnackBar(
            SnackBar(
              content: Text(prefs.getKeys().isEmpty
                  ? 'Datos locales borrados correctamente.'
                  : 'Advertencia: no se pudieron borrar todos los datos.'),
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 5),
              backgroundColor: prefs.getKeys().isEmpty ? Colors.redAccent : Colors.orange,
            ),
          );
        } else if (message.notification != null) {
          final title = message.notification?.title ?? 'Notificación';
          final body = message.notification?.body ?? '';
          
          scaffoldMessengerKey.currentState?.showSnackBar(
            SnackBar(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text(body),
                ],
              ),
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 5),
              backgroundColor: Colors.blueAccent,
            ),
          );
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
