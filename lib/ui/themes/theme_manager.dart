import 'package:flutter/material.dart';
import 'package:telegram_clone_mobile/util/custom_ink_splash.dart';

class ThemeManager {
  static ThemeData get darkTheme {
    return ThemeData(
      appBarTheme: AppBarTheme(
        brightness: Brightness.dark,
        elevation: 1.5,
      ),
      primaryColor: Color.fromARGB(255, 31, 43, 55),
      primaryColorDark: Color.fromARGB(255, 25, 33, 44),
      primaryColorLight: Color.fromARGB(255, 59, 93, 128),
      accentColor: Color.fromARGB(255, 90, 158, 207),
      splashFactory: CustomInkSplash.splashFactory,
      splashColor: Color.fromRGBO(96, 125, 139, 0.25),
      highlightColor: Colors.transparent,
      textTheme: TextTheme(
        headline1: TextStyle(
          color: Color.fromARGB(255, 250, 255, 255),
        ),
        headline2: TextStyle(
          color: Color.fromARGB(255, 135, 147, 159),
        ),
        headline3: TextStyle(
          color: Color.fromARGB(255, 107, 125, 137),
        ),
        headline5: TextStyle(
          color: Color.fromARGB(255, 149, 194, 235),
        ),
        headline6: TextStyle(
          color: Color.fromARGB(255, 138, 179, 210),
        ),
      ),
      canvasColor: Color.fromARGB(255, 27, 37, 47),
      backgroundColor: Color.fromARGB(255, 27, 37, 47),
      scaffoldBackgroundColor: Color.fromARGB(255, 27, 37, 47),
      dividerColor: Color.fromARGB(255, 8, 18, 27),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: Color.fromARGB(255, 90, 158, 207),
        foregroundColor: Color.fromARGB(255, 255, 255, 255),
      ),
    );
  }
}
