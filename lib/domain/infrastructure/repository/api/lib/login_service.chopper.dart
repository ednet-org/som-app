// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$LoginService extends LoginService {
  _$LoginService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = LoginService;

  @override
  Future<Response<AuthenticationResponseDto>> login(
      AuthenticateRequestDto body) {
    final Uri $url = Uri.parse('auth/login');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client
        .send<AuthenticationResponseDto, AuthenticationResponseDto>($request);
  }
}
