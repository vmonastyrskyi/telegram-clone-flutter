import 'package:flutter/material.dart';
import 'package:telegram_clone_mobile/models/user_details.dart';
import 'package:telegram_clone_mobile/locator.dart';
import 'package:telegram_clone_mobile/services/firebase/auth_service.dart';
import 'package:telegram_clone_mobile/services/firebase/user_service.dart';
import 'package:telegram_clone_mobile/ui/screens/home/components/body.dart';
import 'package:telegram_clone_mobile/ui/screens/home/components/nav_drawer.dart';
import 'package:telegram_clone_mobile/ui/themes/theme_switcher_area.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthService _authService = services.get<AuthService>();
  final UserService _userService = services.get<UserService>();

  UserDetails? _userDetails;

  @override
  void initState() {
    super.initState();
    if (_authService.currentUser != null) {
      _userService.onUserChanged(userId: _authService.currentUser!.uid).listen((snapshot) {
        if (snapshot.exists && snapshot.data() != null) {
          setState(() => _userDetails = snapshot.data());
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ThemeSwitcherArea(
      child: Scaffold(
        drawer: NavDrawer(userDetails: _userDetails),
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
