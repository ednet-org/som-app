# openapi.api.SubscriptionsApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**subscriptionsGet**](SubscriptionsApi.md#subscriptionsget) | **GET** /Subscriptions | 


# **subscriptionsGet**
> SubscriptionsResponse subscriptionsGet()



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

[**SubscriptionsResponse**](SubscriptionsResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

