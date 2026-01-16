// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inquiry_form_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$InquiryFormStore on _InquiryFormStore, Store {
  Computed<bool>? _$isValidComputed;

  @override
  bool get isValid => (_$isValidComputed ??= Computed<bool>(
    () => super.isValid,
    name: '_InquiryFormStore.isValid',
  )).value;
  Computed<bool>? _$hasPdfComputed;

  @override
  bool get hasPdf => (_$hasPdfComputed ??= Computed<bool>(
    () => super.hasPdf,
    name: '_InquiryFormStore.hasPdf',
  )).value;

  late final _$branchIdAtom = Atom(
    name: '_InquiryFormStore.branchId',
    context: context,
  );

  @override
  String? get branchId {
    _$branchIdAtom.reportRead();
    return super.branchId;
  }

  @override
  set branchId(String? value) {
    _$branchIdAtom.reportWrite(value, super.branchId, () {
      super.branchId = value;
    });
  }

  late final _$categoryIdAtom = Atom(
    name: '_InquiryFormStore.categoryId',
    context: context,
  );

  @override
  String? get categoryId {
    _$categoryIdAtom.reportRead();
    return super.categoryId;
  }

  @override
  set categoryId(String? value) {
    _$categoryIdAtom.reportWrite(value, super.categoryId, () {
      super.categoryId = value;
    });
  }

  late final _$productTagsAtom = Atom(
    name: '_InquiryFormStore.productTags',
    context: context,
  );

  @override
  ObservableList<String> get productTags {
    _$productTagsAtom.reportRead();
    return super.productTags;
  }

  @override
  set productTags(ObservableList<String> value) {
    _$productTagsAtom.reportWrite(value, super.productTags, () {
      super.productTags = value;
    });
  }

  late final _$deadlineAtom = Atom(
    name: '_InquiryFormStore.deadline',
    context: context,
  );

  @override
  DateTime? get deadline {
    _$deadlineAtom.reportRead();
    return super.deadline;
  }

  @override
  set deadline(DateTime? value) {
    _$deadlineAtom.reportWrite(value, super.deadline, () {
      super.deadline = value;
    });
  }

  late final _$descriptionAtom = Atom(
    name: '_InquiryFormStore.description',
    context: context,
  );

  @override
  String get description {
    _$descriptionAtom.reportRead();
    return super.description;
  }

  @override
  set description(String value) {
    _$descriptionAtom.reportWrite(value, super.description, () {
      super.description = value;
    });
  }

  late final _$deliveryZipsAtom = Atom(
    name: '_InquiryFormStore.deliveryZips',
    context: context,
  );

  @override
  ObservableList<String> get deliveryZips {
    _$deliveryZipsAtom.reportRead();
    return super.deliveryZips;
  }

  @override
  set deliveryZips(ObservableList<String> value) {
    _$deliveryZipsAtom.reportWrite(value, super.deliveryZips, () {
      super.deliveryZips = value;
    });
  }

  late final _$numberOfProvidersAtom = Atom(
    name: '_InquiryFormStore.numberOfProviders',
    context: context,
  );

  @override
  int get numberOfProviders {
    _$numberOfProvidersAtom.reportRead();
    return super.numberOfProviders;
  }

  @override
  set numberOfProviders(int value) {
    _$numberOfProvidersAtom.reportWrite(value, super.numberOfProviders, () {
      super.numberOfProviders = value;
    });
  }

  late final _$providerTypeAtom = Atom(
    name: '_InquiryFormStore.providerType',
    context: context,
  );

  @override
  String? get providerType {
    _$providerTypeAtom.reportRead();
    return super.providerType;
  }

  @override
  set providerType(String? value) {
    _$providerTypeAtom.reportWrite(value, super.providerType, () {
      super.providerType = value;
    });
  }

  late final _$providerSizeAtom = Atom(
    name: '_InquiryFormStore.providerSize',
    context: context,
  );

  @override
  String? get providerSize {
    _$providerSizeAtom.reportRead();
    return super.providerSize;
  }

  @override
  set providerSize(String? value) {
    _$providerSizeAtom.reportWrite(value, super.providerSize, () {
      super.providerSize = value;
    });
  }

  late final _$providerZipPrefixAtom = Atom(
    name: '_InquiryFormStore.providerZipPrefix',
    context: context,
  );

  @override
  String? get providerZipPrefix {
    _$providerZipPrefixAtom.reportRead();
    return super.providerZipPrefix;
  }

  @override
  set providerZipPrefix(String? value) {
    _$providerZipPrefixAtom.reportWrite(value, super.providerZipPrefix, () {
      super.providerZipPrefix = value;
    });
  }

  late final _$contactSalutationAtom = Atom(
    name: '_InquiryFormStore.contactSalutation',
    context: context,
  );

  @override
  String get contactSalutation {
    _$contactSalutationAtom.reportRead();
    return super.contactSalutation;
  }

  @override
  set contactSalutation(String value) {
    _$contactSalutationAtom.reportWrite(value, super.contactSalutation, () {
      super.contactSalutation = value;
    });
  }

  late final _$contactTitleAtom = Atom(
    name: '_InquiryFormStore.contactTitle',
    context: context,
  );

  @override
  String get contactTitle {
    _$contactTitleAtom.reportRead();
    return super.contactTitle;
  }

  @override
  set contactTitle(String value) {
    _$contactTitleAtom.reportWrite(value, super.contactTitle, () {
      super.contactTitle = value;
    });
  }

  late final _$contactFirstNameAtom = Atom(
    name: '_InquiryFormStore.contactFirstName',
    context: context,
  );

  @override
  String get contactFirstName {
    _$contactFirstNameAtom.reportRead();
    return super.contactFirstName;
  }

  @override
  set contactFirstName(String value) {
    _$contactFirstNameAtom.reportWrite(value, super.contactFirstName, () {
      super.contactFirstName = value;
    });
  }

  late final _$contactLastNameAtom = Atom(
    name: '_InquiryFormStore.contactLastName',
    context: context,
  );

  @override
  String get contactLastName {
    _$contactLastNameAtom.reportRead();
    return super.contactLastName;
  }

  @override
  set contactLastName(String value) {
    _$contactLastNameAtom.reportWrite(value, super.contactLastName, () {
      super.contactLastName = value;
    });
  }

  late final _$contactTelephoneAtom = Atom(
    name: '_InquiryFormStore.contactTelephone',
    context: context,
  );

  @override
  String get contactTelephone {
    _$contactTelephoneAtom.reportRead();
    return super.contactTelephone;
  }

  @override
  set contactTelephone(String value) {
    _$contactTelephoneAtom.reportWrite(value, super.contactTelephone, () {
      super.contactTelephone = value;
    });
  }

  late final _$contactEmailAtom = Atom(
    name: '_InquiryFormStore.contactEmail',
    context: context,
  );

  @override
  String get contactEmail {
    _$contactEmailAtom.reportRead();
    return super.contactEmail;
  }

  @override
  set contactEmail(String value) {
    _$contactEmailAtom.reportWrite(value, super.contactEmail, () {
      super.contactEmail = value;
    });
  }

  late final _$pdfBytesAtom = Atom(
    name: '_InquiryFormStore.pdfBytes',
    context: context,
  );

  @override
  List<int>? get pdfBytes {
    _$pdfBytesAtom.reportRead();
    return super.pdfBytes;
  }

  @override
  set pdfBytes(List<int>? value) {
    _$pdfBytesAtom.reportWrite(value, super.pdfBytes, () {
      super.pdfBytes = value;
    });
  }

  late final _$pdfFileNameAtom = Atom(
    name: '_InquiryFormStore.pdfFileName',
    context: context,
  );

  @override
  String? get pdfFileName {
    _$pdfFileNameAtom.reportRead();
    return super.pdfFileName;
  }

  @override
  set pdfFileName(String? value) {
    _$pdfFileNameAtom.reportWrite(value, super.pdfFileName, () {
      super.pdfFileName = value;
    });
  }

  late final _$isSubmittingAtom = Atom(
    name: '_InquiryFormStore.isSubmitting',
    context: context,
  );

  @override
  bool get isSubmitting {
    _$isSubmittingAtom.reportRead();
    return super.isSubmitting;
  }

  @override
  set isSubmitting(bool value) {
    _$isSubmittingAtom.reportWrite(value, super.isSubmitting, () {
      super.isSubmitting = value;
    });
  }

  late final _$errorAtom = Atom(
    name: '_InquiryFormStore.error',
    context: context,
  );

  @override
  String? get error {
    _$errorAtom.reportRead();
    return super.error;
  }

  @override
  set error(String? value) {
    _$errorAtom.reportWrite(value, super.error, () {
      super.error = value;
    });
  }

  late final _$submitAsyncAction = AsyncAction(
    '_InquiryFormStore.submit',
    context: context,
  );

  @override
  Future<Inquiry?> submit(IInquiryRepository repository) {
    return _$submitAsyncAction.run(() => super.submit(repository));
  }

  late final _$_InquiryFormStoreActionController = ActionController(
    name: '_InquiryFormStore',
    context: context,
  );

  @override
  void setBranchId(String? value) {
    final _$actionInfo = _$_InquiryFormStoreActionController.startAction(
      name: '_InquiryFormStore.setBranchId',
    );
    try {
      return super.setBranchId(value);
    } finally {
      _$_InquiryFormStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setCategoryId(String? value) {
    final _$actionInfo = _$_InquiryFormStoreActionController.startAction(
      name: '_InquiryFormStore.setCategoryId',
    );
    try {
      return super.setCategoryId(value);
    } finally {
      _$_InquiryFormStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setProductTags(List<String> tags) {
    final _$actionInfo = _$_InquiryFormStoreActionController.startAction(
      name: '_InquiryFormStore.setProductTags',
    );
    try {
      return super.setProductTags(tags);
    } finally {
      _$_InquiryFormStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void addProductTag(String tag) {
    final _$actionInfo = _$_InquiryFormStoreActionController.startAction(
      name: '_InquiryFormStore.addProductTag',
    );
    try {
      return super.addProductTag(tag);
    } finally {
      _$_InquiryFormStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void removeProductTag(String tag) {
    final _$actionInfo = _$_InquiryFormStoreActionController.startAction(
      name: '_InquiryFormStore.removeProductTag',
    );
    try {
      return super.removeProductTag(tag);
    } finally {
      _$_InquiryFormStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setDeadline(DateTime? value) {
    final _$actionInfo = _$_InquiryFormStoreActionController.startAction(
      name: '_InquiryFormStore.setDeadline',
    );
    try {
      return super.setDeadline(value);
    } finally {
      _$_InquiryFormStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setDescription(String value) {
    final _$actionInfo = _$_InquiryFormStoreActionController.startAction(
      name: '_InquiryFormStore.setDescription',
    );
    try {
      return super.setDescription(value);
    } finally {
      _$_InquiryFormStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setDeliveryZips(List<String> zips) {
    final _$actionInfo = _$_InquiryFormStoreActionController.startAction(
      name: '_InquiryFormStore.setDeliveryZips',
    );
    try {
      return super.setDeliveryZips(zips);
    } finally {
      _$_InquiryFormStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setNumberOfProviders(int value) {
    final _$actionInfo = _$_InquiryFormStoreActionController.startAction(
      name: '_InquiryFormStore.setNumberOfProviders',
    );
    try {
      return super.setNumberOfProviders(value);
    } finally {
      _$_InquiryFormStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setProviderType(String? value) {
    final _$actionInfo = _$_InquiryFormStoreActionController.startAction(
      name: '_InquiryFormStore.setProviderType',
    );
    try {
      return super.setProviderType(value);
    } finally {
      _$_InquiryFormStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setProviderSize(String? value) {
    final _$actionInfo = _$_InquiryFormStoreActionController.startAction(
      name: '_InquiryFormStore.setProviderSize',
    );
    try {
      return super.setProviderSize(value);
    } finally {
      _$_InquiryFormStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setProviderZipPrefix(String? value) {
    final _$actionInfo = _$_InquiryFormStoreActionController.startAction(
      name: '_InquiryFormStore.setProviderZipPrefix',
    );
    try {
      return super.setProviderZipPrefix(value);
    } finally {
      _$_InquiryFormStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setContactSalutation(String value) {
    final _$actionInfo = _$_InquiryFormStoreActionController.startAction(
      name: '_InquiryFormStore.setContactSalutation',
    );
    try {
      return super.setContactSalutation(value);
    } finally {
      _$_InquiryFormStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setContactTitle(String value) {
    final _$actionInfo = _$_InquiryFormStoreActionController.startAction(
      name: '_InquiryFormStore.setContactTitle',
    );
    try {
      return super.setContactTitle(value);
    } finally {
      _$_InquiryFormStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setContactFirstName(String value) {
    final _$actionInfo = _$_InquiryFormStoreActionController.startAction(
      name: '_InquiryFormStore.setContactFirstName',
    );
    try {
      return super.setContactFirstName(value);
    } finally {
      _$_InquiryFormStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setContactLastName(String value) {
    final _$actionInfo = _$_InquiryFormStoreActionController.startAction(
      name: '_InquiryFormStore.setContactLastName',
    );
    try {
      return super.setContactLastName(value);
    } finally {
      _$_InquiryFormStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setContactTelephone(String value) {
    final _$actionInfo = _$_InquiryFormStoreActionController.startAction(
      name: '_InquiryFormStore.setContactTelephone',
    );
    try {
      return super.setContactTelephone(value);
    } finally {
      _$_InquiryFormStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setContactEmail(String value) {
    final _$actionInfo = _$_InquiryFormStoreActionController.startAction(
      name: '_InquiryFormStore.setContactEmail',
    );
    try {
      return super.setContactEmail(value);
    } finally {
      _$_InquiryFormStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setPdf(List<int> bytes, String fileName) {
    final _$actionInfo = _$_InquiryFormStoreActionController.startAction(
      name: '_InquiryFormStore.setPdf',
    );
    try {
      return super.setPdf(bytes, fileName);
    } finally {
      _$_InquiryFormStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearPdf() {
    final _$actionInfo = _$_InquiryFormStoreActionController.startAction(
      name: '_InquiryFormStore.clearPdf',
    );
    try {
      return super.clearPdf();
    } finally {
      _$_InquiryFormStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void reset() {
    final _$actionInfo = _$_InquiryFormStoreActionController.startAction(
      name: '_InquiryFormStore.reset',
    );
    try {
      return super.reset();
    } finally {
      _$_InquiryFormStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearError() {
    final _$actionInfo = _$_InquiryFormStoreActionController.startAction(
      name: '_InquiryFormStore.clearError',
    );
    try {
      return super.clearError();
    } finally {
      _$_InquiryFormStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
branchId: ${branchId},
categoryId: ${categoryId},
productTags: ${productTags},
deadline: ${deadline},
description: ${description},
deliveryZips: ${deliveryZips},
numberOfProviders: ${numberOfProviders},
providerType: ${providerType},
providerSize: ${providerSize},
providerZipPrefix: ${providerZipPrefix},
contactSalutation: ${contactSalutation},
contactTitle: ${contactTitle},
contactFirstName: ${contactFirstName},
contactLastName: ${contactLastName},
contactTelephone: ${contactTelephone},
contactEmail: ${contactEmail},
pdfBytes: ${pdfBytes},
pdfFileName: ${pdfFileName},
isSubmitting: ${isSubmitting},
error: ${error},
isValid: ${isValid},
hasPdf: ${hasPdf}
    ''';
  }
}
