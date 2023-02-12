abstract class IRepository<Entity> {
  Future<List<Entity>> getAll();
}
