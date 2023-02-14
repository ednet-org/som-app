import 'package:mobx/mobx.dart';
import 'package:som/domain/infrastructure/repository/api/lib/models/subscription.dart';

import '../../infrastructure/future_store.dart';
import '../../infrastructure/i_repository.dart';
import '../forms/branches.dart';

part 'som.g.dart';

class Som = _Som with _$Som;

abstract class _Som with Store {
  IRepository<Subscription> apiSubscriptionRepository;

  _Som(this.apiSubscriptionRepository);

  @observable
  String nesto = 'Nesto';

  @observable
  bool isLoadingData = true;

  @observable
  List<TagModel> availableBranches = branchTags.toList();

  @observable
  bool areSubscriptionsLoaded = false;

  @observable
  List<TagModel> requestedBranches = [];

  @action
  void requestBranch(branch) {
    requestedBranches.add(branch);
  }

  @action
  void removeRequestedBranch(branch) {
    requestedBranches.remove(branch);
  }

  @observable
  FutureStore<List<Subscription>> availableSubscriptions = FutureStore();

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
      print(availableSubscriptions.data);
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
