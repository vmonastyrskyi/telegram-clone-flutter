import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:telegram_clone_mobile/locator.dart';
import 'package:telegram_clone_mobile/provider/theme_provider.dart';
import 'package:telegram_clone_mobile/services/firebase/auth_service.dart';
import 'package:telegram_clone_mobile/ui/router.dart';
import 'package:telegram_clone_mobile/ui/themes/material_themes.dart';
import 'package:telegram_clone_mobile/ui/themes/theme_manager.dart';

void main() {
  setupServices();
  WidgetsFlutterBinding.ensureInitialized();
  runApp(TelegramCloneApp());
}

class TelegramCloneApp extends StatefulWidget {
  @override
  _TelegramCloneAppState createState() => _TelegramCloneAppState();
}

class _TelegramCloneAppState extends State<TelegramCloneApp> {

  String _initialRoute = AppRoutes.Auth;
  bool _initialized = false;
  bool _error = false;

  void _initFirebase() async {
    try {
      await Firebase.initializeApp();

      setState(() {
        _initialized = true;

        if (services.get<AuthService>().isAuthenticated()) {
          _initialRoute = AppRoutes.Home;
        }
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

    return ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
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
      theme: MaterialThemes.darkTheme,
      home: Scaffold(
        body: Container(
          child: Center(
            child: Text(
              'Telegram',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Color.fromARGB(255, 250, 255, 255),
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
