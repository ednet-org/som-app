# openapi.api.AdsApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to *http://localhost:8080*

Method | HTTP request | Description
------------- | ------------- | -------------
[**adsAdIdDelete**](AdsApi.md#adsadiddelete) | **DELETE** /ads/{adId} | Delete ad
[**adsAdIdGet**](AdsApi.md#adsadidget) | **GET** /ads/{adId} | Get ad
[**adsAdIdPut**](AdsApi.md#adsadidput) | **PUT** /ads/{adId} | Update ad
[**adsGet**](AdsApi.md#adsget) | **GET** /ads | List active ads
[**createAd**](AdsApi.md#createad) | **POST** /ads | Create ad


# **adsAdIdDelete**
> adsAdIdDelete(adId)

Delete ad

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure HTTP basic authorization: BearerAuth
//defaultApiClient.getAuthentication<HttpBasicAuth>('BearerAuth').username = 'YOUR_USERNAME'
//defaultApiClient.getAuthentication<HttpBasicAuth>('BearerAuth').password = 'YOUR_PASSWORD';

final api = Openapi().getAdsApi();
final String adId = adId_example; // String | 

try {
    api.adsAdIdDelete(adId);
} catch on DioError (e) {
    print('Exception when calling AdsApi->adsAdIdDelete: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **adId** | **String**|  | 

### Return type

void (empty response body)

### Authorization

[BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adsAdIdGet**
> Ad adsAdIdGet(adId)

Get ad

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getAdsApi();
final String adId = adId_example; // String | 

try {
    final response = api.adsAdIdGet(adId);
    print(response);
} catch on DioError (e) {
    print('Exception when calling AdsApi->adsAdIdGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **adId** | **String**|  | 

### Return type

[**Ad**](Ad.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adsAdIdPut**
> adsAdIdPut(adId, ad)

Update ad

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure HTTP basic authorization: BearerAuth
//defaultApiClient.getAuthentication<HttpBasicAuth>('BearerAuth').username = 'YOUR_USERNAME'
//defaultApiClient.getAuthentication<HttpBasicAuth>('BearerAuth').password = 'YOUR_PASSWORD';

final api = Openapi().getAdsApi();
final String adId = adId_example; // String | 
final Ad ad = ; // Ad | 

try {
    api.adsAdIdPut(adId, ad);
} catch on DioError (e) {
    print('Exception when calling AdsApi->adsAdIdPut: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **adId** | **String**|  | 
 **ad** | [**Ad**](Ad.md)|  | 

### Return type

void (empty response body)

### Authorization

[BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adsGet**
> BuiltList<Ad> adsGet(branchId)

List active ads

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getAdsApi();
final String branchId = branchId_example; // String | 

try {
    final response = api.adsGet(branchId);
    print(response);
} catch on DioError (e) {
    print('Exception when calling AdsApi->adsGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **branchId** | **String**|  | [optional] 

### Return type

[**BuiltList&lt;Ad&gt;**](Ad.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **createAd**
> CreateAd200Response createAd(createAdRequest)

Create ad

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure HTTP basic authorization: BearerAuth
//defaultApiClient.getAuthentication<HttpBasicAuth>('BearerAuth').username = 'YOUR_USERNAME'
//defaultApiClient.getAuthentication<HttpBasicAuth>('BearerAuth').password = 'YOUR_PASSWORD';

final api = Openapi().getAdsApi();
final CreateAdRequest createAdRequest = ; // CreateAdRequest | 

try {
    final response = api.createAd(createAdRequest);
    print(response);
} catch on DioError (e) {
    print('Exception when calling AdsApi->createAd: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **createAdRequest** | [**CreateAdRequest**](CreateAdRequest.md)|  | 

### Return type

[**CreateAd200Response**](CreateAd200Response.md)

### Authorization

[BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: application/json, multipart/form-data
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

