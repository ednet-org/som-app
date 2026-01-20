import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:openapi/openapi.dart';
import 'package:provider/provider.dart';
import 'package:som/ui/theme/som_assets.dart';

import '../../domain/application/application.dart';
import '../../domain/infrastructure/supabase_realtime.dart';
import '../../domain/model/layout/app_body.dart';
import '../../theme/tokens.dart';
import '../../utils/formatters.dart';
import '../../utils/ui_logger.dart';
import '../../widgets/app_toolbar.dart';
import '../../widgets/debounced_search_field.dart';
import '../../widgets/detail_section.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/inline_message.dart';
import '../../widgets/meta_text.dart';
import '../../widgets/responsive_filter_panel.dart';
import '../../widgets/selectable_list_view.dart';
import '../../widgets/som_list_tile.dart';
import '../../widgets/status_badge.dart';
import '../../widgets/status_legend.dart';

class CompaniesAppBody extends StatefulWidget {
  const CompaniesAppBody({super.key});

  @override
  State<CompaniesAppBody> createState() => _CompaniesAppBodyState();
}

class _CompaniesAppBodyState extends State<CompaniesAppBody> {
  Future<List<CompanyDto>>? _companiesFuture;
  List<CompanyDto> _companies = const [];
  CompanyDto? _selected;

