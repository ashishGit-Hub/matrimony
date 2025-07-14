import 'dart:convert';
import 'package:http/http.dart' as http;

class ChangePasswordService {
  static Future<Map<String, dynamic>> changePassword({
    required String token,
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    final url = Uri.parse('https://matrimony.sqcreation.site/api/change-password');

    final body = jsonEncode({
      'current_password': currentPassword,
      'new_password': newPassword,
      'new_password_confirmation': confirmPassword,
    });

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: body,
    );


    print('🔐 Bearer Token: $token');
    print('🔼 Sent: $body');
    print('🔽 Status Code: ${response.statusCode}');
    print('🔽 Response: ${response.body}');

    return jsonDecode(response.body);
  }
}
