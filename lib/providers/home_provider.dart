

import 'package:flutter/material.dart';
import 'package:matrimonial_app/core/models/ApiResponse.dart';
import 'package:matrimonial_app/models/home_model.dart';
import 'package:matrimonial_app/services/home_service.dart';

class HomeProvider extends ChangeNotifier{
  final HomeService _homeService = HomeService();

  final bool isLoading = false;
  HomeModel? homeModel;

  Future<void> getHome() async{
    var response = await _homeService.getHome();
    if(response.status){
      homeModel = response.data;
    }
  }
}