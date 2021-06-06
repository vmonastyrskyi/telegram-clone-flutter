import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:telegram_clone_mobile/ui/screens/home/chats/chats_screen.dart';
import 'package:telegram_clone_mobile/ui/screens/home/contacts/contacts_screen.dart';
import 'package:telegram_clone_mobile/util/slide_left_with_fade_route.dart';
import 'package:telegram_clone_mobile/view_models/home/chats/chats_viewmodel.dart';

abstract class HomeRoutes {
  static const String Chats = 'chats';
  static const String Contacts = 'contacts';
}

class HomeRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case HomeRoutes.Chats:
        return SlideWithFadeRoute(
          builder: (context) => ChangeNotifierProvider(
            create: (_) => ChatsViewModel(),
            child: ChatsScreen(),
          ),
        );
      case HomeRoutes.Contacts:
        return SlideWithFadeRoute(
          builder: (context) => ContactsScreen(),
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
