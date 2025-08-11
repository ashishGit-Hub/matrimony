import 'package:flutter/foundation.dart';

import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:matrimonial_app/core/models/ApiResponse.dart';
import 'package:matrimonial_app/models/user_model.dart';
import 'package:matrimonial_app/services/user_service.dart';

import '../features/register_module/model/registration_response.dart';

class UserProvider with ChangeNotifier{
  final UserService _userService = UserService();

  User? user;

  Future<User?> getUserDetails() async {
    var userDetails = await _userService.getUserDetails();
    if(userDetails != null){
      user = userDetails;
      notifyListeners();
      return userDetails;
    }
  }


  Future<ApiResponse> updateUserGalleryImage(List<XFile> file) async{
    return _userService.uploadMultipleImage(file);
  }

}