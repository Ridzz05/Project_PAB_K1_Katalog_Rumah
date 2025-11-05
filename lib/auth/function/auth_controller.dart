import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends ChangeNotifier {
  static const _emailKey = 'auth_email';
  static const _passwordKey = 'auth_password';
  static const _nameKey = 'auth_name';

  bool _isAuthenticated = false;
  bool _isLoading = false;
  String? _errorMessage;
  String? _userName;
  String? _userEmail;
  String? _userPassword;

  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get userName => _userName;
  String? get userEmail => _userEmail;
  String? get userPassword => _userPassword;
  bool get hasRegistered =>
      _userEmail != null && _userPassword != null && _userName != null;

  AuthController() {
    _loadStoredCredentials();
  }

  Future<void> _loadStoredCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final storedEmail = prefs.getString(_emailKey);
    final storedPassword = prefs.getString(_passwordKey);
    final storedName = prefs.getString(_nameKey);

    final hasChanges = storedEmail != _userEmail ||
        storedPassword != _userPassword ||
        storedName != _userName;

    if (!hasChanges) return;

    _userEmail = storedEmail;
    _userPassword = storedPassword;
    _userName = storedName;
    notifyListeners();
  }

  Future<void> login(String email, String password) async {
    if (_isLoading) return;
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 500));

    final inputEmail = email.trim().toLowerCase();
    final inputPassword = password.trim();

    final storedEmail = _userEmail;
    final storedPassword = _userPassword;

    if (storedEmail == null || storedPassword == null) {
      _isAuthenticated = false;
      _errorMessage = 'Akun belum terdaftar.';
    } else {
      final credentialsMatch = inputEmail == storedEmail.toLowerCase() &&
          inputPassword == storedPassword;
      if (credentialsMatch) {
        _isAuthenticated = true;
        _errorMessage = null;
      } else {
        _isAuthenticated = false;
        _errorMessage = 'Email atau password tidak valid.';
      }
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<String?> register(
    String name,
    String email,
    String password,
  ) async {
    if (_isLoading) {
      return 'Permintaan sebelumnya masih diproses.';
    }

    final trimmedName = name.trim();
    final trimmedEmail = email.trim().toLowerCase();
    final trimmedPassword = password.trim();

    if (trimmedName.isEmpty || trimmedEmail.isEmpty || trimmedPassword.isEmpty) {
      return 'Semua kolom wajib diisi.';
    }
    if (trimmedPassword.length < 6) {
      return 'Password minimal 6 karakter.';
    }

    _isLoading = true;
    notifyListeners();

    String? error;

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_nameKey, trimmedName);
      await prefs.setString(_emailKey, trimmedEmail);
      await prefs.setString(_passwordKey, trimmedPassword);

      _userName = trimmedName;
      _userEmail = trimmedEmail;
      _userPassword = trimmedPassword;
      _errorMessage = null;
    } catch (_) {
      error = 'Gagal menyimpan data. Coba lagi.';
    }

    _isLoading = false;
    notifyListeners();
    return error;
  }

  void logout() {
    _isAuthenticated = false;
    _errorMessage = null;
    _isLoading = false;
    notifyListeners();
  }
}
