import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:openapi/openapi.dart';
import 'package:provider/provider.dart';

import '../../domain/model/layout/app_body.dart';

class AuditAppBody extends StatefulWidget {
  const AuditAppBody({Key? key}) : super(key: key);

  @override
  State<AuditAppBody> createState() => _AuditAppBodyState();
}

class _AuditAppBodyState extends State<AuditAppBody> {
  Future<List<Map<String, dynamic>>>? _future;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _future ??= _loadLogs();
  }

  Future<List<Map<String, dynamic>>> _loadLogs() async {
    final api = Provider.of<Openapi>(context, listen: false);
    final response = await api.dio.get('/audit', queryParameters: {'limit': 200});
    final data = response.data as List<dynamic>;
    return data
        .whereType<Map<String, dynamic>>()
        .map((entry) => Map<String, dynamic>.from(entry))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
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
        final items = snapshot.data ?? [];
        return AppBody(
          contextMenu: Row(
            children: [
              const Text('Audit Log'),
              const SizedBox(width: 12),
              TextButton(
                onPressed: () => setState(() => _future = _loadLogs()),
                child: const Text('Refresh'),
              ),
            ],
          ),
          leftSplit: ListView.separated(
            itemCount: items.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final entry = items[index];
              final action = entry['action']?.toString() ?? 'unknown';
              final entity = entry['entityType']?.toString() ?? '-';
              final entityId = entry['entityId']?.toString() ?? '-';
              final actor = entry['actorId']?.toString() ?? 'system';
              final createdAt = entry['createdAt']?.toString() ?? '';
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
