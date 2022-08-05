// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_company_service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// ignore_for_file: always_put_control_body_on_new_line, always_specify_types, prefer_const_declarations, unnecessary_brace_in_string_interps
class _$ApiCompanyService extends ApiCompanyService {
  _$ApiCompanyService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final definitionType = ApiCompanyService;

  @override
  Future<Response<List<Company>>> getCompanies() {
    final $url = 'companies';
    final $request = Request('GET', $url, client.baseUrl);
    return client.send<List<Company>, Company>($request);
  }
}
