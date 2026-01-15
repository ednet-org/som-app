import 'package:openapi/openapi.dart';

/// Filter parameters for inquiry queries.
class InquiryFilter {
  final String? status;
  final String? branchId;
  final String? branch;
  final String? providerType;
  final String? providerSize;
  final DateTime? createdFrom;
  final DateTime? createdTo;
  final DateTime? deadlineFrom;
  final DateTime? deadlineTo;
  final List<String>? editorIds;

  const InquiryFilter({
    this.status,
    this.branchId,
    this.branch,
    this.providerType,
    this.providerSize,
    this.createdFrom,
    this.createdTo,
    this.deadlineFrom,
    this.deadlineTo,
    this.editorIds,
  });

  bool get isEmpty =>
      status == null &&
      branchId == null &&
      branch == null &&
      providerType == null &&
      providerSize == null &&
      createdFrom == null &&
      createdTo == null &&
      deadlineFrom == null &&
      deadlineTo == null &&
      editorIds == null;
}

/// Repository interface for Inquiry operations.
///
/// Abstracts data access from the UI layer, enabling:
/// - Testability via mock implementations
/// - Caching layer insertion
/// - Clean separation of concerns
abstract class IInquiryRepository {
  /// Retrieves a list of inquiries with optional filtering.
  Future<List<Inquiry>> getInquiries({InquiryFilter? filter});

  /// Retrieves a single inquiry by ID.
  Future<Inquiry?> getInquiry(String id);

  /// Creates a new inquiry.
  Future<Inquiry> createInquiry(CreateInquiryRequest request);

  /// Closes an inquiry.
  Future<void> closeInquiry(String inquiryId);

  /// Ignores an inquiry.
  Future<void> ignoreInquiry(String inquiryId);

  /// Assigns providers to an inquiry.
  Future<void> assignProviders(String inquiryId, List<String> providerIds);

  /// Uploads a PDF attachment to an inquiry.
  Future<String?> uploadPdf(String inquiryId, List<int> fileBytes, String fileName);

  /// Removes the PDF attachment from an inquiry.
  Future<void> removePdf(String inquiryId);

  /// Retrieves offers for an inquiry.
  Future<List<Offer>> getOffers(String inquiryId);

  /// Accepts an offer.
  Future<void> acceptOffer(String offerId);

  /// Rejects an offer.
  Future<void> rejectOffer(String offerId);
}
