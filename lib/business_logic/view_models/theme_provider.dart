import 'package:flutter/material.dart';
import 'package:telegram_clone_mobile/ui/themes/themes.dart';

class ThemeProvider extends ChangeNotifier {
  CustomTheme _customTheme = CustomDarkTheme();

  CustomTheme get theme => _customTheme;

  void toggleBrightness() {
    if (_customTheme.brightness == Brightness.dark)
      _customTheme = CustomLightTheme();
    else
      _customTheme = CustomDarkTheme();
    notifyListeners();
  }
}

abstract class CustomTheme {
  Brightness get brightness;

  ThemeData get data;

  Color get drawerHeaderBackground;
  Color get drawerHeaderTitleColor;
  Color get drawerHeaderSubtitleColor;
}

class CustomLightTheme extends CustomTheme {
  Brightness get brightness => Brightness.light;

  ThemeData get data => Themes.lightTheme;

  Color get drawerHeaderBackground => Color.fromARGB(255, 90, 143, 187);
  Color get drawerHeaderTitleColor => Color.fromARGB(255, 250, 255, 255);
  Color get drawerHeaderSubtitleColor => Color.fromARGB(255, 187, 231, 255);
}

class CustomDarkTheme extends CustomTheme {
  Brightness get brightness => Brightness.dark;

  ThemeData get data => Themes.darkTheme;

  Color get drawerHeaderBackground => Colors.redAccent;
  Color get drawerHeaderTitleColor => Colors.redAccent;
  Color get drawerHeaderSubtitleColor => Colors.redAccent;
}
