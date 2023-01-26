import 'package:uuid/uuid.dart';

import 'company.dart';
import 'company_role.dart';
import 'email.dart';
import 'phone_number.dart';
import 'user_role.dart';

/// [User] is a person who can be a [Buyer] or [Provider] or both, and he have a role
/// in the [Company] he belongs to :
///   - [roleAtSom] is [CompanyRoleAtSom] of the [User] on SOM Platform, can be [Buyer] or [Provider] or both
///   - [roleAtCompany] is [UserRoleAtCompany] of the [User] in the [Company] he belongs to, can be [UserRoleAtCompany.admin] or [UserRoleAtCompany.employee]
class User {
  final String id;
  final String username;
  final Company company;
  final CompanyRoleAtSom roleAtSom;
  final UserRoleAtCompany roleAtCompany;
  final PhoneNumber? phoneNumber;
  final Email email;

  const User({
    required this.id,
    required this.username,
    required this.roleAtSom,
    required this.roleAtCompany,
    this.phoneNumber,
    required this.email,
    required this.company,
  });

  static User fromJson(Map<String, dynamic> json) {
    var uuid = const Uuid();

    return User(
      id: json['id'] ?? uuid.v4(),
      username: json['username'],
      company: Company.fromJson(json['company']),
      roleAtSom: CompanyRoleAtSom.fromJson(json['roleAtSom']),
      roleAtCompany: UserRoleAtCompany.fromJson(json['roleAtCompany']),
      phoneNumber:
          json['phoneNumber'] != null ? PhoneNumber.fromJson(json) : null,
      email: Email.fromJson(json),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'roleAtSom': roleAtSom.toJson(),
      'phoneNumber': phoneNumber?.toJson(),
      'email': email.toJson(),
    };
  }
}

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
      phoneNumber: PhoneNumber.fromJson(json['phoneNumber']),
      email: Email.fromJson(json['email']),
    );
  }
}

class Provider extends User {
  const Provider({
    required super.id,
    required super.username,
    required super.company,
    required super.roleAtCompany,
    required super.phoneNumber,
    required super.email,
  }) : super(roleAtSom: CompanyRoleAtSom.provider);

  static Provider fromJson(Map<String, dynamic> json) {
    return Provider(
      id: json['id'] ?? const Uuid()
        ..v4(),
      username: json['username'],
      company: Company.fromJson(json['company']),
      roleAtCompany: UserRoleAtCompany.fromJson(json['roleAtCompany']),
      phoneNumber: PhoneNumber.fromJson(json['phoneNumber']),
      email: Email.fromJson(json['email']),
    );
  }
}
