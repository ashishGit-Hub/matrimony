import 'package:flutter/material.dart';

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
    {
      'name': 'Kavya',
      'message': 'pls send me your details',
      'time': '10:00 AM',
      'image': 'https://randomuser.me/api/portraits/women/3.jpg',
    },
    {
      'name': 'Divya',
      'message': 'pls send me your details',
      'time': '10:00 AM',
      'image': 'https://randomuser.me/api/portraits/women/4.jpg',
    },
    {
      'name': 'Deepika',
      'message': 'pls send me your details',
      'time': '10:00 AM',
      'image': 'https://randomuser.me/api/portraits/women/5.jpg',
    },
  ];

  ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          toolbarHeight: 100,
          backgroundColor: Colors.orange[200],
          elevation: 0,
          title: Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Center(
              child: Text(
                'Chat',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
        body: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: TabBar(
                indicatorSize: TabBarIndicatorSize.tab,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.black,
                indicator: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(30),
                ),
                tabs: const [
                  Tab(text: 'All Messages'),
                  Tab(text: 'Unread Messages'),
                  Tab(text: 'Calls'),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  buildChatList(),
                  Center(child: Text("Unread Messages")),
                  Center(child: Text("Calls")),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildChatList() {
    return ListView.builder(
      itemCount: chatList.length,
      itemBuilder: (context, index) {
        final user = chatList[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: user['image'] != null
                ? NetworkImage(user['image'])
                : null,
            backgroundColor: Colors.grey[300],
            child: user['image'] == null
                ? Icon(Icons.person, color: Colors.white)
                : null,
          ),
          title: Text(
            user['name'],
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Row(
            children: [
              Icon(Icons.done_all, size: 16, color: Colors.blue),
              SizedBox(width: 4),
              Flexible(child: Text(user['message'])),
            ],
          ),
          trailing: Text(user['time']),
        );
      },
    );
  }
}
