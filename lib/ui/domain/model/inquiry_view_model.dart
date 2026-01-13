import 'package:openapi/openapi.dart' as api;

import 'package:som/domain/model/core/entity.dart';
import 'package:som/domain/model/inquiry_management/enums/inquiry_status.dart';
import 'package:som/ui/domain/model/cards/inquiry/inquiry_card_components/core/arr.dart';

class InquiryViewModel extends Entity<Arr> {
  final Arr<String> id;
  final Arr<String> title;
  final Arr<String> description;
  final Arr<String> category;
  final Arr<String> branch;
  final Arr<DateTime> publishingDate;
  final Arr<DateTime> expirationDate;
  @override
  final Arr<InquiryStatus> status;

  InquiryViewModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.branch,
    required this.publishingDate,
    required this.expirationDate,
    required this.status,
  });

  factory InquiryViewModel.fromApi(api.Inquiry inquiry) {
    final id = inquiry.id ?? '';
    final title = _buildTitle(inquiry, id);
    final description = inquiry.description ?? 'No description provided.';
    final branch = inquiry.branchId ?? 'Unknown branch';
    final category = inquiry.categoryId ?? 'Uncategorized';
    final createdAt = inquiry.createdAt ?? DateTime.now().toUtc();
    final deadline = inquiry.deadline ?? createdAt.add(const Duration(days: 7));
    return InquiryViewModel(
      id: Arr<String>(name: 'id', value: id),
      title: Arr<String>(name: 'title', value: title),
      description: Arr<String>(name: 'description', value: description),
      category: Arr<String>(name: 'category', value: category),
      branch: Arr<String>(name: 'branch', value: branch),
      publishingDate: Arr<DateTime>(name: 'publishingDate', value: createdAt),
      expirationDate: Arr<DateTime>(name: 'expirationDate', value: deadline),
      status: Arr<InquiryStatus>(
        name: 'status',
        value: _mapStatus(inquiry.status),
      ),
    );
  }

  static String _buildTitle(api.Inquiry inquiry, String id) {
    final company = inquiry.contactInfo?.companyName;
    if (company != null && company.trim().isNotEmpty) {
      return company;
    }
    final branch = inquiry.branchId;
    final category = inquiry.categoryId;
    if (branch != null && category != null) {
      return '$branch / $category';
    }
    if (branch != null) {
      return branch;
    }
    final shortId = id.isNotEmpty && id.length > 8 ? id.substring(0, 8) : id;
    return shortId.isEmpty ? 'Inquiry' : 'Inquiry $shortId';
  }

  static InquiryStatus _mapStatus(String? status) {
    switch (status?.toLowerCase()) {
      case 'draft':
        return InquiryStatus.draft;
      case 'open':
      case 'published':
        return InquiryStatus.published;
      case 'responded':
      case 'offer_created':
      case 'offer uploaded':
        return InquiryStatus.responded;
      case 'closed':
        return InquiryStatus.closed;
      case 'expired':
        return InquiryStatus.expired;
      default:
        return InquiryStatus.draft;
    }
  }

  @override
  Iterable<Arr> getDocumentAttributes() {
    return [title, description, category, branch, expirationDate];
  }

  @override
  Iterable<Arr> getFilterableAttributes() {
    return [title, description, category, branch, expirationDate, status];
  }

  @override
  Iterable<Arr> getSummaryAttributes() {
    return [title, description, category, branch, status];
  }
}
