import 'package:flutter/material.dart';
import 'package:a_green/theme/theme_provider.dart';

class ThemeProvider with ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  void toggleTheme(bool isOn) {
    _isDarkMode = isOn;
    notifyListeners();
  }

  ThemeData get currentTheme => _isDarkMode ? darkTheme : lightTheme;
}

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: const Color(0xffCBF3BB),
  primaryColor: const Color(0xff658C58),
  colorScheme: ColorScheme.light(
    primary: const Color(0xff658C58),
    secondary: const Color(0xffA0C878),
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xffCBF3BB),
    foregroundColor: Colors.black,
  ),
);

// 🌙 Dark Theme
final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: const Color(0xff1E1E1E),
  primaryColor: const Color(0xff8BC34A),
  colorScheme: ColorScheme.dark(
    primary: const Color(0xff8BC34A),
    secondary: const Color(0xff4CAF50),
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xff1E1E1E),
    foregroundColor: Colors.white,
  ),
);
