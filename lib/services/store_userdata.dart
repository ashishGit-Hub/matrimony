import 'package:shared_preferences/shared_preferences.dart';

Future<void> _storeUserLocally(Map<String, dynamic> user) async {
  final prefs = await SharedPreferences.getInstance();

  await prefs.setString('dummyid', user['dummyid']?.toString() ?? '');
  await prefs.setString('name', user['name']?.toString() ?? '');
  await prefs.setString('email', user['email']?.toString() ?? '');
  await prefs.setString('mobile', user['mobile']?.toString() ?? '');
  await prefs.setString('age', user['age']?.toString() ?? '');
  await prefs.setString('dob', user['dob']?.toString() ?? '');
  await prefs.setString('height', user['height']?.toString() ?? '');
  await prefs.setString('weight', user['weight']?.toString() ?? '');
  await prefs.setString('myself', user['myself']?.toString() ?? '');
  await prefs.setString('gender', user['gender']?.toString() ?? '');
  await prefs.setString('image', user['images']?.toString() ?? '');

  // Nested fields - safely checking if keys exist
  await prefs.setString('profileFor', user['profileFor']?['name']?.toString() ?? '');
  await prefs.setString('education', user['education']?['name']?.toString() ?? '');
  await prefs.setString('occupation', user['occupation']?['name']?.toString() ?? '');
  await prefs.setString('income', user['annualIncome']?['range']?.toString() ?? '');
  await prefs.setString('jobType', user['jobType']?['name']?.toString() ?? '');
  await prefs.setString('companyType', user['companyType']?['name']?.toString() ?? '');
  await prefs.setString('religion', user['religion']?['name']?.toString() ?? '');
  await prefs.setString('caste', user['caste']?['name']?.toString() ?? '');
}
