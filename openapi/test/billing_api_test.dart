import 'package:test/test.dart';
import 'package:openapi/openapi.dart';


/// tests for BillingApi
void main() {
  final instance = Openapi().getBillingApi();

  group(BillingApi, () {
    // Update billing record
    //
    //Future billingBillingIdPut(String billingId, BillingBillingIdPutRequest billingBillingIdPutRequest) async
    test('test billingBillingIdPut', () async {
      // TODO
    });

    // List billing records
    //
    //Future<BuiltList<BillingRecord>> billingGet({ String companyId }) async
    test('test billingGet', () async {
      // TODO
    });

    // Create billing record
    //
    //Future billingPost(BillingRecord billingRecord) async
    test('test billingPost', () async {
      // TODO
    });

  });
}
