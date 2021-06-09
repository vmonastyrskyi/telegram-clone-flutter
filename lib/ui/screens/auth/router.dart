import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:telegram_clone_mobile/models/country.dart';
import 'package:telegram_clone_mobile/util/slide_left_with_fade_route.dart';
import 'package:telegram_clone_mobile/view_models/auth/input_phone/input_phone_viewmodel.dart';
import 'package:telegram_clone_mobile/view_models/auth/phone_verification/phone_verification_viewmodel.dart';
import 'package:telegram_clone_mobile/view_models/auth/select_country/select_country_viewmodel.dart';

import 'input_phone/input_phone_screen.dart';
import 'phone_verification/phone_verification_screen.dart';
import 'select_country/select_country_screen.dart';

abstract class AuthRoutes {
  static const String InputPhone = 'input-phone';
  static const String SelectCountry = 'select-country';
  static const String PhoneVerification = 'phone-verification';
}

class AuthRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AuthRoutes.InputPhone:
        return SlideWithFadeRoute(
          builder: (context) => ChangeNotifierProvider(
            create: (_) => InputPhoneViewModel(),
            child: InputPhoneScreen(),
          ),
          slideDirection: SlideDirection.rightToLeft,
        );
      case AuthRoutes.SelectCountry:
        return SlideWithFadeRoute<Country>(
          builder: (context) => ChangeNotifierProvider(
            create: (_) => SelectCountryViewModel(),
            child: SelectCountryScreen(),
          ),
        );
      case AuthRoutes.PhoneVerification:
        final args = settings.arguments as PhoneVerificationArgs;
        return SlideWithFadeRoute<bool>(
          builder: (context) => ChangeNotifierProvider(
            create: (_) => PhoneVerificationViewModel(),
            child: PhoneVerificationScreen(
              phoneNumber: args.phoneNumber,
            ),
          ),
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
                    fontSize: 18.0,
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
