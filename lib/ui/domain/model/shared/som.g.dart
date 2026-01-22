// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'som.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$Som on _Som, Store {
  late final _$isLoadingDataAtom = Atom(
    name: '_Som.isLoadingData',
    context: context,
  );

  @override
  bool get isLoadingData {
    _$isLoadingDataAtom.reportRead();
    return super.isLoadingData;
  }

  @override
  set isLoadingData(bool value) {
    _$isLoadingDataAtom.reportWrite(value, super.isLoadingData, () {
      super.isLoadingData = value;
    });
  }

  late final _$availableBranchesAtom = Atom(
    name: '_Som.availableBranches',
    context: context,
  );

  @override
  List<TagModel> get availableBranches {
    _$availableBranchesAtom.reportRead();
    return super.availableBranches;
  }

  @override
  set availableBranches(List<TagModel> value) {
    _$availableBranchesAtom.reportWrite(value, super.availableBranches, () {
      super.availableBranches = value;
    });
  }

  late final _$areSubscriptionsLoadedAtom = Atom(
    name: '_Som.areSubscriptionsLoaded',
    context: context,
  );

  @override
  bool get areSubscriptionsLoaded {
    _$areSubscriptionsLoadedAtom.reportRead();
    return super.areSubscriptionsLoaded;
  }

  @override
  set areSubscriptionsLoaded(bool value) {
    _$areSubscriptionsLoadedAtom.reportWrite(
      value,
      super.areSubscriptionsLoaded,
      () {
        super.areSubscriptionsLoaded = value;
      },
    );
  }

  late final _$requestedBranchesAtom = Atom(
    name: '_Som.requestedBranches',
    context: context,
  );

  @override
  List<TagModel> get requestedBranches {
    _$requestedBranchesAtom.reportRead();
    return super.requestedBranches;
  }

  @override
  set requestedBranches(List<TagModel> value) {
    _$requestedBranchesAtom.reportWrite(value, super.requestedBranches, () {
      super.requestedBranches = value;
    });
  }

  late final _$availableSubscriptionsAtom = Atom(
    name: '_Som.availableSubscriptions',
    context: context,
  );

  @override
  FutureStore<List<SubscriptionPlan>> get availableSubscriptions {
    _$availableSubscriptionsAtom.reportRead();
    return super.availableSubscriptions;
  }

  @override
  set availableSubscriptions(FutureStore<List<SubscriptionPlan>> value) {
    _$availableSubscriptionsAtom.reportWrite(
      value,
      super.availableSubscriptions,
      () {
        super.availableSubscriptions = value;
      },
    );
  }

  late final _$areBranchesLoadedAtom = Atom(
    name: '_Som.areBranchesLoaded',
    context: context,
  );

  @override
  bool get areBranchesLoaded {
    _$areBranchesLoadedAtom.reportRead();
    return super.areBranchesLoaded;
  }

  @override
  set areBranchesLoaded(bool value) {
    _$areBranchesLoadedAtom.reportWrite(value, super.areBranchesLoaded, () {
      super.areBranchesLoaded = value;
    });
  }

  late final _$populateAvailableBranchesAsyncAction = AsyncAction(
    '_Som.populateAvailableBranches',
    context: context,
  );

  @override
  Future<dynamic> populateAvailableBranches() {
    return _$populateAvailableBranchesAsyncAction.run(
      () => super.populateAvailableBranches(),
    );
  }

  late final _$populateAvailableSubscriptionsAsyncAction = AsyncAction(
    '_Som.populateAvailableSubscriptions',
    context: context,
  );

  @override
  Future<dynamic> populateAvailableSubscriptions() {
    return _$populateAvailableSubscriptionsAsyncAction.run(
      () => super.populateAvailableSubscriptions(),
    );
  }

  late final _$_SomActionController = ActionController(
    name: '_Som',
    context: context,
  );

  @override
  void requestBranch(TagModel branch) {
    final _$actionInfo = _$_SomActionController.startAction(
      name: '_Som.requestBranch',
    );
    try {
      return super.requestBranch(branch);
    } finally {
      _$_SomActionController.endAction(_$actionInfo);
    }
  }

  @override
  void removeRequestedBranch(TagModel branch) {
    final _$actionInfo = _$_SomActionController.startAction(
      name: '_Som.removeRequestedBranch',
    );
    try {
      return super.removeRequestedBranch(branch);
    } finally {
      _$_SomActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isLoadingData: ${isLoadingData},
availableBranches: ${availableBranches},
areSubscriptionsLoaded: ${areSubscriptionsLoaded},
requestedBranches: ${requestedBranches},
availableSubscriptions: ${availableSubscriptions},
areBranchesLoaded: ${areBranchesLoaded}
    ''';
  }
}
