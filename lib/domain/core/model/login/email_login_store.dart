import 'package:mobx/mobx.dart';
import 'package:som/domain/infrastructure/repository/api/lib/login_service.dart';
import 'package:som/domain/infrastructure/repository/api/lib/models/auth/authentication_request_dto.dart';
import 'package:som/template_storage/main/store/application.dart';

part 'email_login_store.g.dart';

class EmailLoginStore = _EmailLoginStoreBase with _$EmailLoginStore;

abstract class _EmailLoginStoreBase with Store {
  LoginService loginService;
  Application appStore;

  _EmailLoginStoreBase(this.loginService, this.appStore);

  @observable
  bool showWelcomeMessage = false;

  @observable
  bool isInvalidCredentials = false;

  @observable
  Object? errorMessage = false;

  @observable
  String welcomeMessage = "";

  @observable
  bool isLoading = false;

  @action
  Future login() async {
    print(email);
    isLoading = true;
    loginService
        .login(AuthenticateRequestDto(
      email: email,
      password: password,
    ))
        .then((response) {
      isLoading = false;
      if (response.body != null) {
        isInvalidCredentials = false;
        isLoggedIn = true;
        password = "";
        appStore.login(Authorization(
            token: response.body!.token,
            refreshToken: response.body!.refreshToken));
      }

      if (response.error != null) {
        errorMessage = response.error;
        isInvalidCredentials = true;
        print(response.error);
      }
    }).catchError((error) {
      isLoading = false;
      print(error);
      appStore.logout();
    });
  }

  @observable
  String email = "";

  @action
  void setEmail(String value) => email = value;

  @action
  void setPassword(String value) => password = value;

  @observable
  String password = "";

  @observable
  bool showPassword = false;

  @action
  void toggleShowPassword() => showPassword = !showPassword;

  @computed
  bool get isFormValid => email.length > 6 && password.length > 6;

  @observable
  bool isLoggedIn = false;

  @action
  void loggout() {
    isLoggedIn = false;
    isLoading = false;
    email = '';
    password = '';
  }
}
