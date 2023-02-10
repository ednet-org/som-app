enum CompanyRoleAtSom {
  buyer,
  provider,
  both;

  static CompanyRoleAtSom fromJson(String role) {
    return CompanyRoleAtSom.values
        .firstWhere((e) => e.toJson() == role.toLowerCase());
  }

  String toJson() {
    return toString().split('.').last;
  }
}
