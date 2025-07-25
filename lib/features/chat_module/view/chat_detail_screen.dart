import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:matrimonial_app/utils/app_constants.dart';
import 'package:matrimonial_app/utils/preferences.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../../../core/constant/app_textstyle.dart';
import '../../../providers/chat_provider.dart';
import '../model/chat_model.dart';

class ChatDetailScreen extends StatefulWidget {
  final String chatUserId;
  final String name;
  final String? image;

  const ChatDetailScreen({super.key,
    required this.chatUserId,
    required this.name,
    this.image,
  });

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final TextEditingController _controller = TextEditingController();
  bool _sending = false;
  int? currentUserId; // Changed from String? to int?

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Provider.of<ChatProvider>(context, listen: false).loadMessages(widget.chatUserId);
    });
  }

  /// Send Message
  Future<void> sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty || _sending) {
      if (kDebugMode) {
        print("❌ Cannot send: Empty message or userId null");
      }
      return;
    }

    setState(() => _sending = true);

    final requestBody = {
      "message": text,
      "receiver_id": widget.chatUserId, // Replace this with actual receiver id if dynamic
    };
    final token = Preferences.getString(AppConstants.token, defaultValue: "");
    if(token.isEmpty){
      throw Exception('Token not found');
    }

    try {
      final response = await http.post(
        Uri.parse('http://matrimony.sqcreation.site/api/user/messages'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      print("📥 Status Code: ${response.statusCode}");
      print("📥 Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final msg = data['data'];

        Provider.of<ChatProvider>(context, listen: false).messageList.add(
          ChatUserModel(
              chatUserid: msg['id'].toString(),
            senderId: msg['sender_id']?.toString() ?? '',
            receiverId: msg['receiver_id']?.toString() ?? '',
            name: widget.name,
            image: widget.image,
            lastMessage: msg['message'],
            time: msg['created_at'],
            unreadCount: 0,
          ),
        );

        _controller.clear();
        setState(() {});
      } else {
        print("❌ Failed to send message");
      }
    } catch (e) {
      print("❌ Error sending message: $e");
    } finally {
      setState(() => _sending = false);
    }
  }

  Widget buildMessage(ChatUserModel msg, bool isMe) {
    final time = DateFormat('h:mm a').format(
      DateTime.tryParse(msg.time) ?? DateTime.now(),
    );

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe)
            CircleAvatar(
              radius: 16,
              backgroundImage: widget.image != null ? NetworkImage(widget.image!) : null,
              backgroundColor: Colors.grey[300],
              child: widget.image == null
                  ? const Icon(Icons.person, size: 16, color: Colors.white)
                  : null,
            ),
          const SizedBox(width: 6),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 4),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
            decoration: BoxDecoration(
              color: isMe ? Colors.orangeAccent[100] : Colors.grey[200],
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(12),
                topRight: const Radius.circular(12),
                bottomLeft: isMe ? const Radius.circular(12) : const Radius.circular(0),
                bottomRight: isMe ? const Radius.circular(0) : const Radius.circular(12),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(msg.lastMessage, style: const TextStyle(fontSize: 16, color: Colors.black)),
                const SizedBox(height: 4),
                Text(time, style: const TextStyle(fontSize: 10, color: Colors.black54)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Consumer<ChatProvider>(builder: (context,provider, child){
     return Scaffold(
        backgroundColor: const Color(0xffece5dd),
        appBar: AppBar(
          backgroundColor: Colors.orange,
          titleSpacing: 0,
          title: Row(
            children: [
              CircleAvatar(
                backgroundImage: widget.image != null ? NetworkImage(widget.image!) : null,
                backgroundColor: Colors.grey[300],
                child: widget.image == null
                    ? const Icon(Icons.person, color: Colors.white)
                    : null,
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.name, style: const TextStyle(fontSize: 18, color: Colors.white)),
                  Text("Online", style: AppTextStyle.semiBoldInterText(fontSize: 12, color: Colors.white70)),
                ],
              ),
            ],
          ),
          actions: [
            IconButton(icon: const Icon(Icons.videocam, color: Colors.white), onPressed: () {}),
            IconButton(icon: const Icon(Icons.call, color: Colors.white), onPressed: () {}),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: provider.isLoadingMessages
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                reverse: true,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                itemCount: provider.messageList.length,
                itemBuilder: (context, index) {
                  final reversedIndex = provider.messageList.length - 1 - index;
                  final msg = provider.messageList[reversedIndex];
                  final isMe = msg.senderId.toString() != widget.chatUserId;
                  return buildMessage(msg, isMe);
                },
              ),
            ),
            const Divider(height: 1),
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  IconButton(
                    icon: const Icon(Icons.emoji_emotions_outlined, color: Colors.grey),
                    onPressed: () {},
                  ),
                  Expanded(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(minHeight: 40, maxHeight: 120),
                      child: Scrollbar(
                        child: TextField(
                          controller: _controller,
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                          decoration: const InputDecoration(
                            hintText: "Type a message",
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                          ),
                        ),
                      ),
                    ),
                  ),
                  IconButton(icon: const Icon(Icons.camera_alt, color: Colors.grey), onPressed: () {}),
                  IconButton(
                    icon: const Icon(Icons.send, color: Colors.orange),
                    onPressed: _sending ? null : sendMessage,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
