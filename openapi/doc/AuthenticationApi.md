# openapi.api.AuthenticationApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**authConfirmEmailGet**](AuthenticationApi.md#authconfirmemailget) | **GET** /auth/confirmEmail | 
[**authForgotPasswordPost**](AuthenticationApi.md#authforgotpasswordpost) | **POST** /auth/forgotPassword | 
[**authLoginPost**](AuthenticationApi.md#authloginpost) | **POST** /auth/login | 
[**authResetPasswordPost**](AuthenticationApi.md#authresetpasswordpost) | **POST** /auth/resetPassword | 


# **authConfirmEmailGet**
> authConfirmEmailGet(token, email)



### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getAuthenticationApi();
final String token = token_example; // String | 
final String email = email_example; // String | 

try {
    api.authConfirmEmailGet(token, email);
} catch on DioError (e) {
    print('Exception when calling AuthenticationApi->authConfirmEmailGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **token** | **String**|  | [optional] 
 **email** | **String**|  | [optional] 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **authForgotPasswordPost**
> authForgotPasswordPost(forgotPasswordDto)



### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getAuthenticationApi();
final ForgotPasswordDto forgotPasswordDto = ; // ForgotPasswordDto | 

try {
    api.authForgotPasswordPost(forgotPasswordDto);
} catch on DioError (e) {
    print('Exception when calling AuthenticationApi->authForgotPasswordPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **forgotPasswordDto** | [**ForgotPasswordDto**](ForgotPasswordDto.md)|  | [optional] 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json, text/json, application/*+json
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **authLoginPost**
> authLoginPost(authenticateDto)



### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getAuthenticationApi();
final AuthenticateDto authenticateDto = ; // AuthenticateDto | 

try {
    api.authLoginPost(authenticateDto);
} catch on DioError (e) {
    print('Exception when calling AuthenticationApi->authLoginPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **authenticateDto** | [**AuthenticateDto**](AuthenticateDto.md)|  | [optional] 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json, text/json, application/*+json
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **authResetPasswordPost**
> authResetPasswordPost(resetPasswordDto)



### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getAuthenticationApi();
final ResetPasswordDto resetPasswordDto = ; // ResetPasswordDto | 

try {
    api.authResetPasswordPost(resetPasswordDto);
} catch on DioError (e) {
    print('Exception when calling AuthenticationApi->authResetPasswordPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **resetPasswordDto** | [**ResetPasswordDto**](ResetPasswordDto.md)|  | [optional] 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json, text/json, application/*+json
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

