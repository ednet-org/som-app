import 'package:mobx/mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:openapi/openapi.dart';
import 'package:som/domain/core/model/login/email_login_store.dart';
import 'package:som/template_storage/main/store/application.dart';

part 'user_account_confirmation.g.dart';

class UserAccountConfirmation = _UserAccountConfirmationBase
    with _$UserAccountConfirmation;

abstract class _UserAccountConfirmationBase with Store {
  final AuthenticationApi authService;
  final Application appStore;
  final EmailLoginStore emailLoginStore;

  _UserAccountConfirmationBase(
      this.authService, this.appStore, this.emailLoginStore);

  @observable
  String token = '';

  @observable
  String resetPasswordToken = '';

  @observable
  String email = '';

  @observable
  bool isConfirming = false;

  @observable
  bool isLoggingIn = false;

  @observable
  bool isConfirmed = false;

  @observable
  bool isSettingPassword = false;

  @observable
  bool isPasswordSet = false;

  @observable
  String password = '';

  @observable
  String errorMessage = '';

  @action
  void setPassword(String value) {
    password = value;
  }

  @observable
  String repeatedPassword = '';

  @action
  void setRepeatedPassword(String value) {
    repeatedPassword = value;
  }

  @action
  Future<dynamic> setUserPassword(contextCallback) async {
    errorMessage = '';

    if (!isConfirmed || isConfirming || resetPasswordToken.isEmpty) {
      errorMessage = 'Please first confirm email';
      return;
    }

    if (password.isEmpty || repeatedPassword.isEmpty) {
      errorMessage = 'Please enter and repeat password';
      return;
    }

    if (password != repeatedPassword) {
      errorMessage = 'Repeated password does not match';
      return;
    }

    try {
      isSettingPassword = true;
      final resetPasswordDtoBuilder = ResetPasswordDtoBuilder()
        ..token = resetPasswordToken
        ..confirmPassword = repeatedPassword
        ..email = email
        ..password = password;

      authService
          .authResetPasswordPost(
              resetPasswordDto: resetPasswordDtoBuilder.build())
          .then((response) async {
        if (response.statusCode == 200) {
          final authenticateDtoBuilder = AuthenticateDtoBuilder()
            ..email = email
            ..password = password;
          isPasswordSet = true;
          isSettingPassword = false;
          authService.authLoginPost(
              authenticateDto: authenticateDtoBuilder.build());
          emailLoginStore.setPassword(password);
          emailLoginStore.setEmail(email);
          isLoggingIn = true;
          await emailLoginStore.login().then((_) {
            isLoggingIn = false;
            contextCallback();
          });
        } else {
          errorMessage = 'Some error occurred';
        }
      });
    } catch (error) {
      isPasswordSet = false;
      isSettingPassword = false;
    }
  }

  @action
  Future<dynamic> confirmEmail() async {
    if (isConfirmed || isConfirming) {
      return;
    }

    isConfirming = true;

    print(token);
    print(email);
    if (token.isNotEmpty && email.isNotEmpty) {
      authService
          .authConfirmEmailGet(token: token, email: email)
          .then((response) {
        isConfirming = false;
        if (response.statusCode == 200) {
          resetPasswordToken = response.data as String;
          isConfirmed = true;
        }
      }).catchError((error) {
        toastLong(
            'ERROR in Confirming e-mail token:$token email:$email error:$error');

        isConfirming = false;
        print(error.response.data);
      });
    } else {
      toastLong('ERROR in Confirming e-mail token:$token email:$email');
      isConfirming = false;
    }
  }
}
