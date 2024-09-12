import 'package:flutter/material.dart';
import 'package:futela/widgets/theme.dart';

class Themeprovider with ChangeNotifier {
  ThemeData _themeData = lightMode;

  ThemeData get themeData => _themeData; // Définir le getter pour themeData

  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  void toggleTheme() {
    if (_themeData == lightMode) {
      themeData = dartMode;
    } else {
      themeData = lightMode;
    }
    notifyListeners();
  }
}
