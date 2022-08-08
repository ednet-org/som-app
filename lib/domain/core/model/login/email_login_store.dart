import 'package:mobx/mobx.dart';
import 'package:openapi/openapi.dart';
import 'package:som/template_storage/main/store/application.dart';

part 'email_login_store.g.dart';

class EmailLoginStore = _EmailLoginStoreBase with _$EmailLoginStore;

abstract class _EmailLoginStoreBase with Store {
  final AuthenticationApi authService;
  final Application appStore;

  _EmailLoginStoreBase(this.authService, this.appStore);

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
    var authReq = AuthenticateDtoBuilder()
      ..password = password
      ..email = email;
    authReq.password = password;
    authService
        .authLoginPost(authenticateDto: authReq.build())
        .then((response) {
      isLoading = false;
      if (response.statusCode == 200) {
        isInvalidCredentials = false;
        isLoggedIn = true;
        password = "";
        appStore.login(Authorization(
            token: response.data!.token!,
            refreshToken: response.data!.refreshToken!));
      }

      if (response.statusCode != 200) {
        errorMessage = response.statusMessage;
        isInvalidCredentials = true;
        print(response.statusMessage);
      }
    }).catchError((error) {
      errorMessage = error.response.data;
      isInvalidCredentials = true;
      isLoading = false;
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
