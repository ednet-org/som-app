import 'package:mobx/mobx.dart';

part 'branch.g.dart';

// ignore: library_private_types_in_public_api
class Branch = _Branch with _$Branch;

abstract class _Branch with Store {
  @observable
  String? uuid;

  @action
  void setUuid(String value) => uuid = value;

  @observable
  String? title;

  @action
  void setTitle(String value) => title = value;

  @observable
  Branch? category;

  @action
  void setCategory(Branch value) => category = value;

  @observable
  Branch? product;

  @action
  void setProduct(Branch value) => product = value;
}
