import 'package:test/test.dart';

import 'package:som_api/services/email_service.dart';
import 'package:som_api/services/email_templates.dart';

class FakeEmailProvider implements EmailProvider {
  final List<EmailMessage> sent = [];

  @override
  Future<void> send(EmailMessage message) async {
    sent.add(message);
  }
}

void main() {
  group('EmailService', () {
    test('selects outbox provider from config', () {
      final config = EmailServiceConfig(
        providerType: EmailProviderType.outbox,
        fromAddress: 'no-reply@som.test',
        outboxPath: 'storage/test_outbox',
      );
      final service = EmailService.fromConfig(config);
      expect(service.providerType, EmailProviderType.outbox);
    });

    test('selects smtp provider from config', () {
      final config = EmailServiceConfig(
        providerType: EmailProviderType.smtp,
        fromAddress: 'no-reply@som.test',
        smtp: const SmtpConfig(
          host: 'smtp.test',
          port: 25,
        ),
      );
      final service = EmailService.fromConfig(config);
      expect(service.providerType, EmailProviderType.smtp);
    });

    test('sendTemplate renders template content', () async {
      final provider = FakeEmailProvider();
      final templates = EmailTemplateService();
      final service = EmailService(
        provider: provider,
        templates: templates,
        fromAddress: 'no-reply@som.test',
      );
      await service.sendTemplate(
        to: 'user@som.test',
        templateId: EmailTemplateId.userWelcome,
        variables: {'appBaseUrl': 'https://app.test'},
      );
      expect(provider.sent, hasLength(1));
      expect(provider.sent.first.text, contains('https://app.test'));
    });
  });
}
