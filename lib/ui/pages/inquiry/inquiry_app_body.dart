import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:openapi/openapi.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../domain/application/application.dart';
import '../../domain/model/layout/app_body.dart';

const _apiBaseUrl = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: 'http://127.0.0.1:8081',
);

class InquiryAppBody extends StatefulWidget {
  const InquiryAppBody({Key? key}) : super(key: key);

  @override
  State<InquiryAppBody> createState() => _InquiryAppBodyState();
}

class _InquiryAppBodyState extends State<InquiryAppBody> {
  final _deliveryZipsController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _providerZipController = TextEditingController();
  final _contactSalutationController = TextEditingController();
  final _contactTitleController = TextEditingController();
  final _contactFirstNameController = TextEditingController();
  final _contactLastNameController = TextEditingController();
  final _contactTelephoneController = TextEditingController();
  final _contactEmailController = TextEditingController();

  Future<List<Inquiry>>? _inquiriesFuture;
  List<Inquiry> _inquiries = const [];
  Inquiry? _selectedInquiry;
  List<Offer> _offers = const [];
  bool _loadingOffers = false;
  String? _offersError;
  String? _inquiriesError;

  bool _bootstrapped = false;
  List<Branch> _branches = const [];
  List<UserDto> _companyUsers = const [];

  String? _statusFilter;
  String? _branchIdFilter;
  String? _branchNameFilter;
  String? _providerTypeFilter;
  String? _providerSizeFilter;
  DateTime? _createdFrom;
  DateTime? _createdTo;
  DateTime? _deadlineFrom;
  DateTime? _deadlineTo;
  String? _editorFilter;

  String? _selectedBranchId;
  String? _selectedCategoryId;
  List<String> _productTags = [];
  DateTime? _deadline;
  int _numberOfProviders = 1;
  String? _providerType;
  String? _providerCompanySize;
  int? _radiusKm;
  PlatformFile? _selectedPdf;

  bool _showCreateForm = false;
  bool _creating = false;

  @override
  void dispose() {
    _deliveryZipsController.dispose();
    _descriptionController.dispose();
    _providerZipController.dispose();
    _contactSalutationController.dispose();
    _contactTitleController.dispose();
    _contactFirstNameController.dispose();
    _contactLastNameController.dispose();
    _contactTelephoneController.dispose();
    _contactEmailController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _inquiriesFuture ??= _loadInquiries();
    if (!_bootstrapped) {
      _bootstrapped = true;
      _bootstrap();
    }
    final createParam = Uri.base.queryParameters['create'];
    if (createParam == 'true') {
      _showCreateForm = true;
    }
  }

  Future<void> _bootstrap() async {
    final appStore = Provider.of<Application>(context, listen: false);
    final api = Provider.of<Openapi>(context, listen: false);
    try {
      final branchResponse = await api.getBranchesApi().branchesGet();
      setState(() {
        _branches = branchResponse.data?.toList() ?? const [];
      });
    } catch (_) {}

    if (appStore.authorization?.companyId != null) {
      try {
        final usersResponse = await api.getUsersApi().companiesCompanyIdUsersGet(
              companyId: appStore.authorization!.companyId!,
              headers: _authHeader(appStore.authorization?.token),
            );
        setState(() {
          _companyUsers = usersResponse.data?.toList() ?? const [];
        });
      } catch (_) {}
    }

    if (appStore.authorization?.userId != null &&
        appStore.authorization?.token != null) {
      try {
        final profile = await api.getUsersApi().usersLoadUserWithCompanyGet(
          userId: appStore.authorization!.userId!,
          headers: _authHeader(appStore.authorization?.token),
        );
        final data = profile.data;
        if (data != null) {
          setState(() {
            _contactSalutationController.text = data.salutation ?? '';
            _contactTitleController.text = data.title ?? '';
            _contactFirstNameController.text = data.firstName ?? '';
            _contactLastNameController.text = data.lastName ?? '';
            _contactTelephoneController.text = data.telephoneNr ?? '';
            _contactEmailController.text =
                data.emailAddress ?? appStore.authorization?.emailAddress ?? '';
          });
        }
      } catch (_) {}
    }
  }

