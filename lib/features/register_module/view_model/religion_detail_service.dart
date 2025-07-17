import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:matrimonial_app/utils/sharepref.dart';
import '../model/religion_model.dart';

Future<List<Religion>> fetchReligions() async {
  final response = await http.get(
    Uri.parse('https://matrimony.sqcreation.site/api/get/religion/list'),
  );
  final jsonData = jsonDecode(response.body);

  if (response.statusCode == 200 && jsonData['status'] == true) {
    final List list = jsonData['data'];
    return list.map((item) => Religion.fromJson(item)).toList();
  } else {
    throw Exception('Failed to load religions');
  }
}

Future<List<Caste>> fetchCastes(int religionId) async {
  final url = Uri.parse('https://matrimony.sqcreation.site/api/get/caste/list/$religionId');
  final response = await http.get(url);
  final jsonData = jsonDecode(response.body);

  if (response.statusCode == 200 && jsonData['status'] == true) {
    final List list = jsonData['data'];
    return list.map((item) => Caste.fromJson(item)).toList();
  } else {
    throw Exception('Failed to load castes');
  }
}
Future<bool> updateReligionDetails({
  required int religionId,
  required int casteId, required String token,
}) async {
  final token = await SharedPrefs.getToken(); // ✅ correct key

  if (token == null || token.isEmpty) {
    print("❌ Token not found!");
    return false;
  }

  final url = Uri.parse('http://matrimony.sqcreation.site/api/update-religion');

  final response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: jsonEncode({
      'religion': religionId,
      'caste': casteId,
    }),
  );

  print("🔁 Status: ${response.statusCode}");
  print("🔁 Body: ${response.body}");

  if (response.statusCode == 200) {
    final json = jsonDecode(response.body);
    return json['status'] == true;
  } else {
    return false;
  }
}
