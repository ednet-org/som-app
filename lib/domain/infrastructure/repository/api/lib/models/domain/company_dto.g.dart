// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'company_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Company _$CompanyFromJson(Map<String, dynamic> json) => Company(
      json['id'] as String,
      name: json['name'] as String?,
      registrationNr: json['registrationNr'] as String?,
      companySize: json['companySize'] as int?,
      type: json['type'] as int?,
      websiteUrl: json['websiteUrl'] as String?,
    );

Map<String, dynamic> _$CompanyToJson(Company instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'registrationNr': instance.registrationNr,
      'companySize': instance.companySize,
      'type': instance.type,
      'websiteUrl': instance.websiteUrl,
    };
