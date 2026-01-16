import 'package:test/test.dart';
import 'package:openapi/openapi.dart';


/// tests for AuditApi
void main() {
  final instance = Openapi().getAuditApi();

  group(AuditApi, () {
    // List audit log entries
    //
    //Future<BuiltList<AuditLogEntry>> auditGet({ int limit }) async
    test('test auditGet', () async {
      // TODO
    });

  });
}
