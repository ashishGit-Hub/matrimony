class RegisterModel {
  final String name;
  final String mobile;
  final String password;
  final String passwordConfirmation;
  final String profileFor;
  final String? fcmToken;

  RegisterModel({
    required this.name,
    required this.mobile,
    required this.password,
    required this.passwordConfirmation,
    required this.profileFor,
    this.fcmToken,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'mobile': mobile,
      'password': password,
      'password_confirmation': passwordConfirmation,
      'profile_for': profileFor,
      'fcm_token': fcmToken,
    };
  }
}
// StateModel
class StateModel {
  final int sid;
  final String name;

  StateModel({required this.sid, required this.name});

  factory StateModel.fromJson(Map<String, dynamic> json) {
    return StateModel(
      sid: json['sid'],
      name: json['name'],
    );
  }

  Map<String,dynamic> toJson() {
    return {
        "sid": sid,
        "name": name,

    };
  }
}

// CityModel
class CityModel {
  final int cityid;
  final String name;

  CityModel({required this.cityid, required this.name});

  factory CityModel.fromJson(Map<String, dynamic> json) {
    return CityModel(
      cityid: json['cityid'],
      name: json['name'],
    );
  }
}

