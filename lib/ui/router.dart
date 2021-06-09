import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:telegram_clone_mobile/view_models/home/home_viewmodel.dart';
import 'package:telegram_clone_mobile/util/slide_left_with_fade_route.dart';

import 'screens/auth/auth_screen.dart';
import 'screens/home/home_screen.dart';

abstract class AppRoutes {
  static const String Home = '/';
  static const String Auth = 'auth';
}

class RootRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.Auth:
        return SlideWithFadeRoute(
          builder: (context) => AuthScreen(),
        );
      case AppRoutes.Home:
        return SlideWithFadeRoute(
          builder: (context) => ChangeNotifierProvider<HomeViewModel>(
            create: (_) => HomeViewModel(),
            child: HomeScreen(),
          ),
        );
      default:
        return MaterialPageRoute(
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
