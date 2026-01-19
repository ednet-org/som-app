import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:openapi/openapi.dart';
import 'package:provider/provider.dart';
import 'package:som/ui/theme/som_assets.dart';
import 'package:som/ui/widgets/design_system/som_svg_icon.dart';

import '../../domain/application/application.dart';
import '../../domain/infrastructure/supabase_realtime.dart';
import '../../domain/model/layout/app_body.dart';
import '../../theme/tokens.dart';
import '../../utils/formatters.dart';
import '../../utils/ui_logger.dart';
import '../../widgets/app_toolbar.dart';
import '../../widgets/detail_section.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/inline_message.dart';
import '../../widgets/meta_text.dart';
import '../../widgets/selectable_list_view.dart';
import '../../widgets/som_list_tile.dart';
import '../../widgets/snackbars.dart';

class SubscriptionsAppBody extends StatefulWidget {
  const SubscriptionsAppBody({super.key});

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
  bool _realtimeReady = false;
  late final RealtimeRefreshHandle _realtimeRefresh =
      RealtimeRefreshHandle(_handleRealtimeRefresh);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _plansFuture ??= _loadPlans();
    _loadCurrent();
    _setupRealtime();
  }

  @override
  void dispose() {
    _realtimeRefresh.dispose();
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

  void _handleRealtimeRefresh() {
    if (!mounted) return;
    _refresh();
  }

  void _setupRealtime() {
    if (_realtimeReady) return;
    final appStore = Provider.of<Application>(context, listen: false);
    SupabaseRealtime.setAuth(appStore.authorization?.token);
    _realtimeRefresh.subscribe(
      tables: const [
        'subscription_plans',
        'subscriptions',
        'subscription_cancellations',
      ],
      channelName: 'subscriptions-page',
    );
    _realtimeReady = true;
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
    } catch (error, stackTrace) {
      UILogger.silentError('SubscriptionsAppBody._loadCurrent', error, stackTrace);
    }
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
    final input = _buildPlanInput();
    await api.getSubscriptionsApi().subscriptionsPost(
          subscriptionPlanInput: input,
        );
    await _refresh();
  }

  Future<void> _updatePlan() async {
    if (_selected?.id == null) return;
    final api = Provider.of<Openapi>(context, listen: false);
    try {
      await api.getSubscriptionsApi().subscriptionsPlansPlanIdPut(
            planId: _selected!.id!,
            subscriptionPlanInput: _buildPlanInput(),
          );
      await _refresh();
    } on DioException catch (error) {
      final message = error.response?.data?.toString() ?? '';
      if (message.contains('Confirmation required')) {
        if (!mounted) return;
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
              FilledButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Confirm'),
              ),
            ],
          ),
        );
        if (confirmed == true) {
          await api.getSubscriptionsApi().subscriptionsPlansPlanIdPut(
                planId: _selected!.id!,
                subscriptionPlanInput: _buildPlanInput(confirm: true),
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
      await api.getSubscriptionsApi().subscriptionsDowngradePost(
            subscriptionsUpgradePostRequest:
                SubscriptionsUpgradePostRequest((b) => b..planId = _selected!.id!),
          );
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
      return AppBody(
        contextMenu: AppToolbar(title: const Text('Subscriptions')),
        leftSplit: const EmptyState(
          asset: SomAssets.illustrationStateNoConnection,
          title: 'Access required',
          message:
              'Only consultant admins or provider admins can manage subscriptions.',
        ),
        rightSplit: const SizedBox.shrink(),
      );
    }

    return FutureBuilder<List<SubscriptionPlan>>(
      future: _plansFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return AppBody(
            contextMenu: _buildToolbar(isConsultantAdmin, isProviderAdmin),
            leftSplit: const Center(child: CircularProgressIndicator()),
            rightSplit: const SizedBox.shrink(),
          );
        }
        if (snapshot.hasError) {
          return AppBody(
            contextMenu: _buildToolbar(isConsultantAdmin, isProviderAdmin),
            leftSplit: Center(
              child: InlineMessage(
                message: 'Failed to load plans: ${snapshot.error}',
                type: InlineMessageType.error,
              ),
            ),
            rightSplit: const SizedBox.shrink(),
          );
        }
        final plans = snapshot.data ?? const [];
        if (plans.isEmpty) {
          return AppBody(
            contextMenu: _buildToolbar(isConsultantAdmin, isProviderAdmin),
            leftSplit: const EmptyState(
              asset: SomAssets.emptySearchResults,
              title: 'No subscription plans',
              message: 'Create a plan to manage subscriptions',
            ),
            rightSplit: const SizedBox.shrink(),
          );
        }
        return AppBody(
          contextMenu: _buildToolbar(isConsultantAdmin, isProviderAdmin),
          leftSplit: SelectableListView<SubscriptionPlan>(
            items: plans,
            selectedIndex: () {
              final index =
                  plans.indexWhere((plan) => plan.id == _selected?.id);
              return index < 0 ? null : index;
            }(),
            onSelectedIndex: (index) => _selectPlan(plans[index]),
            itemBuilder: (context, plan, isSelected) {
              final index = plans.indexOf(plan);
              final isCurrent = _current?.plan?.id == plan.id;
              return Column(
                children: [
                  SomListTile(
                    selected: isSelected,
                    onTap: () => _selectPlan(plan),
                    title: Text(plan.title ?? plan.id ?? 'Plan'),
                    subtitle: Text(
                      'Price: ${(plan.priceInSubunit ?? 0) / 100} • '
                      '${plan.isActive == true ? 'Active' : 'Inactive'}',
                    ),
                    trailing: isCurrent
                        ? SomSvgIcon(
                            SomAssets.offerStatusAccepted,
                            size: SomIconSize.sm,
                            color: Theme.of(context).colorScheme.primary,
                          )
                        : null,
                  ),
                  if (index != plans.length - 1) const Divider(height: 1),
                ],
              );
            },
          ),
          rightSplit: _selected == null
              ? const EmptyState(
                  asset: SomAssets.emptySearchResults,
                  title: 'Select a plan',
                  message: 'Choose a subscription plan to edit details.',
                )
              : Padding(
                  padding: const EdgeInsets.all(SomSpacing.md),
                  child: ListView(
                    children: [
                      Text(
                        _selected!.title ?? 'Plan',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: SomSpacing.xs),
                      SomMetaText(
                        'Plan ID ${SomFormatters.shortId(_selected!.id)}',
                      ),
                      const SizedBox(height: SomSpacing.md),
                      DetailSection(
                        title: 'Plan details',
                        iconAsset: SomAssets.iconInfo,
                        child: Column(
                          children: [
                            TextField(
                              controller: _titleController,
                              decoration:
                                  const InputDecoration(labelText: 'Title'),
                            ),
                            const SizedBox(height: SomSpacing.sm),
                            TextField(
                              controller: _sortController,
                              decoration: const InputDecoration(
                                labelText: 'Sort priority',
                              ),
                              keyboardType: TextInputType.number,
                            ),
                            const SizedBox(height: SomSpacing.sm),
                            TextField(
                              controller: _priceController,
                              decoration: const InputDecoration(
                                labelText: 'Price (subunit)',
                              ),
                              keyboardType: TextInputType.number,
                            ),
                            const SizedBox(height: SomSpacing.sm),
                            SwitchListTile(
                              value: _isActive,
                              onChanged: (value) =>
                                  setState(() => _isActive = value),
                              title: const Text('Active'),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: SomSpacing.md),
                      DetailSection(
                        title: 'Limits',
                        iconAsset: SomAssets.iconStatistics,
                        child: Column(
                          children: [
                            TextField(
                              controller: _maxUsersController,
                              decoration:
                                  const InputDecoration(labelText: 'Max users'),
                              keyboardType: TextInputType.number,
                            ),
                            const SizedBox(height: SomSpacing.sm),
                            TextField(
                              controller: _setupFeeController,
                              decoration: const InputDecoration(
                                labelText: 'Setup fee (subunit)',
                              ),
                              keyboardType: TextInputType.number,
                            ),
                            const SizedBox(height: SomSpacing.sm),
                            TextField(
                              controller: _freeMonthsController,
                              decoration:
                                  const InputDecoration(labelText: 'Free months'),
                              keyboardType: TextInputType.number,
                            ),
                            const SizedBox(height: SomSpacing.sm),
                            TextField(
                              controller: _commitmentController,
                              decoration: const InputDecoration(
                                labelText: 'Commitment (months)',
                              ),
                              keyboardType: TextInputType.number,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: SomSpacing.md),
                      DetailSection(
                        title: 'Ads',
                        iconAsset: SomAssets.iconOffers,
                        child: Column(
                          children: [
                            TextField(
                              controller: _bannerAdsController,
                              decoration: const InputDecoration(
                                labelText: 'Banner ads per month',
                              ),
                              keyboardType: TextInputType.number,
                            ),
                            const SizedBox(height: SomSpacing.sm),
                            TextField(
                              controller: _normalAdsController,
                              decoration: const InputDecoration(
                                labelText: 'Normal ads per month',
                              ),
                              keyboardType: TextInputType.number,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: SomSpacing.md),
                      DetailSection(
                        title: 'Rules',
                        iconAsset: SomAssets.iconSettings,
                        child: TextField(
                          controller: _rulesController,
                          decoration: const InputDecoration(
                            labelText: 'Rules (JSON array)',
                          ),
                          maxLines: 6,
                        ),
                      ),
                      if (_current != null) ...[
                        const SizedBox(height: SomSpacing.md),
                        DetailSection(
                          title: 'Current subscription',
                          iconAsset: SomAssets.iconStatistics,
                          child: DetailGrid(
                            items: [
                              DetailItem(
                                label: 'Plan',
                                value: _current?.plan?.title ?? '-',
                              ),
                              DetailItem(
                                label: 'Status',
                                value:
                                    _current?.subscription?.status ?? '-',
                              ),
                              DetailItem(
                                label: 'Interval',
                                value: _current
                                        ?.subscription
                                        ?.paymentInterval ??
                                    '-',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
        );
      },
    );
  }

  Widget _buildToolbar(bool isConsultantAdmin, bool isProviderAdmin) {
    return AppToolbar(
      title: const Text('Subscriptions'),
      actions: [
        if (isConsultantAdmin)
          FilledButton.tonal(
            onPressed: _createPlan,
            child: const Text('Create'),
          ),
        if (isConsultantAdmin)
          FilledButton.tonal(
            onPressed: _updatePlan,
            child: const Text('Save'),
          ),
        if (isConsultantAdmin)
          OutlinedButton(onPressed: _deletePlan, child: const Text('Delete')),
        if (isProviderAdmin)
          FilledButton.tonal(
            onPressed: _upgradePlan,
            child: const Text('Upgrade'),
          ),
        if (isProviderAdmin)
          TextButton(
            onPressed: _downgradePlan,
            child: const Text('Downgrade'),
          ),
      ],
    );
  }

  void _showSnack(String message) {
    if (!mounted) return;
    if (message.toLowerCase().contains('failed')) {
      SomSnackBars.error(context, message);
    } else {
      SomSnackBars.success(context, message);
    }
  }

  int? _parseOptionalInt(TextEditingController controller) {
    final value = controller.text.trim();
    if (value.isEmpty) return null;
    return int.tryParse(value);
  }

  String _formatOptional(int? value) => value == null ? '' : value.toString();

  SubscriptionPlanInput _buildPlanInput({bool? confirm}) {
    return SubscriptionPlanInput((b) => b
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
      ..confirm = confirm
      ..rules.replace(_parseRules()));
  }
}
