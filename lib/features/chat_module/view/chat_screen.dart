import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constant/app_textstyle.dart';
import '../../../providers/chat_provider.dart';
import 'chat_detail_screen.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ChatProvider>(context, listen: false).loadChats();
    });
  }

  // ✅ Token fetching + navigation
  void _openChatDetail(String chatUserId, String name, String? image) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token != null && token.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ChatDetailScreen(
            chatUserId: chatUserId,
            name: name,
            image: image,
          ),
        ),
      );
    } else {
      print("❌ Token not found. Redirect to login or show error.");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Authentication token not found')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('Chat', style: AppTextStyle.semiBoldInterText(fontSize: 25)),
        ),
        backgroundColor: Colors.orange,
      ),
      body: chatProvider.isLoadingChats
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: chatProvider.chatList.length,
        itemBuilder: (context, index) {
          final user = chatProvider.chatList[index];
          return ListTile(
            onTap: () {
              _openChatDetail(user.chatUserid,user.name, user.image); // ✅ Proper call
            },
            leading: CircleAvatar(
              backgroundImage: user.image != null ? NetworkImage(user.image!) : null,
              backgroundColor: Colors.grey[300],
              child: user.image == null
                  ? const Icon(Icons.person, color: Colors.white)
                  : null,
            ),
            title: Text(user.name, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(user.lastMessage),
            trailing: Text(
              user.time.split('T').last.substring(0, 5),
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          );
        },
      ),
    );
  }
}
