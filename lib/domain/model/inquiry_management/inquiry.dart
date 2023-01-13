import 'package:ednet_core/ednet_core.dart';

import 'inquiry_status.dart';
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
}
