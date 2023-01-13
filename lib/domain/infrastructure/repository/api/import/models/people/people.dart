import 'package:ednet_core/ednet_core.dart';
import 'package:uuid/uuid.dart';

class People extends Entity {
  final int? age;
  final String? gender;

  // People(
  //   String type,
  //   String id, {
  //   required this.name,
  //   required this.age,
  //   required this.gender,
  // });

  @override
  List<EntityCommand> commands = [];

  @override
  String description = 'Generated news Article';

  @override
  String id = const Uuid().v4();

  @override
  List<EntityEvent> interests = [];

  @override
  List<EntityPolicy> policies = [];

  @override
  List<String> tags = [];

  @override
  List<EntityEvent> topics = [];

  @override
  // TODO: implement attributes
  List<EntityAttribute> get attributes => throw UnimplementedError();

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

  @override
  toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'tags': tags.join(','),
      'attributes': attributes.map((e) => e.toJson()).toList(),
      'commands': commands.map((e) => e.toJson()).toList(),
      'topics': topics.map((e) => e.toJson()).toList(),
      'interests': interests.map((e) => e.toJson()).toList(),
      'policies': policies.map((e) => e.toJson()).toList(),
    };
  }

  static fromJson(Map<String, dynamic> json) {
    return People(
      json['id'],
      json['name'],
      json['age'],
      json['gender'],
      json['description'],
      json['tags'].split(','),
      json['attributes'].map((e) => EntityAttribute.fromJson(e)).toList(),
      json['commands'].map((e) => EntityCommand.fromJson(e)).toList(),
      json['topics'].map((e) => EntityEvent.fromJson(e)).toList(),
      json['interests'].map((e) => EntityEvent.fromJson(e)).toList(),
      json['policies'].map((e) => EntityPolicy.fromJson(e)).toList(),
    );
  }

  People(
    this.id,
    String name,
    this.description,
    this.tags,
    List<EntityAttribute> attributes,
    this.commands,
    this.topics,
    this.interests,
    this.policies,
    this.age,
    this.gender,
  );

  @override
  // TODO: implement status
  get status => throw UnimplementedError();
}
