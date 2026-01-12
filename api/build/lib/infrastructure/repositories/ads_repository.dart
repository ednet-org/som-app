import '../../models/models.dart';
import '../db.dart';

class AdsRepository {
  AdsRepository(this._db);

  final Database _db;

  void create(AdRecord ad) {
    _db.execute(
      '''
      INSERT INTO ads (
        id, company_id, type, status, branch_id, url, image_path, headline,
        description, start_date, end_date, banner_date, created_at, updated_at
      ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
      ''',
      [
        ad.id,
        ad.companyId,
        ad.type,
        ad.status,
        ad.branchId,
        ad.url,
        ad.imagePath,
        ad.headline,
        ad.description,
        ad.startDate?.toIso8601String(),
        ad.endDate?.toIso8601String(),
        ad.bannerDate?.toIso8601String(),
        ad.createdAt.toIso8601String(),
        ad.updatedAt.toIso8601String(),
      ],
    );
  }

  List<AdRecord> listActive({String? branchId}) {
    final rows = branchId == null
        ? _db.select(
            'SELECT * FROM ads WHERE status = ? ORDER BY created_at DESC',
            ['active'],
          )
        : _db.select(
            'SELECT * FROM ads WHERE status = ? AND branch_id = ? ORDER BY created_at DESC',
            ['active', branchId],
          );
    return rows.map(_mapRow).toList();
  }

  List<AdRecord> listByCompany(String companyId) {
    final rows = _db.select(
      'SELECT * FROM ads WHERE company_id = ? ORDER BY created_at DESC',
      [companyId],
    );
    return rows.map(_mapRow).toList();
  }

  int countActiveByCompanyInMonth(String companyId, DateTime month) {
    final start = DateTime.utc(month.year, month.month, 1);
    final end = DateTime.utc(month.year, month.month + 1, 1);
    final rows = _db.select(
      '''
      SELECT COUNT(*) as count FROM ads
      WHERE company_id = ? AND status = 'active' AND created_at >= ? AND created_at < ?
      ''',
      [companyId, start.toIso8601String(), end.toIso8601String()],
    );
    return rows.first['count'] as int;
  }

  int countBannerForDate(DateTime date) {
    final day = DateTime.utc(date.year, date.month, date.day);
    final nextDay = day.add(const Duration(days: 1));
    final rows = _db.select(
      '''
      SELECT COUNT(*) as count FROM ads
      WHERE type = 'banner' AND banner_date >= ? AND banner_date < ?
      ''',
      [day.toIso8601String(), nextDay.toIso8601String()],
    );
    return rows.first['count'] as int;
  }

  AdRecord? findById(String id) {
    final rows = _db.select('SELECT * FROM ads WHERE id = ?', [id]);
    if (rows.isEmpty) {
      return null;
    }
    return _mapRow(rows.first);
  }

  void update(AdRecord ad) {
    _db.execute(
      '''
      UPDATE ads SET
        status = ?,
        branch_id = ?,
        url = ?,
        image_path = ?,
        headline = ?,
        description = ?,
        start_date = ?,
        end_date = ?,
        banner_date = ?,
        updated_at = ?
      WHERE id = ?
      ''',
      [
        ad.status,
        ad.branchId,
        ad.url,
        ad.imagePath,
        ad.headline,
        ad.description,
        ad.startDate?.toIso8601String(),
        ad.endDate?.toIso8601String(),
        ad.bannerDate?.toIso8601String(),
        ad.updatedAt.toIso8601String(),
        ad.id,
      ],
    );
  }

  void delete(String id) {
    _db.execute('DELETE FROM ads WHERE id = ?', [id]);
  }

  AdRecord _mapRow(Map<String, Object?> row) {
    return AdRecord(
      id: row['id'] as String,
      companyId: row['company_id'] as String,
      type: row['type'] as String,
      status: row['status'] as String,
      branchId: row['branch_id'] as String,
      url: row['url'] as String,
      imagePath: row['image_path'] as String,
      headline: row['headline'] as String?,
      description: row['description'] as String?,
      startDate: row['start_date'] == null
          ? null
          : DateTime.parse(row['start_date'] as String),
      endDate: row['end_date'] == null
          ? null
          : DateTime.parse(row['end_date'] as String),
      bannerDate: row['banner_date'] == null
          ? null
          : DateTime.parse(row['banner_date'] as String),
      createdAt: DateTime.parse(row['created_at'] as String),
      updatedAt: DateTime.parse(row['updated_at'] as String),
    );
  }
}
