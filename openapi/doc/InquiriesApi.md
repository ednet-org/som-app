# openapi.api.InquiriesApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to *http://localhost:8080*

Method | HTTP request | Description
------------- | ------------- | -------------
[**createInquiry**](InquiriesApi.md#createinquiry) | **POST** /inquiries | Create inquiry
[**inquiriesGet**](InquiriesApi.md#inquiriesget) | **GET** /inquiries | List inquiries
[**inquiriesInquiryIdAssignPost**](InquiriesApi.md#inquiriesinquiryidassignpost) | **POST** /inquiries/{inquiryId}/assign | Assign inquiry to providers
[**inquiriesInquiryIdGet**](InquiriesApi.md#inquiriesinquiryidget) | **GET** /inquiries/{inquiryId} | Get inquiry


# **createInquiry**
> Inquiry createInquiry(createInquiryRequest)

Create inquiry

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure HTTP basic authorization: BearerAuth
//defaultApiClient.getAuthentication<HttpBasicAuth>('BearerAuth').username = 'YOUR_USERNAME'
//defaultApiClient.getAuthentication<HttpBasicAuth>('BearerAuth').password = 'YOUR_PASSWORD';

final api = Openapi().getInquiriesApi();
final CreateInquiryRequest createInquiryRequest = ; // CreateInquiryRequest | 

try {
    final response = api.createInquiry(createInquiryRequest);
    print(response);
} catch on DioError (e) {
    print('Exception when calling InquiriesApi->createInquiry: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **createInquiryRequest** | [**CreateInquiryRequest**](CreateInquiryRequest.md)|  | 

### Return type

[**Inquiry**](Inquiry.md)

### Authorization

[BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: application/json, multipart/form-data
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **inquiriesGet**
> BuiltList<Inquiry> inquiriesGet(status, format)

List inquiries

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure HTTP basic authorization: BearerAuth
//defaultApiClient.getAuthentication<HttpBasicAuth>('BearerAuth').username = 'YOUR_USERNAME'
//defaultApiClient.getAuthentication<HttpBasicAuth>('BearerAuth').password = 'YOUR_PASSWORD';

final api = Openapi().getInquiriesApi();
final String status = status_example; // String | 
final String format = format_example; // String | 

try {
    final response = api.inquiriesGet(status, format);
    print(response);
} catch on DioError (e) {
    print('Exception when calling InquiriesApi->inquiriesGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **status** | **String**|  | [optional] 
 **format** | **String**|  | [optional] 

### Return type

[**BuiltList&lt;Inquiry&gt;**](Inquiry.md)

### Authorization

[BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, text/csv

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **inquiriesInquiryIdAssignPost**
> inquiriesInquiryIdAssignPost(inquiryId, inquiriesInquiryIdAssignPostRequest)

Assign inquiry to providers

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure HTTP basic authorization: BearerAuth
//defaultApiClient.getAuthentication<HttpBasicAuth>('BearerAuth').username = 'YOUR_USERNAME'
//defaultApiClient.getAuthentication<HttpBasicAuth>('BearerAuth').password = 'YOUR_PASSWORD';

final api = Openapi().getInquiriesApi();
final String inquiryId = inquiryId_example; // String | 
final InquiriesInquiryIdAssignPostRequest inquiriesInquiryIdAssignPostRequest = ; // InquiriesInquiryIdAssignPostRequest | 

try {
    api.inquiriesInquiryIdAssignPost(inquiryId, inquiriesInquiryIdAssignPostRequest);
} catch on DioError (e) {
    print('Exception when calling InquiriesApi->inquiriesInquiryIdAssignPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **inquiryId** | **String**|  | 
 **inquiriesInquiryIdAssignPostRequest** | [**InquiriesInquiryIdAssignPostRequest**](InquiriesInquiryIdAssignPostRequest.md)|  | 

### Return type

void (empty response body)

### Authorization

[BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **inquiriesInquiryIdGet**
> Inquiry inquiriesInquiryIdGet(inquiryId)

Get inquiry

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure HTTP basic authorization: BearerAuth
//defaultApiClient.getAuthentication<HttpBasicAuth>('BearerAuth').username = 'YOUR_USERNAME'
//defaultApiClient.getAuthentication<HttpBasicAuth>('BearerAuth').password = 'YOUR_PASSWORD';

final api = Openapi().getInquiriesApi();
final String inquiryId = inquiryId_example; // String | 

try {
    final response = api.inquiriesInquiryIdGet(inquiryId);
    print(response);
} catch on DioError (e) {
    print('Exception when calling InquiriesApi->inquiriesInquiryIdGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **inquiryId** | **String**|  | 

### Return type

[**Inquiry**](Inquiry.md)

### Authorization

[BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

