import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../features/notification_module/model/notification_model.dart';


class NotificationService {
  Future<List<NotificationModel>> fetchNotifications(int userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      final url = Uri.parse('http://matrimony.sqcreation.site/api/get-user-notification?user_id=$userId');

      final response = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        if (!response.headers['content-type']!.contains('application/json')) {
          throw Exception("Expected JSON, got something else.");
        }

        final body = json.decode(response.body);
        final List data = body['data'];
        return data.map((e) => NotificationModel.fromJson(e)).toList();
      } else {
        throw Exception("Failed with status: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error fetching notifications: $e");
    }
  }
}
