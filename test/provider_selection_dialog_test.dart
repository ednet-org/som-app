import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:openapi/openapi.dart';
import 'package:som/ui/pages/inquiry/widgets/provider_selection_dialog.dart';
import 'package:som/ui/widgets/design_system/som_badge.dart';

void main() {
  testWidgets('ProviderSelectionDialog shows AI badge for AI taxonomy', (
    tester,
  ) async {
    final provider = ProviderSummary(
      (b) => b
        ..companyId = 'company-1'
        ..companyName = 'Media Markt'
        ..companySize = '51-100'
        ..providerType = 'haendler'
        ..branchIds.replace(['branch-1'])
        ..branchAssignments.replace([
          CompanyBranchAssignment(
            (b) => b
              ..branchId = 'branch-1'
              ..branchName = 'Gastronomy'
              ..source_ = 'openai'
              ..confidence = 0.72
              ..status = 'pending',
          ),
        ])
        ..categoryAssignments.replace([
          CompanyCategoryAssignment(
            (b) => b
              ..categoryId = 'cat-1'
              ..categoryName = 'Coffee'
              ..branchId = 'branch-1'
              ..branchName = 'Gastronomy'
              ..source_ = 'openai'
              ..confidence = 0.65
              ..status = 'pending',
          ),
        ]),
    );

    Future<ProviderSearchResult> loadProviders({
      required int limit,
      required int offset,
      String? search,
      String? branchId,
      String? categoryId,
      String? companySize,
      String? providerType,
      String? zipPrefix,
    }) async {
      return ProviderSearchResult(
        providers: [provider],
        totalCount: 1,
        hasMore: false,
      );
    }

    await tester.pumpWidget(
      MaterialApp(
        home: ProviderSelectionDialog(
          branches: const [],
          maxProviders: 3,
          loadProviders: loadProviders,
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(SomBadge), findsOneWidget);
    expect(find.text('AI 72%'), findsOneWidget);
  });
}
