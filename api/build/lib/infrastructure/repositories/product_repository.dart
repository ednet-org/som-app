import 'package:supabase/supabase.dart';

import '../../models/models.dart';

class ProductRepository {
  ProductRepository(this._client);

  final SupabaseClient _client;

  Future<void> create(ProductRecord product) async {
    await _client.from('products').insert({
      'id': product.id,
      'company_id': product.companyId,
      'name': product.name,
      'created_at': product.createdAt.toIso8601String(),
    });
  }

  Future<List<ProductRecord>> listByCompany(String companyId) async {
    final rows = await _client
        .from('products')
        .select()
        .eq('company_id', companyId)
        .order('name') as List<dynamic>;
    return rows.map((row) => _mapRow(row as Map<String, dynamic>)).toList();
  }

  Future<ProductRecord?> findById(String id) async {
    final rows =
        await _client.from('products').select().eq('id', id) as List<dynamic>;
    if (rows.isEmpty) {
      return null;
    }
    return _mapRow(rows.first as Map<String, dynamic>);
  }

  Future<void> update(ProductRecord product) async {
    await _client.from('products').update({
      'name': product.name,
    }).eq('id', product.id);
  }

  Future<void> delete(String id) async {
    await _client.from('products').delete().eq('id', id);
  }

  ProductRecord _mapRow(Map<String, dynamic> row) {
    return ProductRecord(
      id: row['id'] as String,
      companyId: row['company_id'] as String,
      name: row['name'] as String,
      createdAt: parseDate(row['created_at']),
    );
  }
}
