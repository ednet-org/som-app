// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// ignore_for_file: always_put_control_body_on_new_line, always_specify_types, prefer_const_declarations, unnecessary_brace_in_string_interps
class _$SubscriptionService extends SubscriptionService {
  _$SubscriptionService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final definitionType = SubscriptionService;

  @override
  Future<Response<List<Subscription>>> getSubscriptions() {
    final $url = '/Subscriptions';
    final $request = Request('GET', $url, client.baseUrl);
    return client.send<List<Subscription>, Subscription>($request);
  }
}
