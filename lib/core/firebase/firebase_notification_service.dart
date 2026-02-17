import 'dart:developer';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseNotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();


  Future<void> initNotification() async {
    await _firebaseMessaging.requestPermission();

    _firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    await _initLocalNotifications();
    _setupFirebaseMessageHandlers();
  }

  Future<String?> getFirebaseToken() async {
    return await _firebaseMessaging.getToken();
  }

  Future<void> _initLocalNotifications() async {
    const AndroidInitializationSettings androidSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
    );

    await _localNotifications.initialize(settings: initSettings);
  }

  void _setupFirebaseMessageHandlers() {
    // Foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log("📲 Foreground message: ${message.notification?.title}");
      _showLocalNotification(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      log("📥 App opened from background: ${message.notification?.title}");
    });

    // Terminated
    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        log("🔄 App opened from terminated state");
      }
    });
  }

  void _showLocalNotification(RemoteMessage message) {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'channel_id',
      'General Notifications',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
    );

    _localNotifications.show(
      id:0,
      title: message.notification?.title ?? 'No Title',
      body: message.notification?.body ?? 'No Body',
      notificationDetails: notificationDetails,
    );
  }
}
