
import 'package:flutter/foundation.dart';
import 'package:matrimonial_app/services/match_service.dart';

import '../features/match_module/model/match_model.dart';

class MatchProvider extends ChangeNotifier{
  final _matchService = MatchService();


  Future<MatchResponse?> getMatches({
    required String stateId,
    required String cityId,
    String? ageMin,
    String? ageMax,
    String? token,
  }) async {

      return await _matchService.fetchMatches(stateId: stateId, cityId: cityId);

  }


}