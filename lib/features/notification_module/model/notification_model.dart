class NotificationModel {
  final int id;
  final String title;
  final String message;
  final String time;
  final String? icon;
  final int isRead;

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.time,
    required this.isRead,
    this.icon,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      title: json['title'] ?? '',
      message: json['body'] ?? '',
      time: json['created_at'] ?? '',
      isRead: json['is_read'] ?? 0,
      icon: json['image'],
    );
  }
}
