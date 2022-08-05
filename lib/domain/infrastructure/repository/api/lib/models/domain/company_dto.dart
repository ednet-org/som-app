import 'package:json_annotation/json_annotation.dart';
import 'package:som/domain/infrastructure/repository/api/lib/models/api_entity.dart';

part 'company_dto.g.dart';

@JsonSerializable()
class Company extends ApiEntity {
  String? name;
  String? registrationNr;
  int? companySize;
  int? type;
  String? websiteUrl;

  Company(String id,
      {this.name,
      this.registrationNr,
      this.companySize,
      this.type,
      this.websiteUrl})
      : super(id);

  Map<String, dynamic> toJson() => _$CompanyToJson(this);
  static const fromJsonFactory = _$CompanyFromJson;
}
