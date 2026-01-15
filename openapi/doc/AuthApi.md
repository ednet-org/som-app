# openapi.api.AuthApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to *http://localhost:8081*

Method | HTTP request | Description
------------- | ------------- | -------------
[**authChangePasswordPost**](AuthApi.md#authchangepasswordpost) | **POST** /auth/changePassword | Change password for authenticated user
[**authConfirmEmailGet**](AuthApi.md#authconfirmemailget) | **GET** /auth/confirmEmail | Confirm email registration token
[**authForgotPasswordPost**](AuthApi.md#authforgotpasswordpost) | **POST** /auth/forgotPassword | Send password reset email
[**authLoginPost**](AuthApi.md#authloginpost) | **POST** /auth/login | Login
[**authLogoutPost**](AuthApi.md#authlogoutpost) | **POST** /auth/logout | Logout and revoke session
[**authResetPasswordPost**](AuthApi.md#authresetpasswordpost) | **POST** /auth/resetPassword | Reset password with token
[**authSwitchRolePost**](AuthApi.md#authswitchrolepost) | **POST** /auth/switchRole | Switch role for current user


# **authChangePasswordPost**
> AuthChangePasswordPost200Response authChangePasswordPost(authChangePasswordPostRequest)

Change password for authenticated user

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getAuthApi();
final AuthChangePasswordPostRequest authChangePasswordPostRequest = ; // AuthChangePasswordPostRequest | 

try {
    final response = api.authChangePasswordPost(authChangePasswordPostRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling AuthApi->authChangePasswordPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **authChangePasswordPostRequest** | [**AuthChangePasswordPostRequest**](AuthChangePasswordPostRequest.md)|  | 

### Return type

[**AuthChangePasswordPost200Response**](AuthChangePasswordPost200Response.md)

### Authorization

[BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **authConfirmEmailGet**
> authConfirmEmailGet(token, email)

Confirm email registration token

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getAuthApi();
final String token = token_example; // String | 
final String email = email_example; // String | 

try {
    api.authConfirmEmailGet(token, email);
} catch on DioException (e) {
    print('Exception when calling AuthApi->authConfirmEmailGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **token** | **String**|  | 
 **email** | **String**|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **authForgotPasswordPost**
> String authForgotPasswordPost(authForgotPasswordPostRequest)

Send password reset email

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getAuthApi();
final AuthForgotPasswordPostRequest authForgotPasswordPostRequest = ; // AuthForgotPasswordPostRequest | 

try {
    final response = api.authForgotPasswordPost(authForgotPasswordPostRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling AuthApi->authForgotPasswordPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **authForgotPasswordPostRequest** | [**AuthForgotPasswordPostRequest**](AuthForgotPasswordPostRequest.md)|  | 

### Return type

**String**

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **authLoginPost**
> AuthLoginPost200Response authLoginPost(authLoginPostRequest)

Login

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getAuthApi();
final AuthLoginPostRequest authLoginPostRequest = ; // AuthLoginPostRequest | 

try {
    final response = api.authLoginPost(authLoginPostRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling AuthApi->authLoginPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **authLoginPostRequest** | [**AuthLoginPostRequest**](AuthLoginPostRequest.md)|  | 

### Return type

[**AuthLoginPost200Response**](AuthLoginPost200Response.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **authLogoutPost**
> AuthChangePasswordPost200Response authLogoutPost()

Logout and revoke session

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getAuthApi();

try {
    final response = api.authLogoutPost();
    print(response);
} catch on DioException (e) {
    print('Exception when calling AuthApi->authLogoutPost: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**AuthChangePasswordPost200Response**](AuthChangePasswordPost200Response.md)

### Authorization

[BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **authResetPasswordPost**
> authResetPasswordPost(authResetPasswordPostRequest)

Reset password with token

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getAuthApi();
final AuthResetPasswordPostRequest authResetPasswordPostRequest = ; // AuthResetPasswordPostRequest | 

try {
    api.authResetPasswordPost(authResetPasswordPostRequest);
} catch on DioException (e) {
    print('Exception when calling AuthApi->authResetPasswordPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **authResetPasswordPostRequest** | [**AuthResetPasswordPostRequest**](AuthResetPasswordPostRequest.md)|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **authSwitchRolePost**
> AuthSwitchRolePost200Response authSwitchRolePost(authSwitchRolePostRequest)

Switch role for current user

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getAuthApi();
final AuthSwitchRolePostRequest authSwitchRolePostRequest = ; // AuthSwitchRolePostRequest | 

try {
    final response = api.authSwitchRolePost(authSwitchRolePostRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling AuthApi->authSwitchRolePost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **authSwitchRolePostRequest** | [**AuthSwitchRolePostRequest**](AuthSwitchRolePostRequest.md)|  | 

### Return type

[**AuthSwitchRolePost200Response**](AuthSwitchRolePost200Response.md)

### Authorization

[BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

