class LoginModel {
  final String mobile;
  final String password;

  LoginModel({required this.mobile, required this.password});

  Map<String, dynamic> toJson() {
    return {
      'mobile': mobile,
      'password': password,
    };
  }
}