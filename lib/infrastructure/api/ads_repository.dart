import 'package:dio/dio.dart';
import 'package:openapi/openapi.dart';

import '../../domain/advertisement/repositories/i_ads_repository.dart';
import '../../ui/utils/ui_logger.dart';

/// API-based implementation of [IAdsRepository].
///
/// Uses the OpenAPI-generated client for all operations.
class ApiAdsRepository implements IAdsRepository {
  final Openapi _api;

  ApiAdsRepository(this._api);

  @override
  Future<List<Ad>> getAds({AdsFilter? filter}) async {
    try {
      final response = await _api.getAdsApi().adsGet(
        branchId: filter?.branchId,
        status: filter?.status,
        scope: filter?.scope,
      );
      return response.data?.toList() ?? [];
    } catch (error, stackTrace) {
      UILogger.apiError('GET /ads', error, stackTrace);
      rethrow;
    }
  }

  @override
  Future<Ad?> getAd(String id) async {
    try {
      final response = await _api.getAdsApi().adsAdIdGet(adId: id);
      return response.data;
    } catch (error, stackTrace) {
      UILogger.apiError('GET /ads/$id', error, stackTrace);
      rethrow;
    }
  }

  @override
  Future<String?> createAd(CreateAdRequest request) async {
    try {
      final response = await _api.getAdsApi().createAd(
        createAdRequest: request,
      );
      return response.data?.id;
    } catch (error, stackTrace) {
      UILogger.apiError('POST /ads', error, stackTrace);
      rethrow;
    }
  }

  @override
  Future<void> updateAd(String adId, Ad ad) async {
    try {
      await _api.getAdsApi().adsAdIdPut(
        adId: adId,
        ad: ad,
      );
    } catch (error, stackTrace) {
      UILogger.apiError('PUT /ads/$adId', error, stackTrace);
      rethrow;
    }
  }

  @override
  Future<void> deleteAd(String adId) async {
    try {
      await _api.getAdsApi().adsAdIdDelete(adId: adId);
    } catch (error, stackTrace) {
      UILogger.apiError('DELETE /ads/$adId', error, stackTrace);
      rethrow;
    }
  }

  @override
  Future<void> activateAd(String adId) async {
    try {
      await _api.getAdsApi().adsAdIdActivatePost(adId: adId);
    } catch (error, stackTrace) {
      UILogger.apiError('POST /ads/$adId/activate', error, stackTrace);
      rethrow;
    }
  }

  @override
  Future<void> deactivateAd(String adId) async {
    try {
      await _api.getAdsApi().adsAdIdDeactivatePost(adId: adId);
    } catch (error, stackTrace) {
      UILogger.apiError('POST /ads/$adId/deactivate', error, stackTrace);
      rethrow;
    }
  }

  @override
  Future<String?> uploadImage(String adId, List<int> fileBytes, String fileName) async {
    try {
      final multipartFile = MultipartFile.fromBytes(
        fileBytes,
        filename: fileName,
      );
      final response = await _api.getAdsApi().adsAdIdImagePost(
        adId: adId,
        file: multipartFile,
      );
      return response.data?.imagePath;
    } catch (error, stackTrace) {
      UILogger.apiError('POST /ads/$adId/image', error, stackTrace);
      rethrow;
    }
  }
}
