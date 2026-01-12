import 'package:supabase/supabase.dart';

import '../../models/models.dart';

class AdsRepository {
  AdsRepository(this._client);

  final SupabaseClient _client;

  Future<void> create(AdRecord ad) async {
    await _client.from('ads').insert({
      'id': ad.id,
      'company_id': ad.companyId,
      'type': ad.type,
      'status': ad.status,
      'branch_id': ad.branchId,
      'url': ad.url,
      'image_path': ad.imagePath,
      'headline': ad.headline,
      'description': ad.description,
      'start_date': ad.startDate?.toIso8601String(),
      'end_date': ad.endDate?.toIso8601String(),
      'banner_date': ad.bannerDate?.toIso8601String(),
      'created_at': ad.createdAt.toIso8601String(),
      'updated_at': ad.updatedAt.toIso8601String(),
    });
  }

  Future<List<AdRecord>> listActive({String? branchId}) async {
    var query = _client.from('ads').select().eq('status', 'active');
    if (branchId != null) {
      query = query.eq('branch_id', branchId);
    }
    final rows =
        await query.order('created_at', ascending: false) as List<dynamic>;
    return rows.map((row) => _mapRow(row as Map<String, dynamic>)).toList();
  }

  Future<List<AdRecord>> listAll({
    String? companyId,
    String? status,
  }) async {
    var query = _client.from('ads').select();
    if (companyId != null) {
      query = query.eq('company_id', companyId);
    }
    if (status != null && status.isNotEmpty) {
      query = query.eq('status', status);
    }
    final rows =
        await query.order('created_at', ascending: false) as List<dynamic>;
    return rows.map((row) => _mapRow(row as Map<String, dynamic>)).toList();
  }

  Future<List<AdRecord>> listByCompany(String companyId) async {
    return listAll(companyId: companyId);
  }

  Future<int> countActiveByCompanyInMonth(
      String companyId, DateTime month) async {
    final start = DateTime.utc(month.year, month.month, 1);
    final end = DateTime.utc(month.year, month.month + 1, 1);
    final rows = await _client
        .from('ads')
        .select('id')
        .eq('company_id', companyId)
        .eq('status', 'active')
        .gte('created_at', start.toIso8601String())
        .lt('created_at', end.toIso8601String()) as List<dynamic>;
    return rows.length;
  }

  Future<int> countBannerForDate(DateTime date) async {
    final day = DateTime.utc(date.year, date.month, date.day);
    final nextDay = day.add(const Duration(days: 1));
    final rows = await _client
        .from('ads')
        .select('id')
        .eq('type', 'banner')
        .gte('banner_date', day.toIso8601String())
        .lt('banner_date', nextDay.toIso8601String()) as List<dynamic>;
    return rows.length;
  }

  Future<AdRecord?> findById(String id) async {
    final rows =
        await _client.from('ads').select().eq('id', id) as List<dynamic>;
    if (rows.isEmpty) {
      return null;
    }
    return _mapRow(rows.first as Map<String, dynamic>);
  }

  Future<void> update(AdRecord ad) async {
    await _client.from('ads').update({
      'status': ad.status,
      'branch_id': ad.branchId,
      'url': ad.url,
      'image_path': ad.imagePath,
      'headline': ad.headline,
      'description': ad.description,
      'start_date': ad.startDate?.toIso8601String(),
      'end_date': ad.endDate?.toIso8601String(),
      'banner_date': ad.bannerDate?.toIso8601String(),
      'updated_at': ad.updatedAt.toIso8601String(),
    }).eq('id', ad.id);
  }

  Future<void> delete(String id) async {
    await _client.from('ads').delete().eq('id', id);
  }

  AdRecord _mapRow(Map<String, dynamic> row) {
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
      startDate: parseDateOrNull(row['start_date']),
      endDate: parseDateOrNull(row['end_date']),
      bannerDate: parseDateOrNull(row['banner_date']),
      createdAt: parseDate(row['created_at']),
      updatedAt: parseDate(row['updated_at']),
    );
  }
}
