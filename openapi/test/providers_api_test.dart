import 'package:test/test.dart';
import 'package:openapi/openapi.dart';


/// tests for ProvidersApi
void main() {
  final instance = Openapi().getProvidersApi();

  group(ProvidersApi, () {
    // Approve provider branches
    //
    //Future providersCompanyIdApprovePost(String companyId, { ProvidersCompanyIdApprovePostRequest providersCompanyIdApprovePostRequest }) async
    test('test providersCompanyIdApprovePost', () async {
      // TODO
    });

    // Decline provider branch request
    //
    //Future providersCompanyIdDeclinePost(String companyId) async
    test('test providersCompanyIdDeclinePost', () async {
      // TODO
    });

    // List providers
    //
    //Future<BuiltList<ProviderSummary>> providersGet({ String branchId, String companySize, String providerType, String zipPrefix, String status, String claimed, String format }) async
    test('test providersGet', () async {
      // TODO
    });

  });
}
