enum CompanyType {
  dealer,
  manufacturer,
  serviceProvider,
  wholesaler;

  static CompanyType fromJson(String value) {
    return CompanyType.values.firstWhere((e) => e.name == value.toLowerCase());
  }

  String toJson() {
    return toString().split('.').last;
  }
}
