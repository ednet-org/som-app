import 'package:test/test.dart';
import 'package:openapi/openapi.dart';


/// tests for AuthApi
void main() {
  final instance = Openapi().getAuthApi();

  group(AuthApi, () {
    // Confirm email registration token
    //
    //Future authConfirmEmailGet(String token, String email) async
    test('test authConfirmEmailGet', () async {
      // TODO
    });

    // Send password reset email
    //
    //Future<String> authForgotPasswordPost(AuthForgotPasswordPostRequest authForgotPasswordPostRequest) async
    test('test authForgotPasswordPost', () async {
      // TODO
    });

    // Login
    //
    //Future<AuthLoginPost200Response> authLoginPost(AuthLoginPostRequest authLoginPostRequest) async
    test('test authLoginPost', () async {
      // TODO
    });

    // Reset password with token
    //
    //Future authResetPasswordPost(AuthResetPasswordPostRequest authResetPasswordPostRequest) async
    test('test authResetPasswordPost', () async {
      // TODO
    });

    // Switch role for current user
    //
    //Future<AuthSwitchRolePost200Response> authSwitchRolePost(AuthSwitchRolePostRequest authSwitchRolePostRequest) async
    test('test authSwitchRolePost', () async {
      // TODO
    });

  });
}
