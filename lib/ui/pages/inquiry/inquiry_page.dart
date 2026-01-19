import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:openapi/openapi.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../domain/application/application.dart';
import '../../domain/infrastructure/supabase_realtime.dart';
import '../../domain/model/layout/app_body.dart';
import '../../utils/ui_logger.dart';
import '../../widgets/app_toolbar.dart';
import 'widgets/inquiry_create_form.dart';
import 'widgets/inquiry_detail.dart';
import 'widgets/inquiry_filters.dart';
import 'widgets/inquiry_list.dart';
import 'widgets/provider_selection_dialog.dart';

const _apiBaseUrl = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: 'http://127.0.0.1:8081',
);

/// Main page for inquiry management.
///
/// Orchestrates the inquiry list, detail view, create form, and filters.
class InquiryPage extends StatefulWidget {
  const InquiryPage({super.key});

  @override
  State<InquiryPage> createState() => _InquiryPageState();
}

class _InquiryPageState extends State<InquiryPage> {
  Future<List<Inquiry>>? _inquiriesFuture;
  Inquiry? _selectedInquiry;
  List<Offer> _offers = const [];
  bool _loadingOffers = false;
  String? _offersError;
  String? _inquiriesError;
  bool _realtimeReady = false;
  late final RealtimeRefreshHandle _realtimeRefresh =
      RealtimeRefreshHandle(_handleRealtimeRefresh);

  bool _bootstrapped = false;
  List<Branch> _branches = const [];
  List<UserDto> _companyUsers = const [];

  // Filter state
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

  // Contact info from user profile
  String? _contactSalutation;
  String? _contactTitle;
  String? _contactFirstName;
  String? _contactLastName;
  String? _contactTelephone;
  String? _contactEmail;

