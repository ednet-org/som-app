import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:openapi/openapi.dart';
import 'package:provider/provider.dart';
import 'package:som/domain/model/inquiry_management/enums/inquiry_status.dart';
import 'package:som/ui/domain/application/application.dart';
import 'package:som/ui/domain/model/inquiry_view_model.dart';

import '../../domain/model/cards/inquiry/inquiry_card_components/core/arr.dart';
import '../../domain/model/cards/inquiry/inquiry_card_components/core/filter.dart';
import '../../domain/model/cards/inquiry/inquiry_card_components/core/i_filter.dart';
import '../../domain/model/cards/inquiry/inquiry_card_components/flutter/entity/document/document.dart';
import '../../domain/model/cards/inquiry/inquiry_card_components/flutter/entity_card.dart';
import '../../domain/model/cards/inquiry/inquiry_card_components/flutter/entity_list.dart';
import '../../domain/model/layout/app_body.dart';

class InquiryAppBody extends StatefulWidget {
  const InquiryAppBody({Key? key}) : super(key: key);

  @override
  State<InquiryAppBody> createState() => _InquiryAppBodyState();
}

class _InquiryAppBodyState extends State<InquiryAppBody> {
  Future<List<InquiryViewModel>>? _inquiriesFuture;
  EntityList<InquiryViewModel>? _entityList;
  InquiryViewModel? _selectedInquiry;
  List<Offer> _offers = [];
  bool _offersLoading = false;
  String? _offersError;
  Widget? details;

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

