import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:matrimonial_app/utils/app_constants.dart';
import 'package:matrimonial_app/utils/preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../features/login_module/model/login_model.dart';
import '../features/register_module/model/register_model.dart';
import '../features/register_module/model/registration_response.dart';
import 'package:http/http.dart' as http;


class AuthService {

  Future<RegistrationResponse> loginUser(String mobile, String password, String? fcmToken) async {
    final url = Uri.parse(AppConstants.apiBaseUrl+AppConstants.login);
    final body = {
      'mobile': mobile,
      'password': password,
      'fcm_token': fcmToken,
    };

    try {
      if (kDebugMode) {
        print('📤 Sending Login Request...');
        print('🔸 URL: $url');
        print('🔸 Body: $body');
      }

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );
      final prefs = await SharedPreferences.getInstance();
      final user = jsonDecode(response.body)['user'];
      await prefs.setString('user_id', user['dummyid']); // save dummyid as string
      print('✅ Saved user_id (dummyid): ${user['dummyid']}');


      if (kDebugMode) {
        print('📥 Received Response');
        print('🔹 Status Code: ${response.statusCode}');
        print('🔹 Body: ${response.body}');
      }

      // Handle non-200 status codes gracefully
      if (response.statusCode != 200) {
        throw Exception('❌ Server returned status ${response.statusCode}');
      }

      final json = jsonDecode(response.body);

      // Safety check to ensure API returned expected data
      if (!json.containsKey('status')) {
        throw Exception('❌ Unexpected response structure: $json');
      }

      final data = RegistrationResponse.fromJson(json);
      if (data.status && data.token?.isNotEmpty == true) {
        await Preferences.setString(AppConstants.token,data.token!);
        if (kDebugMode) {
          print('✅ Token Saved');
        }
      }
      return data;
    } catch (e) {
      if (kDebugMode) {
        log('❌ Login failed with error: $e');
      }
      return RegistrationResponse(status: false, message: "something went wrong",token: null, user: null);

    }
  }

  Future<RegistrationResponse>  registerUser(RegisterModel model) async {
    final url = Uri.parse(AppConstants.apiBaseUrl+AppConstants.register);

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(model.toJson()),
      );

      if(kDebugMode){
        log('🔼 Register Sent: ${model.toJson()}');
        log('🔽 Status Code: ${response.statusCode}');
        log('🔽 Response: ${response.body}');
      }

      final json = jsonDecode(response.body);
      final data = RegistrationResponse.fromJson(json);

      if (data.status) {
        await Preferences.setString(AppConstants.token,data.token!); // ✅ Save token using your utility
      }

      return data;
    } catch (e) {
      if(kDebugMode){
        log('❌ Registration failed: $e');
      }
      return RegistrationResponse(status: false, message: "Something went wrong",token: null, user: null);
    }
  }

}