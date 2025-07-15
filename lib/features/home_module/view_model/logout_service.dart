import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:matrimonal_app/utils/app_constants.dart';
import 'package:matrimonal_app/utils/preferences.dart';
import 'package:matrimonal_app/utils/sharepref.dart';

class LogoutService {
  static Future<Map<String, dynamic>> logoutUser() async {
    const String url = 'http://matrimony.sqcreation.site/api/logout';

    try {
      final token = Preferences.getString(AppConstants.token, defaultValue: "");
      if (token.isEmpty) {
        throw Exception("Token not found in SharedPreferences");
      }


      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if(kDebugMode){
        print('🔐 Sending Token: $token');
        print('🔽 Status Code: ${response.statusCode}');
        print('🔽 Response: ${response.body}');
      }

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'status': data['status'] == true,
          'message': data['message'] ?? 'Logged out successfully',
        };
      } else {
        return {
          'status': false,
          'message': 'Logout failed: ${response.statusCode}',
        };
      }
    } catch (e) {
      return {
        'status': false,
        'message': 'Something went wrong: $e',
      };
    }
  }
}
