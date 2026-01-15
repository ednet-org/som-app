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

/// tests for AdsApi
void main() {
  group(AdsApi, () {
    test('createAd sends payload and parses response', () async {
      final api = _openapiWithResponder((options) {
        expect(options.method, 'POST');
        expect(options.path, '/ads');
        final data = options.data as Map<String, dynamic>;
        expect(data['type'], 'normal');
        expect(data['status'], 'active');
        expect(data['branchId'], 'branch-1');
        expect(data['url'], 'https://example.com');
        return Response(
          requestOptions: options,
          statusCode: 200,
          data: {'id': 'ad-1'},
        );
      }).getAdsApi();

      final request = CreateAdRequest((b) => b
        ..type = 'normal'
        ..status = 'active'
        ..branchId = 'branch-1'
        ..url = 'https://example.com');

      final response = await api.createAd(createAdRequest: request);
      expect(response.data?.id, 'ad-1');
    });

    test('adsGet returns ads list', () async {
      final startDate = DateTime.utc(2025, 1, 1);
      final api = _openapiWithResponder((options) {
        expect(options.method, 'GET');
        expect(options.path, '/ads');
        expect(options.queryParameters['branchId'], 'branch-1');
        return Response(
          requestOptions: options,
          statusCode: 200,
          data: [
            {
              'id': 'ad-1',
              'companyId': 'company-1',
              'type': 'banner',
              'status': 'active',
              'branchId': 'branch-1',
              'url': 'https://example.com',
              'startDate': startDate.toIso8601String(),
            }
          ],
        );
      }).getAdsApi();

      final response = await api.adsGet(branchId: 'branch-1');
      expect(response.data, isNotNull);
      expect(response.data!.length, 1);
      expect(response.data!.first.id, 'ad-1');
      expect(response.data!.first.startDate!.toUtc(), startDate);
    });

    test('adsAdIdGet returns ad', () async {
      final api = _openapiWithResponder((options) {
        expect(options.method, 'GET');
        expect(options.path, '/ads/ad-1');
        return Response(
          requestOptions: options,
          statusCode: 200,
          data: {
            'id': 'ad-1',
            'status': 'active',
            'branchId': 'branch-1',
          },
        );
      }).getAdsApi();

      final response = await api.adsAdIdGet(adId: 'ad-1');
      expect(response.data?.id, 'ad-1');
      expect(response.data?.status, 'active');
    });

    test('adsAdIdPut sends ad payload', () async {
      final api = _openapiWithResponder((options) {
        expect(options.method, 'PUT');
        expect(options.path, '/ads/ad-1');
        final data = options.data as Map<String, dynamic>;
        expect(data['id'], 'ad-1');
        return Response(
          requestOptions: options,
          statusCode: 200,
          data: null,
        );
      }).getAdsApi();

      final ad = Ad((b) => b
        ..id = 'ad-1'
        ..branchId = 'branch-1'
        ..startDate = DateTime.utc(2025, 1, 2));

      await api.adsAdIdPut(adId: 'ad-1', ad: ad);
    });

    test('adsAdIdActivatePost sends activation payload', () async {
      final api = _openapiWithResponder((options) {
        expect(options.method, 'POST');
        expect(options.path, '/ads/ad-1/activate');
        final data = options.data as Map<String, dynamic>;
        expect(data['startDate'], isNotNull);
        expect(data['endDate'], isNotNull);
        return Response(
          requestOptions: options,
          statusCode: 200,
          data: null,
        );
      }).getAdsApi();

      final activation = AdActivationRequest((b) => b
        ..startDate = DateTime.utc(2025, 1, 2)
        ..endDate = DateTime.utc(2025, 1, 9));

      await api.adsAdIdActivatePost(adId: 'ad-1', adActivationRequest: activation);
    });

    test('adsAdIdDeactivatePost hits deactivate endpoint', () async {
      final api = _openapiWithResponder((options) {
        expect(options.method, 'POST');
        expect(options.path, '/ads/ad-1/deactivate');
        return Response(
          requestOptions: options,
          statusCode: 200,
          data: null,
        );
      }).getAdsApi();

      await api.adsAdIdDeactivatePost(adId: 'ad-1');
    });

    test('adsAdIdDelete hits delete endpoint', () async {
      final api = _openapiWithResponder((options) {
        expect(options.method, 'DELETE');
        expect(options.path, '/ads/ad-1');
        return Response(
          requestOptions: options,
          statusCode: 200,
          data: null,
        );
      }).getAdsApi();

      await api.adsAdIdDelete(adId: 'ad-1');
    });
  });
}
