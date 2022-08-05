import 'package:json_annotation/json_annotation.dart';

part 'authentication_response_dto.g.dart';

@JsonSerializable()
class AuthenticationResponseDto {
  final String token;
  final String refreshToken;

  AuthenticationResponseDto({
    required this.token,
    required this.refreshToken,
  });

  Map<String, dynamic> toJson() => _$AuthenticationResponseDtoToJson(this);
  static const fromJsonFactory = _$AuthenticationResponseDtoFromJson;
}
