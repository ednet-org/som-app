# openapi.api.CompaniesApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**companiesCompanyIdGet**](CompaniesApi.md#companiescompanyidget) | **GET** /Companies/{companyId} | 
[**companiesCompanyIdRegisterUserPost**](CompaniesApi.md#companiescompanyidregisteruserpost) | **POST** /Companies/{companyId}/registerUser | 
[**companiesCompanyIdUsersGet**](CompaniesApi.md#companiescompanyidusersget) | **GET** /Companies/{companyId}/users | 
[**companiesCompanyIdUsersUserIdDelete**](CompaniesApi.md#companiescompanyidusersuseriddelete) | **DELETE** /Companies/{companyId}/users/{userId} | 
[**companiesCompanyIdUsersUserIdGet**](CompaniesApi.md#companiescompanyidusersuseridget) | **GET** /Companies/{companyId}/users/{userId} | 
[**companiesCompanyIdUsersUserIdUpdatePut**](CompaniesApi.md#companiescompanyidusersuseridupdateput) | **PUT** /Companies/{companyId}/users/{userId}/update | 
[**companiesGet**](CompaniesApi.md#companiesget) | **GET** /Companies | 
[**companiesRegisterPost**](CompaniesApi.md#companiesregisterpost) | **POST** /Companies/register | 


# **companiesCompanyIdGet**
> companiesCompanyIdGet(companyId)



### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getCompaniesApi();
final String companyId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    api.companiesCompanyIdGet(companyId);
} catch on DioError (e) {
    print('Exception when calling CompaniesApi->companiesCompanyIdGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **companyId** | **String**|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **companiesCompanyIdRegisterUserPost**
> companiesCompanyIdRegisterUserPost(companyId, userDto)



### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getCompaniesApi();
final String companyId = companyId_example; // String | 
final UserDto userDto = ; // UserDto | 

try {
    api.companiesCompanyIdRegisterUserPost(companyId, userDto);
} catch on DioError (e) {
    print('Exception when calling CompaniesApi->companiesCompanyIdRegisterUserPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **companyId** | **String**|  | 
 **userDto** | [**UserDto**](UserDto.md)|  | [optional] 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json, text/json, application/*+json
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **companiesCompanyIdUsersGet**
> companiesCompanyIdUsersGet(companyId)



### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getCompaniesApi();
final String companyId = companyId_example; // String | 

try {
    api.companiesCompanyIdUsersGet(companyId);
} catch on DioError (e) {
    print('Exception when calling CompaniesApi->companiesCompanyIdUsersGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **companyId** | **String**|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **companiesCompanyIdUsersUserIdDelete**
> companiesCompanyIdUsersUserIdDelete(userId, companyId)



### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getCompaniesApi();
final String userId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final String companyId = companyId_example; // String | 

try {
    api.companiesCompanyIdUsersUserIdDelete(userId, companyId);
} catch on DioError (e) {
    print('Exception when calling CompaniesApi->companiesCompanyIdUsersUserIdDelete: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **userId** | **String**|  | 
 **companyId** | **String**|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **companiesCompanyIdUsersUserIdGet**
> companiesCompanyIdUsersUserIdGet(userId, companyId)



### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getCompaniesApi();
final String userId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final String companyId = companyId_example; // String | 

try {
    api.companiesCompanyIdUsersUserIdGet(userId, companyId);
} catch on DioError (e) {
    print('Exception when calling CompaniesApi->companiesCompanyIdUsersUserIdGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **userId** | **String**|  | 
 **companyId** | **String**|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **companiesCompanyIdUsersUserIdUpdatePut**
> companiesCompanyIdUsersUserIdUpdatePut(userId, companyId, userDto)



### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getCompaniesApi();
final String userId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final String companyId = companyId_example; // String | 
final UserDto userDto = ; // UserDto | 

try {
    api.companiesCompanyIdUsersUserIdUpdatePut(userId, companyId, userDto);
} catch on DioError (e) {
    print('Exception when calling CompaniesApi->companiesCompanyIdUsersUserIdUpdatePut: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **userId** | **String**|  | 
 **companyId** | **String**|  | 
 **userDto** | [**UserDto**](UserDto.md)|  | [optional] 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json, text/json, application/*+json
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **companiesGet**
> companiesGet()



### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getCompaniesApi();

try {
    api.companiesGet();
} catch on DioError (e) {
    print('Exception when calling CompaniesApi->companiesGet: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **companiesRegisterPost**
> companiesRegisterPost(registerCompanyDto)



### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getCompaniesApi();
final RegisterCompanyDto registerCompanyDto = ; // RegisterCompanyDto | 

try {
    api.companiesRegisterPost(registerCompanyDto);
} catch on DioError (e) {
    print('Exception when calling CompaniesApi->companiesRegisterPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **registerCompanyDto** | [**RegisterCompanyDto**](RegisterCompanyDto.md)|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json, text/json, application/*+json
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

