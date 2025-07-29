import 'package:flutter/foundation.dart';
import '../../services/match_service.dart';
import '../features/match_module/model/match_model.dart';
import '../models/receive_match.dart';
import '../utils/app_constants.dart';
import '../utils/preferences.dart';


class MatchProvider extends ChangeNotifier {
  final MatchService _matchService = MatchService();


  // 🔽 Internal state for sent interests
  List<MatchModel> _sentInterests = [];
  bool _isLoading = false;
  String? _errorMessage;

  // 🔽 Getters
  List<MatchModel> get sentInterests => _sentInterests;
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
    required String token,
    required String userId,
  }) async {
    return await MatchService.sendInterest(token: token, userId: userId);
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

    try {
      _sentInterests = await MatchService.fetchSentInterests();
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }
  List<ReceiveInterest> _receivedInterests = [];
  bool _isLoadingReceived = false;
  String? _errorReceived;

  List<ReceiveInterest> get receivedInterests => _receivedInterests;
  bool get isLoadingReceived => _isLoadingReceived;
  String? get errorReceived => _errorReceived;

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
      if (result) {
        fetchReceivedInterests(); // Refresh list
      }
      return result;
    } catch (e) {
      print("Reject Error: $e");
      return false;
    }
  }
  List<MatchModel> _notInterestedList = [];
  bool _isLoadingNotInterested = false;
  String? _errorNotInterested;

  List<MatchModel> get notInterestedList => _notInterestedList;
  bool get isLoadingNotInterested => _isLoadingNotInterested;
  String? get errorNotInterested => _errorNotInterested;

  Future<void> fetchNotInterested(String token) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _notInterestedList = await MatchService.fetchNotInterestedList(token);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  Future<bool> revokeNotInterested(String id, String token) async {
    try {
      final result = await MatchService.revokeNotInterested(id);
      if (result) {
        await fetchNotInterested(token); // Refresh after revoke
      }
      return result;
    } catch (e) {
      print("❌ Revoke Not Interested Error: $e");
      return false;
    }
  }
}
