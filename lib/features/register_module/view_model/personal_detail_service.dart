
import 'dart:convert';
import 'package:http/http.dart' as http;
Future<bool> updateHeightWeight({
  required String height,
  required String weight,
  required String stateId,
  required String cityId,
  required String token,
}) async {
  final url = Uri.parse('https://matrimony.sqcreation.site/api/update-personal');

  print("🔐 Bearer Token: $token");

  final response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: jsonEncode({
      'height': height,
      'weight': weight,
      'state': stateId,
      'city': cityId,
    }),
  );

  print("🔽 Status Code: ${response.statusCode}");
  print("🔽 Response: ${response.body}");

  if (response.statusCode == 200) {
    final json = jsonDecode(response.body);
    return json['status'] == true;
  }

  return false;
}
