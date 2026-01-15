# openapi.model.SubscriptionPlanInput

## Load the model package
```dart
import 'package:openapi/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**title** | **String** |  | 
**sortPriority** | **int** |  | 
**isActive** | **bool** |  | [optional] 
**priceInSubunit** | **int** |  | 
**maxUsers** | **int** |  | [optional] 
**setupFeeInSubunit** | **int** |  | [optional] 
**bannerAdsPerMonth** | **int** |  | [optional] 
**normalAdsPerMonth** | **int** |  | [optional] 
**freeMonths** | **int** |  | [optional] 
**commitmentPeriodMonths** | **int** |  | [optional] 
**confirm** | **bool** | Require explicit confirmation when updating plans with active subscribers. | [optional] 
**rules** | [**BuiltList&lt;SubscriptionPlanRulesInner&gt;**](SubscriptionPlanRulesInner.md) |  | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


