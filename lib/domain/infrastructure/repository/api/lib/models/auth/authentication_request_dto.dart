import 'package:json_annotation/json_annotation.dart';

part 'authentication_request_dto.g.dart';

@JsonSerializable()
class AuthenticateRequestDto {
  final String email;
  final String password;

  AuthenticateRequestDto({required this.email, required this.password});

  Map<String, dynamic> toJson() => _$AuthenticateRequestDtoToJson(this);
  final fromJsonFactory = _$AuthenticateRequestDtoFromJson;
}
