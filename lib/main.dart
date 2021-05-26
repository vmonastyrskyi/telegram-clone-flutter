import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:telegram_clone_mobile/business_logic/view_models/theme_provider.dart';
import 'package:telegram_clone_mobile/ui/themes/theme_provider.dart';

import 'services/firebase/firebase_auth_service.dart';
import 'ui/router.dart';
import 'ui/themes/themes.dart';

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

  String _initialRoute = AppRoutes.Home;
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
      return _SplashScreen();
    }

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        Provider<FirebaseAuthService>.value(value: firebaseAuthService),
      ],
      child: _MainScreen(
        initialRoute: _initialRoute,
      ),
    );
  }
}

class _SplashScreen extends StatelessWidget {
  const _SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: Themes.darkTheme,
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

class _MainScreen extends StatelessWidget {
  const _MainScreen({
    Key? key,
    required this.initialRoute,
  }) : super(key: key);

  final String initialRoute;

  @override
  Widget build(BuildContext context) {
    // return ThemeManager(
    //   duration: Duration(milliseconds: 500),
    //   builder: (context, theme) {
    //     return MaterialApp(
    //       title: 'Telegram',
    //       theme: theme,
    //       initialRoute: initialRoute,
    //       onGenerateRoute: RootRouter.generateRoute,
    //       debugShowCheckedModeBanner: false,
    //     );
    //   },
    // );
    return ThemeManager(
      builder: (context, theme) {
        return MaterialApp(
          title: 'Telegram',
          theme: theme,
          initialRoute: initialRoute,
          onGenerateRoute: RootRouter.generateRoute,
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
