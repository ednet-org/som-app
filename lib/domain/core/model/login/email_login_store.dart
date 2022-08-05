import 'package:mobx/mobx.dart';

part 'email_login_store.g.dart';

class EmailLoginStore = _EmailLoginStoreBase with _$EmailLoginStore;

abstract class _EmailLoginStoreBase with Store {
  @observable
  bool showWelcomeMessage = false;

  @observable
  String welcomeMessage = "";

  @observable
  bool isLoading = false;

  @action
  void login() {
    print(email);
    print(password);
    isLoading = true;
    Future.delayed(const Duration(seconds: 2));
    isLoading = false;
    isLoggedIn = true;
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
