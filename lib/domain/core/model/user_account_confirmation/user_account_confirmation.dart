import 'package:mobx/mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:openapi/openapi.dart';
import 'package:som/template_storage/main/store/application.dart';

part 'user_account_confirmation.g.dart';

class UserAccountConfirmation = _UserAccountConfirmationBase
    with _$UserAccountConfirmation;

abstract class _UserAccountConfirmationBase with Store {
  final AuthenticationApi authService;
  final Application appStore;

  _UserAccountConfirmationBase(this.authService, this.appStore);

  @observable
  String token = '';

  @observable
  String resetPasswordToken = '';

  @observable
  String email = '';

  @observable
  bool isConfirming = false;

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
  Future<dynamic> setUserPassword() async {
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
          .then((response) {
        if (response.statusCode == 200) {
          appStore.login(Authorization(
            token: (response.data as dynamic).token,
            refreshToken: (response.data as dynamic).refreshToken,
          ));
          isPasswordSet = true;
          isSettingPassword = false;
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