    return FutureBuilder<List<InquiryViewModel>>(
      future: _inquiriesFuture,
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
              child: Text('Failed to load inquiries: ${snapshot.error}'),
            ),
            rightSplit: const SizedBox.shrink(),
          );
        }
        final inquiries = snapshot.data ?? [];
        _entityList = _buildEntityList(inquiries);
        return AppBody(
          contextMenu: _buildContextMenu(),
          leftSplit: _entityList!,
          rightSplit: details,
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    // defer loading until we have a BuildContext
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _inquiriesFuture ??= _loadInquiries(context);
  }

  Future<List<InquiryViewModel>> _loadInquiries(BuildContext context) async {
    final api = Provider.of<Openapi>(context, listen: false);
    final response = await api.getInquiriesApi().inquiriesGet();
    final data = response.data?.toList() ?? const <Inquiry>[];
    return data.map(InquiryViewModel.fromApi).toList();
  }

  Widget _buildContextMenu() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            TextButton(
              onPressed: _createInquiry,
              child: const Text('Create inquiry'),
            ),
            TextButton(
              onPressed: _assignInquiry,
              child: const Text('Assign to providers'),
            ),
            TextButton(
              onPressed: _fetchOffers,
              child: const Text('Load offers'),
            ),
            TextButton(
              onPressed: _uploadOffer,
              child: const Text('Upload demo offer'),
            ),
          ],
        ),
        const Divider(),
        SizedBox(
          height: 700,
          child: _entityList!.filters,
        ),
      ],
    );
  }

  EntityList<InquiryViewModel> _buildEntityList(
      List<InquiryViewModel> inquiries) {
    return EntityList<InquiryViewModel>(
      listMode: ListMode.list,
      entities: inquiries,
      entityBuilder: (inquiry) => EntityCard<InquiryViewModel>(
        entity: inquiry,
      ),
      detailsBuilder: (entity) => EntityDocument<InquiryViewModel>(
        entity: entity,
      ),
      filters: [
        Filter(
          name: 'Status',
          value: const Arr<InquiryStatus>(
            name: 'Status',
            value: null,
          ),
          mode: DisplayMode.dropdown,
          allowedValues: [
            const Arr<InquiryStatus>(
              name: 'Draft',
              value: InquiryStatus.draft,
            ),
            const Arr<InquiryStatus>(
              name: 'Published',
              value: InquiryStatus.published,
            ),
            const Arr<InquiryStatus>(
              name: 'Expired',
              value: InquiryStatus.expired,
            ),
            const Arr<InquiryStatus>(
              name: 'Closed',
              value: InquiryStatus.closed,
            ),
          ],
          operands: [
            FilterOperand.equals,
          ],
        ),
        Filter(
          name: 'Title',
          value: const Arr<String>(
            name: 'Title',
            value: null,
          ),
          mode: DisplayMode.input,
          operands: [
            FilterOperand.equals,
            FilterOperand.contains,
          ],
        ),
        Filter(
          name: 'Description',
          value: const Arr<String>(
            name: 'Description',
            value: null,
          ),
          mode: DisplayMode.input,
          operands: [
            FilterOperand.equals,
            FilterOperand.contains,
          ],
        ),
      ],
      onEntitySelected: (entity) {
        if (entity != null) {
          setState(() {
            details = _buildDetails(entity);
            _selectedInquiry = entity;
          });
          _loadInquiryDetail(entity);
        } else {
          setState(() {
            details = null;
            _selectedInquiry = null;
          });
        }
      },
    );
  }

  Future<void> _loadInquiryDetail(InquiryViewModel inquiry) async {
    final id = inquiry.id.value;
    if (id == null || id.isEmpty) return;
    final api = Provider.of<Openapi>(context, listen: false);
    try {
      final response =
          await api.getInquiriesApi().inquiriesInquiryIdGet(inquiryId: id);
      final detail = response.data;
      if (detail == null) return;
      setState(() {
        final viewModel = InquiryViewModel.fromApi(detail);
        _selectedInquiry = viewModel;
        details = _buildDetails(viewModel);
      });
    } catch (_) {}
  }

  Widget _buildDetails(InquiryViewModel inquiry) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          EntityDocument(entity: inquiry),
          const SizedBox(height: 12),
          if (_offersLoading) const LinearProgressIndicator(),
          if (_offersError != null)
            Text('Offers error: $_offersError'),
          if (!_offersLoading && _offers.isEmpty)
            const Text('No offers loaded.'),
          if (_offers.isNotEmpty)
            ..._offers.map((offer) => Card(
                  child: ListTile(
                    title: Text('Offer ${offer.id ?? ''}'),
                    subtitle: Text(
                        'Status: ${offer.status ?? '-'} | Provider: ${offer.providerCompanyId ?? '-'}'),
                    trailing: Wrap(
                      spacing: 8,
                      children: [
                        TextButton(
                          onPressed: () => _acceptOffer(offer.id),
                          child: const Text('Accept'),
                        ),
                        TextButton(
                          onPressed: () => _rejectOffer(offer.id),
                          child: const Text('Reject'),
                        ),
                      ],
                    ),
                  ),
                )),
        ],
      ),
    );
  }

  Future<void> _createInquiry() async {
    final api = Provider.of<Openapi>(context, listen: false);
    final branchesResponse = await api.getBranchesApi().branchesGet();
    final branches = branchesResponse.data?.toList() ?? const <Branch>[];
    if (branches.isEmpty) return;
    final branch = branches.first;
    final category = branch.categories?.isNotEmpty == true
        ? branch.categories!.first
        : null;
    if (branch.id == null || category?.id == null) return;
    final deadline = DateTime.now().add(const Duration(days: 3));
    await api.getInquiriesApi().createInquiry(
          createInquiryRequest: CreateInquiryRequest((b) => b
            ..branchId = branch.id!
            ..categoryId = category!.id!
            ..deadline = deadline
            ..numberOfProviders = 1
            ..deliveryZips.addAll(['1010'])
            ..productTags.add('demo')),
        );
    setState(() {
      _inquiriesFuture = _loadInquiries(context);
    });
  }

  Future<void> _assignInquiry() async {
    if (_selectedInquiry?.id.value == null || _selectedInquiry!.id.value!.isEmpty) {
      return;
    }
    final api = Provider.of<Openapi>(context, listen: false);
    final companiesResponse = await api.getCompaniesApi().companiesGet();
    final companies = companiesResponse.data?.toList() ?? const <CompanyDto>[];
    final providerIds = companies
        .where((company) => company.type == 1)
        .map((company) => company.id)
        .whereType<String>()
        .take(2)
        .toList();
    if (providerIds.isEmpty) return;
    await api.getInquiriesApi().inquiriesInquiryIdAssignPost(
          inquiryId: _selectedInquiry!.id.value!,
          inquiriesInquiryIdAssignPostRequest:
              InquiriesInquiryIdAssignPostRequest((b) => b
                ..providerCompanyIds.addAll(providerIds)),
        );
  }

  Future<void> _fetchOffers() async {
    if (_selectedInquiry?.id.value == null || _selectedInquiry!.id.value!.isEmpty) {
      return;
    }
    setState(() {
      _offersLoading = true;
      _offersError = null;
    });
    final api = Provider.of<Openapi>(context, listen: false);
    try {
      final response = await api
          .getOffersApi()
          .inquiriesInquiryIdOffersGet(inquiryId: _selectedInquiry!.id.value!);
      setState(() {
        _offers = response.data?.toList() ?? [];
        _offersLoading = false;
      });
    } catch (error) {
      setState(() {
        _offersLoading = false;
        _offersError = error.toString();
      });
    }
  }

  Future<void> _uploadOffer() async {
    if (_selectedInquiry?.id.value == null || _selectedInquiry!.id.value!.isEmpty) {
      return;
    }
    final api = Provider.of<Openapi>(context, listen: false);
    final demoBytes = 'Demo offer'.codeUnits;
    final file = MultipartFile.fromBytes(
      demoBytes,
      filename: 'demo-offer.txt',
    );
    await api.getOffersApi().inquiriesInquiryIdOffersPost(
          inquiryId: _selectedInquiry!.id.value!,
          file: file,
        );
    await _fetchOffers();
  }

  Future<void> _acceptOffer(String? offerId) async {
    if (offerId == null) return;
    final api = Provider.of<Openapi>(context, listen: false);
    await api.getOffersApi().offersOfferIdAcceptPost(offerId: offerId);
    await _fetchOffers();
  }

  Future<void> _rejectOffer(String? offerId) async {
    if (offerId == null) return;
    final api = Provider.of<Openapi>(context, listen: false);
    await api.getOffersApi().offersOfferIdRejectPost(offerId: offerId);
    await _fetchOffers();
  }
}
