import 'package:get_it/get_it.dart';
import 'package:telegram_clone_mobile/services/country_service.dart';

import 'services/auth_service.dart';
import 'services/chat_service.dart';
import 'services/user_service.dart';

final locator = GetIt.instance;

void setupLocator() {
  locator.registerSingleton<AuthService>(AuthService());
  locator.registerSingleton<UserService>(UserService());
  locator.registerSingleton<ChatService>(ChatService());
  locator.registerSingleton<CountryService>(CountryService());
}
