import 'package:uuid/uuid.dart';

import 'company.dart';
import 'enums/company_role.dart';
import 'email.dart';
import 'phone_number.dart';
import 'user.dart';
import 'user_role.dart';

class Buyer extends User {
  const Buyer({
    required super.id,
    required super.username,
    required super.company,
    required super.roleAtCompany,
    required super.phoneNumber,
    required super.email,
  }) : super(roleAtSom: CompanyRoleAtSom.buyer);

  static Buyer fromJson(Map<String, dynamic> json) {
    return Buyer(
      id: json['id'] ?? const Uuid()
        ..v4(),
      username: json['username'],
      company: Company.fromJson(json['company']),
      roleAtCompany: UserRoleAtCompany.fromJson(json['roleAtCompany']),
      phoneNumber: PhoneNumber.fromJson(json),
      email: Email.fromJson(json),
    );
  }
}
