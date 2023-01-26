enum CompanyRole {
  buyer,
  provider,
  both;

  static CompanyRole fromJson(String role) {
    switch (role) {
      case 'buyer':
        return CompanyRole.buyer;
      case 'provider':
        return CompanyRole.provider;
      case 'both':
        return CompanyRole.both;
      default:
        throw Exception('Unknown role');
    }
  }

  String toJson() {
    switch (this) {
      case CompanyRole.buyer:
        return 'buyer';
      case CompanyRole.provider:
        return 'provider';
      case CompanyRole.both:
        return 'both';
      default:
        throw Exception('Unknown role');
    }
  }
}
