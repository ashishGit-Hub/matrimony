import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:matrimonial_app/utils/app_constants.dart';
import 'package:matrimonial_app/utils/preferences.dart';
import '../features/chat_module/model/chat_model.dart';

class ChatService {
  static Future<List<ChatUserModel>> fetchChats() async {

    final token = Preferences.getString(AppConstants.token, defaultValue: "");
    if(token.isEmpty){
      throw Exception('Token not found');
    }

    final url = Uri.parse(AppConstants.chatUserList);
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final  jsonData = jsonDecode(response.body);
      if (jsonData != null) {
        final List<dynamic> dataList = jsonData;
        return dataList.map((e) => ChatUserModel.fromJson(e)).toList();
      } else {
        throw Exception('No chat data found');
      }
    } else {
      throw Exception('Failed to load chats');
    }
  }

  static Future<List<ChatUserModel>> fetchMessage() async {
    final url = Uri.parse('http://matrimony.sqcreation.site/api/user/messages');
    final token = Preferences.getString(AppConstants.token, defaultValue: "");
    if(token.isEmpty){
      throw Exception('Token not found');
    }
    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      print('Status Code: ${response.statusCode}');
      print('Response body: ${response.body}');


      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);

        if (jsonData['status'] == true && jsonData['data'] != null) {
          final List<dynamic> data = jsonData['data'];

          return data
              .map((messageJson) => ChatUserModel.fromMessageJson(messageJson))
              .toList();
        } else {
          throw Exception('No messages found');
        }
      } else {
        throw Exception(
            'Failed to fetch messages. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching messages: $e');
      rethrow;
    }
  }
  static Future<ChatUserModel> sendMessage({
    required String token,
    required int receiverId,
    required String message,
  }) async {
    final url = Uri.parse('http://matrimony.sqcreation.site/api/user/messages');

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'receiver_id': receiverId,
          'message': message,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return ChatUserModel.fromSendMessageJson(data['data']);
      } else {
        throw Exception('Failed to send message');
      }
    } catch (e) {
      throw Exception('Error sending message: $e');
    }
  }

}

