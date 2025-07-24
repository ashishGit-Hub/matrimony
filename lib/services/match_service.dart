import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:matrimonial_app/utils/app_constants.dart';
import 'package:matrimonial_app/utils/preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  static Future<bool> sendInterestRequest({
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
  static Future<bool> sendInterest({
    required String token,
    required String userId,
  }) async {
    final url = Uri.parse("https://matrimony.sqcreation.site/api/interests/send/$userId");

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
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
        print("❌ Exception in sendInterest: $e");
      }
      return false;
    }
  }
  static Future<bool> sendNotInterested({
    required String token,
    required String userId,
  }) async {
    final url = Uri.parse("https://matrimony.sqcreation.site/api/interests/not/send/$userId");

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
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
        print("❌ Exception in sendNotInterested: $e");
      }
      return false;
    }
  }
  static const String _baseUrl = 'http://matrimony.sqcreation.site/api';

  static Future<List<MatchModel>> fetchSentInterests() async {
    final token = Preferences.getString(AppConstants.token, defaultValue: "");

    final response = await http.get(
      Uri.parse('$_baseUrl/interests/sent'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );
    if (kDebugMode) {
      print("🔽 Status Code: ${response.statusCode}");
      print("🔽 Body: ${response.body}");
    }

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List<dynamic> dataList = jsonData['data'] ?? [];

      // ✅ Only map 'receiver' into MatchModel
      final List<MatchModel> sentMatches = dataList.map<MatchModel>((item) {
        final receiverData = item['receiver'];
        return MatchModel.fromJson(receiverData);
      }).toList();

      return sentMatches;
    } else {
      throw Exception('Failed to load sent interests');
    }
  }
  static Future<List<MatchModel>> fetchReceivedInterests() async {
    final token = Preferences.getString(AppConstants.token, defaultValue: "");

    final response = await http.get(
      Uri.parse('$_baseUrl/interests/received'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (kDebugMode) {
      print("🔽 Received Interests API Status: ${response.statusCode}");
      print("🔽 Body: ${response.body}");
    }

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List<dynamic> dataList = jsonData['data'] ?? [];

      // ✅ Extract 'sender' from each item and map to MatchModel
      return dataList.map<MatchModel>((item) {
        return MatchModel.fromJson(item['sender']);
      }).toList();
    } else {
      throw Exception('Failed to load received interests');
    }
  }

  static const String baseUrl = 'http://matrimony.sqcreation.site/api';

  static Future<bool> acceptInterest(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final url = Uri.parse('$baseUrl/interests/accept/$id');
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    print('✅ Accept Status: ${response.statusCode}');
    print('✅ Accept Body: ${response.body}');

    return response.statusCode == 200;
  }

  static Future<bool> rejectInterest(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final url = Uri.parse('$baseUrl/interests/reject/$id');
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    print('❌ Reject Status: ${response.statusCode}');
    print('❌ Reject Body: ${response.body}');

    return response.statusCode == 200;
  }
  static Future<List<MatchModel>> fetchNotInterestedList(String token) async {
    final response = await http.get(
      Uri.parse('${AppConstants.baseUrl}/api/interests/not/list'),
      headers: {"Authorization": "Bearer $token"},
    );
    if (kDebugMode) {
      print("🔽 Received Interests API Status: ${response.statusCode}");
      print("🔽 Body: ${response.body}");
    }

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == true && data['data'] is List) {
        return (data['data'] as List)
            .map((e) => MatchModel.fromJson(e['not_interest_data']))
            .toList();
      }
    }

    return [];
  }
  static Future<bool> revokeNotInterested(String id) async {
    final url = Uri.parse('http://matrimony.sqcreation.site/api/interests/not/revoke/$id');

    final response = await http.post(url); // 👈 using POST

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['status'] == true;
    }
    return false;
  }


  }




