// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inquiry_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$InquiryStore on _InquiryStore, Store {
  Computed<bool>? _$hasSelectionComputed;

  @override
  bool get hasSelection => (_$hasSelectionComputed ??= Computed<bool>(
    () => super.hasSelection,
    name: '_InquiryStore.hasSelection',
  )).value;
  Computed<bool>? _$hasOffersComputed;

  @override
  bool get hasOffers => (_$hasOffersComputed ??= Computed<bool>(
    () => super.hasOffers,
    name: '_InquiryStore.hasOffers',
  )).value;

  late final _$inquiriesAtom = Atom(
    name: '_InquiryStore.inquiries',
    context: context,
  );

  @override
  ObservableList<Inquiry> get inquiries {
    _$inquiriesAtom.reportRead();
    return super.inquiries;
  }

  @override
  set inquiries(ObservableList<Inquiry> value) {
    _$inquiriesAtom.reportWrite(value, super.inquiries, () {
      super.inquiries = value;
    });
  }

  late final _$selectedInquiryAtom = Atom(
    name: '_InquiryStore.selectedInquiry',
    context: context,
  );

  @override
  Inquiry? get selectedInquiry {
    _$selectedInquiryAtom.reportRead();
    return super.selectedInquiry;
  }

  @override
  set selectedInquiry(Inquiry? value) {
    _$selectedInquiryAtom.reportWrite(value, super.selectedInquiry, () {
      super.selectedInquiry = value;
    });
  }

  late final _$offersAtom = Atom(
    name: '_InquiryStore.offers',
    context: context,
  );

  @override
  ObservableList<Offer> get offers {
    _$offersAtom.reportRead();
    return super.offers;
  }

  @override
  set offers(ObservableList<Offer> value) {
    _$offersAtom.reportWrite(value, super.offers, () {
      super.offers = value;
    });
  }

  late final _$isLoadingAtom = Atom(
    name: '_InquiryStore.isLoading',
    context: context,
  );

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  late final _$isLoadingOffersAtom = Atom(
    name: '_InquiryStore.isLoadingOffers',
    context: context,
  );

  @override
  bool get isLoadingOffers {
    _$isLoadingOffersAtom.reportRead();
    return super.isLoadingOffers;
  }

  @override
  set isLoadingOffers(bool value) {
    _$isLoadingOffersAtom.reportWrite(value, super.isLoadingOffers, () {
      super.isLoadingOffers = value;
    });
  }

  late final _$errorAtom = Atom(name: '_InquiryStore.error', context: context);

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

  late final _$loadInquiriesAsyncAction = AsyncAction(
    '_InquiryStore.loadInquiries',
    context: context,
  );

  @override
  Future<void> loadInquiries(InquiryFilter? filter) {
    return _$loadInquiriesAsyncAction.run(() => super.loadInquiries(filter));
  }

  late final _$selectInquiryAsyncAction = AsyncAction(
    '_InquiryStore.selectInquiry',
    context: context,
  );

  @override
  Future<void> selectInquiry(Inquiry? inquiry) {
    return _$selectInquiryAsyncAction.run(() => super.selectInquiry(inquiry));
  }

  late final _$loadOffersAsyncAction = AsyncAction(
    '_InquiryStore.loadOffers',
    context: context,
  );

  @override
  Future<void> loadOffers(String inquiryId) {
    return _$loadOffersAsyncAction.run(() => super.loadOffers(inquiryId));
  }

  late final _$closeInquiryAsyncAction = AsyncAction(
    '_InquiryStore.closeInquiry',
    context: context,
  );

  @override
  Future<void> closeInquiry() {
    return _$closeInquiryAsyncAction.run(() => super.closeInquiry());
  }

  late final _$ignoreInquiryAsyncAction = AsyncAction(
    '_InquiryStore.ignoreInquiry',
    context: context,
  );

  @override
  Future<void> ignoreInquiry() {
    return _$ignoreInquiryAsyncAction.run(() => super.ignoreInquiry());
  }

  late final _$assignProvidersAsyncAction = AsyncAction(
    '_InquiryStore.assignProviders',
    context: context,
  );

  @override
  Future<void> assignProviders(List<String> providerIds) {
    return _$assignProvidersAsyncAction.run(
      () => super.assignProviders(providerIds),
    );
  }

  late final _$acceptOfferAsyncAction = AsyncAction(
    '_InquiryStore.acceptOffer',
    context: context,
  );

  @override
  Future<void> acceptOffer(String offerId) {
    return _$acceptOfferAsyncAction.run(() => super.acceptOffer(offerId));
  }

  late final _$rejectOfferAsyncAction = AsyncAction(
    '_InquiryStore.rejectOffer',
    context: context,
  );

  @override
  Future<void> rejectOffer(String offerId) {
    return _$rejectOfferAsyncAction.run(() => super.rejectOffer(offerId));
  }

  late final _$refreshAsyncAction = AsyncAction(
    '_InquiryStore.refresh',
    context: context,
  );

  @override
  Future<void> refresh() {
    return _$refreshAsyncAction.run(() => super.refresh());
  }

  late final _$_InquiryStoreActionController = ActionController(
    name: '_InquiryStore',
    context: context,
  );

  @override
  void clearError() {
    final _$actionInfo = _$_InquiryStoreActionController.startAction(
      name: '_InquiryStore.clearError',
    );
    try {
      return super.clearError();
    } finally {
      _$_InquiryStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearSelection() {
    final _$actionInfo = _$_InquiryStoreActionController.startAction(
      name: '_InquiryStore.clearSelection',
    );
    try {
      return super.clearSelection();
    } finally {
      _$_InquiryStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
inquiries: ${inquiries},
selectedInquiry: ${selectedInquiry},
offers: ${offers},
isLoading: ${isLoading},
isLoadingOffers: ${isLoadingOffers},
error: ${error},
hasSelection: ${hasSelection},
hasOffers: ${hasOffers}
    ''';
  }
}
