import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:telegram_clone_mobile/view_models/base_viewmodel.dart';
import 'package:telegram_clone_mobile/constants/shared_preferences.dart';
import 'package:telegram_clone_mobile/locator.dart';
import 'package:telegram_clone_mobile/models/country.dart';
import 'package:telegram_clone_mobile/models/user_details.dart';
import 'package:telegram_clone_mobile/services/auth_service.dart';
import 'package:telegram_clone_mobile/services/user_service.dart';
import 'package:telegram_clone_mobile/util/phone_number_mask.dart';

class HomeViewModel extends BaseViewModel {
  HomeViewModel() {
    listenOnUserChanged();
  }

  final AuthService _authService = locator<AuthService>();
  final UserService _userService = locator<UserService>();

  UserDetails? _userDetails;
  String? _formattedPhoneNumber;

  UserDetails? get userDetails => _userDetails;

  set userDetails(UserDetails? userDetails) {
    _userDetails = userDetails;
    notifyListeners();
  }

  String? get formattedPhoneNumber => _formattedPhoneNumber;

  void listenOnUserChanged() {
    if (_authService.currentUser != null) {
      _userService
          .onUserChanged(id: _authService.currentUser!.uid)
          .listen((userDetailsSnap) async {
        if (userDetailsSnap.exists && userDetailsSnap.data() != null) {
          final userDetails = userDetailsSnap.data()!;
          await formatPhoneNumber(userDetails.phoneNumber);
          this.userDetails = userDetails;
        }
      });
    }
  }

  void changeOnlineStatus(bool online) {
    _userService.setOnlineStatus(online);
  }

  Future<void> formatPhoneNumber(String phoneNumber) async {
    final prefs = await SharedPreferences.getInstance();
    final selectedCountryJson =
        prefs.getString(SharedPrefsConstants.kSelectedCountry);
    if (selectedCountryJson != null) {
      final selectedCountry = Country.fromJson(jsonDecode(selectedCountryJson));
      _formattedPhoneNumber = PhoneNumberMask.format(
          text: phoneNumber, mask: selectedCountry.format);
    }
  }
}
