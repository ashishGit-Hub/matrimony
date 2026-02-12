import 'package:matrimonial_app/models/user_model.dart';

class SentRequestModel {
    SentRequestModel({
        required this.receiver,
        required this.receiverId,
        required this.senderId,
        required this.interestId,
        required this.status,
    });

    User receiver;
    String receiverId;
    String senderId;
    String interestId;
    String? status;

    factory SentRequestModel.fromJson(Map<String, dynamic> json) => SentRequestModel(
        receiverId: json["receiver_id"].toString() ?? "",
        senderId: json["sender_id"].toString() ?? '',
        interestId: json["interest_id"].toString(),
        status: json["status"],
        receiver:  User.fromJson(json["receiver"]),
    );

}
