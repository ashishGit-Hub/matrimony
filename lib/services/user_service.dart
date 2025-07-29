import 'dart:convert';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:matrimonial_app/core/models/ApiResponse.dart';
import 'package:matrimonial_app/features/register_module/model/registration_response.dart';
import 'package:matrimonial_app/utils/app_constants.dart';
import 'package:matrimonial_app/utils/preferences.dart';

class UserService {

  Future<User?> getUserDetails() async {
    final token = Preferences.getString(AppConstants.token, defaultValue: '');
    final url = Uri.parse('${AppConstants.apiBaseUrl}${AppConstants.getUser}');

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if(kDebugMode){
        log('API Url: $url');
        log("Response Body: ${response.body}");
      }

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final userJson = jsonData['user'];
        final user = User.fromJson(userJson);

        // ✅ Store data locally
        await _storeUserLocally(userJson);

        return user;
      } else {
        if (kDebugMode) {
          print('❌ Error: ${response.statusCode}');
        }
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Exception: $e');
      }
      return null;
    }
  }

  // ✅ Correctly placed inside class as a private static method
  static Future<void> _storeUserLocally(Map<String, dynamic> user) async {

    Preferences.setString('dummyid', user['dummyid'] ?? '');
    Preferences.setString('name', user['name'] ?? '');
    Preferences.setString('email', user['email'] ?? '');
    Preferences.setString('mobile', user['mobile'] ?? '');
    Preferences.setString('age', user['age'] ?? '');
    Preferences.setString('dob', user['dob'].toString() ?? '');
    Preferences.setString('height', user['height'] ?? '');
    Preferences.setString('weight', user['weight'] ?? '');
    Preferences.setString('myself', user['myself'] ?? '');
    Preferences.setString('gender', user['gender'] ?? '');
    Preferences.setString('image', user['images'] ?? '');


    Preferences.setString('state', jsonEncode(user['state']['name'] ?? "").toString());
    Preferences.setString('city', jsonEncode(user['city']['name'] ?? "").toString());

    // Nested fields
    Preferences.setString('profileFor', user['profileFor']?['name'] ?? '');
    Preferences.setString('education', user['education']?['name'] ?? '');
    Preferences.setString('occupation', user['occupation']?['name'] ?? '');
    Preferences.setString('income', user['annualIncome']?['range'] ?? '');
    Preferences.setString('jobType', user['jobType']?['name'] ?? '');
    Preferences.setString('companyType', user['companyType']?['name'] ?? '');
    Preferences.setString('religion', user['relegion']?['name'] ?? '');
    Preferences.setString('caste', user['caste']?['name'] ?? '');
  }


  Future<ApiResponse> uploadMultipleImage(List<XFile> images)async {

    final token = Preferences.getString(AppConstants.token, defaultValue: "");
    final uri = Uri.parse(AppConstants.apiBaseUrl+AppConstants.updateGallery);
    var request = http.MultipartRequest("POST", uri);

    if(kDebugMode){
      log("📤 Uploading to: ${uri.toString()}");
    }
    request.headers['Authorization'] = 'Bearer $token';
    request.headers['Accept'] = 'application/json';

    for (var image in images) {
      request.files.add(await http.MultipartFile.fromPath('images[]', image.path));
    }

    log("${request.files.first.filename}");
    log("${request.files.first.length}");
    log("${request.files.first.contentType}");
    log("${request.files.first.field}");

    try {
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if(kDebugMode){
        log("📥 Status Code: ${response.statusCode}");
        log("📥 Response Body: ${response.body}");
      }

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if(kDebugMode){
          log("✅ Upload Status: ${jsonResponse['status']}");
          log("✅ Message: ${jsonResponse['message']}");
        }
        if (jsonResponse['status'] != true) {
          return ApiResponse(status: false, message: "something went wrong");
        }
        return ApiResponse(status: true, message: "Images Upload Successfully");
      } else {
        return ApiResponse(status: false, message: "something went wrong");
      }
    } catch (e) {
      return ApiResponse(status: false, message: "something went wrong");
    }
  }
}
