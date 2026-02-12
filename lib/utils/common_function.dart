
class CommonFunction{

  static String formatMessageTime(String dateTimeStr) {
    try {
      final DateTime dateTime = DateTime.parse(dateTimeStr);
      final DateTime now = DateTime.now();
      final DateTime today = DateTime(now.year, now.month, now.day);
      final DateTime yesterday = today.subtract(const Duration(days: 1));
      final DateTime messageDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

      if (messageDate == today) {
        // Show time for today's messages
        return "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";
      } else if (messageDate == yesterday) {
        return "Yesterday";
      } else {
        // Show date for older messages
        return "${dateTime.day}/${dateTime.month}/${dateTime.year}";
      }
    } catch (e) {
      return dateTimeStr;
    }
  }
}
