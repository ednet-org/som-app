import 'package:json_annotation/json_annotation.dart';

import 'api_entity.dart';

part 'subscription.g.dart';

@JsonSerializable()
class Subscription extends ApiEntity {
  final num type;
  final bool isActive;

  final num priceInSubunit;
  final String? rules;
  final DateTime createdAt;

  Subscription(
    String id, {
    required this.type,
    required this.isActive,
    required this.priceInSubunit,
    required this.createdAt,
    required this.rules,
  }) : super(id);

  Map<String, dynamic> toJson() => _$SubscriptionToJson(this);
  static const fromJsonFactory = _$SubscriptionFromJson;
}

// https://medium.com/teamkraken/converting-json-api-response-to-dart-objects-with-chopper-and-jsonserializable-8ec98b762ac1
