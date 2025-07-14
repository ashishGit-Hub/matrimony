// 📁 lib/features/register_module/model/basic_details_model.dart
class BasicDetailsModel {
  final String age;
  final String dob;
  final String email;
  final String gender;

  BasicDetailsModel({
    required this.age,
    required this.dob,
    required this.email,
    required this.gender,
  });

  Map<String, dynamic> toJson() {
    return {
      "age": age,
      "dob": dob,
      "email": email,
      "gender": gender,
    };
  }
}
