import 'package:flutter/foundation.dart';
import 'package:mobx/mobx.dart';
import 'package:openapi/openapi.dart';

import '../../infrastructure/future_store.dart';
import '../../infrastructure/i_repository.dart';

part 'som.g.dart';

// ignore: library_private_types_in_public_api
class Som = _Som with _$Som;

abstract class _Som with Store {
  IRepository<SubscriptionPlan> apiSubscriptionRepository;
  BranchesApi branchesApi;

  _Som(this.apiSubscriptionRepository, this.branchesApi);

  @observable
  bool isLoadingData = true;

  @observable
  List<TagModel> availableBranches = [];

  @observable
  bool areSubscriptionsLoaded = false;

  @observable
  List<TagModel> requestedBranches = [];

  @action
  void requestBranch(TagModel branch) {
    requestedBranches.add(branch);
  }

  @action
  void removeRequestedBranch(TagModel branch) {
    requestedBranches.remove(branch);
  }

  @observable
  FutureStore<List<SubscriptionPlan>> availableSubscriptions = FutureStore();

  @observable
  bool areBranchesLoaded = false;

  @action
  Future populateAvailableBranches() async {
    if (areBranchesLoaded) {
      return;
    }

    try {
      final response = await branchesApi.branchesGet();
      final branches = response.data?.toList() ?? const <Branch>[];
      final tags = <TagModel>[];
      for (final branch in branches) {
        final branchName = branch.name ?? 'Branch';
        final branchId = branch.id ?? branchName;
        if (branch.categories != null && branch.categories!.isNotEmpty) {
          for (final category in branch.categories!) {
            final categoryName = category.name ?? 'Category';
            final categoryId = category.id ?? '$branchId-$categoryName';
            tags.add(TagModel(
              id: categoryId,
              title: '$branchName / $categoryName',
            ));
          }
        } else {
          tags.add(TagModel(id: branchId, title: branchName));
        }
      }
      availableBranches = tags;
      areBranchesLoaded = true;
    } catch (e) {
      areBranchesLoaded = false;
    }
  }

  @action
  Future populateAvailableSubscriptions() async {
    isLoadingData = true;
    if (availableSubscriptions.data != null) {
      isLoadingData = false;
      return;
    }

    try {
      availableSubscriptions.errorMessage = null;

      availableSubscriptions.future =
          ObservableFuture(apiSubscriptionRepository.getAll());

      availableSubscriptions.data = await availableSubscriptions.future;
      if (kDebugMode) {
        debugPrint('${availableSubscriptions.data}');
      }
      isLoadingData = false;
    } catch (e) {
      isLoadingData = false;
      availableSubscriptions.errorMessage = e.toString();
    }
  }
}

class TagModel {
  String id;
  String title;

  TagModel({
    required this.id,
    required this.title,
  });
}
