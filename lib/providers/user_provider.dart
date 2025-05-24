import 'package:e_commerce_app/models/user_model.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:e_commerce_app/constants/api_urls.dart';



class UserProvider with ChangeNotifier {
  User? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isLoggedIn => _currentUser != null;

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _errorMessage = error;
    notifyListeners();
  }

  Future<bool> login(String username, String password) async {
    _setLoading(true);
    _setError(null);

    try {
      // Step 1: Authenticate user
      final loginResponse = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'username': username.trim(),
          'password': password.trim(),
        }),
      );

      if (loginResponse.statusCode == 200) {
        final loginData = json.decode(loginResponse.body);
        final token = loginData['token'];

        // Step 2: Get user details
        final userResponse = await http.get(
          Uri.parse('$baseUrl/users/1'), // Using user ID 1 for demo
          headers: {'Authorization': 'Bearer $token'},
        );

        if (userResponse.statusCode == 200) {
          final userData = json.decode(userResponse.body);
          
          _currentUser = User(
            id: userData['id'],
            username: userData['username'],
            email: userData['email'],
            firstName: userData['name']['firstname'],
            lastName: userData['name']['lastname'],
            token: token,
          );

          _setLoading(false);
          return true;
        } else {
          _setError('Failed to fetch user details');
          _setLoading(false);
          return false;
        }
      } else {
        _setError('Invalid login credentials');
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _setError('Network error. Please try again.');
      _setLoading(false);
      return false;
    }
  }

  void logout() {
    _currentUser = null;
    _errorMessage = null;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}