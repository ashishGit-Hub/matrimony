import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:matrimonial_app/core/models/ApiResponse.dart';
import 'package:matrimonial_app/models/not_interest.dart';
import 'package:matrimonial_app/models/send_request_model.dart';
import '../../services/match_service.dart';
import '../features/match_module/model/match_model.dart';
import '../models/receive_match.dart';
import '../utils/app_constants.dart';
import '../utils/preferences.dart';


class MatchProvider extends ChangeNotifier {
  final MatchService _matchService = MatchService();


  // 🔽 Internal state for sent interests
  List<SentRequestModel> _sentRequestsList = [];
  bool _isLoading = false;
  String? _errorMessage;

  // 🔽 Getters
  List<SentRequestModel> get sentRequestList => _sentRequestsList;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // 🔽 Matches (optional filter)
  Future<MatchResponse?> getMatches({
    required String stateId,
    required String cityId,
    String? ageMin,
    String? ageMax,
  }) async {
    return await _matchService.fetchMatches(
      stateId: stateId,
      cityId: cityId,
      ageMin: ageMin,
      ageMax: ageMax,
    );
  }

  // 🔽 Send Interest
  Future<bool> sendInterest({
    required String userId,
  }) async {
    return await MatchService.sendInterest(userId: userId);
  }

  // 🔽 Send Not Interested
  Future<bool> sendNotInterested({
    required String token,
    required String userId,
  }) async {
    return await MatchService.sendNotInterested(token: token, userId: userId);
  }

  // 🔽 Get sent interests
  Future<void> fetchSentInterests() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    // try {
      _sentRequestsList = await _matchService.fetchSentInterests();
      notifyListeners();
    // } catch (e) {
    //   _errorMessage = e.toString();
    // }

    _isLoading = false;
    notifyListeners();
  }
  List<ReceiveInterest> _receivedInterests = [];
  bool _isLoadingReceived = false;
  String? _errorReceived;

  List<ReceiveInterest> get receivedInterests => _receivedInterests;
  bool get isLoadingReceived => _isLoadingReceived;
  String? get errorReceived => _errorReceived;
  void clearErrorReceived() {
    _errorReceived = null;
    notifyListeners();
  }

  Future<void> fetchReceivedInterests() async {
    _isLoadingReceived = true;
    _errorReceived = null;
    notifyListeners();

    try {
      _receivedInterests = await MatchService.fetchReceivedInterests();

    } catch (e) {
      _errorReceived = e.toString();
    }

    _isLoadingReceived = false;
    notifyListeners();
  }
  Future<bool> acceptInterest(String id) async {
    try {
      final result = await MatchService.acceptInterest(id);
      if (result) {
        fetchReceivedInterests(); // Refresh list
      }
      return result;
    } catch (e) {
      print("Accept Error: $e");
      return false;
    }
  }

  Future<bool> rejectInterest(String id) async {
    try {
      final result = await MatchService.rejectInterest(id);
      return result;
    } catch (e) {
      if (kDebugMode) {
        print("Reject Error: $e");
      }
      return false;
    }
  }
  List<NotInterest> _notInterestedList = [];
  final bool _isLoadingNotInterested = false;
  String? _errorNotInterested;

  List<NotInterest> get notInterestedList => _notInterestedList;
  bool get isLoadingNotInterested => _isLoadingNotInterested;
  String? get errorNotInterested => _errorNotInterested;

  Future<void> fetchNotInterested() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _notInterestedList = await MatchService.fetchNotInterestedList();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  Future<bool> revokeNotInterested(String id) async {
    try {
      final result = await MatchService.revokeNotInterested(id);
      return result;
    } catch (e) {
      if (kDebugMode) {
        print(" Revoke Not Interested Error: $e");
      }
      return false;
    }
  }

  // Revoke Interest Request

  Future<ApiResponse> revokeInterestRequest(String requestId){
      return _matchService.revokeInterestRequest(requestId);
  }

}
