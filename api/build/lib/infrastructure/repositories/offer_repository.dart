import '../../models/models.dart';
import '../db.dart';

class OfferRepository {
  OfferRepository(this._db);

  final Database _db;

  void create(OfferRecord offer) {
    _db.execute(
      '''
      INSERT INTO offers (
        id, inquiry_id, provider_company_id, provider_user_id, status,
        pdf_path, forwarded_at, resolved_at, buyer_decision, provider_decision,
        created_at
      ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
      ''',
      [
        offer.id,
        offer.inquiryId,
        offer.providerCompanyId,
        offer.providerUserId,
        offer.status,
        offer.pdfPath,
        offer.forwardedAt?.toIso8601String(),
        offer.resolvedAt?.toIso8601String(),
        offer.buyerDecision,
        offer.providerDecision,
        offer.createdAt.toIso8601String(),
      ],
    );
  }

  List<OfferRecord> listByInquiry(String inquiryId) {
    final rows = _db.select(
      'SELECT * FROM offers WHERE inquiry_id = ? ORDER BY created_at DESC',
      [inquiryId],
    );
    return rows.map(_mapRow).toList();
  }

  OfferRecord? findById(String id) {
    final rows = _db.select('SELECT * FROM offers WHERE id = ?', [id]);
    if (rows.isEmpty) {
      return null;
    }
    return _mapRow(rows.first);
  }

  void updateStatus({
    required String id,
    required String status,
    String? buyerDecision,
    String? providerDecision,
    DateTime? forwardedAt,
    DateTime? resolvedAt,
  }) {
    _db.execute(
      '''
      UPDATE offers SET
        status = ?,
        buyer_decision = ?,
        provider_decision = ?,
        forwarded_at = ?,
        resolved_at = ?
      WHERE id = ?
      ''',
      [
        status,
        buyerDecision,
        providerDecision,
        forwardedAt?.toIso8601String(),
        resolvedAt?.toIso8601String(),
        id,
      ],
    );
  }

  OfferRecord _mapRow(Map<String, Object?> row) {
    return OfferRecord(
      id: row['id'] as String,
      inquiryId: row['inquiry_id'] as String,
      providerCompanyId: row['provider_company_id'] as String,
      providerUserId: row['provider_user_id'] as String?,
      status: row['status'] as String,
      pdfPath: row['pdf_path'] as String?,
      forwardedAt: row['forwarded_at'] == null
          ? null
          : DateTime.parse(row['forwarded_at'] as String),
      resolvedAt: row['resolved_at'] == null
          ? null
          : DateTime.parse(row['resolved_at'] as String),
      buyerDecision: row['buyer_decision'] as String?,
      providerDecision: row['provider_decision'] as String?,
      createdAt: DateTime.parse(row['created_at'] as String),
    );
  }
}
