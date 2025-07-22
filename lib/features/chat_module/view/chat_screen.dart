import 'package:flutter/material.dart';
import 'package:matrimonial_app/core/constant/app_textstyle.dart';
import 'chat_detail_screen.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}


class _ChatScreenState extends  State<ChatScreen> {
  final PusherChannelsFlutter pusher = PusherChannelsFlutter();

  // Future<void> initPusher() async {
  //   try {
  //     await pusher.init(
  //       apiKey: "YOUR_PUSHER_APP_KEY",
  //       cluster: "YOUR_PUSHER_CLUSTER", // e.g., mt1
  //       onConnectionStateChange: (socketId, channelName) => print("Connection: $socketId"),
  //       onError: (x, s) => print("Error: ${x.message}"),
  //     );
  //
  //     await pusher.subscribe(channelName: "chat");
  //
  //     await pusher.bind(
  //       channelName: "chat",
  //       eventName: "MessageSent",
  //       onEvent: (event) {
  //         print("New message: ${event.data}");
  //         // You can parse JSON here
  //       },
  //     );
  //
  //     await pusher.connect();
  //   } catch (e) {
  //     print("Pusher init error: $e");
  //   }
  // }

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

  // @override
  // void initState() {
  //   super.initState();
  //   await pusher.init(
  //       apiKey: API_KEY,
  //       cluster: API_CLUSTER
  //   );
  //   await pusher.connect();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Chat',style: AppTextStyle.semiBoldInterText(fontSize: 25),)),

        backgroundColor: Colors.orange
        ,
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
