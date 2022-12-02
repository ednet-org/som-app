import 'package:mobx/mobx.dart';

part 'inquiry.g.dart';

class Inquiry = _Inquiry with _$Inquiry;

abstract class _Inquiry with Store {
  String? id;
  String? title;
  String? description;
  String? category;
  String? branch;
  String? username;
  String? userrole;
  String? userphonenumber;
  String? usermail;
  String? publishingDate;
  String? expirationDate;
  String? deliverylocation;
  String? numberofOffers;
  String? providerlocation;
  String? providercompanytype;
  String? providercompanysize;
  List<String>? attachments;
  String? status;
  List<String>? offers;
}
