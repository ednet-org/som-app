import 'package:mobx/mobx.dart';
import 'package:openapi/openapi.dart';

part 'auth_forgot_password_page_state.g.dart';

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
    await Future.delayed(Duration(seconds: 3));
    try {
      final forgotPasswordDto = AuthForgotPasswordPostRequestBuilder()
        ..email = email;
      authApi
          .authForgotPasswordPost(
            authForgotPasswordPostRequest: forgotPasswordDto.build(),
          )
          .then((response) {
        if (response.statusCode == 200) {
          url = response.data as String;
          isLinkSent = true;
        } else {
          errorMessage = 'Something went wrong';
        }
        isSendingEmailLink = false;
      });

      isSendingEmailLink = false;
      isLinkSent = true;
    } catch (error) {
      errorMessage = error.toString();
      isSendingEmailLink = false;
    } finally {
      isSendingEmailLink = false;
    }
  }
}
