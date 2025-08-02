import 'package:flutter/material.dart';

class SettingsProvider with ChangeNotifier{
  bool _isDarkmode = false;
  String _fontSize = 'Medium';

  bool get isDarkmode => _isDarkmode;
  String get fontSize => _fontSize;

  void toggleDarkMode () {
    _isDarkmode = !_isDarkmode;
    notifyListeners();
  }

  void setFontSize(String size){
    _fontSize = size;
    notifyListeners();
  }
}