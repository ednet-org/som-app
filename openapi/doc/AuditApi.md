# openapi.api.AuditApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to *http://localhost:8081*

Method | HTTP request | Description
------------- | ------------- | -------------
[**auditGet**](AuditApi.md#auditget) | **GET** /audit | List audit log entries


# **auditGet**
> BuiltList<AuditLogEntry> auditGet(limit)

List audit log entries

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getAuditApi();
final int limit = 56; // int | 

try {
    final response = api.auditGet(limit);
    print(response);
} catch on DioException (e) {
    print('Exception when calling AuditApi->auditGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **limit** | **int**|  | [optional] 

### Return type

[**BuiltList&lt;AuditLogEntry&gt;**](AuditLogEntry.md)

### Authorization

[BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

