enum InquiryStatus {
  draft,
  published,
  responded,
  closed,
  expired;

  static InquiryStatus fromJson(String value) {
    return InquiryStatus.values.firstWhere((e) => e.toString() == value);
  }

  String toJson() {
    return toString().split('.').last;
  }
}
