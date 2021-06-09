import 'package:flutter/material.dart';
import 'package:telegram_clone_mobile/view_models/base_viewmodel.dart';

class CustomAppBarViewModel extends BaseViewModel {
  final TextEditingController countrySearchController = TextEditingController();

  bool _showClearButton = false;

  bool get showClearButton => _showClearButton;

  set showClearButton(bool value) {
    _showClearButton = value;
    notifyListeners();
  }

  void clearCountrySearchInput() {
    countrySearchController.clear();
  }

  @override
  void dispose() {
    countrySearchController.dispose();
    super.dispose();
  }
}