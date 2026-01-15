# openapi.api.ProvidersApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to *http://localhost:8081*

Method | HTTP request | Description
------------- | ------------- | -------------
[**providersCompanyIdApprovePost**](ProvidersApi.md#providerscompanyidapprovepost) | **POST** /providers/{companyId}/approve | Approve provider branches
[**providersCompanyIdDeclinePost**](ProvidersApi.md#providerscompanyiddeclinepost) | **POST** /providers/{companyId}/decline | Decline provider branch request
[**providersCompanyIdGet**](ProvidersApi.md#providerscompanyidget) | **GET** /providers/{companyId} | Get provider profile
[**providersCompanyIdPaymentDetailsPut**](ProvidersApi.md#providerscompanyidpaymentdetailsput) | **PUT** /providers/{companyId}/paymentDetails | Update provider payment details
[**providersCompanyIdProductsGet**](ProvidersApi.md#providerscompanyidproductsget) | **GET** /providers/{companyId}/products | List provider products
[**providersCompanyIdProductsPost**](ProvidersApi.md#providerscompanyidproductspost) | **POST** /providers/{companyId}/products | Create provider product
[**providersCompanyIdProductsProductIdDelete**](ProvidersApi.md#providerscompanyidproductsproductiddelete) | **DELETE** /providers/{companyId}/products/{productId} | Delete provider product
[**providersCompanyIdProductsProductIdPut**](ProvidersApi.md#providerscompanyidproductsproductidput) | **PUT** /providers/{companyId}/products/{productId} | Update provider product
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

# **providersCompanyIdGet**
> ProviderProfile providersCompanyIdGet(companyId)

Get provider profile

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getProvidersApi();
final String companyId = companyId_example; // String | 

try {
    final response = api.providersCompanyIdGet(companyId);
    print(response);
} catch on DioException (e) {
    print('Exception when calling ProvidersApi->providersCompanyIdGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **companyId** | **String**|  | 

### Return type

[**ProviderProfile**](ProviderProfile.md)

### Authorization

[BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **providersCompanyIdPaymentDetailsPut**
> ProvidersCompanyIdPaymentDetailsPut200Response providersCompanyIdPaymentDetailsPut(companyId, bankDetails)

Update provider payment details

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getProvidersApi();
final String companyId = companyId_example; // String | 
final BankDetails bankDetails = ; // BankDetails | 

try {
    final response = api.providersCompanyIdPaymentDetailsPut(companyId, bankDetails);
    print(response);
} catch on DioException (e) {
    print('Exception when calling ProvidersApi->providersCompanyIdPaymentDetailsPut: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **companyId** | **String**|  | 
 **bankDetails** | [**BankDetails**](BankDetails.md)|  | 

### Return type

[**ProvidersCompanyIdPaymentDetailsPut200Response**](ProvidersCompanyIdPaymentDetailsPut200Response.md)

### Authorization

[BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **providersCompanyIdProductsGet**
> BuiltList<Product> providersCompanyIdProductsGet(companyId)

List provider products

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getProvidersApi();
final String companyId = companyId_example; // String | 

try {
    final response = api.providersCompanyIdProductsGet(companyId);
    print(response);
} catch on DioException (e) {
    print('Exception when calling ProvidersApi->providersCompanyIdProductsGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **companyId** | **String**|  | 

### Return type

[**BuiltList&lt;Product&gt;**](Product.md)

### Authorization

[BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **providersCompanyIdProductsPost**
> Product providersCompanyIdProductsPost(companyId, productInput)

Create provider product

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getProvidersApi();
final String companyId = companyId_example; // String | 
final ProductInput productInput = ; // ProductInput | 

try {
    final response = api.providersCompanyIdProductsPost(companyId, productInput);
    print(response);
} catch on DioException (e) {
    print('Exception when calling ProvidersApi->providersCompanyIdProductsPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **companyId** | **String**|  | 
 **productInput** | [**ProductInput**](ProductInput.md)|  | 

### Return type

[**Product**](Product.md)

### Authorization

[BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **providersCompanyIdProductsProductIdDelete**
> providersCompanyIdProductsProductIdDelete(companyId, productId)

Delete provider product

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getProvidersApi();
final String companyId = companyId_example; // String | 
final String productId = productId_example; // String | 

try {
    api.providersCompanyIdProductsProductIdDelete(companyId, productId);
} catch on DioException (e) {
    print('Exception when calling ProvidersApi->providersCompanyIdProductsProductIdDelete: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **companyId** | **String**|  | 
 **productId** | **String**|  | 

### Return type

void (empty response body)

### Authorization

[BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **providersCompanyIdProductsProductIdPut**
> Product providersCompanyIdProductsProductIdPut(companyId, productId, productInput)

Update provider product

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getProvidersApi();
final String companyId = companyId_example; // String | 
final String productId = productId_example; // String | 
final ProductInput productInput = ; // ProductInput | 

try {
    final response = api.providersCompanyIdProductsProductIdPut(companyId, productId, productInput);
    print(response);
} catch on DioException (e) {
    print('Exception when calling ProvidersApi->providersCompanyIdProductsProductIdPut: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **companyId** | **String**|  | 
 **productId** | **String**|  | 
 **productInput** | [**ProductInput**](ProductInput.md)|  | 

### Return type

[**Product**](Product.md)

### Authorization

[BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

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

