import 'package:flutter/material.dart';
import 'package:openapi/openapi.dart';
import 'package:provider/provider.dart';
import 'package:som/ui/theme/som_assets.dart';

import '../../domain/application/application.dart';
import '../../domain/infrastructure/supabase_realtime.dart';
import '../../domain/model/layout/app_body.dart';
import '../../theme/tokens.dart';
import '../../utils/formatters.dart';
import '../../widgets/app_toolbar.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/inline_message.dart';
import '../../widgets/meta_text.dart';
import '../../widgets/som_list_tile.dart';

class AuditAppBody extends StatefulWidget {
  const AuditAppBody({super.key});

  @override
  State<AuditAppBody> createState() => _AuditAppBodyState();
}

class _AuditAppBodyState extends State<AuditAppBody> {
  Future<List<AuditLogEntry>>? _future;
  bool _realtimeReady = false;
  late final RealtimeRefreshHandle _realtimeRefresh =
      RealtimeRefreshHandle(_handleRealtimeRefresh);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _future ??= _loadLogs();
    _setupRealtime();
  }

  @override
  void dispose() {
    _realtimeRefresh.dispose();
    super.dispose();
  }

  void _handleRealtimeRefresh() {
    if (!mounted) return;
    setState(() => _future = _loadLogs());
  }

  void _setupRealtime() {
    if (_realtimeReady) return;
    final appStore = Provider.of<Application>(context, listen: false);
    SupabaseRealtime.setAuth(appStore.authorization?.token);
    _realtimeRefresh.subscribe(
      tables: const ['audit_log'],
      channelName: 'audit-log',
    );
    _realtimeReady = true;
  }

  Future<List<AuditLogEntry>> _loadLogs() async {
    final api = Provider.of<Openapi>(context, listen: false);
    final response = await api.getAuditApi().auditGet(limit: 200);
    return response.data?.toList() ?? const [];
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<AuditLogEntry>>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return AppBody(
            contextMenu: AppToolbar(title: const Text('Audit Log')),
            leftSplit: const Center(child: CircularProgressIndicator()),
            rightSplit: const SizedBox.shrink(),
          );
        }
        if (snapshot.hasError) {
          return AppBody(
            contextMenu: AppToolbar(title: const Text('Audit Log')),
            leftSplit: Center(
              child: InlineMessage(
                message: 'Failed to load audit log: ${snapshot.error}',
                type: InlineMessageType.error,
              ),
            ),
            rightSplit: const SizedBox.shrink(),
          );
        }
        final items = snapshot.data ?? const [];
        return AppBody(
          contextMenu: AppToolbar(
            title: const Text('Audit Log'),
            actions: const [],
          ),
          leftSplit: items.isEmpty
              ? const EmptyState(
                  asset: SomAssets.emptySearchResults,
                  title: 'No audit entries',
                  message: 'Activity will appear here as changes occur',
                )
              : ListView.separated(
                  itemCount: items.length,
                  separatorBuilder: (context, index) =>
                      const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final entry = items[index];
                    final action = entry.action ?? 'unknown';
                    final entity = entry.entityType ?? '-';
                    final entityId = SomFormatters.shortId(entry.entityId);
                    final actor = entry.actorId ?? 'system';
                    final createdAt =
                        SomFormatters.dateTime(entry.createdAt);
                    return SomListTile(
                      title: Text(action),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('$entity • $entityId'),
                          const SizedBox(height: SomSpacing.xs),
                          SomMetaText(createdAt),
                        ],
                      ),
                      trailing: SomMetaText(actor),
                      isThreeLine: true,
                    );
                  },
                ),
          rightSplit: const SizedBox.shrink(),
        );
      },
    );
  }
}
