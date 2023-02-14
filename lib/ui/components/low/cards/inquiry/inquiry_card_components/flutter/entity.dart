abstract class Entity<Attribute> {
  Iterable<Attribute> getFilterableAttributes();

  Iterable<Attribute> getSummaryAttributes();

  Iterable<Attribute> getDocumentAttributes();

  get status;
}
