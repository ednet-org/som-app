import 'company.dart';

class User {
  final String id;
  final String username;
  final String? userphonenumber;
  final String usermail;
  final String userrole; // "buyer", "provider", "som_employee", "som_admin"
  final Company company;

  User(
      {this.userphonenumber,
      required this.id,
      required this.username,
      required this.usermail,
      required this.userrole,
      required this.company});

  static User fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      userphonenumber: json['userphonenumber'],
      usermail: json['usermail'],
      userrole: json['userrole'],
      company: Company.fromJson(json['company']),
    );
  }
}
