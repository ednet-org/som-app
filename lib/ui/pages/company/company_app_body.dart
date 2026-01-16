import 'package:flutter/material.dart';
import 'package:openapi/openapi.dart';
import 'package:provider/provider.dart';
import 'package:som/ui/domain/application/application.dart';

import '../../domain/model/model.dart' hide BankDetails;
import '../../widgets/app_toolbar.dart';

class CompanyAppBody extends StatefulWidget {
  const CompanyAppBody({Key? key}) : super(key: key);

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

  ProviderProfile? _providerProfile;
  List<Product> _products = const [];
  String? _providerError;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _companyFuture ??= _loadCompany(context);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _websiteController.dispose();
    _ibanController.dispose();
    _bicController.dispose();
    _ownerController.dispose();
    _productController.dispose();
    super.dispose();
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
      ..websiteUrl = _websiteController.text.trim());
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
      return const AppBody(
        contextMenu: Text('Login required'),
        leftSplit: Center(child: Text('Please log in to view company data.')),
        rightSplit: SizedBox.shrink(),
      );
    }

    return FutureBuilder<CompanyDto?>(
      future: _companyFuture,
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
              child: Text('Failed to load company: ${snapshot.error}'),
            ),
            rightSplit: const SizedBox.shrink(),
          );
        }
        final company = snapshot.data;
        if (company == null) {
          return const AppBody(
            contextMenu: Text('Company'),
            leftSplit: Center(child: Text('No company data available.')),
            rightSplit: SizedBox.shrink(),
          );
        }
        return AppBody(
          contextMenu: AppToolbar(
            title: const Text('Company'),
            actions: [
              TextButton(onPressed: _refresh, child: const Text('Refresh')),
              FilledButton.tonal(
                onPressed: _updateCompany,
                child: const Text('Save'),
              ),
              TextButton(
                onPressed: _deactivateCompany,
                child: const Text('Deactivate'),
              ),
            ],
          ),
          leftSplit: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(company.name ?? 'Company'),
                const SizedBox(height: 8),
                Text('UID: ${company.uidNr ?? '-'}'),
                Text('Registration: ${company.registrationNr ?? '-'}'),
                Text('Website: ${company.websiteUrl ?? '-'}'),
                Text('Company size: ${company.companySize ?? '-'}'),
                Text('Type: ${company.type ?? '-'}'),
                if (company.address != null) ...[
                  const SizedBox(height: 8),
                  Text('Address: ${company.address!.street ?? ''} '
                      '${company.address!.number ?? ''}, '
                      '${company.address!.zip ?? ''} '
                      '${company.address!.city ?? ''}'),
                ],
              ],
            ),
          ),
          rightSplit: Padding(
            padding: const EdgeInsets.all(16),
            child: ListView(
              children: [
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Company name'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _websiteController,
                  decoration: const InputDecoration(labelText: 'Website'),
                ),
                const SizedBox(height: 12),
                Text('Company ID: ${company.id ?? '-'}'),
                if (_isProviderType(company)) ...[
                  const Divider(height: 32),
                  Text(
                    'Payment details',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  if (_providerError != null)
                    Text(
                      _providerError!,
                      style:
                          const TextStyle(color: Colors.redAccent),
                    ),
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
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: _updatePaymentDetails,
                    child: const Text('Update payment details'),
                  ),
                  const Divider(height: 32),
                  Text(
                    'Products',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _productController,
                          decoration: const InputDecoration(
                              labelText: 'New product'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        onPressed: _addProduct,
                        child: const Text('Add'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ..._products.map(
                    (product) => ListTile(
                      title: Text(product.name),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
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
                                    ElevatedButton(
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
                            icon: const Icon(Icons.delete_outline),
                            onPressed: () => _deleteProduct(product.id),
                          ),
                        ],
                      ),
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

  bool _isProviderType(CompanyDto company) {
    return company.type == 1 || company.type == 2;
  }
}
