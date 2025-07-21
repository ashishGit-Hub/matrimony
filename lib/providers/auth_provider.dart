
import 'package:flutter/material.dart';

import '../features/register_module/model/register_model.dart';
import '../features/register_module/model/registration_response.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier{
  final AuthService _authService = AuthService();

  Future<RegistrationResponse> userLogin(String mobile, String password, String? fcmToken) async {

    var response = await _authService.loginUser(mobile, password, fcmToken);
    return response;
  }

  Future<RegistrationResponse> registerUser(RegisterModel model) async {

    var response = await _authService.registerUser(model);

    return response;

  }




}