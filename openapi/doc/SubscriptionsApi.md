# openapi.api.SubscriptionsApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to *http://localhost:8080*

Method | HTTP request | Description
------------- | ------------- | -------------
[**subscriptionsCancelPost**](SubscriptionsApi.md#subscriptionscancelpost) | **POST** /Subscriptions/cancel | Request subscription cancellation
[**subscriptionsCancellationsCancellationIdPut**](SubscriptionsApi.md#subscriptionscancellationscancellationidput) | **PUT** /Subscriptions/cancellations/{cancellationId} | Resolve cancellation request
[**subscriptionsCancellationsGet**](SubscriptionsApi.md#subscriptionscancellationsget) | **GET** /Subscriptions/cancellations | List subscription cancellation requests
[**subscriptionsCurrentGet**](SubscriptionsApi.md#subscriptionscurrentget) | **GET** /Subscriptions/current | Get current subscription
[**subscriptionsDowngradePost**](SubscriptionsApi.md#subscriptionsdowngradepost) | **POST** /Subscriptions/downgrade | Downgrade subscription plan
[**subscriptionsGet**](SubscriptionsApi.md#subscriptionsget) | **GET** /Subscriptions | List subscription plans
[**subscriptionsPlansPlanIdDelete**](SubscriptionsApi.md#subscriptionsplansplaniddelete) | **DELETE** /Subscriptions/plans/{planId} | Delete subscription plan
[**subscriptionsPlansPlanIdGet**](SubscriptionsApi.md#subscriptionsplansplanidget) | **GET** /Subscriptions/plans/{planId} | Get subscription plan
[**subscriptionsPlansPlanIdPut**](SubscriptionsApi.md#subscriptionsplansplanidput) | **PUT** /Subscriptions/plans/{planId} | Update subscription plan
[**subscriptionsPost**](SubscriptionsApi.md#subscriptionspost) | **POST** /Subscriptions | Create subscription plan
[**subscriptionsUpgradePost**](SubscriptionsApi.md#subscriptionsupgradepost) | **POST** /Subscriptions/upgrade | Upgrade subscription plan


# **subscriptionsCancelPost**
> subscriptionsCancelPost(subscriptionsCancelPostRequest)

Request subscription cancellation

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getSubscriptionsApi();
final SubscriptionsCancelPostRequest subscriptionsCancelPostRequest = ; // SubscriptionsCancelPostRequest | 

try {
    api.subscriptionsCancelPost(subscriptionsCancelPostRequest);
} catch on DioException (e) {
    print('Exception when calling SubscriptionsApi->subscriptionsCancelPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **subscriptionsCancelPostRequest** | [**SubscriptionsCancelPostRequest**](SubscriptionsCancelPostRequest.md)|  | 

### Return type

void (empty response body)

### Authorization

[BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **subscriptionsCancellationsCancellationIdPut**
> subscriptionsCancellationsCancellationIdPut(cancellationId, authChangePasswordPost200Response)

Resolve cancellation request

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getSubscriptionsApi();
final String cancellationId = cancellationId_example; // String | 
final AuthChangePasswordPost200Response authChangePasswordPost200Response = ; // AuthChangePasswordPost200Response | 

try {
    api.subscriptionsCancellationsCancellationIdPut(cancellationId, authChangePasswordPost200Response);
} catch on DioException (e) {
    print('Exception when calling SubscriptionsApi->subscriptionsCancellationsCancellationIdPut: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **cancellationId** | **String**|  | 
 **authChangePasswordPost200Response** | [**AuthChangePasswordPost200Response**](AuthChangePasswordPost200Response.md)|  | 

### Return type

void (empty response body)

### Authorization

[BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **subscriptionsCancellationsGet**
> BuiltList<SubscriptionCancellation> subscriptionsCancellationsGet(companyId, status)

List subscription cancellation requests

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getSubscriptionsApi();
final String companyId = companyId_example; // String | 
final String status = status_example; // String | 

try {
    final response = api.subscriptionsCancellationsGet(companyId, status);
    print(response);
} catch on DioException (e) {
    print('Exception when calling SubscriptionsApi->subscriptionsCancellationsGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **companyId** | **String**|  | [optional] 
 **status** | **String**|  | [optional] 

### Return type

[**BuiltList&lt;SubscriptionCancellation&gt;**](SubscriptionCancellation.md)

### Authorization

[BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **subscriptionsCurrentGet**
> SubscriptionCurrent subscriptionsCurrentGet()

Get current subscription

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getSubscriptionsApi();

try {
    final response = api.subscriptionsCurrentGet();
    print(response);
} catch on DioException (e) {
    print('Exception when calling SubscriptionsApi->subscriptionsCurrentGet: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**SubscriptionCurrent**](SubscriptionCurrent.md)

### Authorization

[BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **subscriptionsDowngradePost**
> subscriptionsDowngradePost(subscriptionsUpgradePostRequest)

Downgrade subscription plan

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getSubscriptionsApi();
final SubscriptionsUpgradePostRequest subscriptionsUpgradePostRequest = ; // SubscriptionsUpgradePostRequest | 

try {
    api.subscriptionsDowngradePost(subscriptionsUpgradePostRequest);
} catch on DioException (e) {
    print('Exception when calling SubscriptionsApi->subscriptionsDowngradePost: $e\n');
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
} catch on DioException (e) {
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

# **subscriptionsPlansPlanIdDelete**
> subscriptionsPlansPlanIdDelete(planId)

Delete subscription plan

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getSubscriptionsApi();
final String planId = planId_example; // String | 

try {
    api.subscriptionsPlansPlanIdDelete(planId);
} catch on DioException (e) {
    print('Exception when calling SubscriptionsApi->subscriptionsPlansPlanIdDelete: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **planId** | **String**|  | 

### Return type

void (empty response body)

### Authorization

[BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **subscriptionsPlansPlanIdGet**
> SubscriptionPlan subscriptionsPlansPlanIdGet(planId)

Get subscription plan

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getSubscriptionsApi();
final String planId = planId_example; // String | 

try {
    final response = api.subscriptionsPlansPlanIdGet(planId);
    print(response);
} catch on DioException (e) {
    print('Exception when calling SubscriptionsApi->subscriptionsPlansPlanIdGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **planId** | **String**|  | 

### Return type

[**SubscriptionPlan**](SubscriptionPlan.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **subscriptionsPlansPlanIdPut**
> subscriptionsPlansPlanIdPut(planId, subscriptionPlanInput)

Update subscription plan

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getSubscriptionsApi();
final String planId = planId_example; // String | 
final SubscriptionPlanInput subscriptionPlanInput = ; // SubscriptionPlanInput | 

try {
    api.subscriptionsPlansPlanIdPut(planId, subscriptionPlanInput);
} catch on DioException (e) {
    print('Exception when calling SubscriptionsApi->subscriptionsPlansPlanIdPut: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **planId** | **String**|  | 
 **subscriptionPlanInput** | [**SubscriptionPlanInput**](SubscriptionPlanInput.md)|  | 

### Return type

void (empty response body)

### Authorization

[BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **subscriptionsPost**
> SubscriptionPlan subscriptionsPost(subscriptionPlanInput)

Create subscription plan

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getSubscriptionsApi();
final SubscriptionPlanInput subscriptionPlanInput = ; // SubscriptionPlanInput | 

try {
    final response = api.subscriptionsPost(subscriptionPlanInput);
    print(response);
} catch on DioException (e) {
    print('Exception when calling SubscriptionsApi->subscriptionsPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **subscriptionPlanInput** | [**SubscriptionPlanInput**](SubscriptionPlanInput.md)|  | 

### Return type

[**SubscriptionPlan**](SubscriptionPlan.md)

### Authorization

[BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **subscriptionsUpgradePost**
> subscriptionsUpgradePost(subscriptionsUpgradePostRequest)

Upgrade subscription plan

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getSubscriptionsApi();
final SubscriptionsUpgradePostRequest subscriptionsUpgradePostRequest = ; // SubscriptionsUpgradePostRequest | 

try {
    api.subscriptionsUpgradePost(subscriptionsUpgradePostRequest);
} catch on DioException (e) {
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

