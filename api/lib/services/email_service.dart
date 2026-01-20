import 'dart:convert';
import 'dart:io';

import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:path/path.dart' as p;

import 'email_templates.dart';

const _defaultFromAddress =
    String.fromEnvironment('EMAIL_FROM', defaultValue: 'no-reply@som.local');
const _defaultFromName =
    String.fromEnvironment('EMAIL_FROM_NAME', defaultValue: 'SOM');
const _defaultLocale =
    String.fromEnvironment('EMAIL_DEFAULT_LOCALE', defaultValue: 'en');

enum EmailProviderType { outbox, smtp, sendgrid }

class EmailMessage {
  EmailMessage({
    required this.to,
    required this.subject,
    required this.text,
    this.html,
    required this.sentAt,
    required this.fromAddress,
    this.fromName,
  });

  final String to;
  final String subject;
  final String text;
  final String? html;
  final DateTime sentAt;
  final String fromAddress;
  final String? fromName;

  Map<String, dynamic> toJson() => {
        'to': to,
        'subject': subject,
        'text': text,
        'html': html,
        'sentAt': sentAt.toIso8601String(),
        'fromAddress': fromAddress,
        'fromName': fromName,
      };
}

abstract class EmailProvider {
  Future<void> send(EmailMessage message);
}

class OutboxEmailProvider implements EmailProvider {
  OutboxEmailProvider({String? outboxPath})
      : _outboxPath = outboxPath ?? _defaultOutboxPath();

  final String _outboxPath;

  static String _defaultOutboxPath() {
    final base = Directory.current.path;
    return p.join(base, 'storage', 'outbox');
  }

  @override
  Future<void> send(EmailMessage message) async {
    final outboxDir = Directory(_outboxPath);
    if (!outboxDir.existsSync()) {
      outboxDir.createSync(recursive: true);
    }
    final fileName =
        '${DateTime.now().toUtc().millisecondsSinceEpoch}_${message.to.replaceAll('@', '_')}.json';
    final file = File(p.join(outboxDir.path, fileName));
    await file.writeAsString(jsonEncode(message.toJson()));
  }
}

class SmtpConfig {
  const SmtpConfig({
    required this.host,
    required this.port,
    this.username,
    this.password,
    this.useTls = false,
    this.allowInsecure = false,
  });

  final String host;
  final int port;
  final String? username;
  final String? password;
  final bool useTls;
  final bool allowInsecure;
}

class SmtpEmailProvider implements EmailProvider {
  SmtpEmailProvider({
    required this.config,
  }) : _server = SmtpServer(
          config.host,
          port: config.port,
          username: config.username,
          password: config.password,
          ssl: config.useTls,
          allowInsecure: config.allowInsecure,
        );

  final SmtpConfig config;
  final SmtpServer _server;

  @override
  Future<void> send(EmailMessage message) async {
    final mail = Message()
      ..from = Address(message.fromAddress, message.fromName)
      ..recipients.add(message.to)
      ..subject = message.subject
      ..text = message.text
      ..html = message.html;
    await send(mail, _server);
  }
}

class SendGridConfig {
  const SendGridConfig({required this.apiKey});

  final String apiKey;
}

class SendGridEmailProvider implements EmailProvider {
  SendGridEmailProvider({required this.config});

  final SendGridConfig config;
  final HttpClient _client = HttpClient();

  @override
  Future<void> send(EmailMessage message) async {
    final payload = {
      'personalizations': [
        {
          'to': [
            {'email': message.to}
          ]
        }
      ],
      'from': {
        'email': message.fromAddress,
        if (message.fromName != null) 'name': message.fromName,
      },
      'subject': message.subject,
      'content': [
        {'type': 'text/plain', 'value': message.text},
        if (message.html != null)
          {'type': 'text/html', 'value': message.html},
      ],
    };
    final request =
        await _client.postUrl(Uri.parse('https://api.sendgrid.com/v3/mail/send'));
    request.headers.set('Authorization', 'Bearer ${config.apiKey}');
    request.headers.contentType = ContentType.json;
    request.write(jsonEncode(payload));
    final response = await request.close();
    if (response.statusCode >= 400) {
      final body = await response.transform(utf8.decoder).join();
      throw StateError('SendGrid error: ${response.statusCode} $body');
    }
  }
}

class EmailServiceConfig {
  EmailServiceConfig({
    required this.providerType,
    required this.fromAddress,
    this.fromName,
    this.defaultLocale = 'en',
    this.outboxPath,
    this.smtp,
    this.sendGrid,
  });

