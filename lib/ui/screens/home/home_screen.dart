import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:telegram_clone_mobile/view_models/home/home_viewmodel.dart';

import 'router.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      context.read<HomeViewModel>().changeOnlineStatus(true);
    } else if (state == AppLifecycleState.inactive) {
      context.read<HomeViewModel>().changeOnlineStatus(false);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeViewModel>(
      builder: (context, model, child) {
        return Navigator(
          initialRoute: HomeRoutes.Chats,
          onGenerateRoute: HomeRouter.generateRoute,
        );
      },
    );
  }
}