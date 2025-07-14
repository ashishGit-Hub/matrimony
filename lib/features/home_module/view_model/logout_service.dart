import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:matrimonal_app/services/sharepref.dart';

class LogoutService {
  static Future<Map<String, dynamic>> logoutUser() async {
    const String url = 'http://matrimony.sqcreation.site/api/logout';

    try {
      final token = await SharedPrefs.getToken();
      if (token == null || token.isEmpty) {
        throw Exception("Token not found in SharedPreferences");
      }

      final rawToken = token.replaceAll('Bearer ', ''); // ✅ Remove double Bearer

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $rawToken',
        },
      );

      print('🔐 Sending Token: Bearer $rawToken');
      print('🔽 Status Code: ${response.statusCode}');
      print('🔽 Response: ${response.body}');

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
