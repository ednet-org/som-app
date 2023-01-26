import 'dart:typed_data';

class Attachment {
  final String name;
  final String type;

  // bytes of PDF or other document binary data
  final Uint8List? data;

  const Attachment({
    required this.name,
    required this.type,
    this.data,
  });

  static Attachment fromJson(Map<String, dynamic> json) {
    return Attachment(
      name: json['name'],
      type: json['type'],
      data: json['data'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'type': type,
      'data': data.toString(),
    };
  }
}
