# openapi.api.ConsultantsApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to *http://localhost:8080*

Method | HTTP request | Description
------------- | ------------- | -------------
[**consultantsGet**](ConsultantsApi.md#consultantsget) | **GET** /consultants | List consultants
[**consultantsPost**](ConsultantsApi.md#consultantspost) | **POST** /consultants | Create consultant
[**consultantsRegisterCompanyPost**](ConsultantsApi.md#consultantsregistercompanypost) | **POST** /consultants/registerCompany | Consultant registers company (allow incomplete)


# **consultantsGet**
> BuiltList<UserDto> consultantsGet()

List consultants

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getConsultantsApi();

try {
    final response = api.consultantsGet();
    print(response);
} catch on DioException (e) {
    print('Exception when calling ConsultantsApi->consultantsGet: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**BuiltList&lt;UserDto&gt;**](UserDto.md)

### Authorization

[BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **consultantsPost**
> consultantsPost(userRegistration)

Create consultant

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getConsultantsApi();
final UserRegistration userRegistration = ; // UserRegistration | 

try {
    api.consultantsPost(userRegistration);
} catch on DioException (e) {
    print('Exception when calling ConsultantsApi->consultantsPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **userRegistration** | [**UserRegistration**](UserRegistration.md)|  | 

### Return type

void (empty response body)

### Authorization

[BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **consultantsRegisterCompanyPost**
> consultantsRegisterCompanyPost(consultantsRegisterCompanyPostRequest)

Consultant registers company (allow incomplete)

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getConsultantsApi();
final ConsultantsRegisterCompanyPostRequest consultantsRegisterCompanyPostRequest = ; // ConsultantsRegisterCompanyPostRequest | 

try {
    api.consultantsRegisterCompanyPost(consultantsRegisterCompanyPostRequest);
} catch on DioException (e) {
    print('Exception when calling ConsultantsApi->consultantsRegisterCompanyPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **consultantsRegisterCompanyPostRequest** | [**ConsultantsRegisterCompanyPostRequest**](ConsultantsRegisterCompanyPostRequest.md)|  | 

### Return type

void (empty response body)

### Authorization

[BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

