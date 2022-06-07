import 'package:json_annotation/json_annotation.dart';
import 'package:som/domain/infrastructure/repository/api/import/models/entity.dart';

part 'article.g.dart';

@JsonSerializable()
class Article extends Entity {
  final String title;
  final String body;

  Article(
    String type,
    String id, {
    required this.title,
    required this.body,
  }) : super(type, id);

  Map<String, dynamic> toJson() => _$ArticleToJson(this);

  static const fromJsonFactory = _$ArticleFromJson;
}
