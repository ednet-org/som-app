import 'package:flutter/material.dart';
import 'package:openapi/openapi.dart';
import 'package:provider/provider.dart';
import 'package:som/ui/domain/application/application.dart';

import '../../domain/model/model.dart';

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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _companyFuture ??= _loadCompany(context);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _websiteController.dispose();
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
    }
    _company = company;
    return company;
  }

  Future<void> _refresh() async {
    setState(() {
      _companyFuture = _loadCompany(context);
    });
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
          contextMenu: Row(
            children: [
              Text('Company', style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(width: 12),
              TextButton(onPressed: _refresh, child: const Text('Refresh')),
              TextButton(onPressed: _updateCompany, child: const Text('Save')),
              TextButton(
                  onPressed: _deactivateCompany,
                  child: const Text('Deactivate')),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
              ],
            ),
          ),
        );
      },
    );
  }
}
