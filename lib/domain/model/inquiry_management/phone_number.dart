class PhoneNumber {
  final String number;

  const PhoneNumber({required this.number});

  static PhoneNumber fromJson(Map<String, dynamic> json) {
    return PhoneNumber(
      number: json['number'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'number': number,
    };
  }
}
