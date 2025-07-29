import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:matrimonial_app/features/register_module/model/proffesional_detail_model.dart';

import '../../../utils/app_constants.dart';
import '../../../utils/preferences.dart';

class ProfessionalService {
  static const String baseUrl = 'https://matrimony.sqcreation.site/api';

  /// GET APIs
  static Future<List<Education>> fetchEducationList() async {
    final response = await http.get(Uri.parse('$baseUrl/get/education/list'));
    final data = jsonDecode(response.body);
    if (data['status'] == true) {
      return (data['data'] as List).map((e) => Education.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load education data');
    }
  }

  static Future<List<JobType>> fetchJobTypeList() async {
    final response = await http.get(Uri.parse('$baseUrl/get/job/type/list'));
    final data = jsonDecode(response.body);
    if (data['status'] == true) {
      return (data['data'] as List).map((e) => JobType.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load job types');
    }
  }

  static Future<List<CompanyType>> fetchCompanyTypeList() async {
    final response = await http.get(Uri.parse('$baseUrl/get/company/type/list'));
    final data = jsonDecode(response.body);
    if (data['status'] == true) {
      return (data['data'] as List).map((e) => CompanyType.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load company types');
    }
  }

  static Future<List<Occupation>> fetchOccupationList() async {
    final response = await http.get(Uri.parse('$baseUrl/get/occupation/list'));
    final data = jsonDecode(response.body);
    if (data['status'] == true) {
      return (data['data'] as List).map((e) => Occupation.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load occupation data');
    }
  }

  static Future<List<AnnualIncome>> fetchAnnualIncomeList() async {
    final response = await http.get(Uri.parse('$baseUrl/get/annual/income/list'));
    final data = jsonDecode(response.body);
    if (data['status'] == true) {
      return (data['data'] as List).map((e) => AnnualIncome.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load income data');
    }
  }

  /// POST API
  static Future<bool> submitProfessionalDetails({
    required int educationId,
    required int jobTypeId,
    required int companyTypeId,
    required int occupationId,
    required int annualIncomeId,
  }) async {
    final url = Uri.parse('$baseUrl/update-professional');
    final token = Preferences.getString(AppConstants.token, defaultValue: "");

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final body = jsonEncode({
      "education": educationId,
      "jobtype": jobTypeId,
      "companytype": companyTypeId,
      "occupation": occupationId,
      "annualincome": annualIncomeId,
    });

    final response = await http.post(url, headers: headers, body: body);

    print("🔽 Status Code: ${response.statusCode}");
    print("🔽 Response: ${response.body}");

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return json['status'] == true;
    }

    return false;
  }
}
