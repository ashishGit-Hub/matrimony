import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:matrimonial_app/core/models/ApiResponse.dart';
import 'package:http/http.dart' as http;
import 'package:matrimonial_app/models/home_model.dart';
import 'package:matrimonial_app/utils/app_constants.dart';
import 'package:matrimonial_app/utils/preferences.dart';


class HomeService {


  Future<ApiResponse<HomeModel>> getHome() async {
    try{

      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${Preferences.getToken()}',
      };

      var response = await http.get(Uri.parse(AppConstants.home), headers: headers);
      if(kDebugMode){
        print("API URL: ${AppConstants.home}");
        print("Token: $headers");
        print("Home Response: ${response.body}");
        print("Home Response Status: ${response.statusCode}");

      }
      if(response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        return ApiResponse<HomeModel>.fromJson(
          jsonResponse,
              (data) => HomeModel.fromJson(data),
        );
      } else {
        return ApiResponse<HomeModel>(
          status: false,
          message: 'Failed to load home data',
          data: null,
        );
      }
    }catch(error){
      return ApiResponse<HomeModel>(
        status: false,
        message: error.toString(),
        data: null,
      );
    }
  }


}