import 'package:telegram_clone_mobile/view_models/base_viewmodel.dart';
import 'package:telegram_clone_mobile/locator.dart';
import 'package:telegram_clone_mobile/services/auth_service.dart';

class NavDrawerViewModel extends BaseViewModel {
  final AuthService _authService = locator<AuthService>();

  Future<void> logout() async {
    return await _authService.logout();
  }
}
