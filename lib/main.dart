import 'package:flutter/material.dart';
import 'package:matrimonial_app/providers/auth_provider.dart';
import 'package:matrimonial_app/providers/match_provider.dart';
import 'package:matrimonial_app/providers/user_provider.dart';
import 'package:matrimonial_app/services/auth_service.dart';
import 'package:matrimonial_app/services/match_service.dart';
import 'package:matrimonial_app/services/user_service.dart';
import 'package:matrimonial_app/splash_screen.dart';
import 'package:matrimonial_app/utils/preferences.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Preferences.initPref();
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
          ChangeNotifierProvider<UserProvider>(create: (context) => UserProvider())
        ],
        child: MaterialApp(
          home: SplashScreen(),
          debugShowCheckedModeBanner: false,
        ));
  }
}
