import '../../models/models.dart';
import '../db.dart';

class InquiryRepository {
  InquiryRepository(this._db);

  final Database _db;

  void create(InquiryRecord inquiry) {
    _db.execute(
      '''
      INSERT INTO inquiries (
        id, buyer_company_id, created_by_user_id, status, branch_id, category_id,
        product_tags_json, deadline, delivery_zips, number_of_providers,
        description, pdf_path, provider_criteria_json, contact_json,
        notified_at, created_at, updated_at
      ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
      ''',
      [
        inquiry.id,
        inquiry.buyerCompanyId,
        inquiry.createdByUserId,
        inquiry.status,
        inquiry.branchId,
        inquiry.categoryId,
        encodeJson(inquiry.productTags),
        inquiry.deadline.toIso8601String(),
        inquiry.deliveryZips.join(','),
        inquiry.numberOfProviders,
        inquiry.description,
        inquiry.pdfPath,
        encodeJson(inquiry.providerCriteria.toJson()),
        encodeJson(inquiry.contactInfo.toJson()),
        inquiry.notifiedAt?.toIso8601String(),
        inquiry.createdAt.toIso8601String(),
        inquiry.updatedAt.toIso8601String(),
      ],
    );
  }

  InquiryRecord? findById(String id) {
    final rows = _db.select('SELECT * FROM inquiries WHERE id = ?', [id]);
    if (rows.isEmpty) {
      return null;
    }
    return _mapRow(rows.first);
  }

  List<InquiryRecord> listByBuyerCompany(String companyId) {
    final rows = _db.select(
      'SELECT * FROM inquiries WHERE buyer_company_id = ? ORDER BY created_at DESC',
      [companyId],
    );
    return rows.map(_mapRow).toList();
  }

  List<InquiryRecord> listAll({String? status}) {
    final rows = status == null
        ? _db.select('SELECT * FROM inquiries ORDER BY created_at DESC')
        : _db.select(
            'SELECT * FROM inquiries WHERE status = ? ORDER BY created_at DESC',
            [status],
          );
    return rows.map(_mapRow).toList();
  }

  List<InquiryRecord> listAssignedToProvider(String providerCompanyId) {
    final rows = _db.select(
      '''
      SELECT i.* FROM inquiries i
      JOIN inquiry_assignments ia ON ia.inquiry_id = i.id
      WHERE ia.provider_company_id = ?
      ORDER BY i.created_at DESC
      ''',
      [providerCompanyId],
    );
    return rows.map(_mapRow).toList();
  }

  void updateStatus(String id, String status) {
    _db.execute(
      'UPDATE inquiries SET status = ?, updated_at = ? WHERE id = ?',
      [status, DateTime.now().toUtc().toIso8601String(), id],
    );
  }

  void markNotified(String id, DateTime notifiedAt) {
    _db.execute(
      'UPDATE inquiries SET notified_at = ?, updated_at = ? WHERE id = ?',
      [notifiedAt.toIso8601String(), DateTime.now().toUtc().toIso8601String(), id],
    );
  }

  void assignToProviders({
    required String inquiryId,
    required String assignedByUserId,
    required List<String> providerCompanyIds,
  }) {
    final now = DateTime.now().toUtc().toIso8601String();
    for (final providerCompanyId in providerCompanyIds) {
      _db.execute(
        '''
        INSERT INTO inquiry_assignments (
          id, inquiry_id, provider_company_id, assigned_at, assigned_by_user_id
        ) VALUES (?, ?, ?, ?, ?)
        ''',
        [
          '${inquiryId}_$providerCompanyId',
          inquiryId,
          providerCompanyId,
          now,
          assignedByUserId,
        ],
      );
    }
  }

  InquiryRecord _mapRow(Map<String, Object?> row) {
    return InquiryRecord(
      id: row['id'] as String,
      buyerCompanyId: row['buyer_company_id'] as String,
      createdByUserId: row['created_by_user_id'] as String,
      status: row['status'] as String,
      branchId: row['branch_id'] as String,
      categoryId: row['category_id'] as String,
      productTags: decodeJsonList(row['product_tags_json'] as String)
          .map((e) => e.toString())
          .toList(),
      deadline: DateTime.parse(row['deadline'] as String),
      deliveryZips: (row['delivery_zips'] as String).split(','),
      numberOfProviders: row['number_of_providers'] as int,
      description: row['description'] as String?,
      pdfPath: row['pdf_path'] as String?,
      providerCriteria: ProviderCriteria.fromJson(
        decodeJsonMap(row['provider_criteria_json'] as String),
      ),
      contactInfo: ContactInfo.fromJson(
        decodeJsonMap(row['contact_json'] as String),
      ),
      notifiedAt: row['notified_at'] == null
          ? null
          : DateTime.parse(row['notified_at'] as String),
      createdAt: DateTime.parse(row['created_at'] as String),
      updatedAt: DateTime.parse(row['updated_at'] as String),
    );
  }
}
