import 'package:chopper/chopper.dart';
import 'package:som/domain/infrastructure/repository/api/lib/models/auth/authentication_request_dto.dart';
import 'package:som/domain/infrastructure/repository/api/lib/models/auth/authentication_response_dto.dart';

part 'login_service.chopper.dart';

@ChopperApi(baseUrl: "auth/login")
abstract class LoginService extends ChopperService {
  // A helper method that helps instantiating the service. You can omit this method and use the generated class directly instead.
  static LoginService create([ChopperClient? client]) => _$LoginService(client);

  @Post()
  Future<Response<AuthenticationResponseDto>> login(
      @Body() AuthenticateRequestDto body);
}
