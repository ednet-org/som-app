import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseRealtime {
  static SupabaseClient? _client;

  static Future<void> initialize({
    required String url,
    required String anonKey,
  }) async {
    if (url.isEmpty || anonKey.isEmpty) {
      return;
    }
    await Supabase.initialize(
      url: url,
      anonKey: anonKey,
    );
    _client = Supabase.instance.client;
  }

  static bool get isAvailable => _client != null;

  static SupabaseClient? get client => _client;

  static void setAuth(String? accessToken) {
    if (_client == null) return;
    _client!.realtime.setAuth(accessToken ?? '');
  }

  static RealtimeChannel? subscribeToTables({
    required List<String> tables,
    required VoidCallback onChange,
    String schema = 'public',
    String? channelName,
  }) {
    final client = _client;
    if (client == null || tables.isEmpty) {
      return null;
    }
    final name = channelName ?? 'realtime-${tables.join('_')}';
    final channel = client.channel(name);
    for (final table in tables) {
      channel.onPostgresChanges(
        event: PostgresChangeEvent.all,
        schema: schema,
        table: table,
        callback: (_) => onChange(),
      );
    }
    channel.subscribe();
    return channel;
  }
}

class RealtimeRefreshHandle {
  RealtimeRefreshHandle(
    this._onRefresh, {
    this.debounce = const Duration(milliseconds: 350),
  });

  final VoidCallback _onRefresh;
  final Duration debounce;

  Timer? _timer;
  RealtimeChannel? _channel;

  void subscribe({
    required List<String> tables,
    String schema = 'public',
    String? channelName,
  }) {
    dispose();
    _channel = SupabaseRealtime.subscribeToTables(
      tables: tables,
      schema: schema,
      channelName: channelName,
      onChange: _scheduleRefresh,
    );
  }

  void _scheduleRefresh() {
    _timer?.cancel();
    _timer = Timer(debounce, _onRefresh);
  }

  void dispose() {
    _timer?.cancel();
    _timer = null;
    if (_channel != null) {
      _channel!.unsubscribe();
      _channel = null;
    }
  }
}
