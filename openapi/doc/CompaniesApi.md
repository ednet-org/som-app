# openapi.api.CompaniesApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to *http://localhost:8080*

Method | HTTP request | Description
------------- | ------------- | -------------
[**companiesCompanyIdActivatePost**](CompaniesApi.md#companiescompanyidactivatepost) | **POST** /Companies/{companyId}/activate | Activate or reactivate company
[**companiesCompanyIdDelete**](CompaniesApi.md#companiescompanyiddelete) | **DELETE** /Companies/{companyId} | Deactivate company and users
[**companiesCompanyIdGet**](CompaniesApi.md#companiescompanyidget) | **GET** /Companies/{companyId} | Get company
[**companiesCompanyIdPut**](CompaniesApi.md#companiescompanyidput) | **PUT** /Companies/{companyId} | Update company
[**companiesGet**](CompaniesApi.md#companiesget) | **GET** /Companies | List companies
[**registerCompany**](CompaniesApi.md#registercompany) | **POST** /Companies | Register buyer/provider company


# **companiesCompanyIdActivatePost**
> AuthChangePasswordPost200Response companiesCompanyIdActivatePost(companyId)

Activate or reactivate company

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getCompaniesApi();
final String companyId = companyId_example; // String | 

try {
    final response = api.companiesCompanyIdActivatePost(companyId);
    print(response);
} catch on DioException (e) {
    print('Exception when calling CompaniesApi->companiesCompanyIdActivatePost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **companyId** | **String**|  | 

### Return type

[**AuthChangePasswordPost200Response**](AuthChangePasswordPost200Response.md)

### Authorization

[BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **companiesCompanyIdDelete**
> companiesCompanyIdDelete(companyId)

Deactivate company and users

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getCompaniesApi();
final String companyId = companyId_example; // String | 

try {
    api.companiesCompanyIdDelete(companyId);
} catch on DioException (e) {
    print('Exception when calling CompaniesApi->companiesCompanyIdDelete: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **companyId** | **String**|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **companiesCompanyIdGet**
> CompanyDto companiesCompanyIdGet(companyId)

Get company

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getCompaniesApi();
final String companyId = companyId_example; // String | 

try {
    final response = api.companiesCompanyIdGet(companyId);
    print(response);
} catch on DioException (e) {
    print('Exception when calling CompaniesApi->companiesCompanyIdGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **companyId** | **String**|  | 

### Return type

[**CompanyDto**](CompanyDto.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **companiesCompanyIdPut**
> companiesCompanyIdPut(companyId, companyDto)

Update company

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getCompaniesApi();
final String companyId = companyId_example; // String | 
final CompanyDto companyDto = ; // CompanyDto | 

try {
    api.companiesCompanyIdPut(companyId, companyDto);
} catch on DioException (e) {
    print('Exception when calling CompaniesApi->companiesCompanyIdPut: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **companyId** | **String**|  | 
 **companyDto** | [**CompanyDto**](CompanyDto.md)|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **companiesGet**
> BuiltList<CompanyDto> companiesGet(type)

List companies

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getCompaniesApi();
final String type = type_example; // String | 

try {
    final response = api.companiesGet(type);
    print(response);
} catch on DioException (e) {
    print('Exception when calling CompaniesApi->companiesGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **type** | **String**|  | [optional] 

### Return type

[**BuiltList&lt;CompanyDto&gt;**](CompanyDto.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **registerCompany**
> registerCompany(registerCompanyRequest)

Register buyer/provider company

### Example
```dart
import 'package:openapi/api.dart';

final api = Openapi().getCompaniesApi();
final RegisterCompanyRequest registerCompanyRequest = ; // RegisterCompanyRequest | 

try {
    api.registerCompany(registerCompanyRequest);
} catch on DioException (e) {
    print('Exception when calling CompaniesApi->registerCompany: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **registerCompanyRequest** | [**RegisterCompanyRequest**](RegisterCompanyRequest.md)|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

