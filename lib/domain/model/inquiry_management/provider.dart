import 'package:uuid/uuid.dart';

import 'company.dart';
import 'company_role.dart';
import 'email.dart';
import 'phone_number.dart';
import 'user.dart';
import 'user_role.dart';

const uuid = Uuid();

class Provider extends User {
  Provider({
    required super.id,
    required super.username,
    required super.company,
    required super.roleAtCompany,
    required super.phoneNumber,
    required super.email,
  }) : super(roleAtSom: CompanyRoleAtSom.provider);

  static Provider fromJson(Map<String, dynamic> json) {
    return Provider(
      id: json['id'] ?? uuid.v4(),
      username: json['username'],
      company: Company.fromJson(json['company']),
      roleAtCompany: UserRoleAtCompany.fromJson(json['roleAtCompany']),
      phoneNumber: PhoneNumber.fromJson(json),
      email: Email.fromJson(json),
    );
  }
}
