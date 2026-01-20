class EmailTemplateId {
  static const userRegistration = 'user.registration';
  static const userWelcome = 'user.welcome';
  static const userPasswordReset = 'user.password_reset';
  static const userPasswordChanged = 'user.password_changed';
  static const userRegistrationExpiring = 'user.registration_expiring';
  static const adminUserRegistrationExpiring = 'admin.user.registration_expiring';
  static const companyRegistered = 'company.registered';
  static const companyUpdated = 'company.updated';
  static const companyActivated = 'company.activated';
  static const companyDeactivated = 'company.deactivated';
  static const companyActivatedAdmin = 'company.activated.admin';
  static const companyDeactivatedAdmin = 'company.deactivated.admin';
  static const userRemoved = 'user.removed';
  static const userRemovedAdmin = 'user.removed.admin';
  static const inquiryAssigned = 'inquiry.assigned';
  static const inquiryDeadlineReminder = 'inquiry.deadline_reminder';
  static const inquiryOffersReady = 'inquiry.offers_ready';
  static const offerAccepted = 'offer.accepted';
  static const offerRejected = 'offer.rejected';
  static const adCreated = 'ad.created';
  static const adActivated = 'ad.activated';
  static const adExpired = 'ad.expired';
  static const providerApproved = 'provider.approved';
  static const providerDeclined = 'provider.declined';
  static const subscriptionCancellationRequested =
      'subscription.cancellation.requested';
  static const subscriptionCancellationUpdated =
      'subscription.cancellation.updated';
  static const billingCreated = 'billing.created';
  static const branchUpdated = 'branch.updated';
  static const branchDeleted = 'branch.deleted';
  static const categoryUpdated = 'category.updated';
  static const categoryDeleted = 'category.deleted';
}

class EmailTemplate {
  const EmailTemplate({
    required this.subject,
    required this.text,
    required this.html,
  });

  final String subject;
  final String text;
  final String html;
}

class EmailTemplateRender {
  EmailTemplateRender({
    required this.subject,
    required this.text,
    required this.html,
  });

  final String subject;
  final String text;
  final String html;
}

class EmailTemplateService {
  EmailTemplateService({this.defaultLocale = 'en'});

  final String defaultLocale;

  EmailTemplateRender render(
    String templateId, {
    String? locale,
    Map<String, String> variables = const {},
  }) {
    final requestedLocale = locale ?? defaultLocale;
    final templates = _templates[requestedLocale] ??
        _templates[defaultLocale] ??
        _templates['en'];
    if (templates == null) {
      throw StateError('No email templates configured.');
    }
    final template =
        templates[templateId] ?? _templates['en']?[templateId];
    if (template == null) {
      throw StateError('Missing email template: $templateId');
    }
    return EmailTemplateRender(
      subject: _applyVariables(template.subject, variables),
      text: _applyVariables(template.text, variables),
      html: _applyVariables(template.html, variables),
    );
  }

  String _applyVariables(String template, Map<String, String> variables) {
    var result = template;
    variables.forEach((key, value) {
      result = result.replaceAll('{{$key}}', value);
    });
    return result;
  }
}

