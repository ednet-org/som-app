# openapi.api.UsersApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to *http://localhost:8080*

Method | HTTP request | Description
------------- | ------------- | -------------
[**companiesCompanyIdRegisterUserPost**](UsersApi.md#companiescompanyidregisteruserpost) | **POST** /Companies/{companyId}/registerUser | Register a new user for a company
[**companiesCompanyIdUsersGet**](UsersApi.md#companiescompanyidusersget) | **GET** /Companies/{companyId}/users | List company users
[**companiesCompanyIdUsersUserIdDelete**](UsersApi.md#companiescompanyidusersuseriddelete) | **DELETE** /Companies/{companyId}/users/{userId} | Deactivate user
[**companiesCompanyIdUsersUserIdGet**](UsersApi.md#companiescompanyidusersuseridget) | **GET** /Companies/{companyId}/users/{userId} | Get user
[**companiesCompanyIdUsersUserIdUpdatePut**](UsersApi.md#companiescompanyidusersuseridupdateput) | **PUT** /Companies/{companyId}/users/{userId}/update | Update user
[**usersLoadUserWithCompanyGet**](UsersApi.md#usersloaduserwithcompanyget) | **GET** /Users/loadUserWithCompany | Load user and company details


# **companiesCompanyIdRegisterUserPost**
> companiesCompanyIdRegisterUserPost(companyId, userRegistration)

Register a new user for a company

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getUsersApi();
final String companyId = companyId_example; // String | 
final UserRegistration userRegistration = ; // UserRegistration | 

try {
    api.companiesCompanyIdRegisterUserPost(companyId, userRegistration);
} catch on DioError (e) {
    print('Exception when calling UsersApi->companiesCompanyIdRegisterUserPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **companyId** | **String**|  | 
 **userRegistration** | [**UserRegistration**](UserRegistration.md)|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **companiesCompanyIdUsersGet**
> BuiltList<UserDto> companiesCompanyIdUsersGet(companyId)

List company users

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getUsersApi();
final String companyId = companyId_example; // String | 

try {
    final response = api.companiesCompanyIdUsersGet(companyId);
    print(response);
} catch on DioError (e) {
    print('Exception when calling UsersApi->companiesCompanyIdUsersGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **companyId** | **String**|  | 

### Return type

[**BuiltList&lt;UserDto&gt;**](UserDto.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **companiesCompanyIdUsersUserIdDelete**
> companiesCompanyIdUsersUserIdDelete(companyId, userId)

Deactivate user

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getUsersApi();
final String companyId = companyId_example; // String | 
final String userId = userId_example; // String | 

try {
    api.companiesCompanyIdUsersUserIdDelete(companyId, userId);
} catch on DioError (e) {
    print('Exception when calling UsersApi->companiesCompanyIdUsersUserIdDelete: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **companyId** | **String**|  | 
 **userId** | **String**|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **companiesCompanyIdUsersUserIdGet**
> UserDto companiesCompanyIdUsersUserIdGet(companyId, userId)

Get user

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getUsersApi();
final String companyId = companyId_example; // String | 
final String userId = userId_example; // String | 

try {
    final response = api.companiesCompanyIdUsersUserIdGet(companyId, userId);
    print(response);
} catch on DioError (e) {
    print('Exception when calling UsersApi->companiesCompanyIdUsersUserIdGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **companyId** | **String**|  | 
 **userId** | **String**|  | 

### Return type

[**UserDto**](UserDto.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **companiesCompanyIdUsersUserIdUpdatePut**
> UserDto companiesCompanyIdUsersUserIdUpdatePut(companyId, userId, userDto)

Update user

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getUsersApi();
final String companyId = companyId_example; // String | 
final String userId = userId_example; // String | 
final UserDto userDto = ; // UserDto | 

try {
    final response = api.companiesCompanyIdUsersUserIdUpdatePut(companyId, userId, userDto);
    print(response);
} catch on DioError (e) {
    print('Exception when calling UsersApi->companiesCompanyIdUsersUserIdUpdatePut: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **companyId** | **String**|  | 
 **userId** | **String**|  | 
 **userDto** | [**UserDto**](UserDto.md)|  | 

### Return type

[**UserDto**](UserDto.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **usersLoadUserWithCompanyGet**
> UsersLoadUserWithCompanyGet200Response usersLoadUserWithCompanyGet(userId, companyId)

Load user and company details

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getUsersApi();
final String userId = userId_example; // String | 
final String companyId = companyId_example; // String | 

try {
    final response = api.usersLoadUserWithCompanyGet(userId, companyId);
    print(response);
} catch on DioError (e) {
    print('Exception when calling UsersApi->usersLoadUserWithCompanyGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **userId** | **String**|  | 
 **companyId** | **String**|  | [optional] 

### Return type

[**UsersLoadUserWithCompanyGet200Response**](UsersLoadUserWithCompanyGet200Response.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

