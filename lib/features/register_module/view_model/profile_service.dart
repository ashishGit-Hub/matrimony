import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:matrimonial_app/models/user_model.dart';

class ProfileForService {
  Future<List<ProfileFor>> fetchProfileOptions() async {
    final url = Uri.parse('http://matrimony.sqcreation.site/api/get/profilefor/list');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonBody = jsonDecode(response.body);

      if (jsonBody['status'] == true && jsonBody['data'] != null) {
        final List data = jsonBody['data'];
        return data.map((e) => ProfileFor.fromJson(e)).toList();
      } else {
        throw Exception(jsonBody['message'] ?? 'Unknown error');
      }
    } else {
      throw Exception('Failed to fetch profile options');
    }
  }
}
