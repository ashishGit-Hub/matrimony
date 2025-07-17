import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:matrimonial_app/utils/app_constants.dart';
import 'package:matrimonial_app/utils/preferences.dart';

import '../features/match_module/model/match_model.dart';

class MatchService {

  Future<MatchResponse?> fetchMatches({
    required String stateId,
    required String cityId,
    String? ageMin,
    String? ageMax,
  }) async {
    try {
      var token = Preferences.getString(AppConstants.token, defaultValue: "");
      final uri =
          Uri.parse('${AppConstants.apiBaseUrl}${AppConstants.getMatches}');

      final headers = <String, String>{
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      };

      if (kDebugMode) {
        log("🔼 Requesting: $uri");
        log("🔐 Headers: $headers");
      }

      final response = await http.get(uri, headers: headers);

      if (kDebugMode) {
        print("🔽 Status Code: ${response.statusCode}");
        print("🔽 Body: ${response.body}");
      }

      if (response.statusCode == 200) {
        final jsonMap = json.decode(response.body);
        return MatchResponse.fromJson(jsonMap);
      } else {
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        log("❌ Exception in fetchMatches: $e");
      }
      return null;
    }
  }

  static Future<bool> updateLikeUser({
    required String token,
    required String likedId,
  }) async {
    final url =
        Uri.parse("https://matrimony.sqcreation.site/api/update/like-user");

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'liked_id': likedId, // ✅ MUST be 'liked_id'
        }),
      );

      if (kDebugMode) {
        print("🔽 Status Code: ${response.statusCode}");
        print("🔽 Body: ${response.body}");
      }

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['status'] == true;
      } else {
        return false;
      }
    } catch (e) {
      if (kDebugMode) {
        print("❌ Exception: $e");
      }
      return false;
    }
  }

  static Future<MatchModel?> getProfileDetails(
      String userId, String token) async {
    final url = Uri.parse(
        "https://matrimony.sqcreation.site/api/get/matches/details/$userId");

    try {
      final response = await http.get(url, headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      });

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        if (body['status'] == true && body['data'] != null) {
          return MatchModel.fromJson(body['data']);
        }
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print("❌ Error fetching profile: $e");
      }
      return null;
    }
  }
}
