import 'package:chopper/chopper.dart';
import 'package:som/domain/infrastructure/repository/api/import/models/people/people.dart';

part 'people_service.chopper.dart';

@ChopperApi(baseUrl: "/people")
abstract class PeopleService extends ChopperService {
  static PeopleService create([ChopperClient? client]) =>
      _$PeopleService(client);

  @Get(path: "/{person_id}")
  Future<Response<People>> getPerson(
    @Path('person_id') String personId,
  );
}
