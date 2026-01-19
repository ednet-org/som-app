import 'package:mobx/mobx.dart';
import 'package:openapi/openapi.dart';

part 'auth_forgot_password_page_state.g.dart';

// ignore: library_private_types_in_public_api
class AuthForgotPasswordPageState = _AuthForgotPasswordPageState
    with _$AuthForgotPasswordPageState;

abstract class _AuthForgotPasswordPageState with Store {
  final AuthApi authApi;

  _AuthForgotPasswordPageState(this.authApi);

  @observable
  String email = '';

  @observable
  String url = '';

  @observable
  String errorMessage = '';

  @observable
  bool isSendingEmailLink = false;

  @observable
  bool isLinkSent = false;

  @action
  void setEmail(String email) => this.email = email;

  @action
  Future<void> sendResetLink() async {
    errorMessage = '';
    isSendingEmailLink = true;
    try {
      final forgotPasswordDto = AuthForgotPasswordPostRequestBuilder()
        ..email = email;
      final response = await authApi.authForgotPasswordPost(
        authForgotPasswordPostRequest: forgotPasswordDto.build(),
      );
      if (response.statusCode == 200) {
        final data = response.data;
        if (data is String && data.contains('http')) {
          url = data;
        }
        isLinkSent = true;
      } else {
        errorMessage = 'Something went wrong';
      }
    } catch (error) {
      errorMessage = error.toString();
    } finally {
      isSendingEmailLink = false;
    }
  }
}
