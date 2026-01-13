import 'package:openapi/openapi.dart' as api;
import 'package:flutter_test/flutter_test.dart';

import 'package:som/ui/domain/model/inquiry_view_model.dart';
import 'package:som/domain/model/inquiry_management/enums/inquiry_status.dart';

void main() {
  test('InquiryViewModel maps API inquiry fields', () {
    final created = DateTime.utc(2025, 1, 1);
    final deadline = DateTime.utc(2025, 1, 5);
    final inquiry = api.Inquiry((b) => b
      ..id = 'inq-1'
      ..status = 'open'
      ..branchId = 'branch-1'
      ..categoryId = 'cat-1'
      ..description = 'Need demo'
      ..createdAt = created
      ..deadline = deadline);

    final viewModel = InquiryViewModel.fromApi(inquiry);

    expect(viewModel.id.value, 'inq-1');
    expect(viewModel.branch.value, 'branch-1');
    expect(viewModel.category.value, 'cat-1');
    expect(viewModel.description.value, 'Need demo');
    expect(viewModel.status.value, InquiryStatus.published);
    expect(viewModel.publishingDate.value, created);
    expect(viewModel.expirationDate.value, deadline);
  });

  test('InquiryViewModel maps closed status', () {
    final inquiry = api.Inquiry((b) => b..status = 'closed');
    final viewModel = InquiryViewModel.fromApi(inquiry);
    expect(viewModel.status.value, InquiryStatus.closed);
  });
}
