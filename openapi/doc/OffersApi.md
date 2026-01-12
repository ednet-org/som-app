# openapi.api.OffersApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to *http://localhost:8080*

Method | HTTP request | Description
------------- | ------------- | -------------
[**inquiriesInquiryIdOffersGet**](OffersApi.md#inquiriesinquiryidoffersget) | **GET** /inquiries/{inquiryId}/offers | List offers for inquiry
[**inquiriesInquiryIdOffersPost**](OffersApi.md#inquiriesinquiryidofferspost) | **POST** /inquiries/{inquiryId}/offers | Create offer for inquiry
[**offersOfferIdAcceptPost**](OffersApi.md#offersofferidacceptpost) | **POST** /offers/{offerId}/accept | Accept offer
[**offersOfferIdRejectPost**](OffersApi.md#offersofferidrejectpost) | **POST** /offers/{offerId}/reject | Reject offer


# **inquiriesInquiryIdOffersGet**
> BuiltList<Offer> inquiriesInquiryIdOffersGet(inquiryId)

List offers for inquiry

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure HTTP basic authorization: BearerAuth
//defaultApiClient.getAuthentication<HttpBasicAuth>('BearerAuth').username = 'YOUR_USERNAME'
//defaultApiClient.getAuthentication<HttpBasicAuth>('BearerAuth').password = 'YOUR_PASSWORD';

final api = Openapi().getOffersApi();
final String inquiryId = inquiryId_example; // String | 

try {
    final response = api.inquiriesInquiryIdOffersGet(inquiryId);
    print(response);
} catch on DioError (e) {
    print('Exception when calling OffersApi->inquiriesInquiryIdOffersGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **inquiryId** | **String**|  | 

### Return type

[**BuiltList&lt;Offer&gt;**](Offer.md)

### Authorization

[BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **inquiriesInquiryIdOffersPost**
> InquiriesInquiryIdOffersGet200Response inquiriesInquiryIdOffersPost(inquiryId, file)

Create offer for inquiry

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure HTTP basic authorization: BearerAuth
//defaultApiClient.getAuthentication<HttpBasicAuth>('BearerAuth').username = 'YOUR_USERNAME'
//defaultApiClient.getAuthentication<HttpBasicAuth>('BearerAuth').password = 'YOUR_PASSWORD';

final api = Openapi().getOffersApi();
final String inquiryId = inquiryId_example; // String | 
final MultipartFile file = BINARY_DATA_HERE; // MultipartFile | 

try {
    final response = api.inquiriesInquiryIdOffersPost(inquiryId, file);
    print(response);
} catch on DioError (e) {
    print('Exception when calling OffersApi->inquiriesInquiryIdOffersPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **inquiryId** | **String**|  | 
 **file** | **MultipartFile**|  | [optional] 

### Return type

[**InquiriesInquiryIdOffersGet200Response**](InquiriesInquiryIdOffersGet200Response.md)

### Authorization

[BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: multipart/form-data, application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **offersOfferIdAcceptPost**
> offersOfferIdAcceptPost(offerId)

Accept offer

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure HTTP basic authorization: BearerAuth
//defaultApiClient.getAuthentication<HttpBasicAuth>('BearerAuth').username = 'YOUR_USERNAME'
//defaultApiClient.getAuthentication<HttpBasicAuth>('BearerAuth').password = 'YOUR_PASSWORD';

final api = Openapi().getOffersApi();
final String offerId = offerId_example; // String | 

try {
    api.offersOfferIdAcceptPost(offerId);
} catch on DioError (e) {
    print('Exception when calling OffersApi->offersOfferIdAcceptPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **offerId** | **String**|  | 

### Return type

void (empty response body)

### Authorization

[BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **offersOfferIdRejectPost**
> offersOfferIdRejectPost(offerId)

Reject offer

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure HTTP basic authorization: BearerAuth
//defaultApiClient.getAuthentication<HttpBasicAuth>('BearerAuth').username = 'YOUR_USERNAME'
//defaultApiClient.getAuthentication<HttpBasicAuth>('BearerAuth').password = 'YOUR_PASSWORD';

final api = Openapi().getOffersApi();
final String offerId = offerId_example; // String | 

try {
    api.offersOfferIdRejectPost(offerId);
} catch on DioError (e) {
    print('Exception when calling OffersApi->offersOfferIdRejectPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **offerId** | **String**|  | 

### Return type

void (empty response body)

### Authorization

[BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

