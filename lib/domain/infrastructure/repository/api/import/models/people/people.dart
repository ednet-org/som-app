import 'package:json_annotation/json_annotation.dart';
import 'package:som/domain/infrastructure/repository/api/import/models/entity.dart';

part 'people.g.dart';

@JsonSerializable()
class People extends Entity {
  final String name;
  final int age;
  final String gender;

  People(
    String type,
    String id, {
    required this.name,
    required this.age,
    required this.gender,
  }) : super(type, id);

  Map<String, dynamic> toJson() => _$PeopleToJson(this);

  static const fromJsonFactory = _$PeopleFromJson;
}
