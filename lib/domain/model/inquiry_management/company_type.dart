enum CompanyType {
  dealer,
  manufacturer,
  serviceProvider,
  wholesaler;

  static CompanyType fromJson(String value) {
    return CompanyType.values.firstWhere((e) => e.toString() == value);
  }

  String toJson() {
    return toString().split('.').last;
  }
}
