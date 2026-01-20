class TestEnv {
  static const apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://127.0.0.1:8081',
  );
  static const outboxPath = String.fromEnvironment(
    'OUTBOX_PATH',
    defaultValue: '',
  );
  static const systemAdminEmail = String.fromEnvironment(
    'SYSTEM_ADMIN_EMAIL',
    defaultValue: 'system-admin@som.local',
  );
  static const systemAdminPassword = String.fromEnvironment(
    'SYSTEM_ADMIN_PASSWORD',
    defaultValue: 'ChangeMe123!',
  );
  static const devFixturesPassword = String.fromEnvironment(
    'DEV_FIXTURES_PASSWORD',
    defaultValue: 'DevPass123!',
  );
  static const consultantEmail = String.fromEnvironment(
    'CONSULTANT_EMAIL',
    defaultValue: 'consultant@som.local',
  );
  static const consultantAdminEmail = String.fromEnvironment(
    'CONSULTANT_ADMIN_EMAIL',
    defaultValue: 'consultant-admin@som.local',
  );
  static const buyerAdminEmail = String.fromEnvironment(
    'BUYER_ADMIN_EMAIL',
    defaultValue: 'buyer-admin@som.local',
  );
  static const providerAdminEmail = String.fromEnvironment(
    'PROVIDER_ADMIN_EMAIL',
    defaultValue: 'provider-admin@som.local',
  );
}
