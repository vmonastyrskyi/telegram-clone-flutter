import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:telegram_clone_mobile/services/firebase/firebase_auth_service.dart';
import 'package:telegram_clone_mobile/ui/router.dart';
import 'package:telegram_clone_mobile/ui/themes/theme_manager.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(TelegramCloneApp());
}

class TelegramCloneApp extends StatefulWidget {
  @override
  _TelegramCloneAppState createState() => _TelegramCloneAppState();
}

class _TelegramCloneAppState extends State<TelegramCloneApp> {
  late FirebaseAuthService firebaseAuthService;

  String _initialRoute = AppRoutes.Auth;
  bool _initialized = false;
  bool _error = false;

  void _initFirebase() async {
    try {
      await Firebase.initializeApp();

      firebaseAuthService = FirebaseAuthService();

      setState(() {
        _initialized = true;
        if (firebaseAuthService.isAuthenticated())
          _initialRoute = AppRoutes.Home;
      });
    } catch (e) {
      setState(() => _error = true);
    }
  }

  @override
  void initState() {
    super.initState();
    _initFirebase();
  }

  @override
  Widget build(BuildContext context) {
    if (_error) {
      print('error');
    }

    if (!_initialized) {
      return SplashScreen();
    }

    return Provider<FirebaseAuthService>.value(
      value: firebaseAuthService,
      child: MainScreen(
        initialRoute: _initialRoute,
      ),
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeManager.darkTheme,
      home: Scaffold(
        body: Container(
          child: Center(
            child: Text(
              'Telegram',
              style: TextStyle(
                fontSize: 18,
                color: Theme.of(context).textTheme.headline1!.color,
              ),
            ),
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainScreen extends StatelessWidget {
  const MainScreen({
    Key? key,
    required this.initialRoute,
  }) : super(key: key);

  final String initialRoute;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Telegram',
      theme: ThemeManager.darkTheme,
      initialRoute: initialRoute,
      onGenerateRoute: RootRouter.generateRoute,
      debugShowCheckedModeBanner: false,
    );
  }
}
