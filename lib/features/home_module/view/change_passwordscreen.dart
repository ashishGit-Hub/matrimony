import 'package:flutter/material.dart';
import 'package:matrimonial_app/features/home_module/view_model/change_password_service.dart';
import 'package:matrimonial_app/utils/sharepref.dart';

import '../../../utils/app_constants.dart';
import '../../../utils/preferences.dart'; // your token service

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;
  bool _isLoading = false;

  Future<void> _submitChange() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final token = Preferences.getString(AppConstants.token, defaultValue: "");

    if (token.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("User is not logged in")),
      );
      setState(() => _isLoading = false);
      return;
    }

    final response = await ChangePasswordService.changePassword(
      token: token,
      currentPassword: _currentPasswordController.text,
      newPassword: _newPasswordController.text,
      confirmPassword: _confirmPasswordController.text,
    );

    setState(() => _isLoading = false);

    if (response['status'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response['message'] ?? 'Password changed!')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response['message'] ?? 'Something went wrong')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Change Password"), backgroundColor: Colors.orange),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Current password
              TextFormField(
                controller: _currentPasswordController,
                obscureText: _obscureCurrent,
                decoration: InputDecoration(
                  labelText: "Current Password",
                  suffixIcon: IconButton(
                    icon: Icon(_obscureCurrent ? Icons.visibility : Icons.visibility_off),
                    onPressed: () => setState(() => _obscureCurrent = !_obscureCurrent),
                  ),
                  border: const OutlineInputBorder(),
                ),
                validator: (value) =>
                value == null || value.isEmpty ? 'Enter current password' : null,
              ),
              const SizedBox(height: 16),

              // New password
              TextFormField(
                controller: _newPasswordController,
                obscureText: _obscureNew,
                decoration: InputDecoration(
                  labelText: "New Password",
                  suffixIcon: IconButton(
                    icon: Icon(_obscureNew ? Icons.visibility : Icons.visibility_off),
                    onPressed: () => setState(() => _obscureNew = !_obscureNew),
                  ),
                  border: const OutlineInputBorder(),
                ),
                validator: (value) =>
                value == null || value.length < 6 ? 'Minimum 6 characters required' : null,
              ),
              const SizedBox(height: 16),

              // Confirm password
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: _obscureConfirm,
                decoration: InputDecoration(
                  labelText: "Confirm New Password",
                  suffixIcon: IconButton(
                    icon: Icon(_obscureConfirm ? Icons.visibility : Icons.visibility_off),
                    onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
                  ),
                  border: const OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value != _newPasswordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submitChange,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: Colors.orange,
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Change Password"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
