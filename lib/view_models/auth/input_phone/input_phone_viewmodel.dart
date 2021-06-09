import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:telegram_clone_mobile/constants/shared_preferences.dart';
import 'package:telegram_clone_mobile/locator.dart';
import 'package:telegram_clone_mobile/models/country.dart';
import 'package:telegram_clone_mobile/services/country_service.dart';
import 'package:telegram_clone_mobile/util/masked_input_controller.dart';
import 'package:telegram_clone_mobile/util/phone_mask_painter.dart';
import 'package:telegram_clone_mobile/view_models/base_viewmodel.dart';

class SelectedCountryPlaceholders {
  static const String ChooseCountry = 'Choose a country';
  static const String InvalidCountryCode = 'Invalid country code';
}

class InputPhoneViewModel extends BaseViewModel {
  static final String _kDefaultPhoneMask = '###############';

  final CountryService _countryService = locator<CountryService>();

  final TextEditingController countryCodeInputController =
      TextEditingController();
  final MaskedInputController phoneInputController =
      MaskedInputController(mask: _kDefaultPhoneMask, filter: {
    '#': RegExp('[0-9]'),
  });
  final PhoneMaskPainter maskPainter = PhoneMaskPainter();

  Country? _selectedCountry;
  String _selectedCountryPlaceholder =
      SelectedCountryPlaceholders.ChooseCountry;
  bool _isValidCountryCode = false;

  Country? get selectedCountry => _selectedCountry;

  String get selectedCountryPlaceholder => _selectedCountryPlaceholder;

  bool get isValidCountryCode => _isValidCountryCode;

  void selectCountryByCode(String code) {
    if (code.isNotEmpty) {
      final country = _countryService.findCountryByCode(int.parse(code));

      if (country != null) {
        _selectedCountryPlaceholder = country.name;
        _selectedCountry = country;
        _isValidCountryCode = true;

        countryCodeInputController.text = country.code.toString();
        countryCodeInputController.selection = TextSelection.fromPosition(
            TextPosition(offset: countryCodeInputController.text.length));
        phoneInputController.changeMask(country.mask);
        maskPainter.fill(phoneInputController.text);
        maskPainter.changeMask(country.mask);
      } else {
        _selectedCountryPlaceholder =
            SelectedCountryPlaceholders.InvalidCountryCode;
        _selectedCountry = null;
        _isValidCountryCode = false;

        phoneInputController.changeMask(_kDefaultPhoneMask);
        maskPainter.fill('');
        maskPainter.changeMask('');
      }
    } else {
      _selectedCountryPlaceholder = SelectedCountryPlaceholders.ChooseCountry;
      _selectedCountry = null;
      _isValidCountryCode = false;

      phoneInputController.changeMask(_kDefaultPhoneMask);
      maskPainter.fill('');
      maskPainter.changeMask('');
    }

    notifyListeners();
  }

  void fillMask() {
    maskPainter.fill(phoneInputController.text);
  }

  void loadSignInData() async {
    final prefs = await SharedPreferences.getInstance();

    final phoneNumber = prefs.getString(SharedPrefsConstants.kPhoneNumber);
    if (phoneNumber != null) {
      phoneInputController.text = phoneNumber;
    }

    final selectedCountryJson =
        prefs.getString(SharedPrefsConstants.kSelectedCountry);
    if (selectedCountryJson != null) {
      final country = Country.fromJson(jsonDecode(selectedCountryJson));
      selectCountryByCode(country.code.toString());
    }
  }

  void saveSignInData() async {
    final prefs = await SharedPreferences.getInstance();

    final phoneNumber =
        phoneInputController.text.replaceAll(RegExp('[^0-9]'), '');
    prefs.setString(SharedPrefsConstants.kPhoneNumber, phoneNumber);

    prefs.setString(
        SharedPrefsConstants.kSelectedCountry, jsonEncode(_selectedCountry));
  }

  @override
  void dispose() {
    countryCodeInputController.dispose();
    phoneInputController.dispose();
    super.dispose();
  }
}
