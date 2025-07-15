import 'dart:convert';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:matrimonal_app/features/register_module/model/registration_response.dart';
import 'package:matrimonal_app/utils/app_constants.dart';
import 'package:matrimonal_app/utils/preferences.dart';
import 'package:matrimonal_app/utils/sharepref.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  static Future<User?> fetchUserDetails() async {
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
        log("Headers: ${response.body}");
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
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('dummyid', user['dummyid'] ?? '');
    await prefs.setString('name', user['name'] ?? '');
    await prefs.setString('email', user['email'] ?? '');
    await prefs.setString('mobile', user['mobile'] ?? '');
    await prefs.setString('age', user['age'] ?? '');
    await prefs.setString('dob', user['dob'] ?? '');
    await prefs.setString('height', user['height'] ?? '');
    await prefs.setString('weight', user['weight'] ?? '');
    await prefs.setString('myself', user['myself'] ?? '');
    await prefs.setString('gender', user['gender'] ?? '');
    await prefs.setString('image', user['images'] ?? '');

    // Nested fields
    await prefs.setString('profileFor', user['profileFor']?['name'] ?? '');
    await prefs.setString('education', user['education']?['name'] ?? '');
    await prefs.setString('occupation', user['occupation']?['name'] ?? '');
    await prefs.setString('income', user['annualIncome']?['range'] ?? '');
    await prefs.setString('jobType', user['jobType']?['name'] ?? '');
    await prefs.setString('companyType', user['companyType']?['name'] ?? '');
    await prefs.setString('religion', user['relegion']?['name'] ?? '');
    await prefs.setString('caste', user['caste']?['name'] ?? '');
  }
}
