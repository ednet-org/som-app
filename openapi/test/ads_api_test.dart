import 'package:test/test.dart';
import 'package:openapi/openapi.dart';


/// tests for AdsApi
void main() {
  final instance = Openapi().getAdsApi();

  group(AdsApi, () {
    // Delete ad
    //
    //Future adsAdIdDelete(String adId) async
    test('test adsAdIdDelete', () async {
      // TODO
    });

    // Get ad
    //
    //Future<Ad> adsAdIdGet(String adId) async
    test('test adsAdIdGet', () async {
      // TODO
    });

    // Update ad
    //
    //Future adsAdIdPut(String adId, Ad ad) async
    test('test adsAdIdPut', () async {
      // TODO
    });

    // List active ads
    //
    //Future<BuiltList<Ad>> adsGet({ String branchId }) async
    test('test adsGet', () async {
      // TODO
    });

    // Create ad
    //
    //Future<AdsGet200Response> adsPost(AdsGetRequest adsGetRequest) async
    test('test adsPost', () async {
      // TODO
    });

  });
}
