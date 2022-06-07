import 'package:chopper/chopper.dart';
import 'package:http/http.dart' as http;
import 'package:som/domain/infrastructure/repository/api/utils/converters/json_serializable_converter.dart';

class ChopperClientBuilder {
  static ChopperClient buildChopperClient(List<ChopperService> services,
          [http.BaseClient? httpClient]) =>
      ChopperClient(
        client: httpClient,
        baseUrl: 'myBaseUrl',
        services: services,
        // converter: JsonSerializableConverter(),
      );
}
