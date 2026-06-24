import 'package:flutter/material.dart';
import '../models/user.dart';
import 'api_service.dart';

class AuthProvider extends ChangeNotifier {
  User? _user;
  bool _loading = false;
  String? _error;

  User? get user => _user;
  bool get loading => _loading;
  String? get error => _error;
  bool get isLoggedIn => _user != null;

  Future<void> login(String phone, String password) async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      final data = await ApiService.login(phone, password);
      await ApiService.saveTokens(
        data['tokens']['accessToken'],
        data['tokens']['refreshToken'],
      );
      _user = User.fromJson(data['user']);
    } catch (e) {
      _error = e.toString().replaceFirst('Exception: ', '');
      rethrow;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> fetchMe() async {
    try {
      final token = await ApiService.getToken();
      if (token == null) return;
      final data = await ApiService.getMe();
      _user = User.fromJson(data);
      notifyListeners();
    } catch (_) {
      await logout();
    }
  }

  Future<void> logout() async {
    await ApiService.clearTokens();
    _user = null;
    notifyListeners();
  }
}
