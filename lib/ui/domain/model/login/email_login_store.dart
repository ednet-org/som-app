import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:mobx/mobx.dart';
import 'package:openapi/openapi.dart';

import '../../application/application.dart';
import '../../../utils/jwt.dart';
import 'login_error_parser.dart';


part 'email_login_store.g.dart';

// ignore: library_private_types_in_public_api
class EmailLoginStore = _EmailLoginStoreBase with _$EmailLoginStore;

abstract class _EmailLoginStoreBase with Store {
  final AuthApi authService;
  final UsersApi usersApi;
  final Application appStore;

  _EmailLoginStoreBase(this.authService, this.usersApi, this.appStore);

  @observable
  bool showWelcomeMessage = false;

  @observable
  bool isInvalidCredentials = false;

  @observable
  String errorMessage = '';

  @observable
  String welcomeMessage = "";

  @observable
  bool isLoading = false;

  @observable
  String loggingInMessage = '';

  @action
  Future login() async {
    errorMessage = '';
    loggingInMessage = '';
    if (kDebugMode) {
      debugPrint(email);
    }
    isLoading = true;
    final authReq = AuthLoginPostRequestBuilder()
      ..password = password
      ..email = email;
    authService
        .authLoginPost(
          authLoginPostRequest: authReq.build(),
          validateStatus: (status) => status != null && status >= 200 && status < 300,
        )
        .then((response) async {
      isLoading = false;

      if (response.statusCode == 200) {
        loggingInMessage = 'Successfully logged in. Redirecting...';
        isInvalidCredentials = false;
        isLoggedIn = true;
        password = "";
        await Future.delayed(Duration(seconds: 5));
        final token = response.data!.token!;
        final refreshToken = response.data!.refreshToken!;
        final payload = decodeJwt(token);
        final userId = payload?['sub'] as String?;
        String? companyId;
        String? companyName;
        String? emailAddress;
        List<String> roles = const [];
        String? activeRole;
        int? companyType;
        String? activeCompanyId;
        List<CompanyContext> companyOptions = const [];
        if (userId != null) {
          try {
            final profileResponse = await usersApi.usersLoadUserWithCompanyGet(
              userId: userId,
              headers: {'Authorization': 'Bearer $token'},
            );
            companyId = profileResponse.data?.companyId;
            activeCompanyId = profileResponse.data?.companyId;
            companyName = profileResponse.data?.companyName;
            emailAddress = profileResponse.data?.emailAddress;
            roles = profileResponse.data?.roles?.toList() ?? const [];
            activeRole = profileResponse.data?.activeRole;
            companyType = _companyTypeFromApi(profileResponse.data?.companyType);
            companyOptions = _companyOptionsFromProfile(profileResponse.data);
          } catch (_) {
            // Best-effort profile load; keep login flow responsive.
          }
        }

        appStore.login(Authorization(
          token: token,
          refreshToken: refreshToken,
          userId: userId,
          companyId: companyId,
          activeCompanyId: activeCompanyId ?? companyId,
          companyName: companyName,
          emailAddress: emailAddress ?? email,
          roles: roles,
          activeRole: activeRole,
          companyType: companyType,
          companyOptions: companyOptions,
        ));
      }

      if (response.statusCode != 200) {
        errorMessage = response.statusMessage ?? 'Something went wrong';
        isInvalidCredentials = true;
        if (kDebugMode) {
          debugPrint(response.statusMessage);
        }
      }
    }).catchError((error) {
      final data = error is DioException ? error.response?.data : null;
      errorMessage = parseLoginErrorMessage(data ?? error);
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

  int? _companyTypeFromApi(
    UsersLoadUserWithCompanyGet200ResponseCompanyTypeEnum? value,
  ) {
    switch (value) {
      case UsersLoadUserWithCompanyGet200ResponseCompanyTypeEnum.number0:
        return 0;
      case UsersLoadUserWithCompanyGet200ResponseCompanyTypeEnum.number1:
        return 1;
      case UsersLoadUserWithCompanyGet200ResponseCompanyTypeEnum.number2:
        return 2;
      case null:
        return null;
    }
    return null;
  }

  List<CompanyContext> _companyOptionsFromProfile(
    UsersLoadUserWithCompanyGet200Response? data,
  ) {
    final companyId = data?.companyId ?? '';
    if (companyId.isEmpty) return const [];
    return [
      CompanyContext(
        companyId: companyId,
        companyName: data?.companyName ?? '',
        companyType: _companyTypeFromApi(data?.companyType) ?? 0,
        roles: data?.roles?.toList() ?? const [],
        activeRole: data?.activeRole ?? '',
      ),
    ];
  }
}
