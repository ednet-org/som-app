import 'package:flutter/material.dart';
import 'package:openapi/openapi.dart';
import 'package:provider/provider.dart';
import 'package:som/ui/theme/som_assets.dart';
import 'package:som/ui/theme/tokens.dart';
import 'package:som/ui/utils/formatters.dart';
import 'package:som/ui/widgets/design_system/som_svg_icon.dart';
import 'package:som/ui/domain/application/application.dart';

import '../../domain/infrastructure/supabase_realtime.dart';
import '../../domain/model/model.dart' hide BankDetails, Address;
import '../../domain/model/layout/app_body.dart';
import '../../widgets/app_toolbar.dart';
import '../../widgets/detail_section.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/inline_message.dart';
import '../../widgets/meta_text.dart';

class CompanyAppBody extends StatefulWidget {
  const CompanyAppBody({super.key});

  @override
  State<CompanyAppBody> createState() => _CompanyAppBodyState();
}

class _CompanyAppBodyState extends State<CompanyAppBody> {
  Future<CompanyDto?>? _companyFuture;
  CompanyDto? _company;
  final _nameController = TextEditingController();
  final _websiteController = TextEditingController();
  final _ibanController = TextEditingController();
  final _bicController = TextEditingController();
  final _ownerController = TextEditingController();
  final _productController = TextEditingController();
  final _streetController = TextEditingController();
  final _numberController = TextEditingController();
  final _zipController = TextEditingController();
  final _cityController = TextEditingController();
  String? _selectedCountry;

