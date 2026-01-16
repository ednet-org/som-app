import 'package:flutter/material.dart';
import 'package:openapi/openapi.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../domain/application/application.dart';
import '../../domain/model/layout/app_body.dart';
import '../../widgets/app_toolbar.dart';
import '../../utils/ui_logger.dart';

const _apiBaseUrl = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: 'http://127.0.0.1:8081',
);

class StatisticsAppBody extends StatefulWidget {
  const StatisticsAppBody({Key? key}) : super(key: key);

  @override
  State<StatisticsAppBody> createState() => _StatisticsAppBodyState();
}

class _StatisticsAppBodyState extends State<StatisticsAppBody> {
  Future<_StatsResult>? _statsFuture;
  DateTime? _from;
  DateTime? _to;
  String? _userIdFilter;
  String _consultantType = 'status';
  List<UserDto> _companyUsers = const [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _statsFuture ??= _loadStats();
    _loadCompanyUsers();
  }

  Future<void> _loadCompanyUsers() async {
    final appStore = Provider.of<Application>(context, listen: false);
    if (appStore.authorization?.companyId == null) return;
    try {
      final api = Provider.of<Openapi>(context, listen: false);
      final response = await api.getUsersApi().companiesCompanyIdUsersGet(
            companyId: appStore.authorization!.companyId!,
            headers: _authHeader(appStore.authorization?.token),
          );
      setState(() {
        _companyUsers = response.data?.toList() ?? const [];
      });
    } catch (error, stackTrace) {
      UILogger.silentError('StatisticsAppBody._loadCompanyUsers', error, stackTrace);
    }
  }

  Future<_StatsResult> _loadStats() async {
    final api = Provider.of<Openapi>(context, listen: false);
    final appStore = Provider.of<Application>(context, listen: false);
    StatsBuyerGet200Response? buyer;
    StatsProviderGet200Response? provider;
    Map<String, int>? consultant;

    if (appStore.authorization?.isBuyer == true) {
      final response = await api.getStatsApi().statsBuyerGet(
            from: _from,
            to: _to,
            userId: _userIdFilter,
          );
      buyer = response.data;
    }
    if (appStore.authorization?.isProvider == true) {
      final response = await api.getStatsApi().statsProviderGet(
            from: _from,
            to: _to,
          );
      provider = response.data;
    }
    if (appStore.authorization?.isConsultant == true) {
      final response = await api.getStatsApi().statsConsultantGet(
            from: _from,
            to: _to,
            type: _consultantType,
          );
      consultant = response.data?.toMap() ?? const {};
    }
    return _StatsResult(buyer: buyer, provider: provider, consultant: consultant);
  }

  Future<void> _refresh() async {
    setState(() {
      _statsFuture = _loadStats();
    });
  }

