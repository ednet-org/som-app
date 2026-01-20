import 'package:test/test.dart';

import 'package:som_api/services/email_templates.dart';

void main() {
  group('EmailTemplateService', () {
    test('renders templates with variables', () {
      final templates = EmailTemplateService();
      final rendered = templates.render(
        EmailTemplateId.userRegistration,
        locale: 'en',
        variables: {'activationUrl': 'https://app.test/activate'},
      );
      expect(rendered.subject, contains('SOM'));
      expect(rendered.text, contains('https://app.test/activate'));
      expect(rendered.html, contains('https://app.test/activate'));
    });

    test('falls back to English for unknown locale', () {
      final templates = EmailTemplateService();
      final rendered = templates.render(
        EmailTemplateId.userWelcome,
        locale: 'fr',
        variables: {'appBaseUrl': 'https://app.test'},
      );
      expect(rendered.subject, contains('SOM'));
      expect(rendered.text, contains('https://app.test'));
    });
  });
}
