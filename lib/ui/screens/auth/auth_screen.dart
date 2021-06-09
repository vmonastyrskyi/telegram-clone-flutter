import 'package:flutter/material.dart';
import 'package:telegram_clone_mobile/ui/screens/auth/router.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Navigator(
      initialRoute: AuthRoutes.InputPhone,
      onGenerateRoute: AuthRouter.generateRoute,
    );
  }
}
