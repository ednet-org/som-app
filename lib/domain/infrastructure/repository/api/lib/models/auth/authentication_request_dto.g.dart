// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'authentication_request_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthenticateRequestDto _$AuthenticateRequestDtoFromJson(
  Map<String, dynamic> json,
) => AuthenticateRequestDto(
  email: json['email'] as String,
  password: json['password'] as String,
);

Map<String, dynamic> _$AuthenticateRequestDtoToJson(
  AuthenticateRequestDto instance,
) => <String, dynamic>{'email': instance.email, 'password': instance.password};
