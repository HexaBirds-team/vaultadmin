// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';

dynamic preference;

class AppSettingsController extends ChangeNotifier {
  /* Theme Mode Handler */
  bool _isDark = false;
  bool get isDark => _isDark;

  AppSettingsController() {
    _isDark = false;
    getThemePreferences();
  }

//Switching the themes
  setisDark(bool value) {
    _isDark = value;
    preference.setBool("DarkMode", value);
    notifyListeners();
  }

  getThemePreferences() async {
    _isDark = await preference.getBool("DarkMode") ?? false;
    notifyListeners();
  }
}
