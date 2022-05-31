import 'package:mobx/mobx.dart';

part 'address.g.dart';

class Address = _Address with _$Address;

abstract class _Address with Store {
  /* rest of the class*/
  @observable
  String? country;

  @action
  void setCountry(String? value) => country = value;
  @observable
  String? city;

  @action
  void setCity(String value) => city = value;
  @observable
  String? street;

  @action
  void setStreet(String value) => street = value;

  @observable
  String? number;

  @action
  void setNumber(String value) => number = value;

  @observable
  String? zip;

  @action
  void setZip(String value) => zip = value;
}
