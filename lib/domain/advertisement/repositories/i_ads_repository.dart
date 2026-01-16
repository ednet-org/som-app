import 'package:openapi/openapi.dart';

/// Filter parameters for ads queries.
class AdsFilter {
  final String? branchId;
  final String? status;
  final String? scope;

  const AdsFilter({
    this.branchId,
    this.status,
    this.scope,
  });

  bool get isEmpty => branchId == null && status == null && scope == null;
}

/// Repository interface for Advertisement operations.
///
/// Abstracts data access from the UI layer, enabling:
/// - Testability via mock implementations
/// - Caching layer insertion
/// - Clean separation of concerns
abstract class IAdsRepository {
  /// Retrieves a list of ads with optional filtering.
  Future<List<Ad>> getAds({AdsFilter? filter});

  /// Retrieves a single ad by ID.
  Future<Ad?> getAd(String id);

  /// Creates a new ad.
  Future<String?> createAd(CreateAdRequest request);

  /// Updates an existing ad.
  Future<void> updateAd(String adId, Ad ad);

  /// Deletes an ad.
  Future<void> deleteAd(String adId);

  /// Activates an ad.
  Future<void> activateAd(String adId);

  /// Deactivates an ad.
  Future<void> deactivateAd(String adId);

  /// Uploads an image for an ad.
  Future<String?> uploadImage(String adId, List<int> fileBytes, String fileName);
}
