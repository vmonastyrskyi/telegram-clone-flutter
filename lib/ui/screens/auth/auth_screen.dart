import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:telegram_clone_mobile/provider/select_country_provider.dart';
import 'package:telegram_clone_mobile/ui/screens/auth/router.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SelectCountryProvider(),
      child: Navigator(
        onGenerateRoute: AuthRouter.generateRoute,
        initialRoute: AuthRoutes.InputPhone,
      ),
    );
  }
}
