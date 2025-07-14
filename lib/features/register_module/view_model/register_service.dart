import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:matrimonal_app/features/register_module/model/register_model.dart';
import 'package:matrimonal_app/features/register_module/model/registration_response.dart';
import 'package:matrimonal_app/utils/sharepref.dart'; // ✅ Use your SharedPrefs utility

class RegisterService {
  Future<RegistrationResponse> registerUser(RegisterModel model) async {
    final url = Uri.parse('http://matrimony.sqcreation.site/api/register');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(model.toJson()),
      );

      print('🔼 Register Sent: ${model.toJson()}');
      print('🔽 Status Code: ${response.statusCode}');
      print('🔽 Response: ${response.body}');

      final json = jsonDecode(response.body);
      final data = RegistrationResponse.fromJson(json);

      if (data.status && data.token != null) {
        await SharedPrefs.saveToken(data.token!); // ✅ Save token using your utility
      }

      return data;
    } catch (e) {
      print('❌ Registration failed: $e');
      rethrow;
    }
  }
}
