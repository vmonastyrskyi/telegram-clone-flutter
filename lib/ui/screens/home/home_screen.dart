import 'package:flutter/material.dart';
import 'package:telegram_clone_mobile/ui/screens/home/components/body.dart';
import 'package:telegram_clone_mobile/ui/screens/home/components/nav_drawer.dart';
import 'package:telegram_clone_mobile/ui/themes/theme_manager.dart';
import 'package:telegram_clone_mobile/ui/themes/theme_switcher_area.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // return ThemeManagerArea(
    return ThemeSwitcherArea(
      child: Scaffold(
        drawer: NavDrawer(),
        appBar: AppBar(
          leading: Builder(
            builder: (context) {
              return IconButton(
                icon: const Icon(Icons.menu),
                splashRadius: 20,
                highlightColor: Theme.of(context).splashColor,
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              );
            },
          ),
          title: const Text('Telegram'),
          actions: <Widget>[
            Container(
              margin: const EdgeInsets.only(right: 12),
              child: const Icon(Icons.search),
            )
          ],
        ),
        body: Body(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: const Icon(Icons.edit),
        ),
      ),
    );
  }
}
