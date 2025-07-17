import 'package:flutter/material.dart';
import 'package:matrimonial_app/core/constant/app_textstyle.dart';
import 'chat_detail_screen.dart';

class ChatScreen extends StatelessWidget {
  final List<Map<String, dynamic>> chatList = [
    {
      'name': 'Srivalli',
      'message': 'pls send me your details',
      'time': '10:00 AM',
      'image': null,
    },
    {
      'name': 'Lavanya',
      'message': 'I’m interested with your profile',
      'time': '10:00 AM',
      'image': 'https://randomuser.me/api/portraits/women/1.jpg',
    },
    {
      'name': 'Harika',
      'message': 'pls send me your details',
      'time': '10:00 AM',
      'image': 'https://randomuser.me/api/portraits/women/2.jpg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Chat',style: AppTextStyle.semiBoldInterText(fontSize: 25),)),

        backgroundColor: Colors.orange,
      ),
      body: ListView.builder(
        itemCount: chatList.length,
        itemBuilder: (context, index) {
          final user = chatList[index];
          return ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ChatDetailScreen(
                    name: user['name'],
                    image: user['image'],
                  ),
                ),
              );
            },
            leading: CircleAvatar(
              backgroundImage: user['image'] != null ? NetworkImage(user['image']) : null,
              backgroundColor: Colors.grey[300],
              child: user['image'] == null ? Icon(Icons.person, color: Colors.white) : null,
            ),
            title: Text(user['name'], style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(user['message']),
            trailing: Text(user['time']),
          );
        },
      ),
    );
  }
}
