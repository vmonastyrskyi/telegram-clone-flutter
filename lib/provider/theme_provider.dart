import 'package:flutter/material.dart';
import 'package:telegram_clone_mobile/ui/themes/material_themes.dart';

class ThemeProvider extends ChangeNotifier {
  AppTheme _customTheme = DarkAppTheme();

  AppTheme get theme => _customTheme;

  void toggleBrightness() {
    if (_customTheme.brightness == Brightness.dark)
      _customTheme = LightAppTheme();
    else
      _customTheme = DarkAppTheme();
    notifyListeners();
  }
}

abstract class AppTheme {
  Brightness get brightness;

  ThemeData get data;

  Color get drawerHeaderBackground;

  Color get drawerHeaderTitleColor;

  Color get drawerHeaderSubtitleColor;
}

class LightAppTheme extends AppTheme {
  Brightness get brightness => Brightness.light;

  ThemeData get data => MaterialThemes.lightTheme;

  Color get drawerHeaderBackground => Color.fromARGB(255, 90, 143, 187);

  Color get drawerHeaderTitleColor => Color.fromARGB(255, 250, 255, 255);

  Color get drawerHeaderSubtitleColor => Color.fromARGB(255, 187, 231, 255);
}

class DarkAppTheme extends AppTheme {
  Brightness get brightness => Brightness.dark;

  ThemeData get data => MaterialThemes.darkTheme;

  Color get drawerHeaderBackground => Color.fromARGB(255, 31, 43, 55);

  Color get drawerHeaderTitleColor => Color.fromARGB(255, 250, 255, 255);

  Color get drawerHeaderSubtitleColor => Color.fromARGB(255, 135, 147, 159);
}
