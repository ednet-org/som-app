// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'som_service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// ignore_for_file: always_put_control_body_on_new_line, always_specify_types, prefer_const_declarations, unnecessary_brace_in_string_interps
class _$SomService extends SomService {
  _$SomService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final definitionType = SomService;

  @override
  Future<Response<List<Subscription>>> getSubscriptions() {
    final $url = '/Subscriptions';
    final $request = Request('GET', $url, client.baseUrl);
    return client.send<List<Subscription>, Subscription>($request);
  }
}
