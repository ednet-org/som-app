import 'package:mobx/mobx.dart';
import 'package:som/domain/core/model/future_store.dart';
import 'package:som/domain/core/model/i_repository.dart';
import 'package:som/domain/infrastructure/repository/api/lib/models/subscription.dart';
import 'package:som/ui/components/forms/branches.dart';

part 'som.g.dart';

class Som = _Som with _$Som;

abstract class _Som with Store {
  IRepository<Subscription> apiSubscriptionRepository;

  _Som(this.apiSubscriptionRepository);

  @observable
  String nesto = 'Nesto';

  @observable
  List<TagModel> availableBranches = branchTags.toList();

  @observable
  bool areSubscriptionsLoaded = false;

  @observable
  List<TagModel> requestedBranches = [];

  @action
  void requestBranch(branch) {
    this.requestedBranches.add(branch);
  }

  @action
  void removeRequestedBranch(branch) {
    this.requestedBranches.remove(branch);
  }

  @observable
  FutureStore<Subscription> availableSubscriptions = FutureStore();

  @action
  Future populateAvailableSubscriptions() async {
    if (availableSubscriptions.data != null) {
      return;
    }

    try {
      availableSubscriptions.errorMessage = null;

      availableSubscriptions.future =
          ObservableFuture(apiSubscriptionRepository.getAll());

      availableSubscriptions.data = await availableSubscriptions.future;
    } catch (e) {
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
