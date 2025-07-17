import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:matrimonal_app/features/chat_module/model/chat_model.dart';


class ChatDetailScreen extends StatefulWidget {
  final String name;
  final String? image;

  const ChatDetailScreen({Key? key, required this.name, this.image}) : super(key: key);

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final List<ChatMessage> messages = [
    ChatMessage(text: "Hi!", isMe: false, time: DateTime.now().subtract(Duration(minutes: 5))),
    ChatMessage(text: "Hey! How are you?", isMe: true, time: DateTime.now().subtract(Duration(minutes: 4))),
    ChatMessage(text: "I'm good. Can you share your details?", isMe: false, time: DateTime.now().subtract(Duration(minutes: 2))),
  ];

  final TextEditingController _controller = TextEditingController();

  void sendMessage() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        messages.add(ChatMessage(text: text, isMe: true, time: DateTime.now()));
        _controller.clear();
      });
    }
  }

  Widget buildMessage(ChatMessage msg) {
    final time = DateFormat('h:mm a').format(msg.time);
    final isMe = msg.isMe;

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
              child: widget.image == null ? Icon(Icons.person, size: 16, color: Colors.white) : null,
            ),
          SizedBox(width: 6),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 4),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
            decoration: BoxDecoration(
              color: isMe ? Colors.orangeAccent : Colors.grey[200],
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
                Text(
                  msg.text,
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
                SizedBox(height: 4),
                Text(
                  time,
                  style: TextStyle(fontSize: 10, color: Colors.black54),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffece5dd),
      appBar: AppBar(
        backgroundColor: Colors.orange,
        titleSpacing: 0,
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: widget.image != null ? NetworkImage(widget.image!) : null,
              backgroundColor: Colors.grey[300],
              child: widget.image == null ? Icon(Icons.person, color: Colors.white) : null,
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.name, style: TextStyle(fontSize: 18)),
                Text("Online", style: TextStyle(fontSize: 12, color: Colors.white70)),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(icon: Icon(Icons.videocam), onPressed: () {}),
          IconButton(icon: Icon(Icons.call), onPressed: () {}),
       //   IconButton(icon: Icon(Icons.more_vert), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final reversedIndex = messages.length - 1 - index;
                return buildMessage(messages[reversedIndex]);
              },
            ),
          ),
          Divider(height: 1),
          Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Row(
              children: [
                IconButton(icon: Icon(Icons.emoji_emotions_outlined, color: Colors.grey), onPressed: () {}),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "Type a message",
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(icon: Icon(Icons.attach_file, color: Colors.grey), onPressed: () {}),
                IconButton(icon: Icon(Icons.camera_alt, color: Colors.grey), onPressed: () {}),
                CircleAvatar(
                  backgroundColor: Colors.orangeAccent,
                  child: IconButton(icon: Icon(Icons.send, color: Colors.white), onPressed: sendMessage),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
