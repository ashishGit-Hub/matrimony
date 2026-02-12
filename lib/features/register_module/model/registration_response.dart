import 'package:matrimonial_app/features/match_module/model/match_model.dart';
import 'package:matrimonial_app/models/user_model.dart';

class RegistrationResponse {
  final bool status;
  final String message;
  final String? token;
  final User? user;

  RegistrationResponse({
    required this.status,
    required this.message,
    required this.token,
    required this.user,
  });

  factory RegistrationResponse.fromJson(Map<String, dynamic> json) {
    return RegistrationResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      token: json['token'] is String
          ? json['token']
          : (json['token']?['access'] ?? ''),
      user: json.containsKey('user') && json['user'] != null
          ? User.fromJson(json['user'])
          : User.empty(),
    );
  }
}
