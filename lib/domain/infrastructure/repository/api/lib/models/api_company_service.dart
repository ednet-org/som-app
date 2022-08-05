import 'package:chopper/chopper.dart';
import 'package:som/domain/infrastructure/repository/api/lib/models/domain/company_dto.dart';

part 'api_company_service.chopper.dart';

@ChopperApi(baseUrl: "companies")
abstract class ApiCompanyService extends ChopperService {
  // A helper method that helps instantiating the service. You can omit this method and use the generated class directly instead.
  static ApiCompanyService create([ChopperClient? client]) =>
      _$ApiCompanyService(client);

  @Get(path: "")
  Future<Response<List<Company>>> getCompanies();
}
