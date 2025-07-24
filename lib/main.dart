import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:matrimonial_app/core/firebase/firebase_notification_service.dart';
import 'package:matrimonial_app/firebase_options.dart';
import 'package:matrimonial_app/providers/auth_provider.dart';
import 'package:matrimonial_app/providers/chat_provider.dart';
import 'package:matrimonial_app/providers/match_provider.dart';
import 'package:matrimonial_app/providers/user_provider.dart';
import 'package:matrimonial_app/splash_screen.dart';
import 'package:matrimonial_app/utils/preferences.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Preferences.initPref();
  await Permission.notification.isDenied.then((value) {
    if (value) {
      Permission.notification.request();
    }
  });
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  await FirebaseNotificationService().initNotification();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<AuthProvider>(create: (context) => AuthProvider()),
          ChangeNotifierProvider<MatchProvider>(create: (context) => MatchProvider()),
          ChangeNotifierProvider<UserProvider>(create: (context) => UserProvider()),
          ChangeNotifierProvider(create: (_) => ChatProvider()),
        ],
        child: MaterialApp(
          home: SplashScreen(),
          debugShowCheckedModeBanner: false,
        ));
  }
}
