# openapi.api.StatsApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to *http://localhost:8080*

Method | HTTP request | Description
------------- | ------------- | -------------
[**statsBuyerGet**](StatsApi.md#statsbuyerget) | **GET** /stats/buyer | Buyer statistics
[**statsConsultantGet**](StatsApi.md#statsconsultantget) | **GET** /stats/consultant | Consultant statistics
[**statsProviderGet**](StatsApi.md#statsproviderget) | **GET** /stats/provider | Provider statistics


# **statsBuyerGet**
> StatsBuyerGet200Response statsBuyerGet(from, to, userId, format)

Buyer statistics

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure HTTP basic authorization: BearerAuth
//defaultApiClient.getAuthentication<HttpBasicAuth>('BearerAuth').username = 'YOUR_USERNAME'
//defaultApiClient.getAuthentication<HttpBasicAuth>('BearerAuth').password = 'YOUR_PASSWORD';

final api = Openapi().getStatsApi();
final DateTime from = 2013-10-20T19:20:30+01:00; // DateTime | 
final DateTime to = 2013-10-20T19:20:30+01:00; // DateTime | 
final String userId = userId_example; // String | 
final String format = format_example; // String | 

try {
    final response = api.statsBuyerGet(from, to, userId, format);
    print(response);
} catch on DioError (e) {
    print('Exception when calling StatsApi->statsBuyerGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **from** | **DateTime**|  | [optional] 
 **to** | **DateTime**|  | [optional] 
 **userId** | **String**|  | [optional] 
 **format** | **String**|  | [optional] 

### Return type

[**StatsBuyerGet200Response**](StatsBuyerGet200Response.md)

### Authorization

[BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, text/csv

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **statsConsultantGet**
> StatsBuyerGet200Response statsConsultantGet(from, to, format)

Consultant statistics

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure HTTP basic authorization: BearerAuth
//defaultApiClient.getAuthentication<HttpBasicAuth>('BearerAuth').username = 'YOUR_USERNAME'
//defaultApiClient.getAuthentication<HttpBasicAuth>('BearerAuth').password = 'YOUR_PASSWORD';

final api = Openapi().getStatsApi();
final DateTime from = 2013-10-20T19:20:30+01:00; // DateTime | 
final DateTime to = 2013-10-20T19:20:30+01:00; // DateTime | 
final String format = format_example; // String | 

try {
    final response = api.statsConsultantGet(from, to, format);
    print(response);
} catch on DioError (e) {
    print('Exception when calling StatsApi->statsConsultantGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **from** | **DateTime**|  | [optional] 
 **to** | **DateTime**|  | [optional] 
 **format** | **String**|  | [optional] 

### Return type

[**StatsBuyerGet200Response**](StatsBuyerGet200Response.md)

### Authorization

[BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, text/csv

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **statsProviderGet**
> StatsProviderGet200Response statsProviderGet(from, to, format)

Provider statistics

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure HTTP basic authorization: BearerAuth
//defaultApiClient.getAuthentication<HttpBasicAuth>('BearerAuth').username = 'YOUR_USERNAME'
//defaultApiClient.getAuthentication<HttpBasicAuth>('BearerAuth').password = 'YOUR_PASSWORD';

final api = Openapi().getStatsApi();
final DateTime from = 2013-10-20T19:20:30+01:00; // DateTime | 
final DateTime to = 2013-10-20T19:20:30+01:00; // DateTime | 
final String format = format_example; // String | 

try {
    final response = api.statsProviderGet(from, to, format);
    print(response);
} catch on DioError (e) {
    print('Exception when calling StatsApi->statsProviderGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **from** | **DateTime**|  | [optional] 
 **to** | **DateTime**|  | [optional] 
 **format** | **String**|  | [optional] 

### Return type

[**StatsProviderGet200Response**](StatsProviderGet200Response.md)

### Authorization

[BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json, text/csv

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

