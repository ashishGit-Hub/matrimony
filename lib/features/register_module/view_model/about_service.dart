import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:matrimonial_app/utils/sharepref.dart';
import 'package:path/path.dart';

class AboutService {
  static const String baseUrl = 'https://matrimony.sqcreation.site/api';

  static Future<bool> updateAbout({
    required String myself,
    File? imageFile,
  }) async {
    final token = await SharedPrefs.getToken();
    final uri = Uri.parse('$baseUrl/update-about');

    var request = http.MultipartRequest('POST', uri)
      ..headers['Authorization'] = 'Bearer $token'
      ..fields['myself'] = myself;

    if (imageFile != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'images',
        imageFile.path,
        filename: basename(imageFile.path),
      ));
    }

    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      print("📤 Status Code: ${response.statusCode}");
      print("📤 Response: ${response.body}");

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return json['status'] == true;
      } else {
        print("❌ Server Error: ${response.body}");
        return false;
      }
    } catch (e) {
      print("❌ Exception: $e");
      return false;
    }
  }
}
