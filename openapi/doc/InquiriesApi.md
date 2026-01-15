# openapi.api.InquiriesApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to *http://localhost:8081*

Method | HTTP request | Description
------------- | ------------- | -------------
[**createInquiry**](InquiriesApi.md#createinquiry) | **POST** /inquiries | Create inquiry
[**inquiriesGet**](InquiriesApi.md#inquiriesget) | **GET** /inquiries | List inquiries
[**inquiriesInquiryIdAssignPost**](InquiriesApi.md#inquiriesinquiryidassignpost) | **POST** /inquiries/{inquiryId}/assign | Assign inquiry to providers
[**inquiriesInquiryIdClosePost**](InquiriesApi.md#inquiriesinquiryidclosepost) | **POST** /inquiries/{inquiryId}/close | Close inquiry
[**inquiriesInquiryIdGet**](InquiriesApi.md#inquiriesinquiryidget) | **GET** /inquiries/{inquiryId} | Get inquiry
[**inquiriesInquiryIdIgnorePost**](InquiriesApi.md#inquiriesinquiryidignorepost) | **POST** /inquiries/{inquiryId}/ignore | Provider ignores inquiry
[**inquiriesInquiryIdPdfDelete**](InquiriesApi.md#inquiriesinquiryidpdfdelete) | **DELETE** /inquiries/{inquiryId}/pdf | Remove inquiry PDF
[**inquiriesInquiryIdPdfPost**](InquiriesApi.md#inquiriesinquiryidpdfpost) | **POST** /inquiries/{inquiryId}/pdf | Upload inquiry PDF


# **createInquiry**
> Inquiry createInquiry(createInquiryRequest)

Create inquiry

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getInquiriesApi();
final CreateInquiryRequest createInquiryRequest = ; // CreateInquiryRequest | 

try {
    final response = api.createInquiry(createInquiryRequest);
    print(response);
} catch on DioException (e) {
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
> BuiltList<Inquiry> inquiriesGet(status, branchId, branch, providerType, providerSize, createdFrom, createdTo, deadlineFrom, deadlineTo, editorIds, format)

List inquiries

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getInquiriesApi();
final String status = status_example; // String | 
final String branchId = branchId_example; // String | 
final String branch = branch_example; // String | 
final String providerType = providerType_example; // String | 
final String providerSize = providerSize_example; // String | 
final DateTime createdFrom = 2013-10-20T19:20:30+01:00; // DateTime | 
final DateTime createdTo = 2013-10-20T19:20:30+01:00; // DateTime | 
final DateTime deadlineFrom = 2013-10-20T19:20:30+01:00; // DateTime | 
final DateTime deadlineTo = 2013-10-20T19:20:30+01:00; // DateTime | 
final String editorIds = editorIds_example; // String | Comma-separated list of editor user IDs (admin/consultant only)
final String format = format_example; // String | 

try {
    final response = api.inquiriesGet(status, branchId, branch, providerType, providerSize, createdFrom, createdTo, deadlineFrom, deadlineTo, editorIds, format);
    print(response);
} catch on DioException (e) {
    print('Exception when calling InquiriesApi->inquiriesGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **status** | **String**|  | [optional] 
 **branchId** | **String**|  | [optional] 
 **branch** | **String**|  | [optional] 
 **providerType** | **String**|  | [optional] 
 **providerSize** | **String**|  | [optional] 
 **createdFrom** | **DateTime**|  | [optional] 
 **createdTo** | **DateTime**|  | [optional] 
 **deadlineFrom** | **DateTime**|  | [optional] 
 **deadlineTo** | **DateTime**|  | [optional] 
 **editorIds** | **String**| Comma-separated list of editor user IDs (admin/consultant only) | [optional] 
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

final api = Openapi().getInquiriesApi();
final String inquiryId = inquiryId_example; // String | 
final InquiriesInquiryIdAssignPostRequest inquiriesInquiryIdAssignPostRequest = ; // InquiriesInquiryIdAssignPostRequest | 

try {
    api.inquiriesInquiryIdAssignPost(inquiryId, inquiriesInquiryIdAssignPostRequest);
} catch on DioException (e) {
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

# **inquiriesInquiryIdClosePost**
> inquiriesInquiryIdClosePost(inquiryId)

Close inquiry

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getInquiriesApi();
final String inquiryId = inquiryId_example; // String | 

try {
    api.inquiriesInquiryIdClosePost(inquiryId);
} catch on DioException (e) {
    print('Exception when calling InquiriesApi->inquiriesInquiryIdClosePost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **inquiryId** | **String**|  | 

### Return type

void (empty response body)

### Authorization

[BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **inquiriesInquiryIdGet**
> Inquiry inquiriesInquiryIdGet(inquiryId)

Get inquiry

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getInquiriesApi();
final String inquiryId = inquiryId_example; // String | 

try {
    final response = api.inquiriesInquiryIdGet(inquiryId);
    print(response);
} catch on DioException (e) {
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

# **inquiriesInquiryIdIgnorePost**
> inquiriesInquiryIdIgnorePost(inquiryId)

Provider ignores inquiry

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getInquiriesApi();
final String inquiryId = inquiryId_example; // String | 

try {
    api.inquiriesInquiryIdIgnorePost(inquiryId);
} catch on DioException (e) {
    print('Exception when calling InquiriesApi->inquiriesInquiryIdIgnorePost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **inquiryId** | **String**|  | 

### Return type

void (empty response body)

### Authorization

[BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **inquiriesInquiryIdPdfDelete**
> inquiriesInquiryIdPdfDelete(inquiryId)

Remove inquiry PDF

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getInquiriesApi();
final String inquiryId = inquiryId_example; // String | 

try {
    api.inquiriesInquiryIdPdfDelete(inquiryId);
} catch on DioException (e) {
    print('Exception when calling InquiriesApi->inquiriesInquiryIdPdfDelete: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **inquiryId** | **String**|  | 

### Return type

void (empty response body)

### Authorization

[BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **inquiriesInquiryIdPdfPost**
> InquiriesInquiryIdPdfPost200Response inquiriesInquiryIdPdfPost(inquiryId, file)

Upload inquiry PDF

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getInquiriesApi();
final String inquiryId = inquiryId_example; // String | 
final MultipartFile file = BINARY_DATA_HERE; // MultipartFile | 

try {
    final response = api.inquiriesInquiryIdPdfPost(inquiryId, file);
    print(response);
} catch on DioException (e) {
    print('Exception when calling InquiriesApi->inquiriesInquiryIdPdfPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **inquiryId** | **String**|  | 
 **file** | **MultipartFile**|  | 

### Return type

[**InquiriesInquiryIdPdfPost200Response**](InquiriesInquiryIdPdfPost200Response.md)

### Authorization

[BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: multipart/form-data
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

