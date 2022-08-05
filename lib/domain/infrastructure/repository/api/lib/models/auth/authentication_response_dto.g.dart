// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'authentication_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthenticationResponseDto _$AuthenticationResponseDtoFromJson(
        Map<String, dynamic> json) =>
    AuthenticationResponseDto(
      token: json['token'] as String,
      refreshToken: json['refreshToken'] as String,
    );

Map<String, dynamic> _$AuthenticationResponseDtoToJson(
        AuthenticationResponseDto instance) =>
    <String, dynamic>{
      'token': instance.token,
      'refreshToken': instance.refreshToken,
    };
