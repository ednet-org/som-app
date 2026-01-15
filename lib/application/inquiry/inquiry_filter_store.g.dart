// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inquiry_filter_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$InquiryFilterStore on _InquiryFilterStore, Store {
  Computed<InquiryFilter>? _$currentFilterComputed;

  @override
  InquiryFilter get currentFilter =>
      (_$currentFilterComputed ??= Computed<InquiryFilter>(
        () => super.currentFilter,
        name: '_InquiryFilterStore.currentFilter',
      )).value;
  Computed<bool>? _$hasActiveFiltersComputed;

  @override
  bool get hasActiveFilters => (_$hasActiveFiltersComputed ??= Computed<bool>(
    () => super.hasActiveFilters,
    name: '_InquiryFilterStore.hasActiveFilters',
  )).value;

  late final _$statusAtom = Atom(
    name: '_InquiryFilterStore.status',
    context: context,
  );

  @override
  String? get status {
    _$statusAtom.reportRead();
    return super.status;
  }

  @override
  set status(String? value) {
    _$statusAtom.reportWrite(value, super.status, () {
      super.status = value;
    });
  }

  late final _$branchIdAtom = Atom(
    name: '_InquiryFilterStore.branchId',
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

  late final _$branchNameAtom = Atom(
    name: '_InquiryFilterStore.branchName',
    context: context,
  );

  @override
  String? get branchName {
    _$branchNameAtom.reportRead();
    return super.branchName;
  }

  @override
  set branchName(String? value) {
    _$branchNameAtom.reportWrite(value, super.branchName, () {
      super.branchName = value;
    });
  }

  late final _$providerTypeAtom = Atom(
    name: '_InquiryFilterStore.providerType',
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
    name: '_InquiryFilterStore.providerSize',
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

  late final _$createdFromAtom = Atom(
    name: '_InquiryFilterStore.createdFrom',
    context: context,
  );

  @override
  DateTime? get createdFrom {
    _$createdFromAtom.reportRead();
    return super.createdFrom;
  }

  @override
  set createdFrom(DateTime? value) {
    _$createdFromAtom.reportWrite(value, super.createdFrom, () {
      super.createdFrom = value;
    });
  }

  late final _$createdToAtom = Atom(
    name: '_InquiryFilterStore.createdTo',
    context: context,
  );

  @override
  DateTime? get createdTo {
    _$createdToAtom.reportRead();
    return super.createdTo;
  }

  @override
  set createdTo(DateTime? value) {
    _$createdToAtom.reportWrite(value, super.createdTo, () {
      super.createdTo = value;
    });
  }

  late final _$deadlineFromAtom = Atom(
    name: '_InquiryFilterStore.deadlineFrom',
    context: context,
  );

  @override
  DateTime? get deadlineFrom {
    _$deadlineFromAtom.reportRead();
    return super.deadlineFrom;
  }

  @override
  set deadlineFrom(DateTime? value) {
    _$deadlineFromAtom.reportWrite(value, super.deadlineFrom, () {
      super.deadlineFrom = value;
    });
  }

  late final _$deadlineToAtom = Atom(
    name: '_InquiryFilterStore.deadlineTo',
    context: context,
  );

  @override
  DateTime? get deadlineTo {
    _$deadlineToAtom.reportRead();
    return super.deadlineTo;
  }

  @override
  set deadlineTo(DateTime? value) {
    _$deadlineToAtom.reportWrite(value, super.deadlineTo, () {
      super.deadlineTo = value;
    });
  }

  late final _$editorIdsAtom = Atom(
    name: '_InquiryFilterStore.editorIds',
    context: context,
  );

  @override
  ObservableList<String> get editorIds {
    _$editorIdsAtom.reportRead();
    return super.editorIds;
  }

  @override
  set editorIds(ObservableList<String> value) {
    _$editorIdsAtom.reportWrite(value, super.editorIds, () {
      super.editorIds = value;
    });
  }

  late final _$_InquiryFilterStoreActionController = ActionController(
    name: '_InquiryFilterStore',
    context: context,
  );

  @override
  void setStatus(String? value) {
    final _$actionInfo = _$_InquiryFilterStoreActionController.startAction(
      name: '_InquiryFilterStore.setStatus',
    );
    try {
      return super.setStatus(value);
    } finally {
      _$_InquiryFilterStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setBranchId(String? value) {
    final _$actionInfo = _$_InquiryFilterStoreActionController.startAction(
      name: '_InquiryFilterStore.setBranchId',
    );
    try {
      return super.setBranchId(value);
    } finally {
      _$_InquiryFilterStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setBranchName(String? value) {
    final _$actionInfo = _$_InquiryFilterStoreActionController.startAction(
      name: '_InquiryFilterStore.setBranchName',
    );
    try {
      return super.setBranchName(value);
    } finally {
      _$_InquiryFilterStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setProviderType(String? value) {
    final _$actionInfo = _$_InquiryFilterStoreActionController.startAction(
      name: '_InquiryFilterStore.setProviderType',
    );
    try {
      return super.setProviderType(value);
    } finally {
      _$_InquiryFilterStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setProviderSize(String? value) {
    final _$actionInfo = _$_InquiryFilterStoreActionController.startAction(
      name: '_InquiryFilterStore.setProviderSize',
    );
    try {
      return super.setProviderSize(value);
    } finally {
      _$_InquiryFilterStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setCreatedFrom(DateTime? value) {
    final _$actionInfo = _$_InquiryFilterStoreActionController.startAction(
      name: '_InquiryFilterStore.setCreatedFrom',
    );
    try {
      return super.setCreatedFrom(value);
    } finally {
      _$_InquiryFilterStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setCreatedTo(DateTime? value) {
    final _$actionInfo = _$_InquiryFilterStoreActionController.startAction(
      name: '_InquiryFilterStore.setCreatedTo',
    );
    try {
      return super.setCreatedTo(value);
    } finally {
      _$_InquiryFilterStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setDeadlineFrom(DateTime? value) {
    final _$actionInfo = _$_InquiryFilterStoreActionController.startAction(
      name: '_InquiryFilterStore.setDeadlineFrom',
    );
    try {
      return super.setDeadlineFrom(value);
    } finally {
      _$_InquiryFilterStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setDeadlineTo(DateTime? value) {
    final _$actionInfo = _$_InquiryFilterStoreActionController.startAction(
      name: '_InquiryFilterStore.setDeadlineTo',
    );
    try {
      return super.setDeadlineTo(value);
    } finally {
      _$_InquiryFilterStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setEditorIds(List<String> values) {
    final _$actionInfo = _$_InquiryFilterStoreActionController.startAction(
      name: '_InquiryFilterStore.setEditorIds',
    );
    try {
      return super.setEditorIds(values);
    } finally {
      _$_InquiryFilterStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearFilters() {
    final _$actionInfo = _$_InquiryFilterStoreActionController.startAction(
      name: '_InquiryFilterStore.clearFilters',
    );
    try {
      return super.clearFilters();
    } finally {
      _$_InquiryFilterStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
status: ${status},
branchId: ${branchId},
branchName: ${branchName},
providerType: ${providerType},
providerSize: ${providerSize},
createdFrom: ${createdFrom},
createdTo: ${createdTo},
deadlineFrom: ${deadlineFrom},
deadlineTo: ${deadlineTo},
editorIds: ${editorIds},
currentFilter: ${currentFilter},
hasActiveFilters: ${hasActiveFilters}
    ''';
  }
}
