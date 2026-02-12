import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:matrimonial_app/core/models/ApiResponse.dart';
import 'package:matrimonial_app/models/not_interest.dart';
import 'package:matrimonial_app/models/receive_match.dart';
import 'package:matrimonial_app/models/send_request_model.dart';
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
    required String userId,
  }) async {
    final token = Preferences.getToken();
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


  /// Get Send Requests
  Future<List<SentRequestModel>> fetchSentInterests() async {
    final token = Preferences.getString(AppConstants.token, defaultValue: "");

    final response = await http.get(
      Uri.parse('$_baseUrl/interests/sent'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );
    if (kDebugMode) {
      log("🔽 Status Code: ${response.statusCode}");
      log("🔽 Body: ${response.body}");
    }

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List<dynamic> dataList = jsonData['data'];
      return dataList.map((item) => SentRequestModel.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load sent interests');
    }
  }

  // Get Received Requests
  static Future<List<ReceiveInterest>> fetchReceivedInterests() async {
    final token = Preferences.getString(AppConstants.token, defaultValue: "");
    if(kDebugMode){
      log("Call Received Match API with token: $token");
    }

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


      return dataList.map<ReceiveInterest>((item) {
        return ReceiveInterest.fromJson(item);
      }).toList();
    } else {
      throw Exception('Failed to load received interests');
    }
  }

  static const String baseUrl = 'http://matrimony.sqcreation.site/api';

  static Future<bool> acceptInterest(String id) async {
    final token = Preferences.getString(AppConstants.token);

    final url = Uri.parse('$baseUrl/interests/accept/$id');
    log("URL $url");
    log('interest $id');
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
    final token = Preferences.getToken();

    final url = Uri.parse('$baseUrl/interests/reject/$id');
    final headers = {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    };

    final response = await http.post(url, headers: headers);

    if (kDebugMode) {
      print('Headers : $headers');
      print('Reject Status: ${response.statusCode}');
      print('Reject Body: ${response.body}');
    }

    return response.statusCode == 200;
  }

  static Future<List<NotInterest>> fetchNotInterestedList() async {

    var token = Preferences.getString(AppConstants.token, defaultValue: "");

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
            .map((e) => NotInterest.fromJson(e))
            .toList();
      }
    }

    return [];
  }

  static Future<bool> revokeNotInterested(String id) async {

    var token = Preferences.getToken();

    final url = Uri.parse('${AppConstants.apiBaseUrl}/interests/not/revoke/$id');

    final response = await http.post(url,headers: {
      "Authorization":"Bearer $token"
    });

    if(kDebugMode){
      log("🔽 API URL: $url");
      log("🔽 Revoke Not Interested API Status: ${response.statusCode}");
      log("🔽 Body: ${response.body}");
    }

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['status'] == true;
    }
    return false;
  }

  Future<ApiResponse> revokeInterestRequest(String requestId) async{
    try{
      var url = Uri.parse("${AppConstants.revokeInterestRequest}$requestId");
      var response = await http.post(url,headers: {
        "Authorization": "Bearer ${Preferences.getToken()}"
      });

      if(kDebugMode){
        log("API Url: $url");
        log("API Headers: Authorization: Bearer ${Preferences.getToken()}");
        log("Response Status: ${response.statusCode}");
        log("Response Body: ${response.body}");

      }

      if(response.statusCode == 200){
        return ApiResponse(status: true, message: jsonDecode(response.body)['message']);
      }

      return ApiResponse(status: false, message: jsonDecode(response.body)['message']);

    }catch(e){
      return ApiResponse(status: false, message: e.toString());
    }
  }


  }




