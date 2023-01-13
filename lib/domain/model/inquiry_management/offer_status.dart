class OfferStatus {
  static const String DRAFT = "draft";
  static const String PUBLISHED = "pending";
  static const String ACCEPTED = "accepted";
  static const String REJECTED = "rejected";

  static String fromString(String status) {
    switch (status) {
      case DRAFT:
        return DRAFT;
      case PUBLISHED:
        return PUBLISHED;
      case ACCEPTED:
        return ACCEPTED;
      case REJECTED:
        return REJECTED;
      default:
        return DRAFT;
    }
  }
}
