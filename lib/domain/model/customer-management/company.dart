import 'address.dart';

class Company {
  String name;
  Address address;
  String uidNr;
  String registrationNumber;
  int companySize;

  // todo: what is this?
  int type;

  Company(this.name, this.address, this.uidNr, this.registrationNumber,
      this.companySize, this.type, this.websiteUrl);

  String websiteUrl;
}
