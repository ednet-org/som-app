import 'package:dio/dio.dart';
import 'package:openapi/openapi.dart';

import '../../domain/inquiry/repositories/i_inquiry_repository.dart';
import '../../ui/utils/ui_logger.dart';

/// API-based implementation of [IInquiryRepository].
///
/// Uses the OpenAPI-generated client for all operations.
class ApiInquiryRepository implements IInquiryRepository {
  final Openapi _api;

  ApiInquiryRepository(this._api);

  @override
  Future<List<Inquiry>> getInquiries({InquiryFilter? filter}) async {
    try {
      final response = await _api.getInquiriesApi().inquiriesGet(
        status: filter?.status,
        branchId: filter?.branchId,
        branch: filter?.branch,
        providerType: filter?.providerType,
        providerSize: filter?.providerSize,
        createdFrom: filter?.createdFrom,
        createdTo: filter?.createdTo,
        deadlineFrom: filter?.deadlineFrom,
        deadlineTo: filter?.deadlineTo,
        editorIds: filter?.editorIds?.join(','),
      );
      return response.data?.toList() ?? [];
    } catch (error, stackTrace) {
      UILogger.apiError('GET /inquiries', error, stackTrace);
      rethrow;
    }
  }

  @override
  Future<Inquiry?> getInquiry(String id) async {
    try {
      final response = await _api.getInquiriesApi().inquiriesInquiryIdGet(
        inquiryId: id,
      );
      return response.data;
    } catch (error, stackTrace) {
      UILogger.apiError('GET /inquiries/$id', error, stackTrace);
      rethrow;
    }
  }

  @override
  Future<Inquiry> createInquiry(CreateInquiryRequest request) async {
    try {
      final response = await _api.getInquiriesApi().createInquiry(
        createInquiryRequest: request,
      );
      if (response.data == null) {
        throw Exception('Failed to create inquiry: empty response');
      }
      return response.data!;
    } catch (error, stackTrace) {
      UILogger.apiError('POST /inquiries', error, stackTrace);
      rethrow;
    }
  }

  @override
  Future<void> closeInquiry(String inquiryId) async {
    try {
      await _api.getInquiriesApi().inquiriesInquiryIdClosePost(
        inquiryId: inquiryId,
      );
    } catch (error, stackTrace) {
      UILogger.apiError('POST /inquiries/$inquiryId/close', error, stackTrace);
      rethrow;
    }
  }

  @override
  Future<void> ignoreInquiry(String inquiryId) async {
    try {
      await _api.getInquiriesApi().inquiriesInquiryIdIgnorePost(
        inquiryId: inquiryId,
      );
    } catch (error, stackTrace) {
      UILogger.apiError('POST /inquiries/$inquiryId/ignore', error, stackTrace);
      rethrow;
    }
  }

  @override
  Future<void> assignProviders(String inquiryId, List<String> providerIds) async {
    try {
      await _api.getInquiriesApi().inquiriesInquiryIdAssignPost(
        inquiryId: inquiryId,
        inquiriesInquiryIdAssignPostRequest: InquiriesInquiryIdAssignPostRequest((b) {
          b.providerCompanyIds.clear();
          b.providerCompanyIds.addAll(providerIds);
        }),
      );
    } catch (error, stackTrace) {
      UILogger.apiError('POST /inquiries/$inquiryId/assign', error, stackTrace);
      rethrow;
    }
  }

  @override
  Future<String?> uploadPdf(String inquiryId, List<int> fileBytes, String fileName) async {
    try {
      final multipartFile = MultipartFile.fromBytes(
        fileBytes,
        filename: fileName,
      );
      final response = await _api.getInquiriesApi().inquiriesInquiryIdPdfPost(
        inquiryId: inquiryId,
        file: multipartFile,
      );
      return response.data?.pdfPath;
    } catch (error, stackTrace) {
      UILogger.apiError('POST /inquiries/$inquiryId/pdf', error, stackTrace);
      rethrow;
    }
  }

  @override
  Future<void> removePdf(String inquiryId) async {
    try {
      await _api.getInquiriesApi().inquiriesInquiryIdPdfDelete(
        inquiryId: inquiryId,
      );
    } catch (error, stackTrace) {
      UILogger.apiError('DELETE /inquiries/$inquiryId/pdf', error, stackTrace);
      rethrow;
    }
  }

  @override
  Future<List<Offer>> getOffers(String inquiryId) async {
    try {
      final response = await _api.getOffersApi().inquiriesInquiryIdOffersGet(
        inquiryId: inquiryId,
      );
      return response.data?.toList() ?? [];
    } catch (error, stackTrace) {
      UILogger.apiError('GET /inquiries/$inquiryId/offers', error, stackTrace);
      rethrow;
    }
  }

  @override
  Future<void> acceptOffer(String offerId) async {
    try {
      await _api.getOffersApi().offersOfferIdAcceptPost(offerId: offerId);
    } catch (error, stackTrace) {
      UILogger.apiError('POST /offers/$offerId/accept', error, stackTrace);
      rethrow;
    }
  }

  @override
  Future<void> rejectOffer(String offerId) async {
    try {
      await _api.getOffersApi().offersOfferIdRejectPost(offerId: offerId);
    } catch (error, stackTrace) {
      UILogger.apiError('POST /offers/$offerId/reject', error, stackTrace);
      rethrow;
    }
  }
}
