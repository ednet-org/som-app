import 'package:flutter/material.dart';
import 'package:som/ui/components/cards/entity_card.dart';
import 'package:som/ui/components/cards/grida_inquiry_info_card.dart';
import 'package:som/ui/components/cards/inquiry_info_card.dart';

// import 'package:som/ui/components/cards/inquiry_info_card.dart';
import 'package:som/ui/components/layout/app_body.dart';

import '../../../domain/model/inquiry_management/inquiry.dart';
import '../../components/cards/inquiry_to_card_mapping.dart';

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
        itemCount: 4,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, crossAxisSpacing: 4.0, mainAxisSpacing: 4.0),
        itemBuilder: (BuildContext context, int index) {
          var modulo = index % 3;
          switch (modulo) {
            case 0:
              return InquiryInfoCard(inquiry: inquiries[index]);
            case 1:
              return GridaInquiryInfoCard(
                  inquiry: Inquiry.fromJson(inquiries[index]));
            case 2:
              return EntityCard(
                item: Inquiry.fromJson(inquiries[index]),
                mapping: const InquiryToCardMapping(),
              );
            default:
              return Container();
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

List<Map<String, String>> inquiries = [
  {
    "id": "1",
    "title": "Laptops for new Dev team - Blue oranges",
    "description": "describe me...",
    "category": "IT",
    "branch": "Laptops",
    "username": "Mr. Basche",
    "userrole": "IT Manager",
    "userphonenumber": "+436641234567",
    "usermail": "basche@som.com",
    "publishingDate": "14.11.2022",
    "expirationDate": "01.12.2022",
    "deliverylocation": "Vienna",
    "numberofOffers": "3",
    "providerlocation": "east austria",
    "providercompanytype": "Dealer",
    "providercompanysize": "no restriction",
    "attachments": "Items and amounts",
    "status": "draft",
    "offers": "3"
  },
  {
    "id": "1",
    "title": "Office Printer",
    "category": "Printing",
    "branch": "Multifunction Printers",
    "description":
        "New Office Printers with FollowMe Solution; We need 4 A3 Colour Office Printers for about 10k A4 printouts per Month. Besides that the printers must have minimum two Paperbanks and one Printer a Bookletfinisher. We want an offer for rental and purchase variation.",
    "username": "Mr. Basche",
    "userrole": "IT Manager",
    "userphonenumber": "+436641234567",
    "usermail": "basche@som.com",
    "publishingDate": "20.11.2022",
    "expirationDate": "31.12.2022",
    "deliverylocation": "Vienna",
    "numberofOffers": "3",
    "providerlocation": "Austria",
    "providercompanytype": "Dealer",
    "providercompanysize": "up to 50 empoyees",
    "attachments": "[]",
    "status": "published",
    "offers": "5"
  },
  {
    "id": "2",
    "title": "Notebooks",
    "category": "Clients",
    "branch": "IT",
    "description": "6x 15“ Notebook; Specifications attached",
    "username": "Mr. Basche",
    "userrole": "IT Manager",
    "userphonenumber": "+436641234567",
    "usermail": "basche@som.com",
    "publishingDate": "20.11.2022",
    "expirationDate": "31.12.2022",
    "deliverylocation": "Graz",
    "numberofOffers": "5",
    "providerlocation": "Austria",
    "providercompanytype": "Dealer",
    "providercompanysize": "no restriction",
    "attachments": "[]",
    "status": "responded",
    "offers": "3"
  },
  {
    "id": "3",
    "title":
        "25 Phonenumbers with Samsung Smartphones and 10 mobile internet for tablets",
    "category": "Mobilephone, mobileinternet",
    "branch": "Telecommunication",
    "description":
        "We need 25 Mobilephonemubers (flat minutes in austria, flat minutes in europe and each number with 10GB internet in austria and europe) with Samsung Galaxy 22FE and 10 Mobileinternet-Cards (each 20GB for austria and europe)",
    "username": "Mr. Basche",
    "userrole": "Purchase Manager",
    "userphonenumber": "+436641234567",
    "usermail": "basche@som.com",
    "publishingDate": "20.11.2022",
    "expirationDate": "31.12.2022",
    "deliverylocation": "Vienna",
    "numberofOffers": "3",
    "providerlocation": "east austria",
    "providercompanytype": "Dealer",
    "providercompanysize": "no restriction",
    "attachments": "[]",
    "status": "draft",
    "offers": "3"
  }
];

//= {location, companyType,companySize};

// can be draft, published, responded, closed

//
// List<Inquiry> parsedInquiries = inquiries.map((inquiry) {
//   Company buyer = Company(
//       name: inquiry["username"] ?? "" ?? "",
//       role: CompanyRole.BUYER,
//       employees: [
//         User(
//             username: inquiry["username"] ?? "" ?? "",
//             role: UserRole.EMPLOYEE,
//             email: inquiry["usermail"] ?? "" ?? "",
//             phoneNumber: inquiry["userphonenumber"] ?? "" ?? "",
//             company: Company(
//                 name: inquiry["username"] ?? "" ?? "",
//                 id: '1',
//                 role: CompanyRole.BUYER,
//                 address: 'address',
//                 employees: []),
//             id: '1')
//       ],
//       id: '1',
//       address: 'Vienna');
//
//   List<Offer> offers = [];
//
//   if (inquiry["offers"] != null && inquiry["offers"] != "[]") {
//     offers = inquiry["offers"].map((offer) {
//       return Offer(
//           id: offer["id"] ?? "",
//           inquiry: Inquiry(
//               id: inquiry["id"] ?? "",
//               title: inquiry["title"] ?? "",
//               description: inquiry["description"] ?? "",
//               category: inquiry["category"] ?? "",
//               branch: inquiry["branch"] ?? "",
//               buyer: user,
//               publishingDate: DateTime.parse(inquiry["publishingDate"] ?? ""),
//               expirationDate: DateTime.parse(inquiry["expirationDate"] ?? ""),
//               deliveryLocation: inquiry["deliverylocation"] ?? "",
//               provider: ProviderCriteria(
//                   location: inquiry["providerlocation"] ?? "",
//                   companyType: inquiry["providercompanytype"] ?? "",
//                   companySize: inquiry["providercompanysize"] ?? ""),
//               attachments: [],
//               status: InquiryStatus.fromString(inquiry["status"] ?? 'draft'),
//               offers: []),
//           provider: User(
//               username: offer["username"] ?? "" ?? "",
//               role: UserRole.EMPLOYEE,
//               email: offer["usermail"] ?? "" ?? "",
//               phoneNumber: offer["userphonenumber"] ?? "" ?? "",
//               company: Company(
//                   name: offer["username"] ?? "" ?? "",
//                   id: '1',
//                   role: CompanyRole.BUYER,
//                   address: 'address',
//                   employees: []),
//               id: '1'),
//           price: offer["price"] ?? "",
//           deliveryTime: offer["deliveryTime"] ?? "",
//           warranty: offer["warranty"] ?? "",
//           attachments: offer["attachments"] ?? "",
//           status: offer["status"] ?? "");
//       )
//     }).toList();
//   }
//   return Inquiry(
//     id: inquiry["id"] ?? "",
//     title: inquiry["title"] ?? "",
//     description: inquiry["description"] ?? "",
//     category: inquiry["category"] ?? "",
//     branch: inquiry["branch"] ?? "",
//     buyer: buyer,
//     publishingDate: DateTime.parse(inquiry["publishingDate"] ?? ""),
//     expirationDate: DateTime.parse(inquiry["expirationDate"] ?? ""),
//     deliveryLocation: inquiry["deliverylocation"] ?? "",
//     numberOfOffers: int.parse(inquiry["numberofOffers"] ?? ""),
//     providerLocation: inquiry["providerlocation"] ?? "",
//     providerCompanyType: inquiry["providercompanytype"] ?? "",
//     providerCompanySize: inquiry["providercompanysize"] ?? "",
//     attachments: inquiry["attachments"] ?? "",
//     status: InquiryStatus.fromString(inquiry["status"] ?? ""),
//     offers: offers,
//   );
// }).toList();
final inquiry = Inquiry.fromMapK(inquiries[0]);