  bool _showCreateForm = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _inquiriesFuture ??= _loadInquiries();
    if (!_bootstrapped) {
      _bootstrapped = true;
      _bootstrap();
    }
    _setupRealtime();
    final createParam = Uri.base.queryParameters['create'];
    if (createParam == 'true') {
      _showCreateForm = true;
    }
  }

  @override
  void dispose() {
    _realtimeRefresh.dispose();
    super.dispose();
  }

  void _handleRealtimeRefresh() {
    if (!mounted) return;
    _refresh();
    if (_selectedInquiry?.id != null) {
      _loadOffers(_selectedInquiry!.id);
    }
  }

  void _setupRealtime() {
    if (_realtimeReady) return;
    final appStore = Provider.of<Application>(context, listen: false);
    SupabaseRealtime.setAuth(appStore.authorization?.token);
    _realtimeRefresh.subscribe(
      tables: const [
        'inquiries',
        'offers',
        'inquiry_assignments',
      ],
      channelName: 'inquiries-page',
    );
    _realtimeReady = true;
  }

  Future<void> _bootstrap() async {
    final appStore = Provider.of<Application>(context, listen: false);
    final api = Provider.of<Openapi>(context, listen: false);

    try {
      final branchResponse = await api.getBranchesApi().branchesGet();
      setState(() {
        _branches = branchResponse.data?.toList() ?? const [];
      });
    } catch (error, stackTrace) {
      UILogger.silentError(
        'InquiryPage._bootstrap.branches',
        error,
        stackTrace,
      );
    }

    if (appStore.authorization?.companyId != null) {
      try {
        final usersResponse = await api
            .getUsersApi()
            .companiesCompanyIdUsersGet(
              companyId: appStore.authorization!.companyId!,
              headers: _authHeader(appStore.authorization?.token),
            );
        setState(() {
          _companyUsers = usersResponse.data?.toList() ?? const [];
        });
      } catch (error, stackTrace) {
        UILogger.silentError(
          'InquiryPage._bootstrap.companyUsers',
          error,
          stackTrace,
        );
      }
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
            _contactSalutation = data.salutation;
            _contactTitle = data.title;
            _contactFirstName = data.firstName;
            _contactLastName = data.lastName;
            _contactTelephone = data.telephoneNr;
            _contactEmail =
                data.emailAddress ?? appStore.authorization?.emailAddress;
          });
        }
      } catch (error, stackTrace) {
        UILogger.silentError(
          'InquiryPage._bootstrap.userProfile',
          error,
          stackTrace,
        );
      }
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
      final response = await api.getOffersApi().inquiriesInquiryIdOffersGet(
        inquiryId: inquiryId,
      );
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

  Future<void> _submitInquiry(InquiryFormData data) async {
    final api = Provider.of<Openapi>(context, listen: false);
    final request = CreateInquiryRequest(
      (b) => b
        ..branchId = data.branchId
        ..categoryId = data.categoryId
        ..deadline = data.deadline.toUtc()
        ..deliveryZips.replace(data.deliveryZips)
        ..numberOfProviders = data.numberOfProviders
        ..description =
            data.description?.isEmpty == true ? null : data.description
        ..productTags.replace(data.productTags)
        ..providerZip = data.providerZip?.isEmpty == true
            ? null
            : data.providerZip
        ..radiusKm = data.radiusKm
        ..providerType = data.providerType
        ..providerCompanySize = data.providerCompanySize
        ..salutation = data.contactSalutation?.isEmpty == true
            ? null
            : data.contactSalutation
        ..title = data.contactTitle?.isEmpty == true ? null : data.contactTitle
        ..firstName = data.contactFirstName?.isEmpty == true
            ? null
            : data.contactFirstName
        ..lastName =
            data.contactLastName?.isEmpty == true ? null : data.contactLastName
        ..telephone = data.contactTelephone?.isEmpty == true
            ? null
            : data.contactTelephone
        ..email = data.contactEmail?.isEmpty == true ? null : data.contactEmail,
    );

    try {
      final response = await api.getInquiriesApi().createInquiry(
        createInquiryRequest: request,
      );
      final inquiry = response.data;

      if (inquiry?.id == null) {
        throw Exception('Inquiry created without an id.');
      }

      if (data.pdfFile?.bytes != null) {
        try {
          await api.getInquiriesApi().inquiriesInquiryIdPdfPost(
            inquiryId: inquiry!.id!,
            file: MultipartFile.fromBytes(
              data.pdfFile!.bytes!,
              filename: data.pdfFile!.name,
            ),
          );
        } on DioException catch (error) {
          final message =
              error.response?.data?.toString() ?? error.message ?? '';
          _showSnack(message.isEmpty
              ? 'Inquiry created, but PDF upload failed.'
              : 'Inquiry created, but PDF upload failed: $message');
        } catch (_) {
          _showSnack('Inquiry created, but PDF upload failed.');
        }
      }

      _showSnack('Inquiry created.');
      if (mounted) {
        setState(() => _showCreateForm = false);
      }
      await _refresh();
    } on DioException catch (error) {
      final message = error.response?.data?.toString() ?? error.message ?? '';
      throw Exception(
        message.isEmpty ? 'Failed to create inquiry.' : message,
      );
    }
  }

  Future<Branch> _ensureBranch(String name) async {
    final api = Provider.of<Openapi>(context, listen: false);
    final response = await api.getBranchesApi().branchesPost(
      branchesPostRequest: BranchesPostRequest((b) => b..name = name),
    );
    final branch = response.data;
    if (branch == null) {
      throw Exception('Failed to create branch');
    }
    setState(() {
      final existingIndex = _branches.indexWhere(
        (b) => b.id != null && b.id == branch.id,
      );
      if (existingIndex == -1) {
        _branches = [..._branches, branch];
      } else {
        final updated = [..._branches];
        updated[existingIndex] = branch;
        _branches = updated;
      }
    });
    return branch;
  }

  Future<Category> _ensureCategory(String branchId, String name) async {
    final api = Provider.of<Openapi>(context, listen: false);
    final response = await api.getBranchesApi().branchesBranchIdCategoriesPost(
      branchId: branchId,
      branchesPostRequest: BranchesPostRequest((b) => b..name = name),
    );
    final category = response.data;
    if (category == null) {
      throw Exception('Failed to create category');
    }
    setState(() {
      final branchIndex = _branches.indexWhere(
        (b) => b.id != null && b.id == branchId,
      );
      if (branchIndex == -1) return;
      final branch = _branches[branchIndex];
      final categories = branch.categories?.toList() ?? <Category>[];
      final existingIndex = categories.indexWhere(
        (c) => c.id != null && c.id == category.id,
      );
      if (existingIndex == -1) {
        categories.add(category);
      } else {
        categories[existingIndex] = category;
      }
      final updatedBranch = branch.rebuild(
        (b) => b..categories.replace(categories),
      );
      final updated = [..._branches];
      updated[branchIndex] = updatedBranch;
      _branches = updated;
    });
    return category;
  }

  Future<void> _uploadOffer() async {
    if (_selectedInquiry?.id == null) return;
    final result = await _pickPdfFile();
    if (result == null || !mounted) return;

    final api = Provider.of<Openapi>(context, listen: false);
    await api.getOffersApi().inquiriesInquiryIdOffersPost(
      inquiryId: _selectedInquiry!.id!,
      file: MultipartFile.fromBytes(result.bytes!, filename: result.name),
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

  Future<void> _assignProviders() async {
    if (_selectedInquiry?.id == null) return;
    final appStore = Provider.of<Application>(context, listen: false);
    if (appStore.authorization?.isConsultant != true) return;

    final providers = await ProviderSelectionDialog.show(
      context: context,
      branches: _branches,
      maxProviders: _selectedInquiry?.numberOfProviders ?? 0,
      loadProviders: _loadProviders,
    );
    if (providers == null || providers.isEmpty || !mounted) return;

    final providerCompanyIds = providers
        .map((p) => p.companyId)
        .whereType<String>()
        .toList();
    if (providerCompanyIds.isEmpty) {
      _showSnack('Selected providers cannot be assigned yet.');
      return;
    }

    final api = Provider.of<Openapi>(context, listen: false);
    try {
      await api.getInquiriesApi().inquiriesInquiryIdAssignPost(
        inquiryId: _selectedInquiry!.id!,
        inquiriesInquiryIdAssignPostRequest:
            InquiriesInquiryIdAssignPostRequest(
              (b) => b..providerCompanyIds.replace(providerCompanyIds),
            ),
      );
      _showSnack('Inquiry forwarded to providers.');
    } on DioException catch (error) {
      final message = error.response?.data?.toString() ?? error.message ?? '';
      _showSnack(message.isEmpty ? 'Failed to assign providers.' : message);
    }
    await _refresh();
  }

  Future<void> _closeInquiry() async {
    if (_selectedInquiry?.id == null) return;
    final confirmed = await _showConfirmDialog(
      title: 'Close inquiry',
      content: 'Are you sure you want to close this inquiry?',
      confirmText: 'Close',
    );
    if (!confirmed || !mounted) return;

    final api = Provider.of<Openapi>(context, listen: false);
    await api.getInquiriesApi().inquiriesInquiryIdClosePost(
      inquiryId: _selectedInquiry!.id!,
    );
    _showSnack('Inquiry closed.');
    await _refresh();
  }

  Future<void> _removeAttachment() async {
    if (_selectedInquiry?.id == null || _selectedInquiry?.pdfPath == null) {
      return;
    }
    final confirmed = await _showConfirmDialog(
      title: 'Remove attachment',
      content: 'Remove the attached PDF from this inquiry?',
      confirmText: 'Remove',
    );
    if (!confirmed || !mounted) return;

    final api = Provider.of<Openapi>(context, listen: false);
    await api.getInquiriesApi().inquiriesInquiryIdPdfDelete(
      inquiryId: _selectedInquiry!.id!,
    );
    _showSnack('Attachment removed.');
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
        if (_createdFrom != null)
          'createdFrom': _createdFrom!.toIso8601String(),
        if (_createdTo != null) 'createdTo': _createdTo!.toIso8601String(),
        if (_deadlineFrom != null)
          'deadlineFrom': _deadlineFrom!.toIso8601String(),
        if (_deadlineTo != null) 'deadlineTo': _deadlineTo!.toIso8601String(),
        if (_editorFilter != null) 'editorIds': _editorFilter,
        'format': 'csv',
      },
    );
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  Future<ProviderSearchResult> _loadProviders({
    required int limit,
    required int offset,
    String? search,
    String? branchId,
    String? categoryId,
    String? companySize,
    String? providerType,
    String? zipPrefix,
  }) async {
    final api = Provider.of<Openapi>(context, listen: false);
    final response = await api.getProvidersApi().providersGet(
      limit: limit,
      offset: offset,
      search: search,
      branchId: branchId,
      categoryId: categoryId,
      companySize: companySize,
      providerType: providerType,
      zipPrefix: zipPrefix,
    );

    // Parse pagination headers
    final totalCountHeader = response.headers.value('X-Total-Count');
    final hasMoreHeader = response.headers.value('X-Has-More');

    return ProviderSearchResult(
      providers: response.data?.toList() ?? const [],
      totalCount: int.tryParse(totalCountHeader ?? '') ?? 0,
      hasMore: hasMoreHeader?.toLowerCase() == 'true',
    );
  }

  void _clearFilters() {
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
  }

  Future<bool> _showConfirmDialog({
    required String title,
    required String content,
    required String confirmText,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(confirmText),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  dynamic _pickPdfFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      withData: true,
    );
    if (result == null || result.files.isEmpty) return null;
    final file = result.files.first;
    if (file.bytes == null) return null;
    return file;
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
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
          contextMenu: _buildContextMenu(appStore),
          leftSplit: Column(
            children: [
              InquiryFilters(
                branches: _branches,
                companyUsers: _companyUsers,
                statusFilter: _statusFilter,
                branchIdFilter: _branchIdFilter,
                branchNameFilter: _branchNameFilter,
                providerTypeFilter: _providerTypeFilter,
                providerSizeFilter: _providerSizeFilter,
                createdFrom: _createdFrom,
                createdTo: _createdTo,
                deadlineFrom: _deadlineFrom,
                deadlineTo: _deadlineTo,
                editorFilter: _editorFilter,
                isAdmin: appStore.authorization?.isAdmin == true,
                isProvider: appStore.authorization?.isProvider == true,
                onStatusChanged: (v) => setState(() => _statusFilter = v),
                onBranchIdChanged: (v) => setState(() => _branchIdFilter = v),
                onBranchNameChanged: (v) =>
                    setState(() => _branchNameFilter = v),
                onProviderTypeChanged: (v) =>
                    setState(() => _providerTypeFilter = v),
                onProviderSizeChanged: (v) =>
                    setState(() => _providerSizeFilter = v),
                onCreatedFromChanged: (v) => setState(() => _createdFrom = v),
                onCreatedToChanged: (v) => setState(() => _createdTo = v),
                onDeadlineFromChanged: (v) => setState(() => _deadlineFrom = v),
                onDeadlineToChanged: (v) => setState(() => _deadlineTo = v),
                onEditorChanged: (v) => setState(() => _editorFilter = v),
                onClear: _clearFilters,
                onApply: _refresh,
              ),
              const Divider(height: 1),
              Expanded(
                child: InquiryList(
                  inquiries: inquiries,
                  selectedInquiryId: _selectedInquiry?.id,
                  onInquirySelected: _selectInquiry,
                ),
              ),
            ],
          ),
          rightSplit: _showCreateForm
              ? InquiryCreateForm(
                  branches: _branches,
                  onSubmit: _submitInquiry,
                  onEnsureBranch: _ensureBranch,
                  onEnsureCategory: _ensureCategory,
                  initialContactSalutation: _contactSalutation,
                  initialContactTitle: _contactTitle,
                  initialContactFirstName: _contactFirstName,
                  initialContactLastName: _contactLastName,
                  initialContactTelephone: _contactTelephone,
                  initialContactEmail: _contactEmail,
                )
              : _selectedInquiry != null
              ? InquiryDetail(
                  inquiry: _selectedInquiry!,
                  offers: _offers,
                  isLoadingOffers: _loadingOffers,
                  offersError: _offersError,
                  isBuyer: appStore.authorization?.isBuyer == true,
                  isProvider: appStore.authorization?.isProvider == true,
                  isConsultant: appStore.authorization?.isConsultant == true,
                  onUploadOffer: _uploadOffer,
                  onIgnoreInquiry: _ignoreInquiry,
                  onAssignProviders: _assignProviders,
                  onCloseInquiry: _closeInquiry,
                  onRemoveAttachment: _removeAttachment,
                  onAcceptOffer: _acceptOffer,
                  onRejectOffer: _rejectOffer,
                )
              : const NoInquirySelected(),
        );
      },
    );
  }

  Widget _buildContextMenu(Application appStore) {
    return AppToolbar(
      title: const Text('Inquiries'),
      actions: [
        TextButton(onPressed: _exportCsv, child: const Text('Export CSV')),
        if (appStore.authorization?.isBuyer == true)
          FilledButton.tonal(
            onPressed: () => setState(() => _showCreateForm = !_showCreateForm),
            child: Text(_showCreateForm ? 'Close form' : 'New inquiry'),
          ),
      ],
    );
  }
}

Map<String, String> _authHeader(String? token) {
  if (token == null || token.isEmpty) return {};
  return {'Authorization': 'Bearer $token'};
}
