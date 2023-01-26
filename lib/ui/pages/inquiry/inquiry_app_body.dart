import 'package:flutter/material.dart';
import 'package:som/domain/model/inquiry_management/inquiry_status.dart';
import 'package:som/ui/components/layout/app_body.dart';

import '../../../domain/model/inquiry_management/inquiry.dart';
import '../../components/cards/inquiry/inquiry_card.dart';

class InquiryAppBody extends StatelessWidget {
  const InquiryAppBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBody(
      contextMenu: Text(
        'Refine your search with Filters',
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
            ),
      ),
      leftSplit: GridView.builder(
        itemCount: inquiries.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, crossAxisSpacing: 5.0, mainAxisSpacing: 5.0),
        itemBuilder: (BuildContext context, int index) {
          var inquiry = Inquiry.fromJson(inquiries[index]);
          switch (inquiry.status) {
            case InquiryStatus.draft:
              return InquiryCard(inquiry: inquiry);
            case InquiryStatus.responded:
              return InquiryCard(inquiry: inquiry);
            case InquiryStatus.published:
              return InquiryCard(inquiry: inquiry);
            case InquiryStatus.closed:
              return InquiryCard(inquiry: inquiry);
            // return EntityCard(
            //   item: inquiry,
            //   mapping: const InquiryToCardMapping(),
            // );
            default:
              return InquiryCard(inquiry: inquiry);
          }
        },
      ),
      rightSplit: null,
      // rightSplit: Image.asset(
      //   'images/som/InquiryInfoCard.png',
      //   height: 500,
      //   fit: BoxFit.fitHeight,
      // ),
    );
  }
}

// https://gist.github.com/slavisam/a4c08dac23b012fb7108d7eb4f2a3f72

