import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;

class EmailMessage {
  EmailMessage({
    required this.to,
    required this.subject,
    required this.text,
    this.html,
    required this.sentAt,
  });

  final String to;
  final String subject;
  final String text;
  final String? html;
  final DateTime sentAt;

  Map<String, dynamic> toJson() => {
        'to': to,
        'subject': subject,
        'text': text,
        'html': html,
        'sentAt': sentAt.toIso8601String(),
      };
}

class EmailService {
  EmailService({String? outboxPath})
      : _outboxPath = outboxPath ?? _defaultOutboxPath();

  final String _outboxPath;

  static String _defaultOutboxPath() {
    final base = Directory.current.path;
    return p.join(base, 'storage', 'outbox');
  }

  Future<void> send({
    required String to,
    required String subject,
    required String text,
    String? html,
  }) async {
    final outboxDir = Directory(_outboxPath);
    if (!outboxDir.existsSync()) {
      outboxDir.createSync(recursive: true);
    }
    final message = EmailMessage(
      to: to,
      subject: subject,
      text: text,
      html: html,
      sentAt: DateTime.now().toUtc(),
    );
    final fileName =
        '${DateTime.now().toUtc().millisecondsSinceEpoch}_${to.replaceAll('@', '_')}.json';
    final file = File(p.join(outboxDir.path, fileName));
    await file.writeAsString(jsonEncode(message.toJson()));
  }
}
