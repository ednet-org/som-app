enum CompanySize {
  unrestricted(0),
  upTo10(10),
  upTo50(50),
  upTo100(100),
  upTo500(500),
  over500(500);

  const CompanySize(this.value);

  final int value;

  static CompanySize fromInt(int value) {
    return CompanySize.values.firstWhere((e) => e.value == value);
  }

  static CompanySize fromString(String value) {
    return CompanySize.values.firstWhere((e) => e.toString() == value);
  }

  static CompanySize fromStringOrNull(String? value) {
    return value == null ? CompanySize.unrestricted : fromString(value);
  }

  static CompanySize fromIntOrNull(int? value) {
    return value == null ? CompanySize.unrestricted : fromInt(value);
  }

  String toShortString() {
    return toString().split('.').last;
  }

  int toInt() {
    return value;
  }

  static CompanySize fromJson(String value) {
    return CompanySize.values.firstWhere((e) => e.toString() == value);
  }

  String toJson() {
    return toString().split('.').last;
  }
}