  Future<void> _exportCsv() async {
    final appStore = Provider.of<Application>(context, listen: false);
    String path;
    final params = <String, String>{};
    if (_from != null) params['from'] = _from!.toIso8601String();
    if (_to != null) params['to'] = _to!.toIso8601String();
    if (appStore.authorization?.isBuyer == true) {
      path = '/stats/buyer';
      if (_userIdFilter != null) params['userId'] = _userIdFilter!;
    } else if (appStore.authorization?.isProvider == true) {
      path = '/stats/provider';
    } else {
      path = '/stats/consultant';
      params['type'] = _consultantType;
    }
    params['format'] = 'csv';
    final uri = Uri.parse(_apiBaseUrl)
        .replace(path: path, queryParameters: params);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final appStore = Provider.of<Application>(context);
    if (appStore.authorization == null) {
      return const AppBody(
        contextMenu: Text('Login required'),
        leftSplit: Center(child: Text('Please log in to view statistics.')),
        rightSplit: SizedBox.shrink(),
      );
    }

    return FutureBuilder<_StatsResult>(
      future: _statsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const AppBody(
            contextMenu: Text('Loading'),
            leftSplit: Center(child: CircularProgressIndicator()),
            rightSplit: SizedBox.shrink(),
          );
        }
        if (snapshot.hasError) {
          return AppBody(
            contextMenu: const Text('Error'),
            leftSplit: Center(
              child: Text('Failed to load stats: ${snapshot.error}'),
            ),
            rightSplit: const SizedBox.shrink(),
          );
        }
        final data = snapshot.data ?? _StatsResult();
        return AppBody(
          contextMenu: AppToolbar(
            title: const Text('Statistics'),
            actions: [
              TextButton(onPressed: _refresh, child: const Text('Refresh')),
              TextButton(onPressed: _exportCsv, child: const Text('Export CSV')),
            ],
          ),
          leftSplit: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildFilters(appStore),
              const SizedBox(height: 12),
              if (appStore.authorization?.isBuyer == true)
                _statsSection('Buyer stats', {
                  'Open': data.buyer?.open ?? 0,
                  'Closed': data.buyer?.closed ?? 0,
                }),
              if (appStore.authorization?.isProvider == true)
                _statsSection('Provider stats', {
                  'Open': data.provider?.open ?? 0,
                  'Offer created': data.provider?.offerCreated ?? 0,
                  'Lost': data.provider?.lost ?? 0,
                  'Won': data.provider?.won ?? 0,
                  'Ignored': data.provider?.ignored ?? 0,
                }),
              if (appStore.authorization?.isConsultant == true)
                _consultantChart(data.consultant ?? const {}),
            ],
          ),
          rightSplit: _buildSummary(appStore, data),
        );
      },
    );
  }

  Widget _buildFilters(Application appStore) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _datePickerButton(
              label: 'From',
              value: _from,
              onSelected: (value) => setState(() => _from = value),
            ),
            _datePickerButton(
              label: 'To',
              value: _to,
              onSelected: (value) => setState(() => _to = value),
            ),
            if (appStore.authorization?.isBuyer == true &&
                appStore.authorization?.isAdmin == true)
              DropdownButton<String>(
                hint: const Text('Editor'),
                value: _userIdFilter,
                items: _companyUsers
                    .map((user) => DropdownMenuItem(
                          value: user.id,
                          child: Text(user.email ?? user.id ?? '-'),
                        ))
                    .toList(),
                onChanged: (value) => setState(() => _userIdFilter = value),
              ),
            if (appStore.authorization?.isConsultant == true)
              DropdownButton<String>(
                value: _consultantType,
                items: const [
                  DropdownMenuItem(value: 'status', child: Text('Status')),
                  DropdownMenuItem(value: 'period', child: Text('Period')),
                  DropdownMenuItem(value: 'providerType', child: Text('Provider type')),
                  DropdownMenuItem(value: 'providerSize', child: Text('Provider size')),
                ],
                onChanged: (value) =>
                    setState(() => _consultantType = value ?? 'status'),
              ),
            TextButton(
              onPressed: () {
                setState(() {
                  _from = null;
                  _to = null;
                  _userIdFilter = null;
                  _consultantType = 'status';
                });
                _refresh();
              },
              child: const Text('Clear'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _datePickerButton({
    required String label,
    required DateTime? value,
    required ValueChanged<DateTime?> onSelected,
  }) {
    return TextButton(
      onPressed: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: value ?? DateTime.now(),
          firstDate: DateTime(2020),
          lastDate: DateTime(2100),
        );
        if (picked != null) {
          onSelected(picked);
        }
      },
      child: Text(value == null
          ? label
          : '$label: ${value.toIso8601String().split('T').first}'),
    );
  }

  Widget _statsSection(String title, Map<String, int> values) {
    final data = values.entries
        .map((entry) => _ChartPoint(entry.key, entry.value))
        .toList();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            SfCartesianChart(
              primaryXAxis: CategoryAxis(),
              series: <CartesianSeries<_ChartPoint, String>>[
                ColumnSeries<_ChartPoint, String>(
                  dataSource: data,
                  xValueMapper: (_ChartPoint point, _) => point.label,
                  yValueMapper: (_ChartPoint point, _) => point.value,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _consultantChart(Map<String, int> values) {
    final data = values.entries
        .map((entry) => _ChartPoint(entry.key, entry.value))
        .toList();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Consultant stats',
                style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            SfCartesianChart(
              primaryXAxis: CategoryAxis(),
              series: <CartesianSeries<_ChartPoint, String>>[
                ColumnSeries<_ChartPoint, String>(
                  dataSource: data,
                  xValueMapper: (_ChartPoint point, _) => point.label,
                  yValueMapper: (_ChartPoint point, _) => point.value,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummary(Application appStore, _StatsResult data) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView(
        children: [
          Text('Summary', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          if (appStore.authorization?.isBuyer == true)
            Text(
              'Buyer: open ${data.buyer?.open ?? 0}, closed ${data.buyer?.closed ?? 0}',
            ),
          if (appStore.authorization?.isProvider == true)
            Text(
              'Provider: open ${data.provider?.open ?? 0}, offers ${data.provider?.offerCreated ?? 0}',
            ),
          if (appStore.authorization?.isConsultant == true)
            Text('Consultant results: ${(data.consultant ?? {}).length} rows'),
        ],
      ),
    );
  }
}

class _StatsResult {
  final StatsBuyerGet200Response? buyer;
  final StatsProviderGet200Response? provider;
  final Map<String, int>? consultant;

  _StatsResult({this.buyer, this.provider, this.consultant});
}

class _ChartPoint {
  final String label;
  final int value;

  const _ChartPoint(this.label, this.value);
}

Map<String, String> _authHeader(String? token) {
  if (token == null || token.isEmpty) return {};
  return {'Authorization': 'Bearer $token'};
}
