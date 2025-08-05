import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../../services/notification_service.dart';
import '../model/notification_model.dart';

class NotificationListScreen extends StatefulWidget {
  final int userId;
  const NotificationListScreen({required this.userId});

  @override
  State<NotificationListScreen> createState() => _NotificationListScreenState();
}

class _NotificationListScreenState extends State<NotificationListScreen> {
  List<NotificationModel> notifications = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserNotifications();
  }

  void fetchUserNotifications() async {
    try {
      final data = await NotificationService().fetchNotifications(widget.userId);
      setState(() {
        notifications = data;
        isLoading = false;
      });
    } catch (e) {
      print("❌ Error: $e");
      setState(() => isLoading = false);
    }
  }

  String getTimeAgo(String timeString) {
    try {
      final parsedTime = DateTime.parse(timeString);
      return timeago.format(parsedTime);
    } catch (e) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.orange,
        elevation: 1,
        title: Text(
          "Notifications",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.check, color: Colors.black),
            onPressed: () {
              print("✔ Mark all as read tapped");
            },
          ),
        ],
      ),

      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : notifications.isEmpty
          ? Center(child: Text("No notifications found."))
          : ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final item = notifications[index];
          return Container(
            padding: EdgeInsets.all(12),
            margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        item.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    Text(
                      getTimeAgo(item.time),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 6),
                Text(
                  item.message,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
