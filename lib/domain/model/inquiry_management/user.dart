import 'company.dart';
import 'company_role.dart';
import 'email.dart';
import 'phone_number.dart';

class User {
  final String id;
  final String username;
  final Company company;
  final CompanyRole role;
  final PhoneNumber phoneNumber;
  final Email email;

  const User({
    required this.id,
    required this.username,
    required this.role,
    required this.phoneNumber,
    required this.email,
    required this.company,
  });

  static User fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      company: Company.fromJson(json['company']),
      role: CompanyRole.fromJson(json['role']),
      phoneNumber: PhoneNumber.fromJson(json['phoneNumber']),
      email: Email.fromJson(json['email']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'role': role.toJson(),
      'phoneNumber': phoneNumber.toJson(),
      'email': email.toJson(),
    };
  }
}

class Buyer extends User {
  const Buyer({
    required super.id,
    required super.username,
    required super.company,
    required super.phoneNumber,
    required super.email,
  }) : super(role: CompanyRole.buyer);

  static Buyer fromJson(Map<String, dynamic> json) {
    return Buyer(
      id: json['id'],
      username: json['username'],
      company: Company.fromJson(json['company']),
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
    required super.phoneNumber,
    required super.email,
  }) : super(role: CompanyRole.provider);

  static Provider fromJson(Map<String, dynamic> json) {
    return Provider(
      id: json['id'],
      username: json['username'],
      company: Company.fromJson(json['company']),
      phoneNumber: PhoneNumber.fromJson(json['phoneNumber']),
      email: Email.fromJson(json['email']),
    );
  }
}
