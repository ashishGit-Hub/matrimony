import 'dart:developer';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseNotificationService{

  final _firebaseMessage =  FirebaseMessaging.instance;
  final _localNotifications = FlutterLocalNotificationsPlugin();


  Future<void> initNotification() async{
    await _firebaseMessage.requestPermission();

    _firebaseMessage.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true
    );

  }

  Future<String?> getFirebaseToken() async {
    return await _firebaseMessage.getToken();
  }


}