# openapi.api.UsersApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**usersLoadUserWithCompanyGet**](UsersApi.md#usersloaduserwithcompanyget) | **GET** /Users/loadUserWithCompany | 


# **usersLoadUserWithCompanyGet**
> usersLoadUserWithCompanyGet(userId, companyId)



### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getUsersApi();
final String userId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final String companyId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    api.usersLoadUserWithCompanyGet(userId, companyId);
} catch on DioError (e) {
    print('Exception when calling UsersApi->usersLoadUserWithCompanyGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **userId** | **String**|  | [optional] 
 **companyId** | **String**|  | [optional] 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

