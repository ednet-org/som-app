enum UserRoleAtCompany {
  admin,
  employee;

  factory UserRoleAtCompany.fromJson(String json) {
    return UserRoleAtCompany.values
        .firstWhere((e) => e.toJson() == json.toLowerCase());
  }

  String toJson() {
    return toString().split('.').last;
  }
}
