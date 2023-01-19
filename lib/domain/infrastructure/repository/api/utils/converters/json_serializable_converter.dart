import 'package:chopper/chopper.dart';
import 'package:som/domain/infrastructure/repository/api/utils/converters/response_error.dart';

import 'json_type_parser.dart';

class JsonSerializableConverter extends JsonConverter {
  const JsonSerializableConverter();

  @override
  Response<BodyType> convertResponse<BodyType, InnerType>(
    Response<dynamic> response,
  ) {
    final dynamic body = response.body;
    final dynamic error = response.error;

    if (body is BodyType) {
      return response.copyWith<BodyType>(body: body);
    } else if (body is Map<String, dynamic>) {
      if (BodyType == dynamic) {
        return response.copyWith<BodyType>(body: body as BodyType);
      } else if (BodyType == ResponseError) {
        return response.copyWith<BodyType>(
          body: ResponseError.fromJsonFactory(body) as BodyType,
        );
      } else {
        return response.copyWith<BodyType>(
          body: JsonTypeParser.decode<BodyType>(body) as BodyType,
        );
      }
    } else if (error is InnerType) {
      return response.copyWith<BodyType>(bodyError: error);
    } else if (error is Map<String, dynamic>) {
      if (InnerType == dynamic) {
        return response.copyWith<BodyType>(bodyError: error as InnerType);
      } else if (InnerType == ResponseError) {
        return response.copyWith<BodyType>(
          bodyError: ResponseError.fromJsonFactory(error) as InnerType,
        );
      } else {
        return response.copyWith<BodyType>(
          bodyError: JsonTypeParser.decode<InnerType>(error) as InnerType,
        );
      }
    } else {
      throw FormatException(
        'The type of the data received (${body.runtimeType}) is not the '
        'same as the expected type ($BodyType).',
      );
    }
  }
}

@override
Request convertRequest(Request request) {
  final dynamic body = request.body;

  if (body is Map<String, dynamic>) {
    return request.copyWith(body: body);
  } else {
    return request;
  }
}
