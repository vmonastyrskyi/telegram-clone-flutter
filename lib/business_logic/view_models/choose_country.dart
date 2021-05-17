import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:telegram_clone_mobile/business_logic/models/country.dart';

class ChooseCountryProvider extends ChangeNotifier {
  ChooseCountryProvider() {
    _countries = [
      for (var countryGroup in _countriesGroups) ...countryGroup.countries
    ];
  }

  //#region Properties

  List<Country>? _countries;
  List<CountryGroup> _countriesGroups = [
    CountryGroup('A', countries: [
      Country(name: 'Afghanistan', code: 93, mask: '### ### ###'),
      Country(name: 'Albania', code: 355, mask: '## ### ####'),
      Country(name: 'Armenia', code: 374, mask: '## ### ### #'),
      Country(name: 'Australia', code: 61, mask: '### ### ###'),
    ]),
    CountryGroup('U', countries: [
      Country(name: 'Ukraine', code: 380, mask: '## ### ## ##'),
      Country(name: 'USA', code: 1, mask: '### ### ####'),
      Country(name: 'United Arab Emirates', code: 971, mask: '## ### ####'),
      Country(name: 'United Kingdom', code: 44, mask: '#### ######'),
    ]),
    CountryGroup('R', countries: [
      Country(name: 'Russian Federation', code: 7, mask: '### ### ####'),
    ]),
  ];
  List<Country> _searchedCountries = List.empty(growable: true);
  Country? selectedCountry;
  bool _enableCountrySearch = false;

  //#endregion

  //#region Getters/Setters/Methods

  bool get enableCountrySearch => _enableCountrySearch;

  set enableCountrySearch(bool value) {
    _enableCountrySearch = value;
    _searchedCountries.clear();
    notifyListeners();
  }

  List<CountryGroup> get countriesGroups => _countriesGroups;

  List<Country> get searchedCountries => _searchedCountries;

  void clearSearchedCountries() {
    _searchedCountries.clear();
    notifyListeners();
  }

  void findCountryByName(String name) {
    if (name.length > 0) {
      _searchedCountries = [
        ..._countries!.where((country) =>
            country.name.toLowerCase().startsWith(name.toLowerCase()))
      ];
    } else {
      _searchedCountries.clear();
    }
    notifyListeners();
  }

  void selectCountry(Country country) {
    selectedCountry = country;
    _enableCountrySearch = false;
    _searchedCountries.clear();
    notifyListeners();
  }

  Country? findCountryByCode(int code) {
    return _countries!.firstWhereOrNull((country) => country.code == code);
  }

//#endregion
}
