import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../features/chat_module/model/chat_model.dart';
import '../services/chat_service.dart';

class ChatProvider extends ChangeNotifier {
  List<ChatUserModel> _chatList = [];
  List<ChatUserModel> _messageList = [];
  bool _isLoadingChats = false;
  bool _isLoadingMessages = false;

  List<ChatUserModel> get chatList => _chatList;
  List<ChatUserModel> get messageList => _messageList;
  bool get isLoadingChats => _isLoadingChats;
  bool get isLoadingMessages => _isLoadingMessages;

  /// Fetch Chat List (from /chat/list endpoint)
  Future<void> loadChats() async {
    _isLoadingChats = true;
    notifyListeners();
    try {
      _chatList = await ChatService.fetchChats();
    } catch (e) {
      if (kDebugMode) {
        log('Error loading chats: $e');
      }
    } finally {
      _isLoadingChats = false;
      notifyListeners();
    }
  }

  /// Fetch Message List (from /messages endpoint)
  Future<void> loadMessages(String chatUserId) async {
    _isLoadingMessages = true;
    notifyListeners();

    try {
      _messageList = await ChatService.fetchMessage(chatUserId);
    } catch (e, stackTrace) {
      print('Error loading messages: $e');
      print(stackTrace);
      // Optionally, you can set an error state or message here for the UI
    } finally {
      _isLoadingMessages = false;
      notifyListeners();
    }
  }
  Future<void> sendMessage({
    required String token,
    required int receiverId,
    required String message,
  }) async {
    try {
      final newMessage = await ChatService.sendMessage(
        token: token,
        receiverId: receiverId,
        message: message,
      );

      _messageList.add(newMessage);
      notifyListeners();
    } catch (e) {
      print('Error sending message: $e');
    }
  }

}