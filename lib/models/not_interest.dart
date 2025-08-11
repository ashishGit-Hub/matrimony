import 'package:matrimonial_app/models/user_model.dart';

class NotInterest {

  final String notInterestId;
  final String userId;
  final String notInterestUserId;
  final User user;

  NotInterest({
    required this.notInterestId,
    required this.userId,
    required this.notInterestUserId,
    required this.user,
  });

  factory NotInterest.fromJson(Map<String, dynamic> json) {
    return NotInterest(
      notInterestId: json['not_interest_id'].toString(),
      userId: json['user_id'].toString(),
      notInterestUserId: json['not_interest_user_id'].toString(),
      user: User.fromJson(json['not_interest_data']),
    );
  }
}