List<Map<String, dynamic>> inquiries = [
  {
    "id": "1",
    "title": "Laptops for new Dev team - Blue oranges",
    "description": "describe me...",
    "category": "IT",
    "branch": "Laptops",
    "user": {
      "username": "Mr. Basche",
      "userrole": "IT Manager",
      "phoneNumber": "+436641234567",
      "email": "basche@som.com",
      "roleAtCompany": "employee",
      "roleAtSom": "buyer",
      "company": {
        "name": "Samsung",
        "role": "buyer",
        "address": "Somewhere over the rainbow"
      }
    },
    "publishingDate": "14.11.2022",
    "expirationDate": "01.12.2022",
    "deliveryLocation": "Vienna",
    "numberofOffers": "3",
    "provider": {
      "location": "east austria",
      "companyType": "Dealer",
      "companySize": "unrestricted",
    },
    "attachments": "[]",
    "status": "draft",
    "offers": "",
  },
  {
    "id": "1",
    "title": "Office Printer",
    "category": "Printing",
    "branch": "Multifunction Printers",
    "description":
        "New Office Printers with FollowMe Solution; We need 4 A3 Colour Office Printers for about 10k A4 printouts per Month. Besides that the printers must have minimum two Paperbanks and one Printer a Bookletfinisher. We want an offer for rental and purchase variation.",
    "user": {
      "username": "Mr. Basche",
      "userrole": "IT Manager",
      "phoneNumber": "+436641234567",
      "email": "basche@som.com",
      "roleAtCompany": "employee",
      "roleAtSom": "buyer",
      "company": {
        "name": "Samsung",
        "role": "buyer",
        "address": "Somewhere over the rainbow"
      }
    },
    "publishingDate": "20.11.2022",
    "expirationDate": "31.12.2022",
    "deliveryLocation": "Vienna",
    "numberofOffers": "3",
    "provider": {
      "location": "Austria",
      "companyType": "Dealer",
      "companySize": "upTo10",
    },
    "attachments": "[]",
    "status": "published",
    "offers": "",
  },
  {
    "id": "2",
    "title": "Notebooks",
    "category": "Clients",
    "branch": "IT",
    "description": "6x 15“ Notebook; Specifications attached",
    "user": {
      "username": "Mr. Basche",
      "userrole": "IT Manager",
      "phoneNumber": "+436641234567",
      "email": "basche@som.com",
      "roleAtCompany": "employee",
      "roleAtSom": "buyer",
      "company": {
        "name": "Samsung",
        "role": "buyer",
        "address": "Somewhere over the rainbow"
      }
    },
    "publishingDate": "20.11.2022",
    "expirationDate": "31.12.2022",
    "deliveryLocation": "Graz",
    "numberofOffers": "5",
    "provider": {
      "location": "Austria",
      "companyType": "Dealer",
      "companySize": "unrestricted",
    },
    "attachments": "[]",
    "status": "responded",
    "offers": "",
  },
  {
    "id": "3",
    "title":
        "25 Phonenumbers with Samsung Smartphones and 10 mobile internet for tablets",
    "category": "Mobilephone, mobileinternet",
    "branch": "Telecommunication",
    "description":
        "We need 25 Mobilephonemubers (flat minutes in austria, flat minutes in europe and each number with 10GB internet in austria and europe) with Samsung Galaxy 22FE and 10 Mobileinternet-Cards (each 20GB for austria and europe)",
    "user": {
      "username": "Mr. Basche",
      "userrole": "Purchase Manager",
      "phoneNumber": "+436641234567",
      "email": "basche@som.com",
      "roleAtCompany": "employee",
      "roleAtSom": "buyer",
      "company": {
        "name": "Samsung",
        "role": "buyer",
        "address": "Somewhere over the rainbow"
      }
    },
    "publishingDate": "20.11.2022",
    "expirationDate": "31.12.2022",
    "deliveryLocation": "Vienna",
    "numberofOffers": "3",
    "provider": {
      "location": "east austria",
      "companyType": "Dealer",
      "companySize": "unrestricted",
    },
    "attachments": "[]",
    "status": "closed",
    "offers": "",
  },
  {
    "id": "1",
    "title": "Laptops for new Dev team - Blue oranges",
    "description": "describe me...",
    "category": "IT",
    "branch": "Laptops",
    "user": {
      "username": "Mr. Basche",
      "userrole": "IT Manager",
      "phoneNumber": "+436641234567",
      "email": "basche@som.com",
      "roleAtCompany": "employee",
      "roleAtSom": "buyer",
      "company": {
        "name": "Samsung",
        "role": "buyer",
        "address": "Somewhere over the rainbow"
      }
    },
    "publishingDate": "14.11.2022",
    "expirationDate": "01.12.2022",
    "deliveryLocation": "Vienna",
    "numberofOffers": "3",
    "provider": {
      "location": "east austria",
      "companyType": "Dealer",
      "companySize": "unrestricted",
    },
    "attachments": "[]",
    "status": "closed",
    "offers": "",
  },
  {
    "id": "1",
    "title": "Office Printer",
    "category": "Printing",
    "branch": "Multifunction Printers",
    "description":
        "New Office Printers with FollowMe Solution; We need 4 A3 Colour Office Printers for about 10k A4 printouts per Month. Besides that the printers must have minimum two Paperbanks and one Printer a Bookletfinisher. We want an offer for rental and purchase variation.",
    "user": {
      "username": "Mr. Basche",
      "userrole": "IT Manager",
      "phoneNumber": "+436641234567",
      "email": "basche@som.com",
      "roleAtCompany": "employee",
      "roleAtSom": "buyer",
      "company": {
        "name": "Samsung",
        "role": "buyer",
        "address": "Somewhere over the rainbow"
      }
    },
    "publishingDate": "20.11.2022",
    "expirationDate": "31.12.2022",
    "deliveryLocation": "Vienna",
    "numberofOffers": "3",
    "provider": {
      "location": "Austria",
      "companyType": "Dealer",
      "companySize": "upTo10",
    },
    "attachments": "[]",
    "status": "published",
    "offers": "",
  },
  {
    "id": "2",
    "title": "Notebooks",
    "category": "Clients",
    "branch": "IT",
    "description": "6x 15“ Notebook; Specifications attached",
    "user": {
      "username": "Mr. Basche",
      "userrole": "IT Manager",
      "phoneNumber": "+436641234567",
      "email": "basche@som.com",
      "roleAtCompany": "employee",
      "roleAtSom": "buyer",
      "company": {
        "name": "Samsung",
        "role": "buyer",
        "address": "Somewhere over the rainbow"
      }
    },
    "publishingDate": "20.11.2022",
    "expirationDate": "31.12.2022",
    "deliveryLocation": "Graz",
    "numberofOffers": "5",
    "provider": {
      "location": "Austria",
      "companyType": "Dealer",
      "companySize": "unrestricted",
    },
    "attachments": "[]",
    "status": "responded",
    "offers": "",
  },
  {
    "id": "3",
    "title":
        "25 Phonenumbers with Samsung Smartphones and 10 mobile internet for tablets",
    "category": "Mobilephone, mobileinternet",
    "branch": "Telecommunication",
    "description":
        "We need 25 Mobilephonemubers (flat minutes in austria, flat minutes in europe and each number with 10GB internet in austria and europe) with Samsung Galaxy 22FE and 10 Mobileinternet-Cards (each 20GB for austria and europe)",
    "user": {
      "username": "Mr. Basche",
      "userrole": "Purchase Manager",
      "phoneNumber": "+436641234567",
      "email": "basche@som.com",
      "roleAtCompany": "employee",
      "roleAtSom": "buyer",
      "company": {
        "name": "Samsung",
        "role": "buyer",
        "address": "Somewhere over the rainbow"
      }
    },
    "publishingDate": "20.11.2022",
    "expirationDate": "31.12.2022",
    "deliveryLocation": "Vienna",
    "numberofOffers": "3",
    "provider": {
      "location": "east austria",
      "companyType": "Dealer",
      "companySize": "unrestricted",
    },
    "attachments": "[]",
    "status": "draft",
    "offers": "",
  },
  {
    "id": "3",
    "title":
        "25 Phonenumbers with Samsung Smartphones and 10 mobile internet for tablets",
    "category": "Mobilephone, mobileinternet",
    "branch": "Telecommunication",
    "description":
        "We need 25 Mobilephonemubers (flat minutes in austria, flat minutes in europe and each number with 10GB internet in austria and europe) with Samsung Galaxy 22FE and 10 Mobileinternet-Cards (each 20GB for austria and europe)",
    "user": {
      "username": "Mr. Basche",
      "userrole": "Purchase Manager",
      "phoneNumber": "+436641234567",
      "email": "basche@som.com",
      "roleAtCompany": "employee",
      "roleAtSom": "buyer",
      "company": {
        "name": "Samsung",
        "role": "buyer",
        "address": "Somewhere over the rainbow"
      }
    },
    "publishingDate": "20.11.2022",
    "expirationDate": "31.12.2022",
    "deliveryLocation": "Vienna",
    "numberofOffers": "3",
    "provider": {
      "location": "east austria",
      "companyType": "Dealer",
      "companySize": "unrestricted",
    },
    "attachments": "[]",
    "status": "draft",
    "offers": "",
  },
  {
    "id": "3",
    "title":
        "25 Phonenumbers with Samsung Smartphones and 10 mobile internet for tablets",
    "category": "Mobilephone, mobileinternet",
    "branch": "Telecommunication",
    "description":
        "We need 25 Mobilephonemubers (flat minutes in austria, flat minutes in europe and each number with 10GB internet in austria and europe) with Samsung Galaxy 22FE and 10 Mobileinternet-Cards (each 20GB for austria and europe)",
    "user": {
      "username": "Mr. Basche",
      "userrole": "Purchase Manager",
      "phoneNumber": "+436641234567",
      "email": "basche@som.com",
      "roleAtCompany": "employee",
      "roleAtSom": "buyer",
      "company": {
        "name": "Samsung",
        "role": "buyer",
        "address": "Somewhere over the rainbow"
      }
    },
    "publishingDate": "20.11.2022",
    "expirationDate": "31.12.2022",
    "deliveryLocation": "Vienna",
    "numberofOffers": "3",
    "provider": {
      "location": "east austria",
      "companyType": "Dealer",
      "companySize": "unrestricted",
    },
    "attachments": "[]",
    "status": "draft",
    "offers": "",
  },
  {
    "id": "3",
    "title":
        "25 Phonenumbers with Samsung Smartphones and 10 mobile internet for tablets",
    "category": "Mobilephone, mobileinternet",
    "branch": "Telecommunication",
    "description":
        "We need 25 Mobilephonemubers (flat minutes in austria, flat minutes in europe and each number with 10GB internet in austria and europe) with Samsung Galaxy 22FE and 10 Mobileinternet-Cards (each 20GB for austria and europe)",
    "user": {
      "username": "Mr. Basche",
      "userrole": "Purchase Manager",
      "phoneNumber": "+436641234567",
      "email": "basche@som.com",
      "roleAtCompany": "employee",
      "roleAtSom": "buyer",
      "company": {
        "name": "Samsung",
        "role": "buyer",
        "address": "Somewhere over the rainbow"
      }
    },
    "publishingDate": "20.11.2022",
    "expirationDate": "31.12.2022",
    "deliveryLocation": "Vienna",
    "numberofOffers": "3",
    "provider": {
      "location": "east austria",
      "companyType": "Dealer",
      "companySize": "unrestricted",
    },
    "attachments": "[]",
    "status": "draft",
    "offers": "",
  }
];
