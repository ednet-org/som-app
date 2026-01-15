// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Subscription _$SubscriptionFromJson(Map<String, dynamic> json) => Subscription(
  json['id'] as String,
  type: json['type'] as num?,
  isActive: json['isActive'] as bool?,
  priceInSubunit: json['priceInSubunit'] as num?,
  rules: json['rules'] as String?,
);

Map<String, dynamic> _$SubscriptionToJson(Subscription instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'isActive': instance.isActive,
      'priceInSubunit': instance.priceInSubunit,
      'rules': instance.rules,
    };
