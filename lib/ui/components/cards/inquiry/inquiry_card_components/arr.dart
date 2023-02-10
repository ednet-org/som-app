import 'serializable.dart';

class Arr<T> implements Serializable<T> {
  final String name;
  final T? value;

  const Arr({
    required this.name,
    required this.value,
  });

  @override
  String toJson() {
    return '$name: ${value.toString()}';
  }

  fromJson(dynamic json) {
    return json as T;
  }
}
