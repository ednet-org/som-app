import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:openapi/openapi.dart';
import 'package:provider/provider.dart';

import '../../domain/application/application.dart';
import '../../domain/model/layout/app_body.dart';

class SubscriptionsAppBody extends StatefulWidget {
  const SubscriptionsAppBody({Key? key}) : super(key: key);

  @override
  State<SubscriptionsAppBody> createState() => _SubscriptionsAppBodyState();
}

class _SubscriptionsAppBodyState extends State<SubscriptionsAppBody> {
  Future<List<SubscriptionPlan>>? _plansFuture;
  List<SubscriptionPlan> _plans = const [];
  SubscriptionPlan? _selected;
  SubscriptionCurrent? _current;

  final _titleController = TextEditingController();
  final _sortController = TextEditingController(text: '0');
  final _priceController = TextEditingController(text: '0');
  final _maxUsersController = TextEditingController();
  final _setupFeeController = TextEditingController();
  final _bannerAdsController = TextEditingController();
  final _normalAdsController = TextEditingController();
  final _freeMonthsController = TextEditingController();
  final _commitmentController = TextEditingController();
  final _rulesController = TextEditingController(text: '[]');
  bool _isActive = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _plansFuture ??= _loadPlans();
    _loadCurrent();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _sortController.dispose();
    _priceController.dispose();
    _maxUsersController.dispose();
    _setupFeeController.dispose();
    _bannerAdsController.dispose();
    _normalAdsController.dispose();
    _freeMonthsController.dispose();
    _commitmentController.dispose();
    _rulesController.dispose();
    super.dispose();
  }

  Future<List<SubscriptionPlan>> _loadPlans() async {
    final api = Provider.of<Openapi>(context, listen: false);
    final response = await api.getSubscriptionsApi().subscriptionsGet();
    _plans = response.data?.subscriptions?.toList() ?? const [];
    return _plans;
  }

  Future<void> _loadCurrent() async {
    final appStore = Provider.of<Application>(context, listen: false);
    if (!(appStore.authorization?.isProvider ?? false)) {
      return;
    }
    try {
      final api = Provider.of<Openapi>(context, listen: false);
      final response = await api.getSubscriptionsApi().subscriptionsCurrentGet();
      setState(() {
        _current = response.data;
      });
    } catch (_) {}
  }

  Future<void> _refresh() async {
    setState(() {
      _plansFuture = _loadPlans();
    });
    await _loadCurrent();
  }

  void _selectPlan(SubscriptionPlan plan) {
    setState(() {
      _selected = plan;
      _titleController.text = plan.title ?? '';
      _sortController.text = (plan.sortPriority ?? 0).toString();
      _priceController.text = (plan.priceInSubunit ?? 0).toString();
      _maxUsersController.text = _formatOptional(plan.maxUsers);
      _setupFeeController.text = _formatOptional(plan.setupFeeInSubunit);
      _bannerAdsController.text = _formatOptional(plan.bannerAdsPerMonth);
      _normalAdsController.text = _formatOptional(plan.normalAdsPerMonth);
      _freeMonthsController.text = _formatOptional(plan.freeMonths);
      _commitmentController.text = _formatOptional(plan.commitmentPeriodMonths);
      _isActive = plan.isActive ?? false;
      final rules = plan.rules?.map((rule) {
        return {
          'restriction': rule.restriction,
          'upperLimit': rule.upperLimit,
        };
      }).toList();
      _rulesController.text = jsonEncode(rules ?? []);
    });
  }

  BuiltList<SubscriptionPlanRulesInner> _parseRules() {
    final raw = _rulesController.text.trim();
    if (raw.isEmpty) {
      return BuiltList<SubscriptionPlanRulesInner>();
    }
    try {
      final parsed = jsonDecode(raw);
      if (parsed is! List) return BuiltList<SubscriptionPlanRulesInner>();
      final items = parsed.map((item) {
        final map = item is Map ? item : {};
        return SubscriptionPlanRulesInner((b) => b
          ..restriction = map['restriction'] is int
              ? map['restriction'] as int
              : null
          ..upperLimit =
              map['upperLimit'] is int ? map['upperLimit'] as int : null);
      }).toList();
      return BuiltList<SubscriptionPlanRulesInner>(items);
    } catch (_) {
      return BuiltList<SubscriptionPlanRulesInner>();
    }
  }

  Future<void> _createPlan() async {
    final api = Provider.of<Openapi>(context, listen: false);
    final input = SubscriptionPlanInput((b) => b
      ..title = _titleController.text.trim()
      ..sortPriority = int.tryParse(_sortController.text.trim()) ?? 0
      ..priceInSubunit = int.tryParse(_priceController.text.trim()) ?? 0
      ..maxUsers = _parseOptionalInt(_maxUsersController)
      ..setupFeeInSubunit = _parseOptionalInt(_setupFeeController)
      ..bannerAdsPerMonth = _parseOptionalInt(_bannerAdsController)
      ..normalAdsPerMonth = _parseOptionalInt(_normalAdsController)
      ..freeMonths = _parseOptionalInt(_freeMonthsController)
      ..commitmentPeriodMonths = _parseOptionalInt(_commitmentController)
      ..isActive = _isActive
      ..rules.replace(_parseRules()));
    await api.getSubscriptionsApi().subscriptionsPost(
          subscriptionPlanInput: input,
        );
    await _refresh();
  }

  Future<void> _updatePlan() async {
    if (_selected?.id == null) return;
    final api = Provider.of<Openapi>(context, listen: false);
    final payload = {
      'title': _titleController.text.trim(),
      'sortPriority': int.tryParse(_sortController.text.trim()) ?? 0,
      'priceInSubunit': int.tryParse(_priceController.text.trim()) ?? 0,
      'maxUsers': _parseOptionalInt(_maxUsersController),
      'setupFeeInSubunit': _parseOptionalInt(_setupFeeController),
      'bannerAdsPerMonth': _parseOptionalInt(_bannerAdsController),
      'normalAdsPerMonth': _parseOptionalInt(_normalAdsController),
      'freeMonths': _parseOptionalInt(_freeMonthsController),
      'commitmentPeriodMonths': _parseOptionalInt(_commitmentController),
      'isActive': _isActive,
      'rules': _parseRules().map((rule) {
        return {
          'restriction': rule.restriction,
          'upperLimit': rule.upperLimit,
        };
      }).toList(),
    };
    try {
      await api.dio.put('/Subscriptions/plans/${_selected!.id!}', data: payload);
      await _refresh();
    } on DioException catch (error) {
      final message = error.response?.data?.toString() ?? '';
      if (message.contains('Confirmation required')) {
        final confirmed = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Confirm plan update'),
            content: const Text(
                'This plan has active subscribers. Apply the changes anyway?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Confirm'),
              ),
            ],
          ),
        );
        if (confirmed == true) {
          await api.dio.put(
            '/Subscriptions/plans/${_selected!.id!}',
            data: {...payload, 'confirm': true},
          );
          await _refresh();
        }
      } else {
        _showSnack('Failed to update plan: ${message.isEmpty ? error.message : message}');
      }
    }
  }

  Future<void> _deletePlan() async {
    if (_selected?.id == null) return;
    final api = Provider.of<Openapi>(context, listen: false);
    await api
        .getSubscriptionsApi()
        .subscriptionsPlansPlanIdDelete(planId: _selected!.id!);
    setState(() => _selected = null);
    await _refresh();
  }

  Future<void> _upgradePlan() async {
    if (_selected?.id == null) return;
    final api = Provider.of<Openapi>(context, listen: false);
    await api.getSubscriptionsApi().subscriptionsUpgradePost(
          subscriptionsUpgradePostRequest:
              SubscriptionsUpgradePostRequest((b) => b..planId = _selected!.id!),
        );
    await _loadCurrent();
  }

  Future<void> _downgradePlan() async {
    if (_selected?.id == null) return;
    final api = Provider.of<Openapi>(context, listen: false);
    try {
      await api.dio.post('/Subscriptions/downgrade', data: {
        'planId': _selected!.id!,
      });
      await _loadCurrent();
      _showSnack('Downgrade scheduled.');
    } on DioException catch (error) {
      final message = error.response?.data?.toString() ?? '';
      _showSnack('Downgrade failed: ${message.isEmpty ? error.message : message}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final appStore = Provider.of<Application>(context);
    final auth = appStore.authorization;
    final isConsultantAdmin =
        (auth?.isConsultant ?? false) && (auth?.isAdmin ?? false);
    final isProviderAdmin =
        (auth?.isProvider ?? false) && (auth?.isAdmin ?? false);

    if (!isConsultantAdmin && !isProviderAdmin) {
      return const AppBody(
        contextMenu: Text('Access required'),
        leftSplit: Center(
            child: Text('Only consultant admins or provider admins can manage subscriptions.')),
        rightSplit: SizedBox.shrink(),
      );
    }

    return FutureBuilder<List<SubscriptionPlan>>(
      future: _plansFuture,
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
              child: Text('Failed to load plans: ${snapshot.error}'),
            ),
            rightSplit: const SizedBox.shrink(),
          );
        }
        final plans = snapshot.data ?? const [];
        return AppBody(
          contextMenu: Row(
            children: [
              Text('Subscriptions', style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(width: 12),
              TextButton(onPressed: _refresh, child: const Text('Refresh')),
              if (isConsultantAdmin)
                TextButton(onPressed: _createPlan, child: const Text('Create')),
              if (isConsultantAdmin)
                TextButton(onPressed: _updatePlan, child: const Text('Save')),
              if (isConsultantAdmin)
                TextButton(onPressed: _deletePlan, child: const Text('Delete')),
              if (isProviderAdmin)
                TextButton(onPressed: _upgradePlan, child: const Text('Upgrade')),
              if (isProviderAdmin)
                TextButton(
                  onPressed: _downgradePlan,
                  child: const Text('Downgrade'),
                ),
            ],
          ),
          leftSplit: ListView.builder(
            itemCount: plans.length,
            itemBuilder: (context, index) {
              final plan = plans[index];
              final isCurrent = _current?.plan?.id == plan.id;
              return ListTile(
                title: Text(plan.title ?? plan.id ?? 'Plan'),
                subtitle: Text(
                  'Price: ${(plan.priceInSubunit ?? 0) / 100} | '
                  'Active: ${plan.isActive ?? false}',
                ),
                trailing: isCurrent ? const Icon(Icons.check) : null,
                selected: _selected?.id == plan.id,
                onTap: () => _selectPlan(plan),
              );
            },
          ),
          rightSplit: _selected == null
              ? const Center(child: Text('Select a plan.'))
              : Padding(
                  padding: const EdgeInsets.all(16),
                  child: ListView(
                    children: [
                      TextField(
                        controller: _titleController,
                        decoration: const InputDecoration(labelText: 'Title'),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _sortController,
                        decoration:
                            const InputDecoration(labelText: 'Sort priority'),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _priceController,
                        decoration:
                            const InputDecoration(labelText: 'Price (subunit)'),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _maxUsersController,
                        decoration:
                            const InputDecoration(labelText: 'Max users'),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _setupFeeController,
                        decoration:
                            const InputDecoration(labelText: 'Setup fee (subunit)'),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _bannerAdsController,
                        decoration:
                            const InputDecoration(labelText: 'Banner ads per month'),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _normalAdsController,
                        decoration:
                            const InputDecoration(labelText: 'Normal ads per month'),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _freeMonthsController,
                        decoration:
                            const InputDecoration(labelText: 'Free months'),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _commitmentController,
                        decoration:
                            const InputDecoration(labelText: 'Commitment (months)'),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 12),
                      SwitchListTile(
                        value: _isActive,
                        onChanged: (value) => setState(() => _isActive = value),
                        title: const Text('Active'),
                      ),
                      TextField(
                        controller: _rulesController,
                        decoration:
                            const InputDecoration(labelText: 'Rules (JSON array)'),
                        maxLines: 6,
                      ),
                      if (_current != null) ...[
                        const Divider(height: 24),
                        Text('Current subscription',
                            style: Theme.of(context).textTheme.titleSmall),
                        Text('Plan: ${_current?.plan?.title ?? '-'}'),
                        Text(
                            'Status: ${_current?.subscription?.status ?? '-'}'),
                        Text(
                            'Interval: ${_current?.subscription?.paymentInterval ?? '-'}'),
                      ],
                    ],
                  ),
                ),
        );
      },
    );
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  int? _parseOptionalInt(TextEditingController controller) {
    final value = controller.text.trim();
    if (value.isEmpty) return null;
    return int.tryParse(value);
  }

  String _formatOptional(int? value) => value == null ? '' : value.toString();
}
