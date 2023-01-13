import 'dart:convert';

import 'package:ednet_core/ednet_core.dart';
import 'package:intl/intl.dart';
import 'package:som/main.dart';

import 'company.dart';
import 'inquiry_status.dart';
import 'offer_status.dart';
import 'offer.dart';
import 'provider_criteria.dart';
import 'user.dart';

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
  final int offers;

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
      tags: json['tags'] != null ? List<String>.from(json['tags']) : [],
      topics: json['topics'] != null
          ? List<EntityEvent>.from(
              json['topics'].map((e) => EntityEvent.fromJson(e)))
          : [],
      interests: json['interests'] != null
          ? List<EntityEvent>.from(
              json['interests'].map((e) => EntityEvent.fromJson(e)))
          : [],
      policies: json['policies'] != null
          ? List<EntityPolicy>.from(
              json['policies'].map((e) => EntityPolicy.fromJson(e)))
          : [],
      title: json['title'] ?? '',
      category: json['category'] ?? '',
      branch: json['branch'] ?? '',
      buyer: json['buyer'] != null
          ? User.fromJson(json['buyer'])
          : User(
              id: '1',
              userphonenumber: '',
              company: Company(
                id: '1',
                name: 'SOM',
                role: '',
                address: '',
                employees: [],
              ),
              username: '',
              usermail: '',
              userrole: '',
            ),
      publishingDate: json['publishingDate'] != null
          ? DateFormat('dd.MM.yyyy').parse(json['publishingDate'])
          : DateTime.now(),
      expirationDate: json['expirationDate'] != null
          ? DateFormat('dd.MM.yyyy').parse(json['expirationDate'])
          : null,
      deliveryLocation: json['deliveryLocation'] ?? '',
      provider: json['provider'] != null
          ? ProviderCriteria.fromJson(json['provider'])
          : ProviderCriteria(
              location: '',
              companyType: '',
              companySize: '',
            ),
      attachments: json['attachments'] != null
          ? List<String>.from(jsonDecode(json['attachments']))
          : [],
      status: InquiryStatus.values
          .firstWhere((e) => e.toString() == 'InquiryStatus.' + json['status']),
      offers: int.parse(json['offers'] ?? 0),
    );
  }

  static Inquiry fromMapK(Map<String, String> map) {
    final User defaultUser = User(
      id: '',
      userphonenumber: '',
      company: Company(
        id: '1',
        name: 'SOM',
        role: '',
        address: '',
        employees: [],
      ),
      username: '',
      usermail: '',
      userrole: '',
    );

    final defaultProviderCriteria = ProviderCriteria(
      location: '',
      companyType: '',
      companySize: '',
    );

    final defaultInquiry = Inquiry('', '',
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
        status: InquiryStatus.draft,
        offers: 2);

    final defaultOffer = Offer(
      id: '',
      price: 0,
      attachments: [],
      status: OfferStatus.draft,
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
