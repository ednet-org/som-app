import 'company.dart';

class User {
  final String id;
  final String username;
  final String? phoneNumber;
  final String email;
  final String role; // "buyer", "provider", "som_employee", "som_admin"
  final Company company;

  User(
      {this.phoneNumber,
        required this.id,
        required this.username,
        required this.email,
        required this.role,
        required this.company});

  static User fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      role: json['role'],
      company: Company.fromJson(json['company']),
    );
  }
}
