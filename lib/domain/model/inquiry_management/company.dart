import 'user.dart';

class Company {
  final String id;
  final String name;
  final String role; // "buyer" or "provider"
  final String address;

  Company(
      {required this.id,
      required this.name,
      required this.role,
      required this.address,
      required List<User> employees});
}
