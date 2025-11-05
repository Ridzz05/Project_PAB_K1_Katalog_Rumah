import 'package:flutter/material.dart';

class AuthController extends ChangeNotifier {
  static const String _dummyEmail = 'ijazahnyamanawok@gmail.com';
  static const String _dummyPassword = 'fufufafa123';

  bool _isAuthenticated = false;
  bool _isLoading = false;
  String? _errorMessage;

  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> login(String email, String password) async {
    if (_isLoading) return;
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 500));

    final matches = email.trim().toLowerCase() == _dummyEmail &&
        password == _dummyPassword;

    if (matches) {
      _isAuthenticated = true;
      _errorMessage = null;
    } else {
      _isAuthenticated = false;
      _errorMessage = 'Email atau password tidak valid.';
    }

    _isLoading = false;
    notifyListeners();
  }

  void logout() {
    _isAuthenticated = false;
    _errorMessage = null;
    _isLoading = false;
    notifyListeners();
  }
}
