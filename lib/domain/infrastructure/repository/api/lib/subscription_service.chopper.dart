// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

part of 'subscription_service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$SubscriptionService extends SubscriptionService {
  _$SubscriptionService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = SubscriptionService;

  @override
  Future<Response<List<Subscription>>> getSubscriptions() {
    final Uri $url = Uri.parse('/Subscriptions');
    final Request $request = Request('GET', $url, client.baseUrl);
    return client.send<List<Subscription>, Subscription>($request);
  }
}
