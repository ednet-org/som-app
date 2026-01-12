// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_company_service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$ApiCompanyService extends ApiCompanyService {
  _$ApiCompanyService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = ApiCompanyService;

  @override
  Future<Response<List<Company>>> getCompanies() {
    final Uri $url = Uri.parse('companies');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<List<Company>, Company>($request);
  }
}
