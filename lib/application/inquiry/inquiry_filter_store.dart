import 'package:mobx/mobx.dart';

import '../../domain/inquiry/repositories/i_inquiry_repository.dart';

part 'inquiry_filter_store.g.dart';

/// Store for managing inquiry filter state.
///
/// Keeps filter values reactive and provides computed filter object.
// ignore: library_private_types_in_public_api
class InquiryFilterStore = _InquiryFilterStore with _$InquiryFilterStore;

abstract class _InquiryFilterStore with Store {
  @observable
  String? status;

  @observable
  String? branchId;

  @observable
  String? branchName;

  @observable
  String? providerType;

  @observable
  String? providerSize;

  @observable
  DateTime? createdFrom;

  @observable
  DateTime? createdTo;

  @observable
  DateTime? deadlineFrom;

  @observable
  DateTime? deadlineTo;

  @observable
  ObservableList<String> editorIds = ObservableList<String>();

  @computed
  InquiryFilter get currentFilter => InquiryFilter(
        status: status,
        branchId: branchId,
        branch: branchName,
        providerType: providerType,
        providerSize: providerSize,
        createdFrom: createdFrom,
        createdTo: createdTo,
        deadlineFrom: deadlineFrom,
        deadlineTo: deadlineTo,
        editorIds: editorIds.isNotEmpty ? editorIds.toList() : null,
      );

  @computed
  bool get hasActiveFilters =>
      status != null ||
      branchId != null ||
      branchName != null ||
      providerType != null ||
      providerSize != null ||
      createdFrom != null ||
      createdTo != null ||
      deadlineFrom != null ||
      deadlineTo != null ||
      editorIds.isNotEmpty;

  @action
  void setStatus(String? value) {
    status = value;
  }

  @action
  void setBranchId(String? value) {
    branchId = value;
  }

  @action
  void setBranchName(String? value) {
    branchName = value;
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
  void setCreatedFrom(DateTime? value) {
    createdFrom = value;
  }

  @action
  void setCreatedTo(DateTime? value) {
    createdTo = value;
  }

  @action
  void setDeadlineFrom(DateTime? value) {
    deadlineFrom = value;
  }

  @action
  void setDeadlineTo(DateTime? value) {
    deadlineTo = value;
  }

  @action
  void setEditorIds(List<String> values) {
    editorIds.clear();
    editorIds.addAll(values);
  }

  @action
  void clearFilters() {
    status = null;
    branchId = null;
    branchName = null;
    providerType = null;
    providerSize = null;
    createdFrom = null;
    createdTo = null;
    deadlineFrom = null;
    deadlineTo = null;
    editorIds.clear();
  }
}