  ProviderProfile? _providerProfile;
  List<Product> _products = const [];
  String? _providerError;
  bool _realtimeReady = false;
  late final RealtimeRefreshHandle _realtimeRefresh =
      RealtimeRefreshHandle(_handleRealtimeRefresh);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _companyFuture ??= _loadCompany(context);
    _setupRealtime();
  }

  @override
  void dispose() {
    _realtimeRefresh.dispose();
    _nameController.dispose();
    _websiteController.dispose();
    _ibanController.dispose();
    _bicController.dispose();
    _ownerController.dispose();
    _productController.dispose();
    _streetController.dispose();
    _numberController.dispose();
    _zipController.dispose();
    _cityController.dispose();
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
      tables: const ['companies', 'provider_profiles', 'products'],
      channelName: 'company-page',
    );
    _realtimeReady = true;
  }

  Future<CompanyDto?> _loadCompany(BuildContext context) async {
    final appStore = Provider.of<Application>(context, listen: false);
    final companyId = appStore.authorization?.companyId;
    if (companyId == null) return null;
    final api = Provider.of<Openapi>(context, listen: false);
    final response =
        await api.getCompaniesApi().companiesCompanyIdGet(companyId: companyId);
    final company = response.data;
    if (company != null) {
      _nameController.text = company.name ?? '';
      _websiteController.text = company.websiteUrl ?? '';
      if (company.address != null) {
        _streetController.text = company.address!.street;
        _numberController.text = company.address!.number;
        _zipController.text = company.address!.zip;
        _cityController.text = company.address!.city;
        _selectedCountry = company.address!.country;
      }
      if (_isProviderType(company)) {
        await _loadProviderExtras(api, companyId);
      }
    }
    _company = company;
    return company;
  }

  Future<void> _loadProviderExtras(Openapi api, String companyId) async {
    try {
      final profileResponse =
          await api.getProvidersApi().providersCompanyIdGet(companyId: companyId);
      _providerProfile = profileResponse.data;
      final bankDetails = _providerProfile?.bankDetails;
      if (bankDetails != null) {
        _ibanController.text = bankDetails.iban;
        _bicController.text = bankDetails.bic;
        _ownerController.text = bankDetails.accountOwner;
      }
      final productsResponse = await api
          .getProvidersApi()
          .providersCompanyIdProductsGet(companyId: companyId);
      _products = productsResponse.data?.toList() ?? const [];
    } catch (error) {
      _providerError = error.toString();
    }
  }

  Future<void> _refresh() async {
    setState(() {
      _companyFuture = _loadCompany(context);
    });
  }

  Future<void> _updatePaymentDetails() async {
    final company = _company;
    if (company?.id == null) return;
    final api = Provider.of<Openapi>(context, listen: false);
    try {
      await api.getProvidersApi().providersCompanyIdPaymentDetailsPut(
            companyId: company!.id!,
            bankDetails: BankDetails((b) => b
              ..iban = _ibanController.text.trim()
              ..bic = _bicController.text.trim()
              ..accountOwner = _ownerController.text.trim()),
          );
      await _refresh();
    } catch (error) {
      setState(() => _providerError = error.toString());
    }
  }

  Future<void> _addProduct() async {
    final company = _company;
    if (company?.id == null) return;
    final api = Provider.of<Openapi>(context, listen: false);
    try {
      await api.getProvidersApi().providersCompanyIdProductsPost(
            companyId: company!.id!,
            productInput: ProductInput((b) => b
              ..name = _productController.text.trim()),
          );
      _productController.clear();
      await _refresh();
    } catch (error) {
      setState(() => _providerError = error.toString());
    }
  }

  Future<void> _updateProduct(String productId, String name) async {
    final company = _company;
    if (company?.id == null) return;
    final api = Provider.of<Openapi>(context, listen: false);
    try {
      await api.getProvidersApi().providersCompanyIdProductsProductIdPut(
            companyId: company!.id!,
            productId: productId,
            productInput: ProductInput((b) => b..name = name),
          );
      await _refresh();
    } catch (error) {
      setState(() => _providerError = error.toString());
    }
  }

  Future<void> _deleteProduct(String productId) async {
    final company = _company;
    if (company?.id == null) return;
    final api = Provider.of<Openapi>(context, listen: false);
    try {
      await api.getProvidersApi().providersCompanyIdProductsProductIdDelete(
            companyId: company!.id!,
            productId: productId,
          );
      await _refresh();
    } catch (error) {
      setState(() => _providerError = error.toString());
    }
  }

  Future<void> _updateCompany() async {
    final company = _company;
    if (company?.id == null) return;
    final api = Provider.of<Openapi>(context, listen: false);
    final updated = company!.rebuild((b) => b
      ..name = _nameController.text.trim()
      ..websiteUrl = _websiteController.text.trim()
      ..address.replace(Address((a) => a
        ..street = _streetController.text.trim()
        ..number = _numberController.text.trim()
        ..zip = _zipController.text.trim()
        ..city = _cityController.text.trim()
        ..country = _selectedCountry ?? company.address?.country ?? '')));
    await api
        .getCompaniesApi()
        .companiesCompanyIdPut(companyId: company.id!, companyDto: updated);
    await _refresh();
  }

  Future<void> _deactivateCompany() async {
    final company = _company;
    if (company?.id == null) return;
    final api = Provider.of<Openapi>(context, listen: false);
    await api
        .getCompaniesApi()
        .companiesCompanyIdDelete(companyId: company!.id!);
    await _refresh();
  }

  @override
  Widget build(BuildContext context) {
    final appStore = Provider.of<Application>(context);
    if (appStore.authorization == null) {
      return AppBody(
        contextMenu: AppToolbar(title: const Text('Company')),
        leftSplit: const EmptyState(
          asset: SomAssets.illustrationStateNoConnection,
          title: 'Login required',
          message: 'Please log in to view company data.',
        ),
        rightSplit: const SizedBox.shrink(),
      );
    }

    return FutureBuilder<CompanyDto?>(
      future: _companyFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return AppBody(
            contextMenu: AppToolbar(title: const Text('Company')),
            leftSplit: const Center(child: CircularProgressIndicator()),
            rightSplit: const SizedBox.shrink(),
          );
        }
        if (snapshot.hasError) {
          return AppBody(
            contextMenu: AppToolbar(title: const Text('Company')),
            leftSplit: Center(
              child: InlineMessage(
                message: 'Failed to load company: ${snapshot.error}',
                type: InlineMessageType.error,
              ),
            ),
            rightSplit: const SizedBox.shrink(),
          );
        }
        final company = snapshot.data;
        if (company == null) {
          return AppBody(
            contextMenu: AppToolbar(title: const Text('Company')),
            leftSplit: const EmptyState(
              asset: SomAssets.emptySearchResults,
              title: 'No company data',
              message: 'No company details are available yet.',
            ),
            rightSplit: const SizedBox.shrink(),
          );
        }
        return AppBody(
          contextMenu: AppToolbar(
            title: const Text('Company'),
            actions: [
              FilledButton.tonal(
                onPressed: _updateCompany,
                child: const Text('Save'),
              ),
              OutlinedButton(
                onPressed: _deactivateCompany,
                child: const Text('Deactivate'),
              ),
            ],
          ),
          leftSplit: _buildCompanySummary(company),
          rightSplit: _buildCompanyEditor(company),
        );
      },
    );
  }

  Widget _buildCompanySummary(CompanyDto company) {
    return Padding(
      padding: const EdgeInsets.all(SomSpacing.md),
      child: ListView(
        children: [
          Text(
            company.name ?? 'Company',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: SomSpacing.xs),
          SomMetaText('ID ${SomFormatters.shortId(company.id)}'),
          const SizedBox(height: SomSpacing.md),
          DetailSection(
            title: 'Overview',
            iconAsset: SomAssets.iconInfo,
            child: DetailGrid(
              items: [
                DetailItem(label: 'UID', value: company.uidNr),
                DetailItem(label: 'Registration', value: company.registrationNr),
                DetailItem(label: 'Website', value: company.websiteUrl),
                DetailItem(
                  label: 'Company size',
                  value: company.companySize?.toString(),
                ),
                DetailItem(label: 'Type', value: company.type?.toString()),
              ],
            ),
          ),
          if (company.address != null) ...[
            const SizedBox(height: SomSpacing.md),
            DetailSection(
              title: 'Address',
              iconAsset: SomAssets.iconSettings,
              child: DetailGrid(
                items: [
                  DetailItem(
                    label: 'Street',
                    value:
                        '${company.address!.street} ${company.address!.number}',
                  ),
                  DetailItem(label: 'ZIP', value: company.address!.zip),
                  DetailItem(label: 'City', value: company.address!.city),
                  DetailItem(label: 'Country', value: company.address!.country),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCompanyEditor(CompanyDto company) {
    return Padding(
      padding: const EdgeInsets.all(SomSpacing.md),
      child: ListView(
        children: [
          DetailSection(
            title: 'Company profile',
            iconAsset: SomAssets.iconEdit,
            child: Column(
              children: [
                TextField(
                  controller: _nameController,
                  decoration:
                      const InputDecoration(labelText: 'Company name'),
                ),
                const SizedBox(height: SomSpacing.sm),
                TextField(
                  controller: _websiteController,
                  decoration: const InputDecoration(labelText: 'Website'),
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
                SomDropDown<String>(
                  value: _selectedCountry,
                  onChanged: (val) => setState(() => _selectedCountry = val),
                  hint: 'Select country',
                  label: 'Country',
                  items: countries,
                  showSearchBox: true,
                ),
                const SizedBox(height: SomSpacing.sm),
                TextField(
                  controller: _streetController,
                  decoration: const InputDecoration(labelText: 'Street'),
                ),
                const SizedBox(height: SomSpacing.sm),
                TextField(
                  controller: _numberController,
                  decoration: const InputDecoration(labelText: 'Number'),
                ),
                const SizedBox(height: SomSpacing.sm),
                TextField(
                  controller: _zipController,
                  decoration: const InputDecoration(labelText: 'ZIP / Postal code'),
                ),
                const SizedBox(height: SomSpacing.sm),
                TextField(
                  controller: _cityController,
                  decoration: const InputDecoration(labelText: 'City'),
                ),
              ],
            ),
          ),
          const SizedBox(height: SomSpacing.md),
          SomMetaText('Company ID ${SomFormatters.shortId(company.id)}'),
          if (_isProviderType(company)) ...[
            const SizedBox(height: SomSpacing.md),
            DetailSection(
              title: 'Payment details',
              iconAsset: SomAssets.iconSettings,
              child: Column(
                children: [
                  if (_providerError != null)
                    InlineMessage(
                      message: _providerError!,
                      type: InlineMessageType.error,
                    ),
                  const SizedBox(height: SomSpacing.sm),
                  TextField(
                    controller: _ibanController,
                    decoration: const InputDecoration(labelText: 'IBAN'),
                  ),
                  TextField(
                    controller: _bicController,
                    decoration: const InputDecoration(labelText: 'BIC/SWIFT'),
                  ),
                  TextField(
                    controller: _ownerController,
                    decoration:
                        const InputDecoration(labelText: 'Account owner'),
                  ),
                  const SizedBox(height: SomSpacing.sm),
                  FilledButton.tonal(
                    onPressed: _updatePaymentDetails,
                    child: const Text('Update payment details'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: SomSpacing.md),
            DetailSection(
              title: 'Products',
              iconAsset: SomAssets.iconOffers,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _productController,
                          decoration:
                              const InputDecoration(labelText: 'New product'),
                        ),
                      ),
                      const SizedBox(width: SomSpacing.sm),
                      FilledButton.tonal(
                        onPressed: _addProduct,
                        child: const Text('Add'),
                      ),
                    ],
                  ),
                  const SizedBox(height: SomSpacing.sm),
                  ..._products.map(
                    (product) => ListTile(
                      title: Text(product.name),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            tooltip: 'Edit product',
                            icon: SomSvgIcon(
                              SomAssets.iconEdit,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                            onPressed: () async {
                              final controller = TextEditingController(
                                text: product.name,
                              );
                              final updated = await showDialog<bool>(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Edit product'),
                                  content: TextField(controller: controller),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(false),
                                      child: const Text('Cancel'),
                                    ),
                                    FilledButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(true),
                                      child: const Text('Save'),
                                    ),
                                  ],
                                ),
                              );
                              if (updated == true &&
                                  product.id.isNotEmpty) {
                                await _updateProduct(
                                  product.id,
                                  controller.text.trim(),
                                );
                              }
                            },
                          ),
                          IconButton(
                            tooltip: 'Delete product',
                            icon: SomSvgIcon(
                              SomAssets.iconDelete,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                            onPressed: () => _deleteProduct(product.id),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  bool _isProviderType(CompanyDto company) {
    return company.type == 1 || company.type == 2;
  }
}
