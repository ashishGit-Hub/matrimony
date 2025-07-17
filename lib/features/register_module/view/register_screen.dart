import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:matrimonial_app/core/constant/app_textstyle.dart';
import 'package:matrimonial_app/core/constant/color_constant.dart';
import 'package:matrimonial_app/features/login_module/view/login_screen.dart';
import 'package:matrimonial_app/features/register_module/model/register_model.dart';
import 'package:matrimonial_app/features/register_module/view/basic_detils_screen.dart';
import 'package:matrimonial_app/features/register_module/view_model/profile_service.dart';
import 'package:matrimonial_app/features/register_module/view_model/register_service.dart';
import 'package:matrimonial_app/providers/auth_provider.dart';
import 'package:matrimonial_app/utils/app_constants.dart';
import 'package:matrimonial_app/utils/preferences.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/registration_response.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  List<ProfileFor> profileOptions = [];
  ProfileFor? selectedProfile;

  @override
  void initState() {
    super.initState();
    _loadProfileOptions();
  }

  Future<void> _loadProfileOptions() async {
    try {
      final options = await ProfileForService().fetchProfileOptions();
      setState(() {
        profileOptions = options;
        selectedProfile = options.isNotEmpty ? options[0] : null;
      });
    } catch (e) {
      if (kDebugMode) {
        print('❌ Failed to load profile options: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(builder: (context, counter, child){
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
                        borderRadius:
                        BorderRadius.vertical(top: Radius.circular(30)),
                      ),
                      child: const Text(
                        'Register For Free',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  )
                ],
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    _buildLabel('Select a Profile for'),
                    DropdownButtonFormField<ProfileFor>(
                      value: selectedProfile,
                      decoration:
                      const InputDecoration(border: OutlineInputBorder()),
                      items: profileOptions.map((profile) {
                        return DropdownMenuItem(
                          value: profile,
                          child: Text(profile.name),
                        );
                      }).toList(),
                      onChanged: (value) =>
                          setState(() => selectedProfile = value),
                    ),
                    const SizedBox(height: 20),
                    _buildLabel('Full Name'),
                    _buildTextField(controller: fullNameController),
                    const SizedBox(height: 20),
                    _buildLabel('Mobile Number'),
                    _buildTextField(
                        controller: mobileController,
                        keyboardType: TextInputType.phone),
                    const SizedBox(height: 20),
                    _buildLabel('Create Password'),
                    _buildTextField(
                        controller: passwordController, obscureText: true),
                    const SizedBox(height: 25),
                    ElevatedButton(
                      onPressed: _handleRegister,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        minimumSize: const Size(double.infinity, 48),
                      ),
                      child: const Text('Register Now',
                          style: TextStyle(color: Colors.white70)),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: RichText(
                  text: TextSpan(
                    text: "Already a member? ",
                    style: AppTextStyle.regularInterText(
                        color: ColorConstant.accountcolor),
                    children: [
                      TextSpan(
                        text: "Login",
                        style: AppTextStyle.regularInterText(
                            color: ColorConstant.signupcolor),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => LoginScreen()),
                          ),
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

  Widget _buildLabel(String text) {
    return Row(
      children: [
        Text(
          text,
          style: AppTextStyle.regularInterText(
              fontSize: 14, color: ColorConstant.textfieldcolor),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      decoration: const InputDecoration(border: OutlineInputBorder()),
    );
  }

  Future<void> _handleRegister() async {
    final fullName = fullNameController.text.trim();
    final mobile = mobileController.text.trim();
    final password = passwordController.text.trim();

    if (fullName.isEmpty ||
        mobile.isEmpty ||
        password.isEmpty ||
        selectedProfile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    if (mobile.length != 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter valid 10-digit mobile number')),
      );
      return;
    }
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final model = RegisterModel(
        name: fullName,
        mobile: mobile,
        password: password,
        passwordConfirmation: password,
        profileFor: selectedProfile!.ptid.toString(),
      );

      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      final response = await authProvider.registerUser(model);
      Navigator.pop(context);

      if (response.status) {
        // Set Current Step
        Preferences.setString(AppConstants.registrationStep, "Second");
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => BasicDetailsScreen(isRegisteredScreen: true)));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(response.message)));
      }
    } catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Registration failed: $e')));
    }
  }
}
