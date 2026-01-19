/// Loader for branches, categories, and company taxonomy mappings.
library;

import '../mappers/entity_to_record.dart';
import '../models/business_entity.dart';
import '../utils/name_normalizer.dart';
import 'seed_config.dart';
import 'supabase_client.dart';

class TaxonomyLoader {
  TaxonomyLoader({
    required SeedSupabaseClient client,
    required SeedConfig config,
  })  : _client = client,
        _config = config,
        _mapper = EntityToRecordMapper();

  final SeedSupabaseClient _client;
  final SeedConfig _config;
  final EntityToRecordMapper _mapper;

  Future<TaxonomyLoadResult> load({
    required List<BusinessEntity> entities,
    void Function(int processed, int total, String message)? onProgress,
  }) async {
    onProgress?.call(0, entities.length, 'Collecting taxonomy records...');

    final branchRecords = <String, Map<String, dynamic>>{};
    final categoryRecords = <String, Map<String, dynamic>>{};
    final companyBranchRecords = <String, Map<String, dynamic>>{};
    final companyCategoryRecords = <String, Map<String, dynamic>>{};

    final now = DateTime.now().toUtc().toIso8601String();
    var processed = 0;

    for (final entity in entities) {
      processed++;
      if (!_isMaterialProvider(entity.providerType)) {
        continue;
      }
      final taxonomy = entity.taxonomy;
      if (taxonomy.isEmpty) {
        continue;
      }
      final branchName = taxonomy.branchName?.trim();
      final categoryName = taxonomy.categoryName?.trim();
      final branchExternalId = (taxonomy.branchId?.trim().isNotEmpty == true)
          ? taxonomy.branchId!.trim()
          : (branchName?.isNotEmpty == true
              ? normalizeTaxonomyName(branchName!)
              : null);
      final categoryExternalId =
          (taxonomy.categoryId?.trim().isNotEmpty == true && branchExternalId != null)
              ? '$branchExternalId:${taxonomy.categoryId!.trim()}'
              : (categoryName?.isNotEmpty == true && branchExternalId != null
                  ? 'name:$branchExternalId:${normalizeTaxonomyName(categoryName!)}'
                  : null);

      String? branchId;
      if (branchExternalId != null && branchExternalId.isNotEmpty) {
        branchId = _mapper.generateBranchId(branchExternalId);
        branchRecords.putIfAbsent(branchExternalId, () {
          final name =
              branchName?.isNotEmpty == true ? branchName! : branchExternalId;
          return {
            'id': branchId,
            'name': name,
            'external_id': branchExternalId,
            'normalized_name': normalizeTaxonomyName(name),
            'status': 'active',
          };
        });
      }

      String? categoryId;
      if (categoryExternalId != null &&
          categoryExternalId.isNotEmpty &&
          branchId != null) {
        categoryId = _mapper.generateCategoryId(categoryExternalId);
        categoryRecords.putIfAbsent(categoryExternalId, () {
          final name = categoryName?.isNotEmpty == true
              ? categoryName!
              : categoryExternalId;
          return {
            'id': categoryId,
            'branch_id': branchId,
            'name': name,
            'external_id': categoryExternalId,
            'normalized_name': normalizeTaxonomyName(name),
            'status': 'active',
          };
        });
      }

      final companyId = _mapper.generateCompanyId(entity.id);
      if (branchId != null) {
        final key = '$companyId|$branchId';
        companyBranchRecords.putIfAbsent(key, () {
          return {
            'company_id': companyId,
            'branch_id': branchId,
            'source': 'etl',
            'confidence': taxonomy.inference?.confidence,
            'status': 'active',
            'created_at': now,
            'updated_at': now,
          };
        });
      }
      if (categoryId != null) {
        final key = '$companyId|$categoryId';
        companyCategoryRecords.putIfAbsent(key, () {
          return {
            'company_id': companyId,
            'category_id': categoryId,
            'source': 'etl',
            'confidence': taxonomy.inference?.confidence,
            'status': 'active',
            'created_at': now,
            'updated_at': now,
          };
        });
      }
    }

    onProgress?.call(
        processed, entities.length, 'Upserting taxonomy tables...');

    final branchResult = await _client.batchUpsert(
      table: 'branches',
      records: branchRecords.values.toList(),
      conflictColumn: 'external_id',
    );
    final categoryResult = await _client.batchUpsert(
      table: 'categories',
      records: categoryRecords.values.toList(),
      conflictColumn: 'branch_id,external_id',
    );
    final companyBranchResult = await _client.batchUpsert(
      table: 'company_branches',
      records: companyBranchRecords.values.toList(),
      conflictColumn: 'company_id,branch_id',
    );
    final companyCategoryResult = await _client.batchUpsert(
      table: 'company_categories',
      records: companyCategoryRecords.values.toList(),
      conflictColumn: 'company_id,category_id',
    );

    return TaxonomyLoadResult(
      branchResult: branchResult,
      categoryResult: categoryResult,
      companyBranchResult: companyBranchResult,
      companyCategoryResult: companyCategoryResult,
      branches: branchRecords.length,
      categories: categoryRecords.length,
      companyBranches: companyBranchRecords.length,
      companyCategories: companyCategoryRecords.length,
      dryRun: _config.dryRun,
    );
  }

  bool _isMaterialProvider(ProviderType type) {
    return type == ProviderType.haendler ||
        type == ProviderType.grosshaendler ||
        type == ProviderType.hersteller;
  }
}

class TaxonomyLoadResult {
  TaxonomyLoadResult({
    required this.branchResult,
    required this.categoryResult,
    required this.companyBranchResult,
    required this.companyCategoryResult,
    required this.branches,
    required this.categories,
    required this.companyBranches,
    required this.companyCategories,
    required this.dryRun,
  });

  final BatchUpsertResult branchResult;
  final BatchUpsertResult categoryResult;
  final BatchUpsertResult companyBranchResult;
  final BatchUpsertResult companyCategoryResult;
  final int branches;
  final int categories;
  final int companyBranches;
  final int companyCategories;
  final bool dryRun;

  bool get success =>
      !branchResult.hasErrors &&
      !categoryResult.hasErrors &&
      !companyBranchResult.hasErrors &&
      !companyCategoryResult.hasErrors;

  @override
  String toString() {
    if (dryRun) {
      return 'TaxonomyLoadResult (dry run): '
          'branches=$branches, categories=$categories, '
          'companyBranches=$companyBranches, companyCategories=$companyCategories';
    }
    return 'TaxonomyLoadResult: '
        'branches=$branches, categories=$categories, '
        'companyBranches=$companyBranches, companyCategories=$companyCategories';
  }
}
