import 'package:get_it/get_it.dart';

import 'services/firebase/auth_service.dart';
import 'services/firebase/user_service.dart';

final services = GetIt.instance;

void setupServices() {
  services.registerLazySingleton<AuthService>(() => AuthService());
  services.registerLazySingleton<UserService>(() => UserService());
}