  String _search = '';
  String? _typeFilter;
  bool _realtimeReady = false;
  late final RealtimeRefreshHandle _realtimeRefresh =
      RealtimeRefreshHandle(_handleRealtimeRefresh);

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
    _setupRealtime();
  }

  @override
  void dispose() {
    _realtimeRefresh.dispose();
    _nameController.dispose();
    _websiteController.dispose();
    _streetController.dispose();
    _numberController.dispose();
    _zipController.dispose();
    _cityController.dispose();
    _countryController.dispose();
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
      tables: const ['companies'],
      channelName: 'companies-page',
    );
    _realtimeReady = true;
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
                              child: Text(
                                branch.name ??
                                    SomFormatters.shortId(branch.id),
                              ),
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
                              child: Text(
                                plan.title ??
                                    'Plan ${SomFormatters.shortId(plan.id)}',
                              ),
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
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Register'),
            ),
          ],
        ),
      ),
    );

    if (created != true) return;
    if (!mounted) return;
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
          c.providerData.replace(providerData);
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
      return AppBody(
        contextMenu: AppToolbar(title: const Text('Companies')),
        leftSplit: const EmptyState(
          asset: SomAssets.illustrationStateNoConnection,
          title: 'Consultant access required',
          message: 'Only consultants can manage companies.',
        ),
        rightSplit: const SizedBox.shrink(),
      );
    }

    return FutureBuilder<List<CompanyDto>>(
      future: _companiesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return AppBody(
            contextMenu: _buildToolbar(),
            leftSplit: const Center(child: CircularProgressIndicator()),
            rightSplit: const SizedBox.shrink(),
          );
        }
        if (snapshot.hasError) {
          return AppBody(
            contextMenu: _buildToolbar(),
            leftSplit: Center(
              child: InlineMessage(
                message: 'Failed to load companies: ${snapshot.error}',
                type: InlineMessageType.error,
              ),
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
            contextMenu: _buildToolbar(),
            leftSplit: const EmptyState(
              asset: SomAssets.emptySearchResults,
              title: 'No companies found',
              message: 'Register a company to get started',
            ),
            rightSplit: const SizedBox.shrink(),
          );
        }
        return AppBody(
          contextMenu: _buildToolbar(),
          leftSplit: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(SomSpacing.sm),
                child: DebouncedSearchField(
                  hintText: 'Search companies',
                  onSearch: (value) => setState(() => _search = value),
                ),
              ),
              ResponsiveFilterPanel(
                title: 'Filters',
                child: Wrap(
                  spacing: SomSpacing.sm,
                  runSpacing: SomSpacing.sm,
                  children: [
                    DropdownButton<String>(
                      hint: const Text('Type'),
                      value: _typeFilter,
                      items: const [
                        DropdownMenuItem(value: 'buyer', child: Text('Buyer')),
                        DropdownMenuItem(
                          value: 'provider',
                          child: Text('Provider'),
                        ),
                        DropdownMenuItem(
                          value: 'buyer_provider',
                          child: Text('Buyer+Provider'),
                        ),
                      ],
                      onChanged: (value) =>
                          setState(() => _typeFilter = value),
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
                child: SelectableListView<CompanyDto>(
                  items: companies,
                  selectedIndex: () {
                    final index = companies.indexWhere(
                      (company) => company.id == _selected?.id,
                    );
                    return index < 0 ? null : index;
                  }(),
                  onSelectedIndex: (index) =>
                      _selectCompany(companies[index]),
                  itemBuilder: (context, company, isSelected) {
                    final index = companies.indexOf(company);
                    final status = company.status ?? 'unknown';
                    return Column(
                      children: [
                        SomListTile(
                          selected: isSelected,
                          onTap: () => _selectCompany(company),
                          title: Text(company.name ?? 'Company'),
                          subtitle: Text(
                            'Type: ${_companyTypeLabel(company)} • ${SomFormatters.capitalize(status)}',
                          ),
                          trailing: StatusBadge.company(
                            status: status,
                            compact: false,
                            showIcon: false,
                          ),
                        ),
                        if (index != companies.length - 1)
                          const Divider(height: 1),
                      ],
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
              : _buildCompanyDetails(),
        );
      },
    );
  }

  Widget _buildToolbar() {
    return AppToolbar(
      title: const Text('Companies'),
      actions: [
        FilledButton.tonal(
          onPressed: _registerCompany,
          child: const Text('Register'),
        ),
        StatusLegendButton(
          title: 'Company status',
          items: const [
            StatusLegendItem(
              label: 'Active',
              status: 'active',
              type: StatusType.company,
            ),
            StatusLegendItem(
              label: 'Pending',
              status: 'pending',
              type: StatusType.company,
            ),
            StatusLegendItem(
              label: 'Inactive',
              status: 'inactive',
              type: StatusType.company,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCompanyDetails() {
    final company = _selected!;
    final status = company.status ?? 'unknown';
    return Padding(
      padding: const EdgeInsets.all(SomSpacing.md),
      child: ListView(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  company.name ?? 'Company',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              StatusBadge.company(status: status),
            ],
          ),
          const SizedBox(height: SomSpacing.sm),
          SomMetaText('ID ${SomFormatters.shortId(company.id)}'),
          const SizedBox(height: SomSpacing.md),
          DetailSection(
            title: 'Company details',
            iconAsset: SomAssets.iconInfo,
            child: DetailGrid(
              items: [
                DetailItem(label: 'Status', value: SomFormatters.capitalize(status)),
                DetailItem(label: 'Type', value: _companyTypeLabel(company)),
                DetailItem(
                  label: 'Website',
                  value: company.websiteUrl,
                ),
                DetailItem(
                  label: 'Size',
                  value: _companySizeLabel(_companySize),
                ),
              ],
            ),
          ),
          const SizedBox(height: SomSpacing.md),
          DetailSection(
            title: 'Edit company',
            iconAsset: SomAssets.iconEdit,
            child: Column(
              children: [
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
                  onChanged: (value) =>
                      setState(() => _companySize = value ?? 0),
                ),
              ],
            ),
          ),
          const SizedBox(height: SomSpacing.md),
          DetailSection(
            title: 'Address',
            iconAsset: SomAssets.iconSettings,
            child: Column(
              children: [
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
              ],
            ),
          ),
          const SizedBox(height: SomSpacing.md),
          Wrap(
            spacing: SomSpacing.sm,
            runSpacing: SomSpacing.sm,
            children: [
              FilledButton(
                onPressed: _saveCompany,
                child: const Text('Save'),
              ),
              if ((company.id != null && (company.status ?? 'active') == 'inactive'))
                FilledButton.tonal(
                  onPressed: _activateCompany,
                  child: const Text('Activate'),
                )
              else
                OutlinedButton(
                  onPressed: _deactivateCompany,
                  child: const Text('Deactivate'),
                ),
            ],
          ),
        ],
      ),
    );
  }

  String _companySizeLabel(int size) {
    return switch (size) {
      0 => '0-10',
      1 => '11-50',
      2 => '51-100',
      3 => '101-250',
      4 => '251-500',
      5 => '500+',
      _ => 'Unknown',
    };
  }
}
