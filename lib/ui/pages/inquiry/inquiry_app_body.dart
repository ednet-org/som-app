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
        style: Theme.of(context).textTheme.titleSmall,
      ),
      leftSplit: LayoutBuilder(builder: (buildContext, constraints) {
        final isMobile = constraints.maxWidth < 600;

        return GridView.builder(
          padding: const EdgeInsets.all(10.0),
          itemCount: inquiries.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: isMobile ? 1 : 3,
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10.0),
          itemBuilder: (BuildContext context, int index) {
            final inquiry = Inquiry.fromJson(inquiries[index]);
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
        );
      }),
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
    "description": '''


Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec lacus libero, tempor quis odio ut, laoreet auctor metus. Nam eu congue urna, consequat ornare augue. Proin sed accumsan mi, ultrices tristique ex. Aliquam ultricies, risus id viverra semper, elit lectus mollis erat, eu interdum mauris leo id quam. Praesent porta eleifend sagittis. Nam elementum tempus nunc in vestibulum. Vivamus aliquet, sapien sit amet lobortis cursus, leo neque rutrum dui, in consequat velit erat id dui. Morbi tincidunt turpis a magna hendrerit, at venenatis orci efficitur. Quisque sollicitudin ornare posuere. Suspendisse sit amet nisl at magna vehicula suscipit ut sed quam. Vivamus at vestibulum arcu. Donec aliquam rutrum mauris, et sagittis orci euismod nec. Lorem ipsum dolor sit amet, consectetur adipiscing elit. In hac habitasse platea dictumst.

Proin nec venenatis ipsum. Pellentesque iaculis nulla non dolor dictum blandit. Sed vel risus sed eros vulputate euismod. Cras gravida pulvinar dui, quis tempus velit vulputate eu. Duis egestas quam nec tempor feugiat. Sed hendrerit dolor at neque mollis, eget bibendum magna tempus. Vivamus mattis felis nunc, sit amet euismod leo tempor non. Phasellus sollicitudin, sem euismod pretium fermentum, tellus tellus lacinia leo, et efficitur nunc dui quis risus. Etiam laoreet commodo risus a accumsan. Praesent vitae neque tincidunt, suscipit erat id, rutrum libero. Sed aliquam faucibus sagittis. Sed lobortis est ornare urna ullamcorper, sodales cursus sem cursus. Curabitur tristique semper sapien ut volutpat. Proin porttitor condimentum ex in maximus. Sed sed efficitur purus.

Aenean eros mi, auctor nec varius in, tempor sit amet urna. Donec leo nibh, laoreet sed sapien nec, luctus tempus felis. Sed augue urna, fermentum non libero sed, faucibus pretium risus. Sed quis nisl ut libero pulvinar iaculis elementum non libero. Aliquam vitae ante lacus. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Praesent vitae quam volutpat, sodales arcu nec, congue sapien. Vivamus sed volutpat nisl. Vestibulum posuere risus massa, vel feugiat lectus sagittis in. Donec sodales dignissim diam sed vehicula.

Nam hendrerit arcu neque, nec gravida massa condimentum eget. Etiam eget dui eu ligula vehicula convallis. Vivamus auctor luctus ex a mollis. Quisque id metus sit amet quam viverra ultrices at non dui. Nulla facilisi. Cras eu iaculis ligula, et pulvinar massa. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Donec sit amet dui placerat, luctus neque non, finibus ante.

In vel consectetur leo. Proin finibus tortor eros, sit amet viverra tortor ornare non. Phasellus id risus dolor. Curabitur ultricies magna et mattis auctor. Curabitur placerat odio ac nulla mattis molestie. Cras aliquam mi vitae dui semper, vitae laoreet felis laoreet. Pellentesque cursus cursus vulputate. Vivamus fringilla ipsum sed arcu ornare, et interdum mauris lobortis. Vivamus malesuada augue et dui scelerisque, sit amet tristique orci consequat. In nibh diam, facilisis sit amet fringilla pretium, molestie blandit risus. Morbi quam elit, gravida eget feugiat sit amet, ullamcorper nec leo. Nunc sodales dictum nulla in finibus. In auctor in ex vel fermentum. 
    ''',
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
        "New Office Printers with FollowMe Solution; We need 4 A3 Colour Office Printers for about 10k A4 printouts per Month. Besides that the printers must have minimum two Paperbanks and one Printer a Bookletfinisher. We want an offer for rental and purchase variation.New Office Printers with FollowMe Solution; We need 4 A3 Colour Office Printers for about 10k A4 printouts per Month. Besides that the printers must have minimum two Paperbanks and one Printer a Bookletfinisher. We want an offer for rental and purchase variation.New Office Printers with FollowMe Solution; We need 4 A3 Colour Office Printers for about 10k A4 printouts per Month. Besides that the printers must have minimum two Paperbanks and one Printer a Bookletfinisher. We want an offer for rental and purchase variation.",
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
    "status": "expired",
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
