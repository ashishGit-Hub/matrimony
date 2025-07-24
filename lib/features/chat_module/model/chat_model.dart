class ChatUserModel {
  final String chatUserid;
  final String senderId;
  final String receiverId;
  final String name;
  final String? image;
  final String lastMessage;
  final String time;
  final int unreadCount;

  ChatUserModel(
       {required this.chatUserid,
        required this.senderId,
        required this.receiverId,
        required this.name,
        this.image,
        required this.lastMessage,
        required this.time,
        required this.unreadCount,
      });

  /// Factory for chat user list (like from chat list API)
  factory ChatUserModel.fromJson(Map<String, dynamic> json) {
    return ChatUserModel(
      chatUserid: json['user']['id'].toString(), // ✅ chatUserid
      senderId: json['user']['id'].toString(),
      receiverId: json['user']['receiver_id']?.toString() ?? '',
      name: json['user']['name'],
      image: json['user']['profile'],
      lastMessage: json['last_message'] ?? '',
      time: json['last_message_at'] ?? '',
      unreadCount: json['unread_count'] ?? 0,
    );
  }

  /// Factory for receiving single message from API (messages list)
  factory ChatUserModel.fromMessageJson(Map<String, dynamic> json) {
    return ChatUserModel(
      chatUserid: json['id'].toString(), // ✅ chatUserid
      senderId: json['sender_id'].toString(),
      receiverId: json['receiver_id'].toString(),
      name: 'User ${json['sender_id']}',
      image: null,
      lastMessage: json['message'] ?? '',
      time: json['created_at'] ?? '',
      unreadCount: json['is_read'] == 0 ? 1 : 0,
    );
  }

  /// Factory for response after sending message
  factory ChatUserModel.fromSendMessageJson(Map<String, dynamic> json) {
    return ChatUserModel(
      chatUserid: json['id'].toString(), // ✅ chatUserid
      senderId: json['sender_id'].toString(),
      receiverId: json['receiver_id'].toString(),
      name: 'User ${json['sender_id']}',
      image: null,
      lastMessage: json['message'] ?? '',
      time: json['created_at'] ?? '',
      unreadCount: 0,
    );
  }
}
