import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:matrimonial_app/core/constant/app_textstyle.dart';
import 'package:matrimonial_app/core/constant/color_constant.dart';
import 'package:matrimonial_app/core/firebase/firebase_notification_service.dart';
import 'package:matrimonial_app/features/home_module/view/home_screen.dart';
import 'package:matrimonial_app/features/register_module/view/register_screen.dart';
import 'package:matrimonial_app/providers/auth_provider.dart';
import 'package:matrimonial_app/utils/sharepref.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final TextEditingController numberController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isLoading = false;
  String? fcmToken;
  @override
  void initState() {
    super.initState();
    getFcmToken();
  }

  Future<void> getFcmToken() async {
    fcmToken = await FirebaseNotificationService().getFirebaseToken();
    log("Notification Token: $fcmToken");
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(builder: (context, authProvider,chile){
      return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40),
                    ),
                    child: Image.asset(
                      'assets/images/images1.png',
                      height: 416,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(30),
                        ),
                      ),
                      child: Text(
                        'Login to your Account',
                        style: AppTextStyle.semiBoldInterText(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Please enter MobileNumber',
                        style: AppTextStyle.regularInterText(
                          fontSize: 14,
                          color: ColorConstant.textfieldcolor,
                        )),
                    const SizedBox(height: 10),
                    TextField(
                      controller: numberController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text('Please enter Password',
                        style: AppTextStyle.regularInterText(
                          fontSize: 14,
                          color: ColorConstant.textfieldcolor,
                        )),
                    const SizedBox(height: 10),
                    TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),
                    ElevatedButton(
                      onPressed: () => login(authProvider),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorConstant.buttoncolor,
                        minimumSize: const Size(double.infinity, 48),
                      ),
                      child: Text(
                        _isLoading ? 'Logging in...' : 'Login',
                        style: AppTextStyle.regularInterText(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: RichText(
                  text: TextSpan(
                    text: "Don't have an account? ",
                    style: AppTextStyle.regularInterText(
                      color: ColorConstant.accountcolor,
                    ),
                    children: [
                      TextSpan(
                        text: "Sign Up",
                        style: AppTextStyle.regularInterText(
                          color: ColorConstant.signupcolor,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => RegisterScreen()),
                            );
                          },
                      ),
                      const TextSpan(text: " here."),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Future<void> login(AuthProvider authProvider) async {
    final mobile = numberController.text.trim();
    final password = passwordController.text.trim();

    if (mobile.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter mobile and password')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final response = await authProvider.userLogin(mobile, password, fcmToken);

      setState(() => _isLoading = false);

      if (response.status) {
        await SharedPrefs.saveToken(response.token ?? "");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => HomeScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.message)),
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed: $e')),
      );
    }
  }
}