  Future<List<Inquiry>> _loadInquiries() async {
    final api = Provider.of<Openapi>(context, listen: false);
    try {
      final response = await api.getInquiriesApi().inquiriesGet(
            status: _statusFilter,
            branchId: _branchIdFilter,
            branch: _branchNameFilter,
            providerType: _providerTypeFilter,
            providerSize: _providerSizeFilter,
            createdFrom: _createdFrom,
            createdTo: _createdTo,
            deadlineFrom: _deadlineFrom,
            deadlineTo: _deadlineTo,
            editorIds: _editorFilter,
          );
      final list = response.data?.toList() ?? const [];
      _inquiries = list;
      _inquiriesError = null;
      return list;
    } on DioException catch (error) {
      final message = error.response?.data?.toString() ?? '';
      if (error.response?.statusCode == 403 &&
          message.contains('Provider registration')) {
        setState(() {
          _inquiriesError =
              'Provider registration is pending. Inquiries will appear once approved.';
        });
        return const [];
      }
      rethrow;
    }
  }

  Future<void> _refresh() async {
    setState(() {
      _inquiriesFuture = _loadInquiries();
    });
  }

  Future<void> _selectInquiry(Inquiry inquiry) async {
    setState(() {
      _selectedInquiry = inquiry;
      _offers = const [];
      _offersError = null;
    });
    await _loadOffers(inquiry.id);
  }

  Future<void> _loadOffers(String? inquiryId) async {
    if (inquiryId == null) return;
    setState(() {
      _loadingOffers = true;
      _offersError = null;
    });
    final api = Provider.of<Openapi>(context, listen: false);
    try {
      final response = await api
          .getOffersApi()
          .inquiriesInquiryIdOffersGet(inquiryId: inquiryId);
      setState(() {
        _offers = response.data?.toList() ?? const [];
      });
    } catch (error) {
      setState(() {
        _offersError = error.toString();
      });
    } finally {
      setState(() {
        _loadingOffers = false;
      });
    }
  }

  Future<void> _toggleCreate() async {
    setState(() {
      _showCreateForm = !_showCreateForm;
    });
  }

