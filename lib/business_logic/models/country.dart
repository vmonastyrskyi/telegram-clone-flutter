class CountryGroup {
  CountryGroup(this.group, {required this.countries});

  final String group;
  final List<Country> countries;
}

class Country {
  Country({
    required this.name,
    required this.mask,
    required this.code,
  });

  final String name;
  final String mask;
  final int code;
}
