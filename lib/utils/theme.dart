
import 'package:flutter/material.dart';

import 'colors.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.dark;

  bool get isDarkMode => themeMode == ThemeMode.dark;

  void toggleTheme(bool isOn) {
    themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}

class Themes {
  static final dark = ThemeData(
    scaffoldBackgroundColor: Barvy.Hex("242b40").withOpacity(.45),
    textTheme: TextTheme(bodyMedium: TextStyle(color: darkPrimary)),
    colorScheme: const ColorScheme.dark(),
    iconTheme: IconThemeData(color: darkPrimary, size: 32),
    // fontFamily: GoogleFonts.sora().fontFamily,
    fontFamily: "Space-Grotesk",
    dividerColor: Colors.transparent,
  );

  static final light = ThemeData(
    scaffoldBackgroundColor: lightBg,
    textTheme: TextTheme(bodyMedium: TextStyle(color: lightPrimary)),
    colorScheme: const ColorScheme.highContrastLight(),
    iconTheme: IconThemeData(color: lightPrimary, size: 32),
    fontFamily: "Space-Grotesk",
      dividerColor: Colors.transparent
  );
}