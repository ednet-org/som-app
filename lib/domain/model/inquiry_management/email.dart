class Email {
  final String address;

  const Email({
    required this.address,
  });

  static Email fromJson(Map<String, dynamic> json) {
    return Email(
      address: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': address,
    };
  }
}
