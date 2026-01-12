import '../infrastructure/db.dart';

class StatisticsService {
  StatisticsService(this._db);

  final Database _db;

  Map<String, int> buyerStats({required String companyId, String? userId, DateTime? from, DateTime? to}) {
    final where = <String>['buyer_company_id = ?'];
    final args = <Object?>[companyId];
    if (userId != null) {
      where.add('created_by_user_id = ?');
      args.add(userId);
    }
    if (from != null) {
      where.add('created_at >= ?');
      args.add(from.toIso8601String());
    }
    if (to != null) {
      where.add('created_at <= ?');
      args.add(to.toIso8601String());
    }
    final openRows = _db.select(
      'SELECT COUNT(*) as count FROM inquiries ${_where(where..add('status = ?'))}',
      [...args, 'open'],
    );
    where.removeLast();
    final closedRows = _db.select(
      'SELECT COUNT(*) as count FROM inquiries ${_where(where..add('status = ?'))}',
      [...args, 'closed'],
    );
    return {
      'open': openRows.first['count'] as int,
      'closed': closedRows.first['count'] as int,
    };
  }

  Map<String, int> providerStats({required String companyId, DateTime? from, DateTime? to}) {
    final where = <String>['provider_company_id = ?'];
    final args = <Object?>[companyId];
    if (from != null) {
      where.add('created_at >= ?');
      args.add(from.toIso8601String());
    }
    if (to != null) {
      where.add('created_at <= ?');
      args.add(to.toIso8601String());
    }
    final openRows = _db.select(
      'SELECT COUNT(*) as count FROM offers ${_where(where..add('status = ?'))}',
      [...args, 'open'],
    );
    where.removeLast();
    final createdRows = _db.select(
      'SELECT COUNT(*) as count FROM offers ${_where(where..add('status = ?'))}',
      [...args, 'offer_uploaded'],
    );
    where.removeLast();
    final lostRows = _db.select(
      'SELECT COUNT(*) as count FROM offers ${_where(where..add('status = ?'))}',
      [...args, 'rejected'],
    );
    where.removeLast();
    final wonRows = _db.select(
      'SELECT COUNT(*) as count FROM offers ${_where(where..add('status = ?'))}',
      [...args, 'accepted'],
    );
    return {
      'open': openRows.first['count'] as int,
      'offer_created': createdRows.first['count'] as int,
      'lost': lostRows.first['count'] as int,
      'won': wonRows.first['count'] as int,
      'ignored': 0,
    };
  }

  Map<String, int> consultantStatusStats({DateTime? from, DateTime? to}) {
    final where = <String>[];
    final args = <Object?>[];
    if (from != null) {
      where.add('created_at >= ?');
      args.add(from.toIso8601String());
    }
    if (to != null) {
      where.add('created_at <= ?');
      args.add(to.toIso8601String());
    }
    final openRows = _db.select(
      'SELECT COUNT(*) as count FROM inquiries ${_where(where..add('status = ?'))}',
      [...args, 'open'],
    );
    where.removeLast();
    final closedRows = _db.select(
      'SELECT COUNT(*) as count FROM inquiries ${_where(where..add('status = ?'))}',
      [...args, 'closed'],
    );
    return {
      'open': openRows.first['count'] as int,
      'closed': closedRows.first['count'] as int,
    };
  }
}

String _where(List<String> parts) => parts.isEmpty ? '' : 'WHERE ${parts.join(' AND ')}';
