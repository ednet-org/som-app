import 'company.dart';

class UserRegistrationRequest {
  String email;
  String firstName;
  String lastName;
  String salutation;
  List<int> roles;
  String telephoneNumber;
  String title;
  Company company;

  UserRegistrationRequest(
      this.email,
      this.firstName,
      this.lastName,
      this.salutation,
      this.roles,
      this.telephoneNumber,
      this.title,
      this.company);
}

/*
{
  "email": "string",
  "firstName": "string",
  "lastName": "string",
  "salutation": "string",
  "roles": [0],
  "telephoneNr": "string",
  "title": "string",
  "companyId": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
  "id": "3fa85f64-5717-4562-b3fc-2c963f66afa6"
}
 */
