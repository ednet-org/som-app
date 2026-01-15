import 'package:mobx/mobx.dart';
import 'package:openapi/openapi.dart';

import '../../domain/inquiry/repositories/i_inquiry_repository.dart';

part 'inquiry_store.g.dart';

/// Main data store for Inquiry management.
///
/// Manages:
/// - List of inquiries with observable state
/// - Selected inquiry
/// - Offers for selected inquiry
/// - Loading and error states
// ignore: library_private_types_in_public_api
class InquiryStore = _InquiryStore with _$InquiryStore;

abstract class _InquiryStore with Store {
  final IInquiryRepository _repository;

  _InquiryStore(this._repository);

  @observable
  ObservableList<Inquiry> inquiries = ObservableList<Inquiry>();

  @observable
  Inquiry? selectedInquiry;

  @observable
  ObservableList<Offer> offers = ObservableList<Offer>();

  @observable
  bool isLoading = false;

  @observable
  bool isLoadingOffers = false;

  @observable
  String? error;

  @computed
  bool get hasSelection => selectedInquiry != null;

  @computed
  bool get hasOffers => offers.isNotEmpty;

  @action
  Future<void> loadInquiries(InquiryFilter? filter) async {
    isLoading = true;
    error = null;
    try {
      final result = await _repository.getInquiries(filter: filter);
      inquiries.clear();
      inquiries.addAll(result);
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> selectInquiry(Inquiry? inquiry) async {
    selectedInquiry = inquiry;
    offers.clear();
    if (inquiry?.id != null) {
      await loadOffers(inquiry!.id!);
    }
  }

  @action
  Future<void> loadOffers(String inquiryId) async {
    isLoadingOffers = true;
    try {
      final result = await _repository.getOffers(inquiryId);
      offers.clear();
      offers.addAll(result);
    } catch (e) {
      error = e.toString();
    } finally {
      isLoadingOffers = false;
    }
  }

  @action
  Future<void> closeInquiry() async {
    if (selectedInquiry?.id == null) return;
    try {
      await _repository.closeInquiry(selectedInquiry!.id!);
      await refresh();
    } catch (e) {
      error = e.toString();
    }
  }

  @action
  Future<void> ignoreInquiry() async {
    if (selectedInquiry?.id == null) return;
    try {
      await _repository.ignoreInquiry(selectedInquiry!.id!);
      await refresh();
    } catch (e) {
      error = e.toString();
    }
  }

  @action
  Future<void> assignProviders(List<String> providerIds) async {
    if (selectedInquiry?.id == null) return;
    try {
      await _repository.assignProviders(selectedInquiry!.id!, providerIds);
      await refresh();
    } catch (e) {
      error = e.toString();
    }
  }

  @action
  Future<void> acceptOffer(String offerId) async {
    try {
      await _repository.acceptOffer(offerId);
      if (selectedInquiry?.id != null) {
        await loadOffers(selectedInquiry!.id!);
      }
    } catch (e) {
      error = e.toString();
    }
  }

  @action
  Future<void> rejectOffer(String offerId) async {
    try {
      await _repository.rejectOffer(offerId);
      if (selectedInquiry?.id != null) {
        await loadOffers(selectedInquiry!.id!);
      }
    } catch (e) {
      error = e.toString();
    }
  }

  @action
  Future<void> refresh() async {
    await loadInquiries(null);
  }

  @action
  void clearError() {
    error = null;
  }

  @action
  void clearSelection() {
    selectedInquiry = null;
    offers.clear();
  }
}
