class ProviderCriteria {
  final String location;
  final String companyType;
  final String companySize;

  ProviderCriteria(
      {required this.location,
      required this.companyType,
      required this.companySize});

  static ProviderCriteria fromJson(Map<String, dynamic> json) {
    return ProviderCriteria(
      location: json['location'],
      companyType: json['companyType'],
      companySize: json['companySize'],
    );
  }
}
