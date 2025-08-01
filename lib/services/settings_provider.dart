import 'package:flutter/material.dart';

class SettingsProvider with ChangeNotifier{
  bool _isDarkmode = false;
  String _fontSize = 'Medium';

  Color _backgroundColor = LightDarkColors.lightBackground;
  Color _fontColor = LightDarkColors.lightFont;

  bool get isDarkmode => _isDarkmode;
  String get fontSize => _fontSize;

  Color get backgroundColor => _backgroundColor;
  Color get fontColor => _fontColor;

  void toggleDarkMode () {
    _isDarkmode = !_isDarkmode;
    notifyListeners();
  }

  void setFontSize(String size){
    _fontSize = size;
    notifyListeners();
  }

  void setBackgroundColor (Color color){
    _backgroundColor = color;
    notifyListeners();
  }

  void setFontColor (Color color){
    _fontColor = color;
    notifyListeners();
  }
}

class LightDarkColors {
  //Light Theme
  static const Color lightBackground = Colors.white;
  static const Color lightFont = Colors.black;

  //Dark Theme
  static const Color darkBackground = Colors.black;
  static const Color darkFont = Colors.white;

}