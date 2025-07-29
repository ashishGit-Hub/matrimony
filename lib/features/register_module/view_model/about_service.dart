import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:matrimonial_app/utils/app_constants.dart';
import 'package:matrimonial_app/utils/preferences.dart';
import 'package:path/path.dart';

class AboutService {
  static const String baseUrl = 'https://matrimony.sqcreation.site/api';

  static Future<Map<String,dynamic>> updateAbout({
    required String myself,
    File? imageFile,
  }) async {
    final token = Preferences.getString(AppConstants.token, defaultValue: "");
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

      if (kDebugMode) {
        log("📤 Status Code: ${response.statusCode}");
        log("📤 Response: ${response.body}");
      }


      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return {
          "status": json['status'],
          "message": json['message']
        };
      } else {
        if(kDebugMode){
          print("❌ Server Error: ${response.body}");
        }
        final json = jsonDecode(response.body);
        return {
          "status": json['status'],
          "message": json['message'] ?? json['errors']['myself'][0]
        };
      }
    } catch (e) {
      if(kDebugMode){
        log("❌ Exception: $e");
      }
      return {
        "status": false,
        "message": e
      };
    }
  }
}
