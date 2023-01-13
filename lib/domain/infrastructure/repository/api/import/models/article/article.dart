import 'package:ednet_core/ednet_core.dart';
import 'package:uuid/uuid.dart';

class Article extends Entity {
  String? title;
  String? body;

  // Article(
  //   String type,
  //   String id, {
  //   required this.title,
  //   required this.body,
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
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'tags': tags,
      'attributes': attributes,
      'commands': commands,
      'topics': topics,
      'interests': interests,
      'policies': policies,
    };
  }

  fromJsonFactory(Map<String, dynamic> json) {
    return Article(
      id: json['id'],
      description: json['description'],
      tags: json['tags'],
      commands: json['commands'],
      topics: json['topics'],
      interests: json['interests'],
      policies: json['policies'],
    );
  }

  Article({
    required this.id,
    required this.description,
    required this.tags,
    required this.commands,
    required this.topics,
    required this.interests,
    required this.policies,
  });

  @override
  // TODO: implement status
  get status => throw UnimplementedError();
}
