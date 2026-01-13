import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:openapi/openapi.dart';
import 'package:built_collection/built_collection.dart';
import 'package:provider/provider.dart';
import 'package:som/ui/domain/application/application.dart';

import '../../domain/model/layout/app_body.dart';

class StatisticsAppBody extends StatefulWidget {
  const StatisticsAppBody({Key? key}) : super(key: key);

  @override
  State<StatisticsAppBody> createState() => _StatisticsAppBodyState();
}

class _StatisticsAppBodyState extends State<StatisticsAppBody> {
  Future<_StatsResult>? _statsFuture;
  String _devLog = '';
  String? _devBranchId;
  String? _devCategoryId;
  String? _devProviderCompanyId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _statsFuture ??= _loadStats(context);
  }

  Future<_StatsResult> _loadStats(BuildContext context) async {
    final api = Provider.of<Openapi>(context, listen: false);
    final statsApi = api.getStatsApi();
    StatsBuyerGet200Response? buyer;
    StatsProviderGet200Response? provider;
    StatsBuyerGet200Response? consultant;
    try {
      final response = await statsApi.statsBuyerGet();
      buyer = response.data;
    } catch (_) {}
    try {
      final response = await statsApi.statsProviderGet();
      provider = response.data;
    } catch (_) {}
    try {
      final response = await statsApi.statsConsultantGet();
      consultant = response.data;
    } catch (_) {}
    return _StatsResult(buyer: buyer, provider: provider, consultant: consultant);
  }

  Future<void> _refresh() async {
    setState(() {
      _statsFuture = _loadStats(context);
    });
  }

  void _appendLog(String message) {
    setState(() {
      _devLog = '${DateTime.now().toIso8601String()} $message\n$_devLog';
    });
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
          contextMenu: Row(
            children: [
              Text('Statistics', style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(width: 12),
              TextButton(onPressed: _refresh, child: const Text('Refresh')),
            ],
          ),
          leftSplit: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _statsSection('Buyer stats', [
                'Open: ${data.buyer?.open ?? '-'}',
                'Closed: ${data.buyer?.closed ?? '-'}',
              ]),
              _statsSection('Provider stats', [
                'Open: ${data.provider?.open ?? '-'}',
                'Offer created: ${data.provider?.offerCreated ?? '-'}',
                'Lost: ${data.provider?.lost ?? '-'}',
                'Won: ${data.provider?.won ?? '-'}',
                'Ignored: ${data.provider?.ignored ?? '-'}',
              ]),
              _statsSection('Consultant stats', [
                'Open: ${data.consultant?.open ?? '-'}',
                'Closed: ${data.consultant?.closed ?? '-'}',
              ]),
            ],
          ),
          rightSplit: _buildRightSplit(context),
        );
      },
    );
  }

  Widget _statsSection(String title, List<String> lines) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ...lines.map(Text.new),
          ],
        ),
      ),
    );
  }

  Widget _buildRightSplit(BuildContext context) {
    if (!kDebugMode ||
        !const bool.fromEnvironment('DEV_QUICK_LOGIN', defaultValue: false)) {
      return const Center(child: Text('Filters and export coming next.'));
    }
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Dev admin actions',
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              TextButton(
                onPressed: _createBranch,
                child: const Text('Create branch'),
              ),
              TextButton(
                onPressed: _createCategory,
                child: const Text('Create category'),
              ),
              TextButton(
                onPressed: _deleteCategory,
                child: const Text('Delete category'),
              ),
              TextButton(
                onPressed: _deleteBranch,
                child: const Text('Delete branch'),
              ),
              TextButton(
                onPressed: _createConsultant,
                child: const Text('Create consultant'),
              ),
              TextButton(
                onPressed: _listConsultants,
                child: const Text('List consultants'),
              ),
              TextButton(
                onPressed: _registerCompanyAsConsultant,
                child: const Text('Register company'),
              ),
              TextButton(
                onPressed: _upgradeSubscription,
                child: const Text('Upgrade subscription'),
              ),
              TextButton(
                onPressed: _approveProvider,
                child: const Text('Approve provider'),
              ),
              TextButton(
                onPressed: _declineProvider,
                child: const Text('Decline provider'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 240,
            child: SingleChildScrollView(
              child: Text(_devLog.isEmpty ? 'No dev logs yet.' : _devLog),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _createBranch() async {
    final api = Provider.of<Openapi>(context, listen: false);
    final stamp = DateTime.now().millisecondsSinceEpoch;
    try {
      final response = await api.getBranchesApi().branchesPost(
            branchesGetRequest:
                BranchesGetRequest((b) => b..name = 'Dev Branch $stamp'),
          );
      if (response.statusCode == 200) {
        final list = await api.getBranchesApi().branchesGet();
        final branch = list.data?.last;
        _devBranchId = branch?.id;
      }
      _appendLog('Created branch $_devBranchId');
    } catch (error) {
      _appendLog('Create branch failed: $error');
    }
  }

  Future<void> _createCategory() async {
    if (_devBranchId == null) {
      await _createBranch();
    }
    if (_devBranchId == null) return;
    final api = Provider.of<Openapi>(context, listen: false);
    final stamp = DateTime.now().millisecondsSinceEpoch;
    try {
      await api.getBranchesApi().branchesBranchIdCategoriesPost(
            branchId: _devBranchId!,
            branchesGetRequest:
                BranchesGetRequest((b) => b..name = 'Dev Category $stamp'),
          );
      final list = await api.getBranchesApi().branchesGet();
      final branch = list.data
          ?.firstWhere((item) => item.id == _devBranchId, orElse: () => list.data!.last);
      _devCategoryId = branch?.categories?.last.id;
      _appendLog('Created category $_devCategoryId');
    } catch (error) {
      _appendLog('Create category failed: $error');
    }
  }

  Future<void> _deleteCategory() async {
    if (_devCategoryId == null) {
      _appendLog('No category to delete');
      return;
    }
    final api = Provider.of<Openapi>(context, listen: false);
    try {
      await api
          .getBranchesApi()
          .categoriesCategoryIdDelete(categoryId: _devCategoryId!);
      _appendLog('Deleted category $_devCategoryId');
      _devCategoryId = null;
    } catch (error) {
      _appendLog('Delete category failed: $error');
    }
  }

  Future<void> _deleteBranch() async {
    if (_devBranchId == null) {
      _appendLog('No branch to delete');
      return;
    }
    final api = Provider.of<Openapi>(context, listen: false);
    try {
      await api.getBranchesApi().branchesBranchIdDelete(
            branchId: _devBranchId!,
          );
      _appendLog('Deleted branch $_devBranchId');
      _devBranchId = null;
    } catch (error) {
      _appendLog('Delete branch failed: $error');
    }
  }

  Future<void> _createConsultant() async {
    final api = Provider.of<Openapi>(context, listen: false);
    final stamp = DateTime.now().millisecondsSinceEpoch;
    try {
      await api.getConsultantsApi().consultantsPost(
            userRegistration: UserRegistration((b) => b
              ..email = 'consultant-$stamp@som.local'
              ..firstName = 'Con'
              ..lastName = 'Sultant'
              ..salutation = 'Mx'
              ..roles.add(UserRegistrationRolesEnum.number3)),
          );
      _appendLog('Created consultant consultant-$stamp@som.local');
    } catch (error) {
      _appendLog('Create consultant failed: $error');
    }
  }

  Future<void> _listConsultants() async {
    final api = Provider.of<Openapi>(context, listen: false);
    try {
      final response = await api.getConsultantsApi().consultantsGet();
      final count = response.data?.length ?? 0;
      _appendLog('Loaded $count consultants');
    } catch (error) {
      _appendLog('List consultants failed: $error');
    }
  }

  Future<void> _registerCompanyAsConsultant() async {
    final api = Provider.of<Openapi>(context, listen: false);
    final stamp = DateTime.now().millisecondsSinceEpoch;
    try {
      await api.getConsultantsApi().consultantsRegisterCompanyPost(
            consultantsRegisterCompanyPostRequest:
                ConsultantsRegisterCompanyPostRequest((b) => b
                  ..company.replace(CompanyRegistration((c) => c
                    ..name = 'Consultant Co $stamp'
                    ..uidNr = 'ATU-$stamp'
                    ..registrationNr = 'REG-$stamp'
                    ..companySize = CompanyRegistrationCompanySizeEnum.number0
                    ..type = CompanyRegistrationTypeEnum.number0
                    ..termsAccepted = true
                    ..privacyAccepted = true
                    ..address.replace(Address((a) => a
                      ..country = 'AT'
                      ..city = 'Vienna'
                      ..street = 'Main Street'
                      ..number = '1'
                      ..zip = '1010'))))
                  ..users.add(UserRegistration((u) => u
                    ..email = 'consultant-admin-$stamp@som.local'
                    ..firstName = 'Admin'
                    ..lastName = 'Consultant'
                    ..salutation = 'Mx'
                    ..roles.add(UserRegistrationRolesEnum.number4)))),
          );
      _appendLog('Registered company via consultant');
    } catch (error) {
      _appendLog('Register company failed: $error');
    }
  }

  Future<void> _approveProvider() async {
    final api = Provider.of<Openapi>(context, listen: false);
    try {
      final companies = await api.getCompaniesApi().companiesGet();
      final provider = companies.data
          ?.firstWhere((company) => company.type == 1, orElse: () => companies.data!.first);
      if (provider?.id == null) return;
      _devProviderCompanyId = provider!.id;
      await api.getProvidersApi().providersCompanyIdApprovePost(
            companyId: provider.id!,
            providersCompanyIdApprovePostRequest:
                ProvidersCompanyIdApprovePostRequest((b) => b
                  ..approvedBranchIds.replace(
                    BuiltList.of(
                      _devBranchId == null ? const [] : [_devBranchId!],
                    ),
                  )),
          );
      _appendLog('Approved provider ${provider.id}');
    } catch (error) {
      _appendLog('Approve provider failed: $error');
    }
  }

  Future<void> _declineProvider() async {
    final api = Provider.of<Openapi>(context, listen: false);
    final companyId = _devProviderCompanyId;
    if (companyId == null) {
      _appendLog('No provider selected to decline');
      return;
    }
    try {
      await api.getProvidersApi().providersCompanyIdDeclinePost(
            companyId: companyId,
          );
      _appendLog('Declined provider $companyId');
    } catch (error) {
      _appendLog('Decline provider failed: $error');
    }
  }

  Future<void> _upgradeSubscription() async {
    final api = Provider.of<Openapi>(context, listen: false);
    try {
      final subscriptions = await api.getSubscriptionsApi().subscriptionsGet();
      final plan = subscriptions.data?.subscriptions?.first;
      if (plan?.id == null) {
        _appendLog('No subscription plan available to upgrade');
        return;
      }
      final planId = plan!.id!;
      await api.getSubscriptionsApi().subscriptionsUpgradePost(
            subscriptionsUpgradePostRequest:
                SubscriptionsUpgradePostRequest((b) => b..planId = planId),
          );
      _appendLog('Upgraded subscription to $planId');
    } catch (error) {
      _appendLog('Upgrade subscription failed: $error');
    }
  }
}

class _StatsResult {
  final StatsBuyerGet200Response? buyer;
  final StatsProviderGet200Response? provider;
  final StatsBuyerGet200Response? consultant;

  _StatsResult({this.buyer, this.provider, this.consultant});
}
