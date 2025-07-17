import 'package:flutter/material.dart';
import 'package:matrimonial_app/features/notification_module/model/notification_model.dart';
import 'notification_detail_screen.dart';

class NotificationListScreen extends StatelessWidget {
  final List<NotificationModel> notifications = [
    NotificationModel(
      title: "Profile Shortlisted",
      message: "Someone shortlisted your profile. Tap to see.",
      time: "10m ago",
      icon: "❤️",
    ),
    NotificationModel(
      title: "New Match Found",
      message: "You have a new match suggestion.",
      time: "1h ago",
      icon: "🔔",
    ),
    NotificationModel(
      title: "Profile View",
      message: "Your profile was viewed 3 times today.",
      time: "2h ago",
      icon: "👀",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
        backgroundColor: Colors.orangeAccent,
      ),
      body: ListView.separated(
        itemCount: notifications.length,
        separatorBuilder: (_, __) => Divider(height: 1),
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.orange.shade100,
              child: Text(notification.icon, style: TextStyle(fontSize: 18)),
            ),
            title: Text(notification.title, style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(notification.message),
            trailing: Text(notification.time, style: TextStyle(fontSize: 12, color: Colors.grey)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => NotificationDetailScreen(notification: notification),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
