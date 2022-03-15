import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:telegram_clone_mobile/util/custom_ink_splash.dart';

class MaterialThemes {
  static ThemeData get lightTheme {
    return ThemeData(
      appBarTheme: AppBarTheme(
        elevation: 1.5,
        color: Color.fromARGB(255, 81, 125, 162),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      primaryColor: Color.fromARGB(255, 81, 125, 162),
      primaryColorLight: Color.fromARGB(255, 90, 143, 187),
      accentColor: Color.fromARGB(255, 102, 169, 224),
      splashFactory: CustomInkSplash.splashFactory,
      splashColor: Color.fromRGBO(175, 175, 175, 0.25),
      highlightColor: Colors.transparent,
      textTheme: TextTheme(
        headline1: TextStyle(
          color: Color.fromARGB(255, 63, 63, 63),
        ),
        headline2: TextStyle(
          color: Color.fromARGB(255, 134, 134, 134),
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
      canvasColor: Color.fromARGB(255, 255, 255, 255),
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      scaffoldBackgroundColor: Color.fromARGB(255, 255, 255, 255),
      dividerColor: Color.fromARGB(255, 230, 230, 230),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: Color.fromARGB(255, 90, 158, 207),
        foregroundColor: Color.fromARGB(255, 255, 255, 255),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      appBarTheme: AppBarTheme(
        elevation: 1.5,
        color: Color.fromARGB(255, 31, 43, 55),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      primaryColor: Color.fromARGB(255, 31, 43, 55),
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
        foregroundColor: Color.fromARGB(255, 250, 255, 255),
      ),
    );
  }
}
