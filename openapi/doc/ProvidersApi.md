# openapi.api.ProvidersApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to *http://localhost:8080*

Method | HTTP request | Description
------------- | ------------- | -------------
[**providersCompanyIdApprovePost**](ProvidersApi.md#providerscompanyidapprovepost) | **POST** /providers/{companyId}/approve | Approve provider branches
[**providersCompanyIdDeclinePost**](ProvidersApi.md#providerscompanyiddeclinepost) | **POST** /providers/{companyId}/decline | Decline provider branch request
[**providersGet**](ProvidersApi.md#providersget) | **GET** /providers | List providers


# **providersCompanyIdApprovePost**
> providersCompanyIdApprovePost(companyId, providersCompanyIdApprovePostRequest)

Approve provider branches

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getProvidersApi();
final String companyId = companyId_example; // String | 
final ProvidersCompanyIdApprovePostRequest providersCompanyIdApprovePostRequest = ; // ProvidersCompanyIdApprovePostRequest | 

try {
    api.providersCompanyIdApprovePost(companyId, providersCompanyIdApprovePostRequest);
} catch on DioException (e) {
    print('Exception when calling ProvidersApi->providersCompanyIdApprovePost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **companyId** | **String**|  | 
 **providersCompanyIdApprovePostRequest** | [**ProvidersCompanyIdApprovePostRequest**](ProvidersCompanyIdApprovePostRequest.md)|  | [optional] 

### Return type

void (empty response body)

### Authorization

[BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **providersCompanyIdDeclinePost**
> providersCompanyIdDeclinePost(companyId, subscriptionsCancelPostRequest)

Decline provider branch request

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getProvidersApi();
final String companyId = companyId_example; // String | 
final SubscriptionsCancelPostRequest subscriptionsCancelPostRequest = ; // SubscriptionsCancelPostRequest | 

try {
    api.providersCompanyIdDeclinePost(companyId, subscriptionsCancelPostRequest);
} catch on DioException (e) {
    print('Exception when calling ProvidersApi->providersCompanyIdDeclinePost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **companyId** | **String**|  | 
 **subscriptionsCancelPostRequest** | [**SubscriptionsCancelPostRequest**](SubscriptionsCancelPostRequest.md)|  | [optional] 

### Return type

void (empty response body)

### Authorization

[BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **providersGet**
> BuiltList<ProviderSummary> providersGet(branchId, companySize, providerType, zipPrefix, status, claimed, format)

List providers

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getProvidersApi();
final String branchId = branchId_example; // String | 
final String companySize = companySize_example; // String | 
final String providerType = providerType_example; // String | 
final String zipPrefix = zipPrefix_example; // String | 
final String status = status_example; // String | 
final String claimed = claimed_example; // String | 
final String format = format_example; // String | Use format=csv to export providers list.

try {
    final response = api.providersGet(branchId, companySize, providerType, zipPrefix, status, claimed, format);
    print(response);
} catch on DioException (e) {
    print('Exception when calling ProvidersApi->providersGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **branchId** | **String**|  | [optional] 
 **companySize** | **String**|  | [optional] 
 **providerType** | **String**|  | [optional] 
 **zipPrefix** | **String**|  | [optional] 
 **status** | **String**|  | [optional] 
 **claimed** | **String**|  | [optional] 
 **format** | **String**| Use format=csv to export providers list. | [optional] 

### Return type

[**BuiltList&lt;ProviderSummary&gt;**](ProviderSummary.md)

### Authorization

[BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

