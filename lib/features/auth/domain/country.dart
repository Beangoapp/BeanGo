class Country {
  const Country({
    required this.isoCode,
    required this.dialCode,
    required this.flag,
  });

  final String isoCode;
  final String dialCode;
  final String flag;
}

abstract final class SupportedCountries {
  static const all = [
    Country(isoCode: 'QA', dialCode: '+974', flag: '🇶🇦'),
    Country(isoCode: 'SA', dialCode: '+966', flag: '🇸🇦'),
    Country(isoCode: 'AE', dialCode: '+971', flag: '🇦🇪'),
    Country(isoCode: 'GB', dialCode: '+44', flag: '🇬🇧'),
    Country(isoCode: 'US', dialCode: '+1', flag: '🇺🇸'),
  ];

  static Country forLocale(String? countryCode) => all.firstWhere(
    (country) => country.isoCode == countryCode,
    orElse: () => all.last,
  );
}
