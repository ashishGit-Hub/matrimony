import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:matrimonial_app/features/register_module/model/registration_response.dart';


import '../../../utils/sharepref.dart';

class BasicDetailService {
  Future<RegistrationResponse> submitBasicDetails({
    required String age,
    required String dob,
    required String email,
    required String gender,
  }) async {
    final url = Uri.parse('http://matrimony.sqcreation.site/api/update-basic');

    final token = await SharedPrefs.getToken();
    if (token == null || token.isEmpty) {
      throw Exception("Token not found in SharedPreferences");
    }

    final body = {
      'age': age,
      'dob': dob,
      'email': email,
      'gender': gender,
    };

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // ✅ fixed: added Bearer
      },
      body: jsonEncode(body),
    );

    print('🔐 Bearer Token: $token');
    print('🔼 Sent: $body');
    print('🔽 Status Code: ${response.statusCode}');
    print('🔽 Response: ${response.body}');

    final json = jsonDecode(response.body);
    return RegistrationResponse.fromJson(json);
  }
}
