# openapi.model.CompanyRegistration

## Load the model package
```dart
import 'package:openapi/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**name** | **String** |  | 
**address** | [**Address**](Address.md) |  | 
**uidNr** | **String** |  | 
**registrationNr** | **String** |  | 
**companySize** | **int** | 0=0-10, 1=11-50, 2=51-100, 3=101-250, 4=251-500, 5=500+ | 
**type** | **int** | 0=buyer, 1=provider | 
**websiteUrl** | **String** |  | [optional] 
**providerData** | [**ProviderRegistrationData**](ProviderRegistrationData.md) |  | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


