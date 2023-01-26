enum CompanySize {
  unrestricted(0),
  upTo10(10),
  upTo50(50),
  upTo100(100),
  upTo500(500),
  over500(500);

  const CompanySize(this.value);

  final int value;

  static CompanySize fromString(String value) {
    switch (value) {
      case 'unrestricted':
        return CompanySize.unrestricted;
      case 'upTo10':
        return CompanySize.upTo10;
      case 'upTo50':
        return CompanySize.upTo50;
      case 'upTo100':
        return CompanySize.upTo100;
      case 'upTo500':
        return CompanySize.upTo500;
      case 'over500':
        return CompanySize.over500;
      default:
        throw ArgumentError('Invalid CompanySize: $value');
    }
  }

  static CompanySize fromStringOrNull(String? value) {
    return value == null ? CompanySize.unrestricted : fromString(value);
  }

  String toShortString() {
    return toString().split('.').last;
  }

  int toInt() {
    return value;
  }

  static CompanySize fromJson(String value) {
    return CompanySize.values.firstWhere((e) => e.name == value.toLowerCase());
  }

  String toJson() {
    return toString().split('.').last;
  }
}
