enum OfferStatus {
  draft,
  published,
  accepted,
  rejected,
  static;

  static OfferStatus fromJson(String value) {
    return OfferStatus.values.firstWhere((e) => e.name == value.toLowerCase());
  }

  String toJson() {
    return toString().split('.').last;
  }
}