const Map<String, Map<String, EmailTemplate>> _templates = {
  'en': {
    EmailTemplateId.userRegistration: EmailTemplate(
      subject: 'Complete your SOM registration',
      text: 'Activate your account: {{activationUrl}}',
      html:
          '<p>Activate your account:</p><p><a href="{{activationUrl}}">Complete registration</a></p>',
    ),
    EmailTemplateId.userWelcome: EmailTemplate(
      subject: 'Welcome to SOM',
      text: 'Your account is now active. Sign in: {{appBaseUrl}}',
      html:
          '<p>Your account is now active.</p><p><a href="{{appBaseUrl}}">Sign in</a></p>',
    ),
    EmailTemplateId.userPasswordReset: EmailTemplate(
      subject: 'Reset your SOM password',
      text: 'Use this link to reset your password: {{resetUrl}}',
      html:
          '<p>Reset your password:</p><p><a href="{{resetUrl}}">Reset password</a></p>',
    ),
    EmailTemplateId.userPasswordChanged: EmailTemplate(
      subject: 'Your SOM password was changed',
      text:
          'Your password was changed. If this was not you, contact support immediately.',
      html:
          '<p>Your password was changed.</p><p>If this was not you, contact support immediately.</p>',
    ),
    EmailTemplateId.userRegistrationExpiring: EmailTemplate(
      subject: 'Your SOM registration link is expiring soon',
      text:
          'Your registration link will expire on {{expiresAt}}. Please complete your registration.',
      html:
          '<p>Your registration link will expire on {{expiresAt}}.</p><p>Please complete your registration.</p>',
    ),
    EmailTemplateId.adminUserRegistrationExpiring: EmailTemplate(
      subject: 'User registration link expiring',
      text:
          'User {{userEmail}} has a registration link expiring on {{expiresAt}}.',
      html:
          '<p>User {{userEmail}} has a registration link expiring on {{expiresAt}}.</p>',
    ),
    EmailTemplateId.companyRegistered: EmailTemplate(
      subject: 'New company registered',
      text: 'Company {{companyName}} has registered on SOM.',
      html: '<p>Company {{companyName}} has registered on SOM.</p>',
    ),
    EmailTemplateId.companyUpdated: EmailTemplate(
      subject: 'Company updated',
      text: 'Company {{companyName}} has updated its profile.',
      html: '<p>Company {{companyName}} has updated its profile.</p>',
    ),
    EmailTemplateId.companyActivated: EmailTemplate(
      subject: 'Company activated',
      text: 'Company {{companyName}} has been activated.',
      html: '<p>Company {{companyName}} has been activated.</p>',
    ),
    EmailTemplateId.companyDeactivated: EmailTemplate(
      subject: 'Company deactivated',
      text: 'Company {{companyName}} has been deactivated.',
      html: '<p>Company {{companyName}} has been deactivated.</p>',
    ),
    EmailTemplateId.companyActivatedAdmin: EmailTemplate(
      subject: 'Company activated',
      text: 'Your company {{companyName}} has been activated.',
      html: '<p>Your company {{companyName}} has been activated.</p>',
    ),
    EmailTemplateId.companyDeactivatedAdmin: EmailTemplate(
      subject: 'Company deactivated',
      text: 'Your company {{companyName}} has been deactivated.',
      html: '<p>Your company {{companyName}} has been deactivated.</p>',
    ),
    EmailTemplateId.userRemoved: EmailTemplate(
      subject: 'You have been removed from {{companyName}}',
      text:
          'Your account has been removed from {{companyName}}. Please contact support if this was unexpected.',
      html:
          '<p>Your account has been removed from {{companyName}}.</p><p>Please contact support if this was unexpected.</p>',
    ),
    EmailTemplateId.userRemovedAdmin: EmailTemplate(
      subject: 'User removed from company',
      text:
          'User {{userEmail}} was removed from {{companyName}} by {{removedByEmail}}.',
      html:
          '<p>User {{userEmail}} was removed from {{companyName}} by {{removedByEmail}}.</p>',
    ),
    EmailTemplateId.inquiryAssigned: EmailTemplate(
      subject: 'New inquiry assigned',
      text:
          'A new inquiry has been assigned to your company.\nInquiry ID: {{inquiryId}}\nDeadline: {{deadline}}\nView: {{link}}',
      html:
          '<p>A new inquiry has been assigned to your company.</p><p>Inquiry ID: {{inquiryId}}<br/>Deadline: {{deadline}}</p><p><a href="{{link}}">View inquiry</a></p>',
    ),
    EmailTemplateId.inquiryDeadlineReminder: EmailTemplate(
      subject: 'Inquiry deadline approaching',
      text:
          'The inquiry {{inquiryId}} is due on {{deadline}}.\nPlease submit your offer before the deadline.\nView: {{link}}',
      html:
          '<p>The inquiry {{inquiryId}} is due on {{deadline}}.</p><p>Please submit your offer before the deadline.</p><p><a href="{{link}}">View inquiry</a></p>',
    ),
    EmailTemplateId.inquiryOffersReady: EmailTemplate(
      subject: 'New offers for your inquiry',
      text: 'Inquiry {{inquiryId}}: {{reason}}\nView offers: {{link}}',
      html:
          '<p>Inquiry {{inquiryId}}: {{reason}}</p><p><a href="{{link}}">View offers</a></p>',
    ),
    EmailTemplateId.offerAccepted: EmailTemplate(
      subject: 'Offer accepted',
      text:
          'Offer {{offerId}} has been accepted.\nBuyer contact:\nCompany: {{companyName}}\nName: {{contactName}}\nPhone: {{contactPhone}}\nEmail: {{contactEmail}}',
      html:
          '<p>Offer {{offerId}} has been accepted.</p><p>Buyer contact:</p><p>Company: {{companyName}}<br/>Name: {{contactName}}<br/>Phone: {{contactPhone}}<br/>Email: {{contactEmail}}</p>',
    ),
    EmailTemplateId.offerRejected: EmailTemplate(
      subject: 'Offer rejected',
      text: 'Offer {{offerId}} has been rejected.',
      html: '<p>Offer {{offerId}} has been rejected.</p>',
    ),
    EmailTemplateId.adCreated: EmailTemplate(
      subject: 'New ad created',
      text: 'Company {{companyName}} created a new ad.\nReview: {{link}}',
      html:
          '<p>Company {{companyName}} created a new ad.</p><p><a href="{{link}}">Review ad</a></p>',
    ),
    EmailTemplateId.adActivated: EmailTemplate(
      subject: 'Ad activated',
      text: 'Company {{companyName}} activated an ad.\nReview: {{link}}',
      html:
          '<p>Company {{companyName}} activated an ad.</p><p><a href="{{link}}">Review ad</a></p>',
    ),
    EmailTemplateId.adExpired: EmailTemplate(
      subject: 'Your ad has expired',
      text: 'Ad {{adId}} has expired.\nReview: {{link}}',
      html:
          '<p>Ad {{adId}} has expired.</p><p><a href="{{link}}">Review ad</a></p>',
    ),
    EmailTemplateId.providerApproved: EmailTemplate(
      subject: 'Registration completed',
      text: 'Your provider registration is now active.',
      html: '<p>Your provider registration is now active.</p>',
    ),
    EmailTemplateId.providerDeclined: EmailTemplate(
      subject: 'Registration pending',
      text:
          'Your registration remains pending because the requested category was declined. {{reason}}',
      html:
          '<p>Your registration remains pending because the requested category was declined.</p><p>{{reason}}</p>',
    ),
    EmailTemplateId.subscriptionCancellationRequested: EmailTemplate(
      subject: 'Subscription cancellation request',
      text:
          'Company {{companyId}} requested cancellation. Request ID: {{cancellationId}}',
      html:
          '<p>Company {{companyId}} requested cancellation.</p><p>Request ID: {{cancellationId}}</p>',
    ),
    EmailTemplateId.subscriptionCancellationUpdated: EmailTemplate(
      subject: 'Subscription cancellation update',
      text: 'Your cancellation request {{cancellationId}} is now {{status}}.',
      html:
          '<p>Your cancellation request {{cancellationId}} is now {{status}}.</p>',
    ),
    EmailTemplateId.billingCreated: EmailTemplate(
      subject: 'New billing record',
      text: 'A new billing record ({{billingId}}) has been created.',
      html:
          '<p>A new billing record ({{billingId}}) has been created.</p>',
    ),
    EmailTemplateId.branchUpdated: EmailTemplate(
      subject: 'Branch updated',
      text:
          'Branch "{{oldName}}" has been renamed to "{{newName}}". Please review your provider profile.',
      html:
          '<p>Branch "{{oldName}}" has been renamed to "{{newName}}".</p><p>Please review your provider profile.</p>',
    ),
    EmailTemplateId.branchDeleted: EmailTemplate(
      subject: 'Branch removed',
      text:
          'Branch "{{name}}" has been removed. Please update your provider profile.',
      html:
          '<p>Branch "{{name}}" has been removed.</p><p>Please update your provider profile.</p>',
    ),
    EmailTemplateId.categoryUpdated: EmailTemplate(
      subject: 'Category updated',
      text:
          'Category "{{oldName}}" has been renamed to "{{newName}}". Please review your provider profile and inquiries.',
      html:
          '<p>Category "{{oldName}}" has been renamed to "{{newName}}".</p><p>Please review your provider profile and inquiries.</p>',
    ),
    EmailTemplateId.categoryDeleted: EmailTemplate(
      subject: 'Category removed',
      text:
          'Category "{{name}}" has been removed. Please review your provider profile.',
      html:
          '<p>Category "{{name}}" has been removed.</p><p>Please review your provider profile.</p>',
    ),
  },
  'de': {
    EmailTemplateId.userRegistration: EmailTemplate(
      subject: 'Schliessen Sie Ihre SOM Registrierung ab',
      text: 'Aktivieren Sie Ihr Konto: {{activationUrl}}',
      html:
          '<p>Aktivieren Sie Ihr Konto:</p><p><a href="{{activationUrl}}">Registrierung abschliessen</a></p>',
    ),
    EmailTemplateId.userWelcome: EmailTemplate(
      subject: 'Willkommen bei SOM',
      text: 'Ihr Konto ist jetzt aktiv. Anmeldung: {{appBaseUrl}}',
      html:
          '<p>Ihr Konto ist jetzt aktiv.</p><p><a href="{{appBaseUrl}}">Anmelden</a></p>',
    ),
    EmailTemplateId.userPasswordReset: EmailTemplate(
      subject: 'SOM Passwort zuruecksetzen',
      text: 'Link zum Zuruecksetzen: {{resetUrl}}',
      html:
          '<p>Passwort zuruecksetzen:</p><p><a href="{{resetUrl}}">Passwort zuruecksetzen</a></p>',
    ),
    EmailTemplateId.userPasswordChanged: EmailTemplate(
      subject: 'Ihr SOM Passwort wurde geaendert',
      text:
          'Ihr Passwort wurde geaendert. Wenn dies nicht Sie waren, kontaktieren Sie den Support.',
      html:
          '<p>Ihr Passwort wurde geaendert.</p><p>Wenn dies nicht Sie waren, kontaktieren Sie den Support.</p>',
    ),
    EmailTemplateId.userRegistrationExpiring: EmailTemplate(
      subject: 'Ihr SOM Registrierungslink laeuft bald ab',
      text:
          'Ihr Registrierungslink laeuft am {{expiresAt}} ab. Bitte schliessen Sie die Registrierung ab.',
      html:
          '<p>Ihr Registrierungslink laeuft am {{expiresAt}} ab.</p><p>Bitte schliessen Sie die Registrierung ab.</p>',
    ),
    EmailTemplateId.adminUserRegistrationExpiring: EmailTemplate(
      subject: 'Registrierungslink laeuft ab',
      text:
          'Benutzer {{userEmail}} hat einen Registrierungslink, der am {{expiresAt}} ablaeuft.',
      html:
          '<p>Benutzer {{userEmail}} hat einen Registrierungslink, der am {{expiresAt}} ablaeuft.</p>',
    ),
    EmailTemplateId.companyRegistered: EmailTemplate(
      subject: 'Neues Unternehmen registriert',
      text: 'Unternehmen {{companyName}} hat sich bei SOM registriert.',
      html: '<p>Unternehmen {{companyName}} hat sich bei SOM registriert.</p>',
    ),
    EmailTemplateId.companyUpdated: EmailTemplate(
      subject: 'Unternehmen aktualisiert',
      text: 'Unternehmen {{companyName}} hat sein Profil aktualisiert.',
      html: '<p>Unternehmen {{companyName}} hat sein Profil aktualisiert.</p>',
    ),
    EmailTemplateId.companyActivated: EmailTemplate(
      subject: 'Unternehmen aktiviert',
      text: 'Unternehmen {{companyName}} wurde aktiviert.',
      html: '<p>Unternehmen {{companyName}} wurde aktiviert.</p>',
    ),
    EmailTemplateId.companyDeactivated: EmailTemplate(
      subject: 'Unternehmen deaktiviert',
      text: 'Unternehmen {{companyName}} wurde deaktiviert.',
      html: '<p>Unternehmen {{companyName}} wurde deaktiviert.</p>',
    ),
    EmailTemplateId.companyActivatedAdmin: EmailTemplate(
      subject: 'Unternehmen aktiviert',
      text: 'Ihr Unternehmen {{companyName}} wurde aktiviert.',
      html: '<p>Ihr Unternehmen {{companyName}} wurde aktiviert.</p>',
    ),
    EmailTemplateId.companyDeactivatedAdmin: EmailTemplate(
      subject: 'Unternehmen deaktiviert',
      text: 'Ihr Unternehmen {{companyName}} wurde deaktiviert.',
      html: '<p>Ihr Unternehmen {{companyName}} wurde deaktiviert.</p>',
    ),
    EmailTemplateId.userRemoved: EmailTemplate(
      subject: 'Sie wurden aus {{companyName}} entfernt',
      text:
          'Ihr Konto wurde aus {{companyName}} entfernt. Bitte kontaktieren Sie den Support, falls dies unerwartet war.',
      html:
          '<p>Ihr Konto wurde aus {{companyName}} entfernt.</p><p>Bitte kontaktieren Sie den Support, falls dies unerwartet war.</p>',
    ),
    EmailTemplateId.userRemovedAdmin: EmailTemplate(
      subject: 'Benutzer aus Unternehmen entfernt',
      text:
          'Benutzer {{userEmail}} wurde aus {{companyName}} von {{removedByEmail}} entfernt.',
      html:
          '<p>Benutzer {{userEmail}} wurde aus {{companyName}} von {{removedByEmail}} entfernt.</p>',
    ),
    EmailTemplateId.inquiryAssigned: EmailTemplate(
      subject: 'Neue Anfrage zugewiesen',
      text:
          'Eine neue Anfrage wurde Ihrem Unternehmen zugewiesen.\nAnfrage ID: {{inquiryId}}\nFrist: {{deadline}}\nLink: {{link}}',
      html:
          '<p>Eine neue Anfrage wurde Ihrem Unternehmen zugewiesen.</p><p>Anfrage ID: {{inquiryId}}<br/>Frist: {{deadline}}</p><p><a href="{{link}}">Anfrage ansehen</a></p>',
    ),
    EmailTemplateId.inquiryDeadlineReminder: EmailTemplate(
      subject: 'Anfrage Frist naht',
      text:
          'Die Anfrage {{inquiryId}} ist faellig am {{deadline}}.\nBitte reichen Sie Ihr Angebot rechtzeitig ein.\nLink: {{link}}',
      html:
          '<p>Die Anfrage {{inquiryId}} ist faellig am {{deadline}}.</p><p>Bitte reichen Sie Ihr Angebot rechtzeitig ein.</p><p><a href="{{link}}">Anfrage ansehen</a></p>',
    ),
    EmailTemplateId.inquiryOffersReady: EmailTemplate(
      subject: 'Neue Angebote fuer Ihre Anfrage',
      text: 'Anfrage {{inquiryId}}: {{reason}}\nLink: {{link}}',
      html:
          '<p>Anfrage {{inquiryId}}: {{reason}}</p><p><a href="{{link}}">Angebote ansehen</a></p>',
    ),
    EmailTemplateId.offerAccepted: EmailTemplate(
      subject: 'Angebot angenommen',
      text:
          'Angebot {{offerId}} wurde angenommen.\nKontakt:\nFirma: {{companyName}}\nName: {{contactName}}\nTelefon: {{contactPhone}}\nEmail: {{contactEmail}}',
      html:
          '<p>Angebot {{offerId}} wurde angenommen.</p><p>Kontakt:</p><p>Firma: {{companyName}}<br/>Name: {{contactName}}<br/>Telefon: {{contactPhone}}<br/>Email: {{contactEmail}}</p>',
    ),
    EmailTemplateId.offerRejected: EmailTemplate(
      subject: 'Angebot abgelehnt',
      text: 'Angebot {{offerId}} wurde abgelehnt.',
      html: '<p>Angebot {{offerId}} wurde abgelehnt.</p>',
    ),
    EmailTemplateId.adCreated: EmailTemplate(
      subject: 'Neue Anzeige erstellt',
      text: 'Unternehmen {{companyName}} hat eine Anzeige erstellt.\nLink: {{link}}',
      html:
          '<p>Unternehmen {{companyName}} hat eine Anzeige erstellt.</p><p><a href="{{link}}">Anzeige ansehen</a></p>',
    ),
    EmailTemplateId.adActivated: EmailTemplate(
      subject: 'Anzeige aktiviert',
      text: 'Unternehmen {{companyName}} hat eine Anzeige aktiviert.\nLink: {{link}}',
      html:
          '<p>Unternehmen {{companyName}} hat eine Anzeige aktiviert.</p><p><a href="{{link}}">Anzeige ansehen</a></p>',
    ),
    EmailTemplateId.adExpired: EmailTemplate(
      subject: 'Ihre Anzeige ist abgelaufen',
      text: 'Anzeige {{adId}} ist abgelaufen.\nLink: {{link}}',
      html:
          '<p>Anzeige {{adId}} ist abgelaufen.</p><p><a href="{{link}}">Anzeige ansehen</a></p>',
    ),
    EmailTemplateId.providerApproved: EmailTemplate(
      subject: 'Registrierung abgeschlossen',
      text: 'Ihre Provider Registrierung ist jetzt aktiv.',
      html: '<p>Ihre Provider Registrierung ist jetzt aktiv.</p>',
    ),
    EmailTemplateId.providerDeclined: EmailTemplate(
      subject: 'Registrierung ausstehend',
      text:
          'Ihre Registrierung bleibt ausstehend, weil die gewuenschte Kategorie abgelehnt wurde. {{reason}}',
      html:
          '<p>Ihre Registrierung bleibt ausstehend, weil die gewuenschte Kategorie abgelehnt wurde.</p><p>{{reason}}</p>',
    ),
    EmailTemplateId.subscriptionCancellationRequested: EmailTemplate(
      subject: 'Kuendigung angefordert',
      text:
          'Unternehmen {{companyId}} hat eine Kuendigung angefordert. Anfrage ID: {{cancellationId}}',
      html:
          '<p>Unternehmen {{companyId}} hat eine Kuendigung angefordert.</p><p>Anfrage ID: {{cancellationId}}</p>',
    ),
    EmailTemplateId.subscriptionCancellationUpdated: EmailTemplate(
      subject: 'Kuendigung aktualisiert',
      text: 'Ihre Kuendigung {{cancellationId}} ist jetzt {{status}}.',
      html:
          '<p>Ihre Kuendigung {{cancellationId}} ist jetzt {{status}}.</p>',
    ),
    EmailTemplateId.billingCreated: EmailTemplate(
      subject: 'Neue Abrechnung',
      text: 'Eine neue Abrechnung ({{billingId}}) wurde erstellt.',
      html: '<p>Eine neue Abrechnung ({{billingId}}) wurde erstellt.</p>',
    ),
    EmailTemplateId.branchUpdated: EmailTemplate(
      subject: 'Branche aktualisiert',
      text:
          'Branche "{{oldName}}" wurde in "{{newName}}" umbenannt. Bitte pruefen Sie Ihr Provider Profil.',
      html:
          '<p>Branche "{{oldName}}" wurde in "{{newName}}" umbenannt.</p><p>Bitte pruefen Sie Ihr Provider Profil.</p>',
    ),
    EmailTemplateId.branchDeleted: EmailTemplate(
      subject: 'Branche entfernt',
      text:
          'Branche "{{name}}" wurde entfernt. Bitte aktualisieren Sie Ihr Provider Profil.',
      html:
          '<p>Branche "{{name}}" wurde entfernt.</p><p>Bitte aktualisieren Sie Ihr Provider Profil.</p>',
    ),
    EmailTemplateId.categoryUpdated: EmailTemplate(
      subject: 'Kategorie aktualisiert',
      text:
          'Kategorie "{{oldName}}" wurde in "{{newName}}" umbenannt. Bitte pruefen Sie Ihr Provider Profil und Ihre Anfragen.',
      html:
          '<p>Kategorie "{{oldName}}" wurde in "{{newName}}" umbenannt.</p><p>Bitte pruefen Sie Ihr Provider Profil und Ihre Anfragen.</p>',
    ),
    EmailTemplateId.categoryDeleted: EmailTemplate(
      subject: 'Kategorie entfernt',
      text:
          'Kategorie "{{name}}" wurde entfernt. Bitte pruefen Sie Ihr Provider Profil.',
      html:
          '<p>Kategorie "{{name}}" wurde entfernt.</p><p>Bitte pruefen Sie Ihr Provider Profil.</p>',
    ),
  },
};
