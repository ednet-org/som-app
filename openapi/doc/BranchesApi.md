# openapi.api.BranchesApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to *http://localhost:8081*

Method | HTTP request | Description
------------- | ------------- | -------------
[**branchesBranchIdCategoriesPost**](BranchesApi.md#branchesbranchidcategoriespost) | **POST** /branches/{branchId}/categories | Create category
[**branchesBranchIdDelete**](BranchesApi.md#branchesbranchiddelete) | **DELETE** /branches/{branchId} | Delete branch
[**branchesBranchIdPut**](BranchesApi.md#branchesbranchidput) | **PUT** /branches/{branchId} | Update branch
[**branchesGet**](BranchesApi.md#branchesget) | **GET** /branches | List branches
[**branchesPost**](BranchesApi.md#branchespost) | **POST** /branches | Create branch
[**categoriesCategoryIdDelete**](BranchesApi.md#categoriescategoryiddelete) | **DELETE** /categories/{categoryId} | Delete category
[**categoriesCategoryIdPut**](BranchesApi.md#categoriescategoryidput) | **PUT** /categories/{categoryId} | Update category


# **branchesBranchIdCategoriesPost**
> branchesBranchIdCategoriesPost(branchId, branchesPostRequest)

Create category

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getBranchesApi();
final String branchId = branchId_example; // String | 
final BranchesPostRequest branchesPostRequest = ; // BranchesPostRequest | 

try {
    api.branchesBranchIdCategoriesPost(branchId, branchesPostRequest);
} catch on DioException (e) {
    print('Exception when calling BranchesApi->branchesBranchIdCategoriesPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **branchId** | **String**|  | 
 **branchesPostRequest** | [**BranchesPostRequest**](BranchesPostRequest.md)|  | 

### Return type

void (empty response body)

### Authorization

[BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **branchesBranchIdDelete**
> branchesBranchIdDelete(branchId)

Delete branch

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getBranchesApi();
final String branchId = branchId_example; // String | 

try {
    api.branchesBranchIdDelete(branchId);
} catch on DioException (e) {
    print('Exception when calling BranchesApi->branchesBranchIdDelete: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **branchId** | **String**|  | 

### Return type

void (empty response body)

### Authorization

[BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **branchesBranchIdPut**
> branchesBranchIdPut(branchId, branchesPostRequest)

Update branch

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getBranchesApi();
final String branchId = branchId_example; // String | 
final BranchesPostRequest branchesPostRequest = ; // BranchesPostRequest | 

try {
    api.branchesBranchIdPut(branchId, branchesPostRequest);
} catch on DioException (e) {
    print('Exception when calling BranchesApi->branchesBranchIdPut: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **branchId** | **String**|  | 
 **branchesPostRequest** | [**BranchesPostRequest**](BranchesPostRequest.md)|  | 

### Return type

void (empty response body)

### Authorization

[BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **branchesGet**
> BuiltList<Branch> branchesGet()

List branches

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getBranchesApi();

try {
    final response = api.branchesGet();
    print(response);
} catch on DioException (e) {
    print('Exception when calling BranchesApi->branchesGet: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**BuiltList&lt;Branch&gt;**](Branch.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **branchesPost**
> branchesPost(branchesPostRequest)

Create branch

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getBranchesApi();
final BranchesPostRequest branchesPostRequest = ; // BranchesPostRequest | 

try {
    api.branchesPost(branchesPostRequest);
} catch on DioException (e) {
    print('Exception when calling BranchesApi->branchesPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **branchesPostRequest** | [**BranchesPostRequest**](BranchesPostRequest.md)|  | 

### Return type

void (empty response body)

### Authorization

[BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **categoriesCategoryIdDelete**
> categoriesCategoryIdDelete(categoryId)

Delete category

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getBranchesApi();
final String categoryId = categoryId_example; // String | 

try {
    api.categoriesCategoryIdDelete(categoryId);
} catch on DioException (e) {
    print('Exception when calling BranchesApi->categoriesCategoryIdDelete: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **categoryId** | **String**|  | 

### Return type

void (empty response body)

### Authorization

[BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **categoriesCategoryIdPut**
> categoriesCategoryIdPut(categoryId, branchesPostRequest)

Update category

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getBranchesApi();
final String categoryId = categoryId_example; // String | 
final BranchesPostRequest branchesPostRequest = ; // BranchesPostRequest | 

try {
    api.categoriesCategoryIdPut(categoryId, branchesPostRequest);
} catch on DioException (e) {
    print('Exception when calling BranchesApi->categoriesCategoryIdPut: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **categoryId** | **String**|  | 
 **branchesPostRequest** | [**BranchesPostRequest**](BranchesPostRequest.md)|  | 

### Return type

void (empty response body)

### Authorization

[BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

