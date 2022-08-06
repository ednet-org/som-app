import 'package:test/test.dart';
import 'package:openapi/openapi.dart';


/// tests for AuthenticationApi
void main() {
  final instance = Openapi().getAuthenticationApi();

  group(AuthenticationApi, () {
    //Future authConfirmEmailGet({ String token, String email }) async
    test('test authConfirmEmailGet', () async {
      // TODO
    });

    //Future authForgotPasswordPost({ ForgotPasswordDto forgotPasswordDto }) async
    test('test authForgotPasswordPost', () async {
      // TODO
    });

    //Future authLoginPost({ AuthenticateDto authenticateDto }) async
    test('test authLoginPost', () async {
      // TODO
    });

    //Future authResetPasswordPost({ ResetPasswordDto resetPasswordDto }) async
    test('test authResetPasswordPost', () async {
      // TODO
    });

  });
}
