import 'package:built_collection/built_collection.dart';
import 'package:mobx/mobx.dart';
import 'package:openapi/openapi.dart';

import '../../domain/inquiry/repositories/i_inquiry_repository.dart';

part 'inquiry_form_store.g.dart';

/// Store for managing inquiry creation form state.
///
/// Handles:
/// - Form field values
/// - Validation
/// - Submission state
/// - PDF attachment
// ignore: library_private_types_in_public_api
class InquiryFormStore = _InquiryFormStore with _$InquiryFormStore;

abstract class _InquiryFormStore with Store {
  @observable
  String? branchId;

  @observable
  String? categoryId;

  @observable
  ObservableList<String> productTags = ObservableList<String>();

  @observable
  DateTime? deadline;

  @observable
  String description = '';

  @observable
  ObservableList<String> deliveryZips = ObservableList<String>();

  @observable
  int numberOfProviders = 3;

  @observable
  String? providerType;

  @observable
  String? providerSize;

  @observable
  String? providerZipPrefix;

  // Contact info
  @observable
  String contactSalutation = '';

  @observable
  String contactTitle = '';

  @observable
  String contactFirstName = '';

  @observable
  String contactLastName = '';

  @observable
  String contactTelephone = '';

  @observable
  String contactEmail = '';

  // PDF attachment
  @observable
  List<int>? pdfBytes;

  @observable
  String? pdfFileName;

  // Submission state
  @observable
  bool isSubmitting = false;

  @observable
  String? error;

  @computed
  bool get isValid =>
      branchId != null &&
      categoryId != null &&
      deadline != null &&
      description.trim().isNotEmpty &&
      deliveryZips.isNotEmpty;

  @computed
  bool get hasPdf => pdfBytes != null && pdfFileName != null;

  // Note: Contact info and provider criteria are passed as flat fields
  // in CreateInquiryRequest, not as nested objects.

  @action
  void setBranchId(String? value) {
    branchId = value;
  }

  @action
  void setCategoryId(String? value) {
    categoryId = value;
  }

  @action
  void setProductTags(List<String> tags) {
    productTags.clear();
    productTags.addAll(tags);
  }

  @action
  void addProductTag(String tag) {
    if (!productTags.contains(tag)) {
      productTags.add(tag);
    }
  }

  @action
  void removeProductTag(String tag) {
    productTags.remove(tag);
  }

  @action
  void setDeadline(DateTime? value) {
    deadline = value;
  }

  @action
  void setDescription(String value) {
    description = value;
  }

  @action
  void setDeliveryZips(List<String> zips) {
    deliveryZips.clear();
    deliveryZips.addAll(zips);
  }

  @action
  void setNumberOfProviders(int value) {
    numberOfProviders = value;
  }

  @action
  void setProviderType(String? value) {
    providerType = value;
  }

  @action
  void setProviderSize(String? value) {
    providerSize = value;
  }

  @action
  void setProviderZipPrefix(String? value) {
    providerZipPrefix = value;
  }

  @action
  void setContactSalutation(String value) {
    contactSalutation = value;
  }

  @action
  void setContactTitle(String value) {
    contactTitle = value;
  }

  @action
  void setContactFirstName(String value) {
    contactFirstName = value;
  }

  @action
  void setContactLastName(String value) {
    contactLastName = value;
  }

  @action
  void setContactTelephone(String value) {
    contactTelephone = value;
  }

  @action
  void setContactEmail(String value) {
    contactEmail = value;
  }

  @action
  void setPdf(List<int> bytes, String fileName) {
    pdfBytes = bytes;
    pdfFileName = fileName;
  }

  @action
  void clearPdf() {
    pdfBytes = null;
    pdfFileName = null;
  }

  @action
  Future<Inquiry?> submit(IInquiryRepository repository) async {
    if (!isValid) {
      error = 'Please fill in all required fields.';
      return null;
    }

    isSubmitting = true;
    error = null;

    try {
      final request = CreateInquiryRequest((b) => b
        ..branchId = branchId
        ..categoryId = categoryId
        ..productTags = productTags.isNotEmpty ? ListBuilder(productTags) : null
        ..deadline = deadline
        ..description = description.trim()
        ..deliveryZips = ListBuilder(deliveryZips)
        ..numberOfProviders = numberOfProviders
        ..providerType = providerType
        ..providerCompanySize = providerSize
        ..providerZip = providerZipPrefix
        ..salutation = contactSalutation.isNotEmpty ? contactSalutation : null
        ..title = contactTitle.isNotEmpty ? contactTitle : null
        ..firstName = contactFirstName.isNotEmpty ? contactFirstName : null
        ..lastName = contactLastName.isNotEmpty ? contactLastName : null
        ..telephone = contactTelephone.isNotEmpty ? contactTelephone : null
        ..email = contactEmail.isNotEmpty ? contactEmail : null);

      final inquiry = await repository.createInquiry(request);

      // Upload PDF if attached
      if (hasPdf && inquiry.id != null) {
        await repository.uploadPdf(inquiry.id!, pdfBytes!, pdfFileName!);
      }

      return inquiry;
    } catch (e) {
      error = e.toString();
      return null;
    } finally {
      isSubmitting = false;
    }
  }

  @action
  void reset() {
    branchId = null;
    categoryId = null;
    productTags.clear();
    deadline = null;
    description = '';
    deliveryZips.clear();
    numberOfProviders = 3;
    providerType = null;
    providerSize = null;
    providerZipPrefix = null;
    contactSalutation = '';
    contactTitle = '';
    contactFirstName = '';
    contactLastName = '';
    contactTelephone = '';
    contactEmail = '';
    pdfBytes = null;
    pdfFileName = null;
    isSubmitting = false;
    error = null;
  }

  @action
  void clearError() {
    error = null;
  }
}
