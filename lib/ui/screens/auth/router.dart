import 'package:flutter/material.dart';
import 'package:telegram_clone_mobile/ui/screens/auth/choose_country/choose_country_screen.dart';
import 'package:telegram_clone_mobile/ui/screens/auth/input_phone/input_phone_screen.dart';
import 'package:telegram_clone_mobile/ui/screens/auth/phone_verification/phone_verification_screen.dart';
import 'package:telegram_clone_mobile/util/slide_left_with_fade_route.dart';

abstract class AuthRoutes {
  static const String InputPhone = 'input-phone';
  static const String ChooseCountry = 'choose-country';
  static const String PhoneVerification = 'phone-verification';
}

class AuthRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AuthRoutes.InputPhone:
        return SlideWithFadeRoute(
          builder: (context) => InputPhoneScreen(),
          slideDirection: SlideDirection.rightToLeft,
        );
      case AuthRoutes.ChooseCountry:
        return SlideWithFadeRoute(
          builder: (context) => ChooseCountryScreen(),
        );
      case AuthRoutes.PhoneVerification:
        final args = settings.arguments as PhoneVerificationArgs;
        return SlideWithFadeRoute(
          builder: (context) => PhoneVerificationScreen(phone: args.phone),
        );
      default:
        return SlideWithFadeRoute(
          builder: (context) {
            return Scaffold(
              appBar: AppBar(
                title: Text('Telegram'),
              ),
              body: Center(
                child: Text(
                  'No route defined for ${settings.name}',
                  style: TextStyle(
                    fontSize: 18,
                    color: Theme.of(context).textTheme.headline2!.color,
                  ),
                ),
              ),
            );
          },
        );
    }
  }
}
