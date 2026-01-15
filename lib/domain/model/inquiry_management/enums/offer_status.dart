enum OfferStatus {
  open,
  offerCreated,
  lost,
  won,
  ignored;

  static OfferStatus fromJson(String value) {
    final normalized = value.toLowerCase();
    switch (normalized) {
      case 'offer_created':
      case 'offercreated':
      case 'offer_uploaded':
        return OfferStatus.offerCreated;
      case 'accepted':
      case 'won':
        return OfferStatus.won;
      case 'rejected':
      case 'lost':
        return OfferStatus.lost;
      case 'ignored':
        return OfferStatus.ignored;
      case 'open':
      default:
        return OfferStatus.open;
    }
  }

  String toJson() {
    switch (this) {
      case OfferStatus.offerCreated:
        return 'offer_created';
      case OfferStatus.won:
        return 'won';
      case OfferStatus.lost:
        return 'lost';
      case OfferStatus.ignored:
        return 'ignored';
      case OfferStatus.open:
        return 'open';
    }
  }
}
