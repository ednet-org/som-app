import 'package:flutter/material.dart';
import 'package:openapi/openapi.dart';
import 'package:provider/provider.dart';
import 'package:som/ui/theme/som_assets.dart';

import '../../domain/model/layout/app_body.dart';
import '../../widgets/app_toolbar.dart';
import '../../widgets/empty_state.dart';

class AuditAppBody extends StatefulWidget {
  const AuditAppBody({Key? key}) : super(key: key);

  @override
  State<AuditAppBody> createState() => _AuditAppBodyState();
}

class _AuditAppBodyState extends State<AuditAppBody> {
  Future<List<AuditLogEntry>>? _future;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _future ??= _loadLogs();
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
          return const AppBody(
            contextMenu: Text('Audit'),
            leftSplit: Center(child: CircularProgressIndicator()),
            rightSplit: SizedBox.shrink(),
          );
        }
        if (snapshot.hasError) {
          return AppBody(
            contextMenu: const Text('Audit'),
            leftSplit: Center(
              child: Text('Failed to load audit log: ${snapshot.error}'),
            ),
            rightSplit: const SizedBox.shrink(),
          );
        }
        final items = snapshot.data ?? const [];
        return AppBody(
          contextMenu: AppToolbar(
            title: const Text('Audit Log'),
            actions: [
              TextButton(
                onPressed: () => setState(() => _future = _loadLogs()),
                child: const Text('Refresh'),
              ),
            ],
          ),
          leftSplit: items.isEmpty
              ? const EmptyState(
                  asset: SomAssets.emptySearchResults,
                  title: 'No audit entries',
                  message: 'Activity will appear here as changes occur',
                )
              : ListView.separated(
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final entry = items[index];
                    final action = entry.action ?? 'unknown';
                    final entity = entry.entityType ?? '-';
                    final entityId = entry.entityId ?? '-';
                    final actor = entry.actorId ?? 'system';
                    final createdAt = entry.createdAt?.toLocal().toString() ?? '';
                    return ListTile(
                      title: Text(action),
                      subtitle: Text('$entity • $entityId\n$createdAt'),
                      trailing: Text(actor),
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
