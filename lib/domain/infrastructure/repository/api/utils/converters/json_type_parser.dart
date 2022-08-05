import 'package:som/domain/infrastructure/repository/api/lib/models/auth/authentication_response_dto.dart';
import 'package:som/domain/infrastructure/repository/api/lib/models/domain/company_dto.dart';
import 'package:som/domain/infrastructure/repository/api/lib/models/subscription.dart';
import 'package:som/domain/infrastructure/repository/api/utils/converters/exceptions.dart';

typedef JsonFactory<T> = T Function(Map<String, dynamic> json);

class JsonTypeParser {
  static const Map<Type, JsonFactory> factories = {
    Subscription: Subscription.fromJsonFactory,
    AuthenticationResponseDto: AuthenticationResponseDto.fromJsonFactory,
    Company: Company.fromJsonFactory,
    // People: People.fromJsonFactory,
  };

  static dynamic decode<T>(dynamic entity) {
    if (entity is Iterable) return _decodeList<T>(entity);

    if (entity is Map<String, dynamic>) return _decodeMap<T>(entity);

    return entity;
  }

  static T _decodeMap<T>(Map<String, dynamic> values) {
    final jsonFactory = factories[T];
    if (jsonFactory == null || jsonFactory is! JsonFactory<T>) {
      /// throw serializer not found error;
      throw JsonFactoryNotFoundException(T.toString());
    }

    return jsonFactory(values);
  }

  static List<T> _decodeList<T>(Iterable values) => values
      .where((dynamic v) => v != null)
      .map((dynamic v) => decode<T>(v) as T)
      .toList();
}
