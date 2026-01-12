import 'package:test/test.dart';
import 'package:openapi/openapi.dart';


/// tests for InquiriesApi
void main() {
  final instance = Openapi().getInquiriesApi();

  group(InquiriesApi, () {
    // List inquiries
    //
    //Future<BuiltList<Inquiry>> inquiriesGet({ String status, String format }) async
    test('test inquiriesGet', () async {
      // TODO
    });

    // Assign inquiry to providers
    //
    //Future inquiriesInquiryIdAssignPost(String inquiryId, InquiriesInquiryIdAssignPostRequest inquiriesInquiryIdAssignPostRequest) async
    test('test inquiriesInquiryIdAssignPost', () async {
      // TODO
    });

    // Get inquiry
    //
    //Future<Inquiry> inquiriesInquiryIdGet(String inquiryId) async
    test('test inquiriesInquiryIdGet', () async {
      // TODO
    });

    // Create inquiry
    //
    //Future<Inquiry> inquiriesPost(InquiriesGetRequest inquiriesGetRequest) async
    test('test inquiriesPost', () async {
      // TODO
    });

  });
}