  factory EmailServiceConfig.fromEnvironment() {
    final provider = _parseProvider(
      const String.fromEnvironment('EMAIL_PROVIDER', defaultValue: 'outbox'),
    );
    final fromAddress = const String.fromEnvironment(
      'EMAIL_FROM',
      defaultValue: 'no-reply@som.local',
    );
    final fromName = const String.fromEnvironment('EMAIL_FROM_NAME',
        defaultValue: 'SOM');
    final defaultLocale = const String.fromEnvironment(
      'EMAIL_DEFAULT_LOCALE',
      defaultValue: 'en',
    );
    final outboxPath =
        const String.fromEnvironment('EMAIL_OUTBOX_PATH', defaultValue: '');

    if (provider == EmailProviderType.smtp) {
      final host = const String.fromEnvironment('SMTP_HOST',
          defaultValue: 'inbucket');
      final port = int.tryParse(
              const String.fromEnvironment('SMTP_PORT', defaultValue: '2500')) ??
          2500;
      final username =
          const String.fromEnvironment('SMTP_USERNAME', defaultValue: '');
      final password =
          const String.fromEnvironment('SMTP_PASSWORD', defaultValue: '');
      final useTls =
          const bool.fromEnvironment('SMTP_USE_TLS', defaultValue: false);
      final allowInsecure = const bool.fromEnvironment(
        'SMTP_ALLOW_INSECURE',
        defaultValue: false,
      );
      return EmailServiceConfig(
        providerType: provider,
        fromAddress: fromAddress,
        fromName: fromName,
        defaultLocale: defaultLocale,
        smtp: SmtpConfig(
          host: host,
          port: port,
          username: username.isEmpty ? null : username,
          password: password.isEmpty ? null : password,
          useTls: useTls,
          allowInsecure: allowInsecure,
        ),
      );
    }

    if (provider == EmailProviderType.sendgrid) {
      final apiKey =
          const String.fromEnvironment('SENDGRID_API_KEY', defaultValue: '');
      if (apiKey.isEmpty) {
        throw StateError('SENDGRID_API_KEY is required for SendGrid provider.');
      }
      return EmailServiceConfig(
        providerType: provider,
        fromAddress: fromAddress,
        fromName: fromName,
        defaultLocale: defaultLocale,
        sendGrid: SendGridConfig(apiKey: apiKey),
      );
    }

    return EmailServiceConfig(
      providerType: EmailProviderType.outbox,
      fromAddress: fromAddress,
      fromName: fromName,
      defaultLocale: defaultLocale,
      outboxPath: outboxPath.isEmpty ? null : outboxPath,
    );
  }

  final EmailProviderType providerType;
  final String fromAddress;
  final String? fromName;
  final String defaultLocale;
  final String? outboxPath;
  final SmtpConfig? smtp;
  final SendGridConfig? sendGrid;
}

class EmailService {
  EmailService({
    EmailProvider? provider,
    EmailTemplateService? templates,
    String? fromAddress,
    String? fromName,
    String? defaultLocale,
    String? outboxPath,
  })  : _provider = provider ?? OutboxEmailProvider(outboxPath: outboxPath),
        providerType = _inferProviderType(provider),
        _templates = templates ?? EmailTemplateService(),
        fromAddress = fromAddress ?? _defaultFromAddress,
        fromName = fromName ?? _defaultFromName,
        defaultLocale = defaultLocale ?? _defaultLocale;

  factory EmailService.fromConfig(
    EmailServiceConfig config, {
    EmailTemplateService? templates,
  }) {
    final provider = _buildProvider(config);
    return EmailService(
      provider: provider,
      templates: templates,
      fromAddress: config.fromAddress,
      fromName: config.fromName,
      defaultLocale: config.defaultLocale,
      outboxPath: config.outboxPath,
    );
  }

  factory EmailService.fromEnvironment() {
    final config = EmailServiceConfig.fromEnvironment();
    return EmailService.fromConfig(config);
  }

  final EmailProvider _provider;
  final EmailTemplateService _templates;
  final String fromAddress;
  final String? fromName;
  final String defaultLocale;
  final EmailProviderType providerType;

  Future<void> send({
    required String to,
    required String subject,
    required String text,
    String? html,
  }) async {
    final message = EmailMessage(
      to: to,
      subject: subject,
      text: text,
      html: html,
      sentAt: DateTime.now().toUtc(),
      fromAddress: fromAddress,
      fromName: fromName,
    );
    await _provider.send(message);
  }

  Future<void> sendTemplate({
    required String to,
    required String templateId,
    Map<String, String> variables = const {},
    String? locale,
  }) async {
    final rendered = _templates.render(
      templateId,
      locale: locale ?? defaultLocale,
      variables: variables,
    );
    await send(
      to: to,
      subject: rendered.subject,
      text: rendered.text,
      html: rendered.html,
    );
  }
}

EmailProvider _buildProvider(EmailServiceConfig config) {
  switch (config.providerType) {
    case EmailProviderType.smtp:
      final smtp = config.smtp;
      if (smtp == null) {
        throw StateError('SMTP configuration is required.');
      }
      return SmtpEmailProvider(config: smtp);
    case EmailProviderType.sendgrid:
      final sendGrid = config.sendGrid;
      if (sendGrid == null) {
        throw StateError('SendGrid configuration is required.');
      }
      return SendGridEmailProvider(config: sendGrid);
    case EmailProviderType.outbox:
    default:
      return OutboxEmailProvider(outboxPath: config.outboxPath);
  }
}

EmailProviderType _inferProviderType(EmailProvider? provider) {
  if (provider is SmtpEmailProvider) {
    return EmailProviderType.smtp;
  }
  if (provider is SendGridEmailProvider) {
    return EmailProviderType.sendgrid;
  }
  return EmailProviderType.outbox;
}

EmailProviderType _parseProvider(String value) {
  final normalized = value.trim().toLowerCase();
  switch (normalized) {
    case 'smtp':
      return EmailProviderType.smtp;
    case 'sendgrid':
      return EmailProviderType.sendgrid;
    case 'outbox':
    default:
      return EmailProviderType.outbox;
  }
}
