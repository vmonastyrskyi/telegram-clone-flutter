class CountryGroup {
  CountryGroup(this.group, {required this.countries});

  final String group;
  final List<Country> countries;
}

class Country {
  Country({
    required this.name,
    required this.mask,
    required this.format,
    required this.code,
  });

  final String name;
  final String mask;
  final String format;
  final int code;

  Country.fromJson(Map<String, dynamic> json)
      : this(
          name: json['name'] as String,
          mask: json['mask'] as String,
          format: json['format'] as String,
          code: json['code'] as int,
        );

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'mask': mask,
      'format': format,
      'code': code,
    };
  }
}
