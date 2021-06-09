import 'package:collection/collection.dart';
import 'package:telegram_clone_mobile/models/country.dart';

class CountryService {
  CountryService() {
    _countries = [
      for (final countryGroup in _countriesGroups) ...countryGroup.countries
    ];
  }

  late List<Country> _countries;
  List<CountryGroup> _countriesGroups = [
    CountryGroup('A', countries: [
      Country(
          name: 'Afghanistan',
          code: 93,
          mask: '### ### ###',
          format: '+## ### ### ###'),
      Country(
          name: 'Albania',
          code: 355,
          mask: '## ### ####',
          format: '+### ## ### ####'),
      Country(
          name: 'Armenia',
          code: 374,
          mask: '## ### ### #',
          format: '+### ## ### ### #'),
      Country(
          name: 'Australia',
          code: 61,
          mask: '### ### ###',
          format: '+## ### ### ###'),
    ]),
    CountryGroup('U', countries: [
      Country(
          name: 'Ukraine',
          code: 380,
          mask: '## ### ## ##',
          format: '+### (##) ### ## ##'),
      Country(
          name: 'USA',
          code: 1,
          mask: '### ### ####',
          format: '+# ### ### ####'),
      Country(
          name: 'United Arab Emirates',
          code: 971,
          mask: '## ### ####',
          format: '+### ## ### ####'),
      Country(
          name: 'United Kingdom',
          code: 44,
          mask: '#### ######',
          format: '+## #### ######'),
    ]),
    CountryGroup('R', countries: [
      Country(
          name: 'Russian Federation',
          code: 7,
          mask: '### ### ####',
          format: '+# ### ### ####'),
    ]),
  ];

  List<CountryGroup> getAllCountriesGroups() {
    return _countriesGroups;
  }

  List<Country> getAllCountries() {
    return _countries;
  }

  Country? findCountryByCode(int code) {
    return _countries.firstWhereOrNull((country) => country.code == code);
  }

  List<Country> findCountryByName(String name) {
    return _countries
        .where((country) =>
            country.name.toLowerCase().startsWith(name.trim().toLowerCase()))
        .toList();
  }
}
