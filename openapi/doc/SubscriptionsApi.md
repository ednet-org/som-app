# openapi.api.SubscriptionsApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to *http://localhost:8080*

Method | HTTP request | Description
------------- | ------------- | -------------
[**subscriptionsGet**](SubscriptionsApi.md#subscriptionsget) | **GET** /Subscriptions | List subscription plans
[**subscriptionsUpgradePost**](SubscriptionsApi.md#subscriptionsupgradepost) | **POST** /Subscriptions/upgrade | Upgrade subscription plan


# **subscriptionsGet**
> SubscriptionsGet200Response subscriptionsGet()

List subscription plans

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getSubscriptionsApi();

try {
    final response = api.subscriptionsGet();
    print(response);
} catch on DioError (e) {
    print('Exception when calling SubscriptionsApi->subscriptionsGet: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**SubscriptionsGet200Response**](SubscriptionsGet200Response.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **subscriptionsUpgradePost**
> subscriptionsUpgradePost(subscriptionsUpgradePostRequest)

Upgrade subscription plan

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure HTTP basic authorization: BearerAuth
//defaultApiClient.getAuthentication<HttpBasicAuth>('BearerAuth').username = 'YOUR_USERNAME'
//defaultApiClient.getAuthentication<HttpBasicAuth>('BearerAuth').password = 'YOUR_PASSWORD';

final api = Openapi().getSubscriptionsApi();
final SubscriptionsUpgradePostRequest subscriptionsUpgradePostRequest = ; // SubscriptionsUpgradePostRequest | 

try {
    api.subscriptionsUpgradePost(subscriptionsUpgradePostRequest);
} catch on DioError (e) {
    print('Exception when calling SubscriptionsApi->subscriptionsUpgradePost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **subscriptionsUpgradePostRequest** | [**SubscriptionsUpgradePostRequest**](SubscriptionsUpgradePostRequest.md)|  | 

### Return type

void (empty response body)

### Authorization

[BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

