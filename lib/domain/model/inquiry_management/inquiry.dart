import 'package:ednet_core/ednet_core.dart';
import 'package:som/main.dart';

import 'company.dart';
import 'inquiry_status.dart';
import 'offer_status.dart';
import 'offer.dart';
import 'provider_criteria.dart';
import 'user.dart';

List<Map<String, String>> rawMapKInquiries = [
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
    "offers": "[]"
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
    "attachments": "...",
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
    "attachments": "...",
    "status": "draft",
    "offers": "3"
  }
];

class Inquiry extends Entity {
  @override
  List<EntityCommand> commands = [];

  @override
  String description;

  @override
  String id;

  @override
  List<EntityEvent> interests;

  @override
  List<EntityPolicy> policies;

  @override
  List<String> tags;

  @override
  List<EntityEvent> topics;

  @override
// TODO: implement attributes
  List<EntityAttribute> get attributes => throw UnimplementedError();

  final String title;
  final String category;
  final String branch;
  final User buyer; // User that created the inquiry, should have role "buyer"
  final DateTime publishingDate;
  final DateTime? expirationDate;
  final String? deliveryLocation;
  final ProviderCriteria provider;
  final List<String> attachments;
  final InquiryStatus status;
  final List<Offer> offers;

  Inquiry(
    this.description,
    this.id, {
    required this.tags,
    required this.topics,
    required this.interests,
    required this.policies,
    required this.title,
    required this.category,
    required this.branch,
    required this.buyer,
    required this.publishingDate,
    this.expirationDate,
    this.deliveryLocation,
    required this.provider,
    required this.attachments,
    required this.status,
    required this.offers,
  });

  @override
  Map<String, dynamic> toJson() {
    // return merged local json with super json
    return {
      'description': description,
      'id': id,
      'tags': tags,
      'topics': topics,
      'interests': interests,
      'policies': policies,
      'attributes': attributes.map((e) => e.toJson()).toList(),
    };
  }

  get numberOfOffers => offers.length;

  @override
  getAttributeByName(String name) {
    // TODO: implement getAttributeByName
    throw UnimplementedError();
  }

  @override
  getAttributesByType(String type) {
    // TODO: implement getAttributesByType
    throw UnimplementedError();
  }

  @override
  getAttributesNames() {
    // TODO: implement getAttributesNames
    throw UnimplementedError();
  }

  @override
  getValueByName(String name) {
    // TODO: implement getValueByName
    throw UnimplementedError();
  }

  @override
  // TODO: implement name
  String get name => throw UnimplementedError();

  static Inquiry fromJson(Map<String, dynamic> json) {
    return Inquiry(
      json['description'],
      json['id'],
      tags: json['tags'],
      topics: json['topics'],
      interests: json['interests'],
      policies: json['policies'],
      title: json['title'],
      category: json['category'],
      branch: json['branch'],
      buyer: json['buyer'],
      publishingDate: json['publishingDate'],
      expirationDate: json['expirationDate'],
      deliveryLocation: json['deliveryLocation'],
      provider: json['provider'],
      attachments: json['attachments'],
      status: json['status'],
      offers: json['offers'],
    );
  }

  static Inquiry fromMapK(Map<String, String> map) {
    final User defaultUser = User(
      id: '',
      role: '',
      phoneNumber: '',
      company: Company(
        id: '1',
        name: 'SOM',
        role: '',
        address: '',
        employees: [],
      ),
      username: '',
      email: '',
    );

    final defaultProviderCriteria = ProviderCriteria(
      location: '',
      companyType: '',
      companySize: '',
    );

    final defaultInquiry = Inquiry(
      '',
      '',
      tags: [],
      topics: [],
      interests: [],
      policies: [],
      title: '',
      category: '',
      branch: '',
      buyer: defaultUser,
      publishingDate: DateTime.now(),
      expirationDate: DateTime.now(),
      deliveryLocation: '',
      provider: defaultProviderCriteria,
      attachments: [],
      status: InquiryStatus.DRAFT as InquiryStatus,
      offers: [],
    );

    final defaultOffer = Offer(
      id: '',
      price: 0,
      attachments: [],
      status: OfferStatus.DRAFT as OfferStatus,
      provider: defaultUser,
      inquiry: defaultInquiry,
      deliveryTime: '',
    );

    final defaultPolicy = EntityPolicy(
      id: '',
      name: 'Default Policy',
      type: '',
      version: '',
    );

    final defaultTopic = EntityEvent(
      id: '',
      name: 'Default Topic',
      type: '',
      version: '',
      topic: '',
      source: '',
      time: DateTime.now(),
      data: {},
    );

    final defaultInterest = EntityEvent(
      id: '',
      name: 'Default Interest',
      type: '',
      version: '',
      topic: '',
      source: '',
      time: DateTime.now(),
      data: {},
    );

    final defaultAttribute = EntityAttribute(
      name: 'age',
      type: 'int',
      value: 3,
    );

    return Inquiry(
      map['description']!,
      map['id']!,
      tags: map['tags'] != null ? map['tags']!.split(',') : ['it', 'monitor'],
      topics: map['topics'] != null
          ? parseJson(map['topics']!).map((e) => e as EntityEvent).toList()
          : [defaultTopic],
      interests: map['interests'] != null
          ? parseJson(map['interests']!).map((e) => e as EntityEvent).toList()
          : [defaultInterest],
      policies: map['policies'] != null
          ? parseJson(map['policies']!).map((e) => e as EntityPolicy).toList()
          : [defaultPolicy],
      title: map['title'] ?? '',
      category: map['category'] ?? '',
      branch: map['branch'] ?? '',
      buyer: map['buyer'] != null
          ? User.fromJson(parseJson(map['buyer']!))
          : defaultUser,
      publishingDate: map['publishingDate'] != null
          ? DateTime.parse(map['publishingDate']!)
          : DateTime.now(),
      expirationDate: map['expirationDate'] != null
          ? DateTime.parse(map['expirationDate']!)
          : null,
      deliveryLocation: map['deliveryLocation'] ?? '',
      provider: map['provider'] != null
          ? ProviderCriteria.fromJson(parseJson(map['provider']!))
          : defaultProviderCriteria,
      attachments: [],
      status: map['status'] as InquiryStatus,
      offers: map['offers'] != null && (map['offers'] as List).isNotEmpty
          ? parseJson(map['offers']!).map((e) => e as Offer).toList()
          : [defaultOffer],
    );
  }
}
