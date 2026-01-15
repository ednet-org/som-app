# openapi.api.AdsApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to *http://localhost:8080*

Method | HTTP request | Description
------------- | ------------- | -------------
[**adsAdIdActivatePost**](AdsApi.md#adsadidactivatepost) | **POST** /ads/{adId}/activate | Activate ad
[**adsAdIdDeactivatePost**](AdsApi.md#adsadiddeactivatepost) | **POST** /ads/{adId}/deactivate | Deactivate ad
[**adsAdIdDelete**](AdsApi.md#adsadiddelete) | **DELETE** /ads/{adId} | Delete ad
[**adsAdIdGet**](AdsApi.md#adsadidget) | **GET** /ads/{adId} | Get ad
[**adsAdIdImagePost**](AdsApi.md#adsadidimagepost) | **POST** /ads/{adId}/image | Upload ad image
[**adsAdIdPut**](AdsApi.md#adsadidput) | **PUT** /ads/{adId} | Update ad
[**adsGet**](AdsApi.md#adsget) | **GET** /ads | List ads
[**createAd**](AdsApi.md#createad) | **POST** /ads | Create ad


# **adsAdIdActivatePost**
> adsAdIdActivatePost(adId, adActivationRequest)

Activate ad

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getAdsApi();
final String adId = adId_example; // String | 
final AdActivationRequest adActivationRequest = ; // AdActivationRequest | 

try {
    api.adsAdIdActivatePost(adId, adActivationRequest);
} catch on DioException (e) {
    print('Exception when calling AdsApi->adsAdIdActivatePost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **adId** | **String**|  | 
 **adActivationRequest** | [**AdActivationRequest**](AdActivationRequest.md)|  | [optional] 

### Return type

void (empty response body)

### Authorization

[BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adsAdIdDeactivatePost**
> adsAdIdDeactivatePost(adId)

Deactivate ad

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getAdsApi();
final String adId = adId_example; // String | 

try {
    api.adsAdIdDeactivatePost(adId);
} catch on DioException (e) {
    print('Exception when calling AdsApi->adsAdIdDeactivatePost: $e\n');
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

# **adsAdIdDelete**
> adsAdIdDelete(adId)

Delete ad

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getAdsApi();
final String adId = adId_example; // String | 

try {
    api.adsAdIdDelete(adId);
} catch on DioException (e) {
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
} catch on DioException (e) {
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

# **adsAdIdImagePost**
> AdsAdIdImagePost200Response adsAdIdImagePost(adId, file)

Upload ad image

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getAdsApi();
final String adId = adId_example; // String | 
final MultipartFile file = BINARY_DATA_HERE; // MultipartFile | 

try {
    final response = api.adsAdIdImagePost(adId, file);
    print(response);
} catch on DioException (e) {
    print('Exception when calling AdsApi->adsAdIdImagePost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **adId** | **String**|  | 
 **file** | **MultipartFile**|  | 

### Return type

[**AdsAdIdImagePost200Response**](AdsAdIdImagePost200Response.md)

### Authorization

[BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: multipart/form-data
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **adsAdIdPut**
> adsAdIdPut(adId, ad)

Update ad

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getAdsApi();
final String adId = adId_example; // String | 
final Ad ad = ; // Ad | 

try {
    api.adsAdIdPut(adId, ad);
} catch on DioException (e) {
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
> BuiltList<Ad> adsGet(branchId, scope, companyId, status)

List ads

Public calls return active ads. Use scope=company or scope=all with Bearer auth to list managed ads.

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getAdsApi();
final String branchId = branchId_example; // String | 
final String scope = scope_example; // String | company = list ads for the authenticated company, all = list ads across companies (consultant only)
final String companyId = companyId_example; // String | Optional company id when scope=all
final String status = status_example; // String | Filter by ad status (e.g. active, draft, expired)

try {
    final response = api.adsGet(branchId, scope, companyId, status);
    print(response);
} catch on DioException (e) {
    print('Exception when calling AdsApi->adsGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **branchId** | **String**|  | [optional] 
 **scope** | **String**| company = list ads for the authenticated company, all = list ads across companies (consultant only) | [optional] 
 **companyId** | **String**| Optional company id when scope=all | [optional] 
 **status** | **String**| Filter by ad status (e.g. active, draft, expired) | [optional] 

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

final api = Openapi().getAdsApi();
final CreateAdRequest createAdRequest = ; // CreateAdRequest | 

try {
    final response = api.createAd(createAdRequest);
    print(response);
} catch on DioException (e) {
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

