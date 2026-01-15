import 'package:test/test.dart';
import 'package:openapi/openapi.dart';


/// tests for StatsApi
void main() {
  final instance = Openapi().getStatsApi();

  group(StatsApi, () {
    // Buyer statistics
    //
    //Future<StatsBuyerGet200Response> statsBuyerGet({ DateTime from, DateTime to, String userId, String format }) async
    test('test statsBuyerGet', () async {
      // TODO
    });

    // Consultant statistics
    //
    //Future<StatsBuyerGet200Response> statsConsultantGet({ DateTime from, DateTime to, String format }) async
    test('test statsConsultantGet', () async {
      // TODO
    });

    // Provider statistics
    //
    //Future<StatsProviderGet200Response> statsProviderGet({ DateTime from, DateTime to, String type, String format }) async
    test('test statsProviderGet', () async {
      // TODO
    });

  });
}
