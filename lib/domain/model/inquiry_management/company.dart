import 'package:uuid/uuid.dart';

import 'company_role.dart';

class Company {
  final String id;
  final String name;
  final CompanyRoleAtSom role; // "buyer" or "provider" or "both"
  final String address;

  Company({
    required this.id,
    required this.name,
    required this.role,
    required this.address,
  });

  static Company fromJson(Map<String, dynamic> json) {
    var uuid = const Uuid();
    return Company(
      id: json['id'] ?? uuid.v4(),
      name: json['name'],
      role: CompanyRoleAtSom.fromJson(json['role']),
      address: json['address'],
    );
  }
}
