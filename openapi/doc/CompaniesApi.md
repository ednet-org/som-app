# openapi.api.CompaniesApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to *http://localhost:8080*

Method | HTTP request | Description
------------- | ------------- | -------------
[**companiesCompanyIdDelete**](CompaniesApi.md#companiescompanyiddelete) | **DELETE** /Companies/{companyId} | Deactivate company and users
[**companiesCompanyIdGet**](CompaniesApi.md#companiescompanyidget) | **GET** /Companies/{companyId} | Get company
[**companiesCompanyIdPut**](CompaniesApi.md#companiescompanyidput) | **PUT** /Companies/{companyId} | Update company
[**companiesGet**](CompaniesApi.md#companiesget) | **GET** /Companies | List companies
[**registerCompany**](CompaniesApi.md#registercompany) | **POST** /Companies | Register buyer/provider company


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
} catch on DioError (e) {
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
} catch on DioError (e) {
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
} catch on DioError (e) {
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
 - **Accept**: Not defined

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
} catch on DioError (e) {
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
} catch on DioError (e) {
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

