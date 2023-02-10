abstract class Serializable<T> {
  String toJson();

  static fromJson<T>(dynamic json) {
    return json as T;
  }
}
