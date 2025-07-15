import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:matrimonal_app/utils/app_constants.dart';
import 'package:matrimonal_app/utils/preferences.dart';
import '../../register_module/model/registration_response.dart';
import '../model/login_model.dart';
import 'package:http/http.dart' as http;

class LoginService {
  Future<RegistrationResponse> loginUser(LoginModel model) async {
    final url = Uri.parse('http://matrimony.sqcreation.site/api/login');

    try {
      if (kDebugMode) {
        print('📤 Sending Login Request...');
        print('🔸 URL: $url');
        print('🔸 Body: ${model.toJson()}');
      }

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(model.toJson()),
      );

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
      if (data.status && data.token.isNotEmpty) {
        await Preferences.setString(AppConstants.token,data.token);
        if (kDebugMode) {
          print('✅ Token Saved');
        }
      }

      return data;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Login failed with error: $e');
      }
      rethrow;
    }
  }
}
