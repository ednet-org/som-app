import 'package:mobx/mobx.dart';
import 'package:som/domain/infrastructure/repository/api/lib/login_service.dart';
import 'package:som/domain/infrastructure/repository/api/lib/models/auth/authentication_request_dto.dart';

part 'email_login_store.g.dart';

class EmailLoginStore = _EmailLoginStoreBase with _$EmailLoginStore;

abstract class _EmailLoginStoreBase with Store {
  LoginService loginService;

  _EmailLoginStoreBase(this.loginService);

  @observable
  bool showWelcomeMessage = false;

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
      isLoggedIn = true;
      password = "";
    }).catchError((error) {
      isLoading = false;
      print(error);
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
