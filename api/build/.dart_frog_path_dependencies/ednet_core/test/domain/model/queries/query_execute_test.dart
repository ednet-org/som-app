import 'package:ednet_core/ednet_core.dart';
import 'package:test/test.dart';

class _RepositoryWithExecuteQuery {
  Future<EntityQueryResult<DynamicEntity>> executeQuery(Query query) async {
    return EntityQueryResult<DynamicEntity>.success(
      <DynamicEntity>[],
      concept: query.concept,
    );
  }
}

void main() {
  group('Query.execute', () {
    late Concept concept;

    setUp(() {
      final model = Model(Domain('Test'), 'TestModel');
      concept = Concept(model, 'TestConcept');
    });

    test('returns failure result when repository lacks executeQuery', () async {
      final query = Query('TestQuery', concept);
      final result = await query.execute(Object());
      expect(result.isSuccess, isFalse);
      expect(result.errorMessage, isNotNull);
    });

    test('delegates to repository.executeQuery when available', () async {
      final query = Query('TestQuery', concept);
      final result = await query.execute(_RepositoryWithExecuteQuery());
      expect(result.isSuccess, isTrue);
      expect(result.concept, equals(concept));
    });
  });
}
