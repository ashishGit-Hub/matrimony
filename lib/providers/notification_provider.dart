import 'package:flutter/material.dart';
import '../features/notification_module/model/notification_model.dart';
import '../services/notification_service.dart';

class NotificationProvider extends ChangeNotifier {
  List<NotificationModel> _notifications = [];
  bool _isLoading = false;
  String? _error;

  List<NotificationModel> get notifications => _notifications;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadNotifications(int userId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final service = NotificationService();
      _notifications = await service.fetchNotifications(userId);
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }
}
