import 'package:test/test.dart';
import 'package:openapi/openapi.dart';


/// tests for CompaniesApi
void main() {
  final instance = Openapi().getCompaniesApi();

  group(CompaniesApi, () {
    // Deactivate company and users
    //
    //Future companiesCompanyIdDelete(String companyId) async
    test('test companiesCompanyIdDelete', () async {
      // TODO
    });

    // Get company
    //
    //Future<CompanyDto> companiesCompanyIdGet(String companyId) async
    test('test companiesCompanyIdGet', () async {
      // TODO
    });

    // Update company
    //
    //Future companiesCompanyIdPut(String companyId, CompanyDto companyDto) async
    test('test companiesCompanyIdPut', () async {
      // TODO
    });

    // List companies
    //
    //Future<BuiltList<CompanyDto>> companiesGet({ String type }) async
    test('test companiesGet', () async {
      // TODO
    });

    // Register buyer/provider company
    //
    //Future registerCompany(RegisterCompanyRequest registerCompanyRequest) async
    test('test registerCompany', () async {
      // TODO
    });

  });
}
