import 'package:matrimonial_app/features/match_module/model/match_model.dart';

class ReceiveInterest {
  final String interestId;
  final String status;
  final String senderId;
  final String receiverId;
  final MatchModel sender;
  ReceiveInterest(
      {
      required this.interestId,
      required this.status,
      required this.senderId,
      required this.receiverId,
      required this.sender});

  factory ReceiveInterest.fromJson(Map<String, dynamic> json) {
    return ReceiveInterest(
        interestId: json['interest_id'].toString(),
        status: json['status'],
        senderId: json['sender_id'].toString(),
        receiverId: json['receiver_id'].toString(),
        sender: MatchModel.fromJson(json['sender']));
  }
}
