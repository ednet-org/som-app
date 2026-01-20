import 'package:supabase/supabase.dart';

class SupabaseService {
  SupabaseService({
    required this.adminClient,
    required this.anonClient,
    required this.jwtSecret,
    required this.storageBucket,
  });

  factory SupabaseService.fromEnvironment() {
    const url = String.fromEnvironment('SUPABASE_URL');
    const anonKey = String.fromEnvironment('SUPABASE_ANON_KEY');
    const serviceRoleKey = String.fromEnvironment('SUPABASE_SERVICE_ROLE_KEY');
    const jwtSecret = String.fromEnvironment('SUPABASE_JWT_SECRET');
    const schema = String.fromEnvironment(
      'SUPABASE_SCHEMA',
      defaultValue: 'som',
    );
    const storageBucket = String.fromEnvironment(
      'SUPABASE_STORAGE_BUCKET',
      defaultValue: 'som-assets',
    );
    if (url.isEmpty ||
        anonKey.isEmpty ||
        serviceRoleKey.isEmpty ||
        jwtSecret.isEmpty) {
      throw StateError('Supabase environment variables are missing.');
    }
    const postgrestOptions = PostgrestClientOptions(schema: schema);
    return SupabaseService(
      adminClient: SupabaseClient(
        url,
        serviceRoleKey,
        postgrestOptions: postgrestOptions,
      ),
      anonClient: SupabaseClient(
        url,
        anonKey,
        postgrestOptions: postgrestOptions,
      ),
      jwtSecret: jwtSecret,
      storageBucket: storageBucket,
    );
  }

  final SupabaseClient adminClient;
  final SupabaseClient anonClient;
  final String jwtSecret;
  final String storageBucket;
}
