# openapi.api.BillingApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to *http://localhost:8080*

Method | HTTP request | Description
------------- | ------------- | -------------
[**billingBillingIdPut**](BillingApi.md#billingbillingidput) | **PUT** /billing/{billingId} | Update billing record
[**billingGet**](BillingApi.md#billingget) | **GET** /billing | List billing records
[**billingPost**](BillingApi.md#billingpost) | **POST** /billing | Create billing record


# **billingBillingIdPut**
> billingBillingIdPut(billingId, billingBillingIdPutRequest)

Update billing record

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getBillingApi();
final String billingId = billingId_example; // String | 
final BillingBillingIdPutRequest billingBillingIdPutRequest = ; // BillingBillingIdPutRequest | 

try {
    api.billingBillingIdPut(billingId, billingBillingIdPutRequest);
} catch on DioException (e) {
    print('Exception when calling BillingApi->billingBillingIdPut: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **billingId** | **String**|  | 
 **billingBillingIdPutRequest** | [**BillingBillingIdPutRequest**](BillingBillingIdPutRequest.md)|  | 

### Return type

void (empty response body)

### Authorization

[BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **billingGet**
> BuiltList<BillingRecord> billingGet(companyId)

List billing records

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getBillingApi();
final String companyId = companyId_example; // String | 

try {
    final response = api.billingGet(companyId);
    print(response);
} catch on DioException (e) {
    print('Exception when calling BillingApi->billingGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **companyId** | **String**|  | [optional] 

### Return type

[**BuiltList&lt;BillingRecord&gt;**](BillingRecord.md)

### Authorization

[BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **billingPost**
> billingPost(billingRecord)

Create billing record

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getBillingApi();
final BillingRecord billingRecord = ; // BillingRecord | 

try {
    api.billingPost(billingRecord);
} catch on DioException (e) {
    print('Exception when calling BillingApi->billingPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **billingRecord** | [**BillingRecord**](BillingRecord.md)|  | 

### Return type

void (empty response body)

### Authorization

[BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

