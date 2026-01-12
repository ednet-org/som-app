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


# **providersCompanyIdApprovePost**
> providersCompanyIdApprovePost(companyId, providersCompanyIdApprovePostRequest)

Approve provider branches

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure HTTP basic authorization: BearerAuth
//defaultApiClient.getAuthentication<HttpBasicAuth>('BearerAuth').username = 'YOUR_USERNAME'
//defaultApiClient.getAuthentication<HttpBasicAuth>('BearerAuth').password = 'YOUR_PASSWORD';

final api = Openapi().getProvidersApi();
final String companyId = companyId_example; // String | 
final ProvidersCompanyIdApprovePostRequest providersCompanyIdApprovePostRequest = ; // ProvidersCompanyIdApprovePostRequest | 

try {
    api.providersCompanyIdApprovePost(companyId, providersCompanyIdApprovePostRequest);
} catch on DioError (e) {
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
> providersCompanyIdDeclinePost(companyId)

Decline provider branch request

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure HTTP basic authorization: BearerAuth
//defaultApiClient.getAuthentication<HttpBasicAuth>('BearerAuth').username = 'YOUR_USERNAME'
//defaultApiClient.getAuthentication<HttpBasicAuth>('BearerAuth').password = 'YOUR_PASSWORD';

final api = Openapi().getProvidersApi();
final String companyId = companyId_example; // String | 

try {
    api.providersCompanyIdDeclinePost(companyId);
} catch on DioError (e) {
    print('Exception when calling ProvidersApi->providersCompanyIdDeclinePost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **companyId** | **String**|  | 

### Return type

void (empty response body)

### Authorization

[BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

