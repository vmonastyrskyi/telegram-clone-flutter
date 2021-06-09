import 'package:telegram_clone_mobile/locator.dart';
import 'package:telegram_clone_mobile/models/country.dart';
import 'package:telegram_clone_mobile/services/country_service.dart';
import 'package:telegram_clone_mobile/view_models/base_viewmodel.dart';

class SelectCountryViewModel extends BaseViewModel {
  SelectCountryViewModel() {
    _countriesGroups = _countryService.getAllCountriesGroups();
  }

  final CountryService _countryService = locator<CountryService>();

  List<CountryGroup> _countriesGroups = [];
  List<Country> _searchedCountries = [];
  bool _enableCountrySearch = false;

  List<CountryGroup> get countriesGroups => _countriesGroups;

  List<Country> get searchedCountries => _searchedCountries;

  bool get enableCountrySearch => _enableCountrySearch;

  set enableCountrySearch(bool value) {
    _enableCountrySearch = value;
    _searchedCountries.clear();
    notifyListeners();
  }

  void clearSearchedCountries() {
    _searchedCountries.clear();
    notifyListeners();
  }

  void findCountryByName(String name) {
    if (name.isNotEmpty) {
      _searchedCountries = _countryService.findCountryByName(name);
    } else {
      _searchedCountries.clear();
    }
    notifyListeners();
  }

  // void selectCountry(Country country) {
  //   _selectedCountry = country;
  //   _enableCountrySearch = false;
  //   _searchedCountries.clear();
  //   notifyListeners();
  // }
}
