import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:openapi/openapi.dart';
import 'package:provider/provider.dart';
import 'package:som/ui/theme/som_assets.dart';

import '../../domain/application/application.dart';
import '../../domain/model/layout/app_body.dart';
import '../../theme/tokens.dart';
import '../../utils/ui_logger.dart';
import '../../widgets/app_toolbar.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/status_badge.dart';

class CompaniesAppBody extends StatefulWidget {
  const CompaniesAppBody({Key? key}) : super(key: key);

  @override
  State<CompaniesAppBody> createState() => _CompaniesAppBodyState();
}

class _CompaniesAppBodyState extends State<CompaniesAppBody> {
  Future<List<CompanyDto>>? _companiesFuture;
  List<CompanyDto> _companies = const [];
  CompanyDto? _selected;

  String _search = '';
  String? _typeFilter;

  final _nameController = TextEditingController();
  final _websiteController = TextEditingController();
  final _streetController = TextEditingController();
  final _numberController = TextEditingController();
  final _zipController = TextEditingController();
  final _cityController = TextEditingController();
  final _countryController = TextEditingController(text: 'AT');
  int _companySize = 0;

  List<Branch> _branches = const [];
  List<SubscriptionPlan> _plans = const [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _companiesFuture ??= _loadCompanies();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    final api = Provider.of<Openapi>(context, listen: false);
    try {
      final branchesResponse = await api.getBranchesApi().branchesGet();
      _branches = branchesResponse.data?.toList() ?? const [];
    } catch (error, stackTrace) {
      UILogger.silentError('CompaniesAppBody._bootstrap.branches', error, stackTrace);
    }
    try {
      final plansResponse = await api.getSubscriptionsApi().subscriptionsGet();
      _plans = plansResponse.data?.subscriptions?.toList() ?? const [];
    } catch (error, stackTrace) {
      UILogger.silentError('CompaniesAppBody._bootstrap.plans', error, stackTrace);
    }
  }

  Future<List<CompanyDto>> _loadCompanies() async {
    final api = Provider.of<Openapi>(context, listen: false);
    final response = await api.getCompaniesApi().companiesGet();
    _companies = response.data?.toList() ?? const [];
    return _companies;
  }

  Future<void> _refresh() async {
    setState(() {
      _companiesFuture = _loadCompanies();
    });
  }

  void _selectCompany(CompanyDto company) {
    setState(() {
      _selected = company;
      _nameController.text = company.name ?? '';
      _websiteController.text = company.websiteUrl ?? '';
      _streetController.text = company.address?.street ?? '';
      _numberController.text = company.address?.number ?? '';
      _zipController.text = company.address?.zip ?? '';
      _cityController.text = company.address?.city ?? '';
      _countryController.text = company.address?.country ?? 'AT';
      _companySize = company.companySize ?? 0;
    });
  }

  Future<void> _saveCompany() async {
    if (_selected?.id == null) return;
    final api = Provider.of<Openapi>(context, listen: false);
    final updated = _selected!.rebuild((b) => b
      ..name = _nameController.text.trim()
      ..websiteUrl = _websiteController.text.trim().isEmpty
          ? null
          : _websiteController.text.trim()
      ..companySize = _companySize
      ..address.replace(Address((a) => a
        ..street = _streetController.text.trim()
        ..number = _numberController.text.trim()
        ..zip = _zipController.text.trim()
        ..city = _cityController.text.trim()
        ..country = _countryController.text.trim())));
    await api
        .getCompaniesApi()
        .companiesCompanyIdPut(companyId: updated.id!, companyDto: updated);
    await _refresh();
  }

  Future<void> _deactivateCompany() async {
    if (_selected?.id == null) return;
    final api = Provider.of<Openapi>(context, listen: false);
    await api
        .getCompaniesApi()
        .companiesCompanyIdDelete(companyId: _selected!.id!);
    setState(() {
      _selected = null;
    });
    await _refresh();
  }