  Future<void> _pickPdf() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      withData: true,
    );
    if (result == null || result.files.isEmpty) return;
    setState(() {
      _selectedPdf = result.files.first;
    });
  }

  Future<void> _submitInquiry() async {
    if (_selectedBranchId == null || _selectedCategoryId == null) {
      _showSnack('Please select branch and category.');
      return;
    }
    if (_deadline == null) {
      _showSnack('Please select a deadline.');
      return;
    }
    final zips = _deliveryZipsController.text
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
    if (zips.isEmpty) {
      _showSnack('Please add delivery ZIP codes.');
      return;
    }
    setState(() {
      _creating = true;
    });

    final api = Provider.of<Openapi>(context, listen: false);
    try {
      final request = CreateInquiryRequest((b) => b
        ..branchId = _selectedBranchId!
        ..categoryId = _selectedCategoryId!
        ..deadline = _deadline!
        ..deliveryZips.replace(zips)
        ..numberOfProviders = _numberOfProviders
        ..description = _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim()
        ..productTags.replace(_productTags)
        ..providerZip = _providerZipController.text.trim().isEmpty
            ? null
            : _providerZipController.text.trim()
        ..radiusKm = _radiusKm
        ..providerType = _providerType
        ..providerCompanySize = _providerCompanySize
        ..salutation = _contactSalutationController.text.trim().isEmpty
            ? null
            : _contactSalutationController.text.trim()
        ..title = _contactTitleController.text.trim().isEmpty
            ? null
            : _contactTitleController.text.trim()
        ..firstName = _contactFirstNameController.text.trim().isEmpty
            ? null
            : _contactFirstNameController.text.trim()
        ..lastName = _contactLastNameController.text.trim().isEmpty
            ? null
            : _contactLastNameController.text.trim()
        ..telephone = _contactTelephoneController.text.trim().isEmpty
            ? null
            : _contactTelephoneController.text.trim()
        ..email = _contactEmailController.text.trim().isEmpty
            ? null
            : _contactEmailController.text.trim());

      final response = await api
          .getInquiriesApi()
          .createInquiry(createInquiryRequest: request);
      final inquiry = response.data;
      if (inquiry?.id != null && _selectedPdf?.bytes != null) {
        await api.getInquiriesApi().inquiriesInquiryIdPdfPost(
              inquiryId: inquiry!.id!,
              file: MultipartFile.fromBytes(
                _selectedPdf!.bytes!,
                filename: _selectedPdf!.name,
              ),
            );
      }
      _showSnack('Inquiry created.');
      setState(() {
        _showCreateForm = false;
        _selectedPdf = null;
        _productTags = [];
        _deliveryZipsController.clear();
        _descriptionController.clear();
        _providerZipController.clear();
      });
      await _refresh();
    } catch (error) {
      _showSnack('Failed to create inquiry: $error');
    } finally {
      setState(() {
        _creating = false;
      });
    }
  }

  Future<void> _uploadOffer() async {
    if (_selectedInquiry?.id == null) return;
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      withData: true,
    );
    if (result == null || result.files.isEmpty) return;
    final file = result.files.first;
    if (file.bytes == null) return;
    final api = Provider.of<Openapi>(context, listen: false);
    await api.getOffersApi().inquiriesInquiryIdOffersPost(
          inquiryId: _selectedInquiry!.id!,
          file: MultipartFile.fromBytes(file.bytes!, filename: file.name),
        );
    _showSnack('Offer uploaded.');
    await _loadOffers(_selectedInquiry!.id);
    await _refresh();
  }

  Future<void> _ignoreInquiry() async {
    if (_selectedInquiry?.id == null) return;
    final api = Provider.of<Openapi>(context, listen: false);
    await api.getInquiriesApi().inquiriesInquiryIdIgnorePost(
          inquiryId: _selectedInquiry!.id!,
        );
    _showSnack('Inquiry ignored.');
    await _refresh();
  }

  Future<void> _acceptOffer(Offer offer) async {
    if (offer.id == null) return;
    final api = Provider.of<Openapi>(context, listen: false);
    await api.getOffersApi().offersOfferIdAcceptPost(offerId: offer.id!);
    await _loadOffers(_selectedInquiry?.id);
    await _refresh();
  }

  Future<void> _rejectOffer(Offer offer) async {
    if (offer.id == null) return;
    final api = Provider.of<Openapi>(context, listen: false);
    await api.getOffersApi().offersOfferIdRejectPost(offerId: offer.id!);
    await _loadOffers(_selectedInquiry?.id);
    await _refresh();
  }

  Future<void> _exportCsv() async {
    final uri = Uri.parse(_apiBaseUrl).replace(
      path: '/inquiries',
      queryParameters: {
        if (_statusFilter != null) 'status': _statusFilter,
        if (_branchIdFilter != null) 'branchId': _branchIdFilter,
        if (_branchNameFilter != null) 'branch': _branchNameFilter,
        if (_providerTypeFilter != null) 'providerType': _providerTypeFilter,
        if (_providerSizeFilter != null) 'providerSize': _providerSizeFilter,
        if (_createdFrom != null) 'createdFrom': _createdFrom!.toIso8601String(),
        if (_createdTo != null) 'createdTo': _createdTo!.toIso8601String(),
        if (_deadlineFrom != null)
          'deadlineFrom': _deadlineFrom!.toIso8601String(),
        if (_deadlineTo != null)
          'deadlineTo': _deadlineTo!.toIso8601String(),
        if (_editorFilter != null) 'editorIds': _editorFilter,
        'format': 'csv',
      },
    );
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  Future<void> _assignProviders() async {
    if (_selectedInquiry?.id == null) return;
    final appStore = Provider.of<Application>(context, listen: false);
    if (appStore.authorization?.isConsultant != true) return;

    final providers = await _loadProvidersDialog();
    if (providers == null || providers.isEmpty) return;

    final api = Provider.of<Openapi>(context, listen: false);
    try {
      await api.getInquiriesApi().inquiriesInquiryIdAssignPost(
            inquiryId: _selectedInquiry!.id!,
            inquiriesInquiryIdAssignPostRequest:
                InquiriesInquiryIdAssignPostRequest((b) => b
                  ..providerCompanyIds.replace(providers
                      .map((provider) => provider.companyId)
                      .whereType<String>()
                      .toList())),
          );
      _showSnack('Inquiry forwarded to providers.');
    } on DioException catch (error) {
      final message = error.response?.data?.toString() ?? error.message ?? '';
      _showSnack(
        message.isEmpty ? 'Failed to assign providers.' : message,
      );
    }
    await _refresh();
  }

  Future<void> _closeInquiry() async {
    if (_selectedInquiry?.id == null) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Close inquiry'),
        content: const Text('Are you sure you want to close this inquiry?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Close'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    final api = Provider.of<Openapi>(context, listen: false);
    await api
        .getInquiriesApi()
        .inquiriesInquiryIdClosePost(inquiryId: _selectedInquiry!.id!);
    _showSnack('Inquiry closed.');
    await _refresh();
  }

  Future<void> _removeAttachment() async {
    if (_selectedInquiry?.id == null || _selectedInquiry?.pdfPath == null) {
      return;
    }
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove attachment'),
        content: const Text('Remove the attached PDF from this inquiry?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    final api = Provider.of<Openapi>(context, listen: false);
    await api
        .getInquiriesApi()
        .inquiriesInquiryIdPdfDelete(inquiryId: _selectedInquiry!.id!);
    _showSnack('Attachment removed.');
    await _refresh();
  }

  Future<List<ProviderSummary>?> _loadProvidersDialog() async {
    return showDialog<List<ProviderSummary>>(
      context: context,
      builder: (context) {
        String? branchId;
        String? companySize;
        String? providerType;
        String? zipPrefix;
        final selected = <String>{};
        final maxProviders = _selectedInquiry?.numberOfProviders ?? 0;
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            final overLimit =
                maxProviders > 0 && selected.length > maxProviders;
            return AlertDialog(
              title: const Text('Select providers'),
              content: SizedBox(
                width: 600,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        DropdownButton<String>(
                          hint: const Text('Branch'),
                          value: branchId,
                          items: _branches
                              .map((branch) => DropdownMenuItem(
                                    value: branch.id,
                                    child: Text(branch.name ?? branch.id ?? '-'),
                                  ))
                              .toList(),
                          onChanged: (value) =>
                              setStateDialog(() => branchId = value),
                        ),
                        DropdownButton<String>(
                          hint: const Text('Provider type'),
                          value: providerType,
                          items: const [
                            DropdownMenuItem(value: 'haendler', child: Text('Händler')),
                            DropdownMenuItem(value: 'hersteller', child: Text('Hersteller')),
                            DropdownMenuItem(value: 'dienstleister', child: Text('Dienstleister')),
                            DropdownMenuItem(value: 'grosshaendler', child: Text('Großhändler')),
                          ],
                          onChanged: (value) =>
                              setStateDialog(() => providerType = value),
                        ),
                        DropdownButton<String>(
                          hint: const Text('Company size'),
                          value: companySize,
                          items: const [
                            DropdownMenuItem(value: '0-10', child: Text('0-10')),
                            DropdownMenuItem(value: '11-50', child: Text('11-50')),
                            DropdownMenuItem(value: '51-100', child: Text('51-100')),
                            DropdownMenuItem(value: '101-250', child: Text('101-250')),
                            DropdownMenuItem(value: '251-500', child: Text('251-500')),
                            DropdownMenuItem(value: '500+', child: Text('500+')),
                          ],
                          onChanged: (value) =>
                              setStateDialog(() => companySize = value),
                        ),
                        SizedBox(
                          width: 120,
                          child: TextField(
                            decoration: const InputDecoration(labelText: 'ZIP prefix'),
                            onChanged: (value) =>
                                setStateDialog(() => zipPrefix = value.trim()),
                          ),
                        ),
                        TextButton(
                          onPressed: () => setStateDialog(() {}),
                          child: const Text('Refresh'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    if (overLimit)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text(
                          'Selection exceeds allowed providers ($maxProviders).',
                          style: const TextStyle(color: Colors.orangeAccent),
                        ),
                      ),
                    Expanded(
                      child: FutureBuilder<List<ProviderSummary>>(
                        future: _loadProviders(
                          branchId: branchId,
                          companySize: companySize,
                          providerType: providerType,
                          zipPrefix: zipPrefix,
                        ),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          }
                          if (snapshot.hasError) {
                            return Text('Failed to load providers: ${snapshot.error}');
                          }
                          final providers = snapshot.data ?? const [];
                          if (providers.isEmpty) {
                            return const Text('No providers match filters.');
                          }
                          return ListView.builder(
                            itemCount: providers.length,
                            itemBuilder: (context, index) {
                              final provider = providers[index];
                              final id = provider.companyId ?? 'unknown';
                              final checked = selected.contains(id);
                              return CheckboxListTile(
                                value: checked,
                                onChanged: (value) {
                                  setStateDialog(() {
                                    if (value == true) {
                                      selected.add(id);
                                    } else {
                                      selected.remove(id);
                                    }
                                  });
                                },
                                title: Text(provider.companyName ?? id),
                                subtitle: Text(
                                  'Branch: ${provider.branchIds?.join(', ') ?? '-'} | '
                                  'Type: ${provider.providerType ?? '-'} | '
                                  'Size: ${provider.companySize ?? '-'}',
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: selected.isEmpty || overLimit
                      ? null
                      : () {
                          Navigator.of(context).pop(
                            selected
                                .map((id) => ProviderSummary((b) => b..companyId = id))
                                .toList(),
                          );
                        },
                  child: const Text('Assign'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<List<ProviderSummary>> _loadProviders({
    String? branchId,
    String? companySize,
    String? providerType,
    String? zipPrefix,
  }) async {
    final api = Provider.of<Openapi>(context, listen: false);
    final response = await api.getProvidersApi().providersGet(
          branchId: branchId,
          companySize: companySize,
          providerType: providerType,
          zipPrefix: zipPrefix,
        );
    return response.data?.toList() ?? const [];
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appStore = Provider.of<Application>(context);
    if (appStore.authorization == null) {
      return const AppBody(
        contextMenu: Text('Login required'),
        leftSplit: Center(child: Text('Please log in to view inquiries.')),
        rightSplit: SizedBox.shrink(),
      );
    }

    return FutureBuilder<List<Inquiry>>(
      future: _inquiriesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const AppBody(
            contextMenu: Text('Loading'),
            leftSplit: Center(child: CircularProgressIndicator()),
            rightSplit: SizedBox.shrink(),
          );
        }
        if (_inquiriesError != null) {
          return AppBody(
            contextMenu: const Text('Inquiries'),
            leftSplit: Center(child: Text(_inquiriesError!)),
            rightSplit: const SizedBox.shrink(),
          );
        }
        if (snapshot.hasError) {
          return AppBody(
            contextMenu: const Text('Error'),
            leftSplit: Center(
              child: Text('Failed to load inquiries: ${snapshot.error}'),
            ),
            rightSplit: const SizedBox.shrink(),
          );
        }
        final inquiries = snapshot.data ?? const [];
        return AppBody(
          contextMenu: Row(
            children: [
              Text('Inquiries', style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(width: 12),
              TextButton(onPressed: _refresh, child: const Text('Refresh')),
              TextButton(onPressed: _exportCsv, child: const Text('Export CSV')),
              if (appStore.authorization?.isBuyer == true)
                TextButton(
                  onPressed: _toggleCreate,
                  child: Text(_showCreateForm ? 'Close form' : 'New inquiry'),
                ),
            ],
          ),
          leftSplit: Column(
            children: [
              _buildFilters(appStore),
              const Divider(height: 1),
              Expanded(
                child: ListView.builder(
                  itemCount: inquiries.length,
                  itemBuilder: (context, index) {
                    final inquiry = inquiries[index];
                    return ListTile(
                      title: Text(inquiry.id ?? 'Inquiry'),
                      subtitle: Text(
                        'Status: ${inquiry.status ?? '-'} | Branch: ${inquiry.branchId ?? '-'}',
                      ),
                      selected: _selectedInquiry?.id == inquiry.id,
                      onTap: () => _selectInquiry(inquiry),
                    );
                  },
                ),
              ),
            ],
          ),
          rightSplit: _showCreateForm
              ? _buildCreateForm(appStore)
              : _buildDetails(appStore),
        );
      },
    );
  }

  Widget _buildFilters(Application appStore) {
    return ExpansionTile(
      title: const Text('Filters'),
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              DropdownButton<String>(
                hint: const Text('Status'),
                value: _statusFilter,
                items: _statusOptions(appStore)
                    .map((status) => DropdownMenuItem(
                          value: status,
                          child: Text(status),
                        ))
                    .toList(),
                onChanged: (value) => setState(() => _statusFilter = value),
              ),
              DropdownButton<String>(
                hint: const Text('Branch'),
                value: _branchIdFilter,
                items: _branches
                    .map((branch) => DropdownMenuItem(
                          value: branch.id,
                          child: Text(branch.name ?? branch.id ?? '-'),
                        ))
                    .toList(),
                onChanged: (value) => setState(() => _branchIdFilter = value),
              ),
              SizedBox(
                width: 160,
                child: TextField(
                  decoration: const InputDecoration(labelText: 'Branch (text)'),
                  onChanged: (value) =>
                      setState(() => _branchNameFilter = value.trim()),
                ),
              ),
              DropdownButton<String>(
                hint: const Text('Provider type'),
                value: _providerTypeFilter,
                items: const [
                  DropdownMenuItem(value: 'haendler', child: Text('Händler')),
                  DropdownMenuItem(value: 'hersteller', child: Text('Hersteller')),
                  DropdownMenuItem(value: 'dienstleister', child: Text('Dienstleister')),
                  DropdownMenuItem(value: 'grosshaendler', child: Text('Großhändler')),
                ],
                onChanged: (value) => setState(() => _providerTypeFilter = value),
              ),
              DropdownButton<String>(
                hint: const Text('Provider size'),
                value: _providerSizeFilter,
                items: const [
                  DropdownMenuItem(value: '0-10', child: Text('0-10')),
                  DropdownMenuItem(value: '11-50', child: Text('11-50')),
                  DropdownMenuItem(value: '51-100', child: Text('51-100')),
                  DropdownMenuItem(value: '101-250', child: Text('101-250')),
                  DropdownMenuItem(value: '251-500', child: Text('251-500')),
                  DropdownMenuItem(value: '500+', child: Text('500+')),
                ],
                onChanged: (value) => setState(() => _providerSizeFilter = value),
              ),
              _dateFilterButton(
                label: 'Created from',
                value: _createdFrom,
                onSelected: (value) => setState(() => _createdFrom = value),
              ),
              _dateFilterButton(
                label: 'Created to',
                value: _createdTo,
                onSelected: (value) => setState(() => _createdTo = value),
              ),
              _dateFilterButton(
                label: 'Deadline from',
                value: _deadlineFrom,
                onSelected: (value) => setState(() => _deadlineFrom = value),
              ),
              _dateFilterButton(
                label: 'Deadline to',
                value: _deadlineTo,
                onSelected: (value) => setState(() => _deadlineTo = value),
              ),
              if (appStore.authorization?.isAdmin == true)
                DropdownButton<String>(
                  hint: const Text('Editor'),
                  value: _editorFilter,
                  items: _companyUsers
                      .map((user) => DropdownMenuItem(
                            value: user.id,
                            child: Text(user.email ?? user.id ?? '-'),
                          ))
                      .toList(),
                  onChanged: (value) => setState(() => _editorFilter = value),
                ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _statusFilter = null;
                    _branchIdFilter = null;
                    _branchNameFilter = null;
                    _providerTypeFilter = null;
                    _providerSizeFilter = null;
                    _createdFrom = null;
                    _createdTo = null;
                    _deadlineFrom = null;
                    _deadlineTo = null;
                    _editorFilter = null;
                  });
                  _refresh();
                },
                child: const Text('Clear'),
              ),
              ElevatedButton(
                onPressed: _refresh,
                child: const Text('Apply'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  List<String> _statusOptions(Application appStore) {
    if (appStore.authorization?.isProvider == true) {
      return const ['open', 'offer_created', 'lost', 'won', 'ignored'];
    }
    return const ['open', 'closed', 'draft', 'expired'];
  }

  Widget _dateFilterButton({
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
      child: Text(value == null ? label : '$label: ${value.toIso8601String().split('T').first}'),
    );
  }

  Widget _buildCreateForm(Application appStore) {
    final categories = _branches
        .firstWhere((branch) => branch.id == _selectedBranchId,
            orElse: () => Branch())
        .categories
        ?.toList();
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView(
        children: [
          Text('Create inquiry',
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          DropdownButton<String>(
            hint: const Text('Branch'),
            value: _selectedBranchId,
            items: _branches
                .map((branch) => DropdownMenuItem(
                      value: branch.id,
                      child: Text(branch.name ?? branch.id ?? '-'),
                    ))
                .toList(),
            onChanged: (value) => setState(() {
              _selectedBranchId = value;
              _selectedCategoryId = null;
            }),
          ),
          DropdownButton<String>(
            hint: const Text('Category'),
            value: _selectedCategoryId,
            items: (categories ?? const [])
                .map((category) => DropdownMenuItem(
                      value: category.id,
                      child: Text(category.name ?? category.id ?? '-'),
                    ))
                .toList(),
            onChanged: (value) => setState(() => _selectedCategoryId = value),
          ),
          const SizedBox(height: 8),
          TextField(
            decoration: const InputDecoration(
              labelText: 'Product tags (comma separated)',
            ),
            onChanged: (value) {
              setState(() {
                _productTags = value
                    .split(',')
                    .map((e) => e.trim())
                    .where((e) => e.isNotEmpty)
                    .toList();
              });
            },
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: _deadline ?? DateTime.now().add(const Duration(days: 3)),
                firstDate: DateTime.now(),
                lastDate: DateTime(2100),
              );
              if (picked != null) {
                setState(() => _deadline = picked);
              }
            },
            child: Text(_deadline == null
                ? 'Select deadline'
                : 'Deadline: ${_deadline!.toIso8601String().split('T').first}'),
          ),
          TextField(
            controller: _deliveryZipsController,
            decoration: const InputDecoration(
              labelText: 'Delivery ZIPs (comma separated)',
            ),
          ),
          const SizedBox(height: 8),
          DropdownButton<int>(
            value: _numberOfProviders,
            items: List.generate(10, (index) => index + 1)
                .map((value) => DropdownMenuItem(
                      value: value,
                      child: Text(value.toString()),
                    ))
                .toList(),
            onChanged: (value) =>
                setState(() => _numberOfProviders = value ?? 1),
          ),
          TextField(
            controller: _descriptionController,
            maxLines: 3,
            decoration: const InputDecoration(labelText: 'Description'),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _providerZipController,
            decoration: const InputDecoration(labelText: 'Provider ZIP (optional)'),
          ),
          DropdownButton<int>(
            hint: const Text('Radius km'),
            value: _radiusKm,
            items: const [
              DropdownMenuItem(value: 50, child: Text('50km')),
              DropdownMenuItem(value: 150, child: Text('150km')),
              DropdownMenuItem(value: 250, child: Text('250km')),
            ],
            onChanged: (value) => setState(() => _radiusKm = value),
          ),
          DropdownButton<String>(
            hint: const Text('Provider type'),
            value: _providerType,
            items: const [
              DropdownMenuItem(value: 'haendler', child: Text('Händler')),
              DropdownMenuItem(value: 'hersteller', child: Text('Hersteller')),
              DropdownMenuItem(value: 'dienstleister', child: Text('Dienstleister')),
              DropdownMenuItem(value: 'grosshaendler', child: Text('Großhändler')),
            ],
            onChanged: (value) => setState(() => _providerType = value),
          ),
          DropdownButton<String>(
            hint: const Text('Provider size'),
            value: _providerCompanySize,
            items: const [
              DropdownMenuItem(value: '0-10', child: Text('0-10')),
              DropdownMenuItem(value: '11-50', child: Text('11-50')),
              DropdownMenuItem(value: '51-100', child: Text('51-100')),
              DropdownMenuItem(value: '101-250', child: Text('101-250')),
              DropdownMenuItem(value: '251-500', child: Text('251-500')),
              DropdownMenuItem(value: '500+', child: Text('500+')),
            ],
            onChanged: (value) => setState(() => _providerCompanySize = value),
          ),
          const Divider(height: 24),
          Text('Contact info', style: Theme.of(context).textTheme.titleSmall),
          TextField(
            controller: _contactSalutationController,
            decoration: const InputDecoration(labelText: 'Salutation'),
          ),
          TextField(
            controller: _contactTitleController,
            decoration: const InputDecoration(labelText: 'Title'),
          ),
          TextField(
            controller: _contactFirstNameController,
            decoration: const InputDecoration(labelText: 'First name'),
          ),
          TextField(
            controller: _contactLastNameController,
            decoration: const InputDecoration(labelText: 'Last name'),
          ),
          TextField(
            controller: _contactTelephoneController,
            decoration: const InputDecoration(labelText: 'Telephone'),
          ),
          TextField(
            controller: _contactEmailController,
            decoration: const InputDecoration(labelText: 'Email'),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              TextButton(
                onPressed: _pickPdf,
                child: Text(_selectedPdf == null
                    ? 'Attach PDF'
                    : 'PDF: ${_selectedPdf!.name}'),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: _creating ? null : _submitInquiry,
                child: _creating
                    ? const SizedBox(
                        height: 16,
                        width: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Create inquiry'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetails(Application appStore) {
    if (_selectedInquiry == null) {
      return const Center(child: Text('Select an inquiry to view details.'));
    }
    final inquiry = _selectedInquiry!;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView(
        children: [
          Text('Inquiry ${inquiry.id ?? ''}',
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Text('Status: ${inquiry.status ?? '-'}'),
          Text('Branch: ${inquiry.branchId ?? '-'}'),
          Text('Category: ${inquiry.categoryId ?? '-'}'),
          Text('Deadline: ${inquiry.deadline?.toIso8601String() ?? '-'}'),
          Text('Created: ${inquiry.createdAt?.toIso8601String() ?? '-'}'),
          if (inquiry.assignedAt != null)
            Text('Assigned: ${inquiry.assignedAt?.toIso8601String() ?? '-'}'),
          if (inquiry.closedAt != null)
            Text('Closed: ${inquiry.closedAt?.toIso8601String() ?? '-'}'),
          if (inquiry.pdfPath != null) ...[
            const SizedBox(height: 8),
            Wrap(
              spacing: 12,
              children: [
                TextButton(
                  onPressed: () => launchUrl(Uri.parse(inquiry.pdfPath!)),
                  child: const Text('Download inquiry PDF'),
                ),
                if (appStore.authorization?.isBuyer == true ||
                    appStore.authorization?.isConsultant == true)
                  TextButton(
                    onPressed: _removeAttachment,
                    child: const Text('Remove attachment'),
                  ),
              ],
            ),
          ],
          const Divider(height: 24),
          if (appStore.authorization?.isProvider == true) ...[
            Row(
              children: [
                TextButton(
                  onPressed: _uploadOffer,
                  child: const Text('Upload offer'),
                ),
                TextButton(
                  onPressed: _ignoreInquiry,
                  child: const Text('I don\'t want to make an offer'),
                ),
              ],
            ),
          ],
          if (appStore.authorization?.isConsultant == true) ...[
            TextButton(
              onPressed: _assignProviders,
              child: const Text('Assign providers'),
            ),
          ],
          if (appStore.authorization?.isBuyer == true ||
              appStore.authorization?.isConsultant == true) ...[
            if ((inquiry.status ?? '').toLowerCase() != 'closed')
              TextButton(
                onPressed: _closeInquiry,
                child: const Text('Close inquiry'),
              ),
          ],
          const Divider(height: 24),
          Text('Offers', style: Theme.of(context).textTheme.titleSmall),
          if (_loadingOffers) const LinearProgressIndicator(),
          if (_offersError != null) Text('Failed to load offers: $_offersError'),
          if (_offers.isEmpty && !_loadingOffers)
            const Text('No offers yet.'),
          ..._offers.map((offer) => Card(
                child: ListTile(
                  title: Text('Offer ${offer.id ?? ''}'),
                  subtitle: Text(
                    'Provider: ${offer.providerCompanyId ?? '-'} | '
                    'Status: ${offer.status ?? '-'}',
                  ),
                  trailing: Wrap(
                    spacing: 8,
                    children: [
                      if (offer.pdfPath != null)
                        TextButton(
                          onPressed: () => launchUrl(Uri.parse(offer.pdfPath!)),
                          child: const Text('PDF'),
                        ),
                      if (appStore.authorization?.isBuyer == true) ...[
                        TextButton(
                          onPressed: () => _acceptOffer(offer),
                          child: const Text('Accept'),
                        ),
                        TextButton(
                          onPressed: () => _rejectOffer(offer),
                          child: const Text('Reject'),
                        ),
                      ],
                    ],
                  ),
                ),
              )),
        ],
      ),
    );
  }
}

Map<String, String> _authHeader(String? token) {
  if (token == null || token.isEmpty) return {};
  return {'Authorization': 'Bearer $token'};
}
