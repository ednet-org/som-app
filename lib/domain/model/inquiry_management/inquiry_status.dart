class InquiryStatus {
  static const DRAFT = 'draft';
  static const PUBLISHED = 'published';
  static const RESPONDED = 'responded';
  static const CLOSED = 'closed';

  static fromString(String status) {
    switch (status) {
      case DRAFT:
        return DRAFT;
      case PUBLISHED:
        return PUBLISHED;
      case RESPONDED:
        return RESPONDED;
      case CLOSED:
        return CLOSED;
      default:
        throw Exception('Invalid status');
    }
  }
}
