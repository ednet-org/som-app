# openapi.api.RolesApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to *http://localhost:8081*

Method | HTTP request | Description
------------- | ------------- | -------------
[**rolesGet**](RolesApi.md#rolesget) | **GET** /roles | List roles
[**rolesPost**](RolesApi.md#rolespost) | **POST** /roles | Create role
[**rolesRoleIdDelete**](RolesApi.md#rolesroleiddelete) | **DELETE** /roles/{roleId} | Delete role
[**rolesRoleIdPut**](RolesApi.md#rolesroleidput) | **PUT** /roles/{roleId} | Update role


# **rolesGet**
> BuiltList<Role> rolesGet()

List roles

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getRolesApi();

try {
    final response = api.rolesGet();
    print(response);
} catch on DioException (e) {
    print('Exception when calling RolesApi->rolesGet: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**BuiltList&lt;Role&gt;**](Role.md)

### Authorization

[BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **rolesPost**
> Role rolesPost(roleInput)

Create role

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getRolesApi();
final RoleInput roleInput = ; // RoleInput | 

try {
    final response = api.rolesPost(roleInput);
    print(response);
} catch on DioException (e) {
    print('Exception when calling RolesApi->rolesPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **roleInput** | [**RoleInput**](RoleInput.md)|  | 

### Return type

[**Role**](Role.md)

### Authorization

[BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **rolesRoleIdDelete**
> rolesRoleIdDelete(roleId)

Delete role

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getRolesApi();
final String roleId = roleId_example; // String | 

try {
    api.rolesRoleIdDelete(roleId);
} catch on DioException (e) {
    print('Exception when calling RolesApi->rolesRoleIdDelete: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **roleId** | **String**|  | 

### Return type

void (empty response body)

### Authorization

[BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **rolesRoleIdPut**
> Role rolesRoleIdPut(roleId, roleInput)

Update role

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getRolesApi();
final String roleId = roleId_example; // String | 
final RoleInput roleInput = ; // RoleInput | 

try {
    final response = api.rolesRoleIdPut(roleId, roleInput);
    print(response);
} catch on DioException (e) {
    print('Exception when calling RolesApi->rolesRoleIdPut: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **roleId** | **String**|  | 
 **roleInput** | [**RoleInput**](RoleInput.md)|  | 

### Return type

[**Role**](Role.md)

### Authorization

[BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

