import 'package:dio/dio.dart';
import 'package:openapi/openapi.dart';
import 'package:test/test.dart';

Openapi _openapiWithResponder(Response<dynamic> Function(RequestOptions) responder) {
  final interceptor = InterceptorsWrapper(
    onRequest: (options, handler) {
      try {
        handler.resolve(responder(options));
      } catch (error) {
        handler.reject(
          DioException(
            requestOptions: options,
            error: error,
            type: DioExceptionType.unknown,
          ),
          true,
        );
      }
    },
  );

  return Openapi(
    dio: Dio(BaseOptions(baseUrl: 'http://localhost')),
    interceptors: [interceptor],
  );
}

/// tests for InquiriesApi
void main() {
  group(InquiriesApi, () {
    test('createInquiry sends payload and parses response', () async {
      final deadline = DateTime.utc(2025, 1, 15);
      final api = _openapiWithResponder((options) {
        expect(options.method, 'POST');
        expect(options.path, '/inquiries');
        final data = options.data as Map<String, dynamic>;
        expect(data['branchId'], 'branch-1');
        expect(data['categoryId'], 'category-1');
        expect(data['numberOfProviders'], 3);
        expect(data['deliveryZips'], ['1010', '1020']);
        expect(data['deadline'], deadline.toIso8601String());
        return Response(
          requestOptions: options,
          statusCode: 200,
          data: {
            'id': 'inq-1',
            'status': 'open',
            'deadline': deadline.toIso8601String(),
          },
        );
      }).getInquiriesApi();

      final request = CreateInquiryRequest((b) => b
        ..branchId = 'branch-1'
        ..categoryId = 'category-1'
        ..deadline = deadline
        ..numberOfProviders = 3
        ..deliveryZips.addAll(['1010', '1020'])
        ..productTags.addAll(['paper', 'ink']));

      final response = await api.createInquiry(createInquiryRequest: request);
      expect(response.data?.id, 'inq-1');
      expect(response.data?.deadline?.toUtc(), deadline);
    });

    test('inquiriesGet returns list', () async {
      final api = _openapiWithResponder((options) {
        expect(options.method, 'GET');
        expect(options.path, '/inquiries');
        expect(options.queryParameters['status'], 'open');
        expect(options.queryParameters['format'], 'json');
        return Response(
          requestOptions: options,
          statusCode: 200,
          data: [
            {'id': 'inq-1', 'status': 'open'},
            {'id': 'inq-2', 'status': 'closed'}
          ],
        );
      }).getInquiriesApi();

      final response = await api.inquiriesGet(status: 'open', format: 'json');
      expect(response.data, isNotNull);
      expect(response.data!.length, 2);
      expect(response.data!.first.id, 'inq-1');
    });

    test('inquiriesInquiryIdAssignPost sends assignment payload', () async {
      final api = _openapiWithResponder((options) {
        expect(options.method, 'POST');
        expect(options.path, '/inquiries/inq-1/assign');
        final data = options.data as Map<String, dynamic>;
        expect(data['providerCompanyIds'], ['provider-1', 'provider-2']);
        return Response(
          requestOptions: options,
          statusCode: 204,
          data: null,
        );
      }).getInquiriesApi();

      final request = InquiriesInquiryIdAssignPostRequest((b) => b
        ..providerCompanyIds.addAll(['provider-1', 'provider-2']));

      await api.inquiriesInquiryIdAssignPost(
        inquiryId: 'inq-1',
        inquiriesInquiryIdAssignPostRequest: request,
      );
    });

    test('inquiriesInquiryIdGet returns inquiry', () async {
      final api = _openapiWithResponder((options) {
        expect(options.method, 'GET');
        expect(options.path, '/inquiries/inq-1');
        return Response(
          requestOptions: options,
          statusCode: 200,
          data: {'id': 'inq-1', 'status': 'open'},
        );
      }).getInquiriesApi();

      final response = await api.inquiriesInquiryIdGet(inquiryId: 'inq-1');
      expect(response.data?.id, 'inq-1');
      expect(response.data?.status, 'open');
    });
  });
}
