import 'package:mobx/mobx.dart';

part 'bank_details.g.dart';

// ignore: library_private_types_in_public_api
class BankDetails = _BankDetails with _$BankDetails;

abstract class _BankDetails with Store {
  @observable
  String? iban;

  @action
  void setIban(String value) => iban = value;
  @observable
  String? bic;

  @action
  void setBic(String value) => bic = value;
  @observable
  String? accountOwner;

  @action
  void setAccountOwner(String value) => accountOwner = value;
}
