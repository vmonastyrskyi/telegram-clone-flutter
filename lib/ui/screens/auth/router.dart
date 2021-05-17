import 'package:flutter/material.dart';
import 'package:telegram_clone_mobile/ui/screens/auth/choose_country/choose_country_screen.dart';
import 'package:telegram_clone_mobile/ui/screens/auth/input_phone/input_phone_screen.dart';
import 'package:telegram_clone_mobile/util/slide_left_with_fade_route.dart';

abstract class AuthRoutes {
  static const String InputPhone = 'InputPhone';
  static const String ChooseCountry = 'ChooseCountry';
}

class AuthRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AuthRoutes.InputPhone:
        return SlideLeftWithFadeRoute(
          builder: (context) => InputPhoneScreen(),
        );
      case AuthRoutes.ChooseCountry:
        return SlideLeftWithFadeRoute(
          builder: (context) => ChooseCountryScreen(),
        );
      default:
        return MaterialPageRoute(builder: (_) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Telegram'),
            ),
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          );
        });
    }
  }
}
