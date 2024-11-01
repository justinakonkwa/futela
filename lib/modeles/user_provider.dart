import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class UserProvider with ChangeNotifier {
  bool isLoggedIn = false;
  Map<String, dynamic>? currentUserData;
  String? errorMessage;

  UserProvider() {
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    String? userData = prefs.getString('userData');

    if (userData != null) {
      currentUserData = json.decode(userData);
      isLoggedIn = true;
    } else {
      isLoggedIn = false;
    }
    notifyListeners();
  }

  Future<void> login(String username, String password) async {
    final String url = 'http://futela.com/api/login';
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userData', jsonEncode(data['data']));
      await prefs.setBool('isLoggedIn', true);

      currentUserData = data['data'];
      isLoggedIn = true;
      errorMessage = null;
    } else {
      errorMessage = 'Erreur de connexion: ${response.statusCode}';
    }
    notifyListeners();
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userData');
    await prefs.setBool('isLoggedIn', false);

    currentUserData = null;
    isLoggedIn = false;
    notifyListeners();
  }
}
