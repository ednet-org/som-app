import 'package:test/test.dart';
import 'package:openapi/openapi.dart';


/// tests for OffersApi
void main() {
  final instance = Openapi().getOffersApi();

  group(OffersApi, () {
    // List offers for inquiry
    //
    //Future<BuiltList<Offer>> inquiriesInquiryIdOffersGet(String inquiryId) async
    test('test inquiriesInquiryIdOffersGet', () async {
      // TODO
    });

    // Create offer for inquiry
    //
    //Future<InquiriesInquiryIdOffersGet200Response> inquiriesInquiryIdOffersPost(String inquiryId, { MultipartFile file }) async
    test('test inquiriesInquiryIdOffersPost', () async {
      // TODO
    });

    // Accept offer
    //
    //Future offersOfferIdAcceptPost(String offerId) async
    test('test offersOfferIdAcceptPost', () async {
      // TODO
    });

    // Reject offer
    //
    //Future offersOfferIdRejectPost(String offerId) async
    test('test offersOfferIdRejectPost', () async {
      // TODO
    });

  });
}