  Future<void> _activateCompany() async {
    if (_selected?.id == null) return;
    final api = Provider.of<Openapi>(context, listen: false);
    await api
        .getCompaniesApi()
        .companiesCompanyIdActivatePost(companyId: _selected!.id!);
    await _refresh();
  }

  Future<void> _registerCompany() async {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final firstNameController = TextEditingController();
    final lastNameController = TextEditingController();
    String type = 'buyer';
    String? branchId;
    String providerType = 'haendler';
    SubscriptionPlan? selectedPlan = _plans.isNotEmpty ? _plans.first : null;

    final created = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setStateDialog) => AlertDialog(
          title: const Text('Register company'),
          content: SizedBox(
            width: 480,
            child: ListView(
              shrinkWrap: true,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Company name'),
                ),
                DropdownButton<String>(
                  value: type,
                  items: const [
                    DropdownMenuItem(value: 'buyer', child: Text('Buyer')),
                    DropdownMenuItem(value: 'provider', child: Text('Provider')),
                  ],
                  onChanged: (value) => setStateDialog(() => type = value ?? 'buyer'),
                ),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: 'Admin email'),
                ),
                TextField(
                  controller: firstNameController,
                  decoration: const InputDecoration(labelText: 'Admin first name'),
                ),
                TextField(
                  controller: lastNameController,
                  decoration: const InputDecoration(labelText: 'Admin last name'),
                ),
                if (type == 'provider')
                  DropdownButton<String>(
                    hint: const Text('Branch'),
                    value: branchId,
                    items: _branches
                        .map((branch) => DropdownMenuItem(
                              value: branch.id,
                              child: Text(branch.name ?? branch.id ?? '-'),
                            ))
                        .toList(),
                    onChanged: (value) => setStateDialog(() => branchId = value),
                  ),
                if (type == 'provider')
                  DropdownButton<String>(
                    value: providerType,
                    items: const [
                      DropdownMenuItem(value: 'haendler', child: Text('Händler')),
                      DropdownMenuItem(value: 'hersteller', child: Text('Hersteller')),
                      DropdownMenuItem(value: 'dienstleister', child: Text('Dienstleister')),
                      DropdownMenuItem(value: 'grosshaendler', child: Text('Großhändler')),
                    ],
                    onChanged: (value) => setStateDialog(() => providerType = value ?? 'haendler'),
                  ),
                if (type == 'provider')
                  DropdownButton<SubscriptionPlan>(
                    value: selectedPlan,
                    items: _plans
                        .map((plan) => DropdownMenuItem(
                              value: plan,
                              child: Text(plan.title ?? plan.id ?? 'Plan'),
                            ))
                        .toList(),
                    onChanged: (value) => setStateDialog(() => selectedPlan = value),
                  ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Register'),
            ),
          ],
        ),
      ),
    );

    if (created != true) return;
    final stamp = DateTime.now().millisecondsSinceEpoch;
    final api = Provider.of<Openapi>(context, listen: false);
    ProviderRegistrationData? providerData;
    if (type == 'provider') {
      providerData = ProviderRegistrationData((b) => b
        ..bankDetails.replace(BankDetails((bank) => bank
          ..accountOwner = 'Demo Owner'
          ..iban = 'AT00DEMO$stamp'
          ..bic = 'DEMOATXX'))
        ..paymentInterval = ProviderRegistrationDataPaymentIntervalEnum.number0
        ..subscriptionPlanId = selectedPlan?.id
        ..providerType = providerType
        ..branchIds = ListBuilder(branchId == null ? const [] : [branchId!]));
    }

    final request = ConsultantsRegisterCompanyPostRequest((b) => b
      ..company.replace(CompanyRegistration((c) {
        c
          ..name = nameController.text.trim().isEmpty
              ? 'Company $stamp'
              : nameController.text.trim()
          ..address.replace(Address((a) => a
            ..country = 'AT'
            ..city = 'Vienna'
            ..street = 'Test Street'
            ..number = '1'
            ..zip = '1010'))
          ..uidNr = 'ATU-$stamp'
          ..registrationNr = 'REG-$stamp'
          ..companySize = CompanyRegistrationCompanySizeEnum.number1
          ..type = type == 'provider'
              ? CompanyRegistrationTypeEnum.number1
              : CompanyRegistrationTypeEnum.number0
          ..websiteUrl = null
          ..termsAccepted = true
          ..privacyAccepted = true;
        if (providerData != null) {
          c.providerData.replace(providerData!);
        }
      }))
      ..users.add(UserRegistration((u) => u
        ..email = emailController.text.trim().isEmpty
            ? 'admin-$stamp@som.local'
            : emailController.text.trim()
        ..firstName = firstNameController.text.trim().isEmpty
            ? 'Admin'
            : firstNameController.text.trim()
        ..lastName = lastNameController.text.trim().isEmpty
            ? 'User'
            : lastNameController.text.trim()
        ..salutation = 'Mx'
        ..roles = ListBuilder([
          UserRegistrationRolesEnum.number4,
          if (type == 'provider') UserRegistrationRolesEnum.number1,
          if (type == 'buyer') UserRegistrationRolesEnum.number0,
        ]))));

    await api.getConsultantsApi().consultantsRegisterCompanyPost(
          consultantsRegisterCompanyPostRequest: request,
        );
    await _refresh();
  }

  String _companyTypeLabel(CompanyDto company) {
    return switch (company.type) {
      0 => 'buyer',
      1 => 'provider',
      2 => 'buyer+provider',
      _ => 'unknown',
    };
  }

  @override
  Widget build(BuildContext context) {
    final appStore = Provider.of<Application>(context);
    if (appStore.authorization == null ||
        appStore.authorization?.isConsultant != true) {
      return const AppBody(
        contextMenu: Text('Consultant access required'),
        leftSplit:
            Center(child: Text('Only consultants can manage companies.')),
        rightSplit: SizedBox.shrink(),
      );
    }

    return FutureBuilder<List<CompanyDto>>(
      future: _companiesFuture,
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
              child: Text('Failed to load companies: ${snapshot.error}'),
            ),
            rightSplit: const SizedBox.shrink(),
          );
        }
        final companies = (snapshot.data ?? const [])
            .where((company) {
              final matchesType = _typeFilter == null ||
                  (_typeFilter == 'buyer' && company.type == 0) ||
                  (_typeFilter == 'provider' && company.type == 1) ||
                  (_typeFilter == 'buyer_provider' && company.type == 2);
              final matchesSearch = _search.isEmpty ||
                  (company.name ?? '')
                      .toLowerCase()
                      .contains(_search.toLowerCase());
              return matchesType && matchesSearch;
            })
            .toList();
        if (companies.isEmpty) {
          return AppBody(
            contextMenu: AppToolbar(
              title: const Text('Companies'),
              actions: [
                TextButton(onPressed: _refresh, child: const Text('Refresh')),
                FilledButton.tonal(
                  onPressed: _registerCompany,
                  child: const Text('Register'),
                ),
              ],
            ),
            leftSplit: const EmptyState(
              asset: SomAssets.emptySearchResults,
              title: 'No companies found',
              message: 'Register a company to get started',
            ),
            rightSplit: const SizedBox.shrink(),
          );
        }
        return AppBody(
          contextMenu: AppToolbar(
            title: const Text('Companies'),
            actions: [
              TextButton(onPressed: _refresh, child: const Text('Refresh')),
              FilledButton.tonal(
                onPressed: _registerCompany,
                child: const Text('Register'),
              ),
            ],
          ),
          leftSplit: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: Wrap(
                  spacing: 12,
                  children: [
                    SizedBox(
                      width: 180,
                      child: TextField(
                        decoration: const InputDecoration(labelText: 'Search'),
                        onChanged: (value) => setState(() => _search = value),
                      ),
                    ),
                    DropdownButton<String>(
                      hint: const Text('Type'),
                      value: _typeFilter,
                      items: const [
                        DropdownMenuItem(value: 'buyer', child: Text('Buyer')),
                        DropdownMenuItem(value: 'provider', child: Text('Provider')),
                        DropdownMenuItem(value: 'buyer_provider', child: Text('Buyer+Provider')),
                      ],
                      onChanged: (value) => setState(() => _typeFilter = value),
                    ),
                    TextButton(
                      onPressed: () => setState(() {
                        _search = '';
                        _typeFilter = null;
                      }),
                      child: const Text('Clear'),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: ListView.builder(
                  itemCount: companies.length,
                  itemBuilder: (context, index) {
                    final company = companies[index];
                    final status = company.status ?? 'unknown';
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: SomSpacing.md,
                        vertical: SomSpacing.xs,
                      ),
                      title: Text(company.name ?? 'Company'),
                      subtitle: Text('Type: ${_companyTypeLabel(company)} • $status'),
                      selected: _selected?.id == company.id,
                      onTap: () => _selectCompany(company),
                      trailing: StatusBadge.provider(
                        status: status,
                        compact: false,
                        showIcon: false,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          rightSplit: _selected == null
              ? const EmptyState(
                  asset: SomAssets.emptySearchResults,
                  title: 'Select a company',
                  message: 'Choose a company from the list to view details',
                )
              : Padding(
                  padding: const EdgeInsets.all(16),
                  child: ListView(
                    children: [
                      Text(_selected!.name ?? 'Company',
                          style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Text('Status: ${_selected?.status ?? 'unknown'}'),
                          const SizedBox(width: SomSpacing.sm),
                          StatusBadge.provider(
                            status: _selected?.status ?? 'unknown',
                            compact: false,
                            showIcon: false,
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _nameController,
                        decoration: const InputDecoration(labelText: 'Name'),
                      ),
                      TextField(
                        controller: _websiteController,
                        decoration: const InputDecoration(labelText: 'Website'),
                      ),
                      DropdownButton<int>(
                        value: _companySize,
                        items: const [
                          DropdownMenuItem(value: 0, child: Text('0-10')),
                          DropdownMenuItem(value: 1, child: Text('11-50')),
                          DropdownMenuItem(value: 2, child: Text('51-100')),
                          DropdownMenuItem(value: 3, child: Text('101-250')),
                          DropdownMenuItem(value: 4, child: Text('251-500')),
                          DropdownMenuItem(value: 5, child: Text('500+')),
                        ],
                        onChanged: (value) => setState(() => _companySize = value ?? 0),
                      ),
                      TextField(
                        controller: _streetController,
                        decoration: const InputDecoration(labelText: 'Street'),
                      ),
                      TextField(
                        controller: _numberController,
                        decoration: const InputDecoration(labelText: 'Number'),
                      ),
                      TextField(
                        controller: _zipController,
                        decoration: const InputDecoration(labelText: 'ZIP'),
                      ),
                      TextField(
                        controller: _cityController,
                        decoration: const InputDecoration(labelText: 'City'),
                      ),
                      TextField(
                        controller: _countryController,
                        decoration: const InputDecoration(labelText: 'Country'),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          ElevatedButton(
                            onPressed: _saveCompany,
                            child: const Text('Save'),
                          ),
                          const SizedBox(width: 12),
                          if ((_selected?.id != null &&
                                  (_selected?.status ?? 'active') ==
                                      'inactive'))
                            TextButton(
                              onPressed: _activateCompany,
                              child: const Text('Activate'),
                            )
                          else
                            TextButton(
                              onPressed: _deactivateCompany,
                              child: const Text('Deactivate'),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
        );
      },
    );
  }
}
