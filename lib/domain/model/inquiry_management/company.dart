import 'company_role.dart';

class Company {
  final String id;
  final String name;
  final CompanyRole role; // "buyer" or "provider"
  final String address;

  Company({
    required this.id,
    required this.name,
    required this.role,
    required this.address,
  });

  static Company fromJson(Map<String, dynamic> json) {
    return Company(
      id: json['id'],
      name: json['name'],
      role: json['role'],
      address: json['address'],
    );
  }
}
