import 'package:mobx/mobx.dart';
import 'package:som/ui/components/forms/branches.dart';

part 'som.g.dart';

class Som = _Som with _$Som;

abstract class _Som with Store {
  @observable
  String nesto = 'Nesto';

  @observable
  List<TagModel> availableBranches = branchTags.toList();

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
}

class TagModel {
  String id;
  String title;

  TagModel({
    required this.id,
    required this.title,
  });
}
