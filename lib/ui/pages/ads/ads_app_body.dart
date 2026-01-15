import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:openapi/openapi.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../domain/application/application.dart';
import '../../domain/model/layout/app_body.dart';


class AdsAppBody extends StatefulWidget {
  const AdsAppBody({Key? key}) : super(key: key);

  @override
  State<AdsAppBody> createState() => _AdsAppBodyState();
}

class _AdsAppBodyState extends State<AdsAppBody> {
  Future<List<Ad>>? _adsFuture;
  List<Ad> _ads = const [];
  Ad? _selectedAd;
  List<Branch> _branches = const [];

  String? _filterBranchId;
  String? _filterStatus;
  String? _filterType;

  bool _showCreateForm = false;
  bool _creating = false;

  String _createType = 'normal';
  String? _createBranchId;
  DateTime? _createStartDate;
  DateTime? _createEndDate;
  DateTime? _createBannerDate;
  final _createUrlController = TextEditingController();
  final _createHeadlineController = TextEditingController();
  final _createDescriptionController = TextEditingController();
  PlatformFile? _createImage;

  final _editUrlController = TextEditingController();
  final _editHeadlineController = TextEditingController();
  final _editDescriptionController = TextEditingController();
  DateTime? _editStartDate;
  DateTime? _editEndDate;
  DateTime? _editBannerDate;
  PlatformFile? _editImage;

  bool _bootstrapped = false;

  @override
  void dispose() {
    _createUrlController.dispose();
    _createHeadlineController.dispose();
    _createDescriptionController.dispose();
    _editUrlController.dispose();
    _editHeadlineController.dispose();
    _editDescriptionController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _adsFuture ??= _loadAds();
    if (!_bootstrapped) {
      _bootstrapped = true;
      _bootstrap();
    }
  }

  Future<void> _bootstrap() async {
    final api = Provider.of<Openapi>(context, listen: false);
    try {
      final response = await api.getBranchesApi().branchesGet();
      setState(() {
        _branches = response.data?.toList() ?? const [];
      });
    } catch (_) {}
  }

  Future<List<Ad>> _loadAds() async {
    final appStore = Provider.of<Application>(context, listen: false);
    final api = Provider.of<Openapi>(context, listen: false);
    final scope = appStore.authorization?.isConsultant == true
        ? 'all'
        : appStore.authorization?.isProvider == true
            ? 'company'
            : null;
    final response = await api.getAdsApi().adsGet(
          branchId: _filterBranchId,
          status: _filterStatus,
          scope: scope,
        );
    final list = response.data?.toList() ?? const [];
    _ads = list;
    return list;
  }

  Future<void> _refresh() async {
    setState(() {
      _adsFuture = _loadAds();
    });
  }

  Future<void> _pickImage({required bool isEdit}) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
    );
    if (result == null || result.files.isEmpty) return;
    setState(() {
      if (isEdit) {
        _editImage = result.files.first;
      } else {
        _createImage = result.files.first;
      }
    });
  }

  Future<void> _createAd() async {
    if (_createBranchId == null) {
      _showSnack('Please select a branch.');
      return;
    }
    if (_createUrlController.text.trim().isEmpty) {
      _showSnack('Please provide a URL.');
      return;
    }
    if (_createType == 'normal' &&
        (_createStartDate == null || _createEndDate == null)) {
      _showSnack('Select start and end dates.');
      return;
    }
    if (_createType == 'banner' && _createBannerDate == null) {
      _showSnack('Select banner date.');
      return;
    }
    setState(() {
      _creating = true;
    });
    final api = Provider.of<Openapi>(context, listen: false);
    try {
      final response = await api.getAdsApi().createAd(
            createAdRequest: CreateAdRequest((b) => b
              ..type = _createType
              ..status = CreateAdRequestStatusEnum.draft
              ..branchId = _createBranchId!
              ..url = _createUrlController.text.trim()
              ..headline = _createType == 'normal'
                  ? _createHeadlineController.text.trim()
                  : null
              ..description = _createType == 'normal'
                  ? _createDescriptionController.text.trim()
                  : null
              ..startDate = _createStartDate?.toIso8601String()
              ..endDate = _createEndDate?.toIso8601String()
              ..bannerDate = _createBannerDate?.toIso8601String()),
          );
      final adId = response.data?.id;
      if (adId != null && _createImage?.bytes != null) {
        await api.getAdsApi().adsAdIdImagePost(
              adId: adId,
              file: MultipartFile.fromBytes(
                _createImage!.bytes!,
                filename: _createImage!.name,
              ),
            );
      }
      _showSnack('Ad created.');
      setState(() {
        _showCreateForm = false;
        _createImage = null;
        _createUrlController.clear();
        _createHeadlineController.clear();
        _createDescriptionController.clear();
      });
      await _refresh();
    } catch (error) {
      _showSnack('Failed to create ad: $error');
    } finally {
      setState(() {
        _creating = false;
      });
    }
  }

  Future<void> _selectAd(Ad ad) async {
    setState(() {
      _selectedAd = ad;
      _editStartDate = ad.startDate;
      _editEndDate = ad.endDate;
      _editBannerDate = ad.bannerDate;
      _editUrlController.text = ad.url ?? '';
      _editHeadlineController.text = ad.headline ?? '';
      _editDescriptionController.text = ad.description ?? '';
      _editImage = null;
    });
  }

  Future<void> _updateAd() async {
    if (_selectedAd?.id == null) return;
    final api = Provider.of<Openapi>(context, listen: false);
    final updated = _selectedAd!.rebuild((b) => b
      ..url = _editUrlController.text.trim()
      ..headline = _editHeadlineController.text.trim().isEmpty
          ? null
          : _editHeadlineController.text.trim()
      ..description = _editDescriptionController.text.trim().isEmpty
          ? null
          : _editDescriptionController.text.trim()
      ..startDate = _editStartDate
      ..endDate = _editEndDate
      ..bannerDate = _editBannerDate);
    await api.getAdsApi().adsAdIdPut(adId: updated.id!, ad: updated);
    if (_editImage?.bytes != null) {
      await api.getAdsApi().adsAdIdImagePost(
            adId: updated.id!,
            file: MultipartFile.fromBytes(
              _editImage!.bytes!,
              filename: _editImage!.name,
            ),
          );
    }
    _showSnack('Ad updated.');
    await _refresh();
  }

  Future<void> _activateAd() async {
    if (_selectedAd?.id == null) return;
    if (_selectedAd?.type == 'banner' && _editBannerDate == null) {
      _showSnack('Select banner date before activating.');
      return;
    }
    if (_selectedAd?.type != 'banner' &&
        (_editStartDate == null || _editEndDate == null)) {
      _showSnack('Select start and end dates before activating.');
      return;
    }
    final api = Provider.of<Openapi>(context, listen: false);
    try {
      await api.getAdsApi().adsAdIdActivatePost(
            adId: _selectedAd!.id!,
            adActivationRequest: AdActivationRequest((b) => b
              ..startDate = _editStartDate
              ..endDate = _editEndDate
              ..bannerDate = _editBannerDate),
          );
      _showSnack('Ad activated.');
      await _refresh();
    } catch (error) {
      _showSnack('Failed to activate ad: $error');
    }
  }

  Future<void> _deactivateAd() async {
    if (_selectedAd?.id == null) return;
    final api = Provider.of<Openapi>(context, listen: false);
    try {
      await api
          .getAdsApi()
          .adsAdIdDeactivatePost(adId: _selectedAd!.id!);
      _showSnack('Ad deactivated.');
      await _refresh();
    } catch (error) {
      _showSnack('Failed to deactivate ad: $error');
    }
  }

  Future<void> _deleteAd() async {
    if (_selectedAd?.id == null) return;
    final api = Provider.of<Openapi>(context, listen: false);
    await api.getAdsApi().adsAdIdDelete(adId: _selectedAd!.id!);
    setState(() {
      _selectedAd = null;
    });
    await _refresh();
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final appStore = Provider.of<Application>(context);
    if (appStore.authorization == null) {
      return const AppBody(
        contextMenu: Text('Login required'),
        leftSplit: Center(child: Text('Please log in to view ads.')),
        rightSplit: SizedBox.shrink(),
      );
    }

    return FutureBuilder<List<Ad>>(
      future: _adsFuture,
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
              child: Text('Failed to load ads: ${snapshot.error}'),
            ),
            rightSplit: const SizedBox.shrink(),
          );
        }
        final ads = snapshot.data ?? const [];
        return AppBody(
          contextMenu: Row(
            children: [
              Text('SOM Ads', style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(width: 12),
              TextButton(onPressed: _refresh, child: const Text('Refresh')),
              if (appStore.authorization?.isBuyer != true)
                TextButton(
                  onPressed: () => setState(() => _showCreateForm = !_showCreateForm),
                  child: Text(_showCreateForm ? 'Close form' : 'Create ad'),
                ),
            ],
          ),
          leftSplit: Column(
            children: [
              _buildFilters(appStore),
              const Divider(height: 1),
              Expanded(
                child: ListView.builder(
                  itemCount: ads.length,
                  itemBuilder: (context, index) {
                    final ad = ads[index];
                    if (_filterType != null && ad.type != _filterType) {
                      return const SizedBox.shrink();
                    }
                    return ListTile(
                      title: Text(ad.headline ?? ad.id ?? 'Ad'),
                      subtitle: Text('${ad.status ?? '-'} | ${ad.type ?? '-'}'),
                      selected: _selectedAd?.id == ad.id,
                      onTap: () => _selectAd(ad),
                      onLongPress: appStore.authorization?.isBuyer == true
                          ? () {
                              if (ad.url != null) {
                                launchUrl(Uri.parse(ad.url!),
                                    mode: LaunchMode.externalApplication);
                              }
                            }
                          : null,
                    );
                  },
                ),
              ),
            ],
          ),
          rightSplit: appStore.authorization?.isBuyer == true
              ? _buildBuyerView(ads)
              : _showCreateForm
                  ? _buildCreateForm()
                  : _buildEditForm(),
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
                hint: const Text('Branch'),
                value: _filterBranchId,
                items: _branches
                    .map((branch) => DropdownMenuItem(
                          value: branch.id,
                          child: Text(branch.name ?? branch.id ?? '-'),
                        ))
                    .toList(),
                onChanged: (value) => setState(() => _filterBranchId = value),
              ),
              DropdownButton<String>(
                hint: const Text('Status'),
                value: _filterStatus,
                items: const [
                  DropdownMenuItem(value: 'active', child: Text('Active')),
                  DropdownMenuItem(value: 'draft', child: Text('Draft')),
                  DropdownMenuItem(value: 'expired', child: Text('Expired')),
                ],
                onChanged: (value) => setState(() => _filterStatus = value),
              ),
              DropdownButton<String>(
                hint: const Text('Type'),
                value: _filterType,
                items: const [
                  DropdownMenuItem(value: 'normal', child: Text('Normal')),
                  DropdownMenuItem(value: 'banner', child: Text('Banner')),
                ],
                onChanged: (value) => setState(() => _filterType = value),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _filterBranchId = null;
                    _filterStatus = null;
                    _filterType = null;
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

  Widget _buildBuyerView(List<Ad> ads) {
    final banners = ads.where((ad) => ad.type == 'banner').toList();
    final normal = ads.where((ad) => ad.type != 'banner').toList();
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView(
        children: [
          if (banners.isNotEmpty) ...[
            Text('Banner ads', style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 8),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: banners
                  .map((ad) => OutlinedButton(
                        onPressed: ad.url == null
                            ? null
                            : () => launchUrl(Uri.parse(ad.url!),
                                mode: LaunchMode.externalApplication),
                        child: Text(ad.headline ?? ad.id ?? 'Banner'),
                      ))
                  .toList(),
            ),
            const Divider(height: 24),
          ],
          Text('Ads', style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 8),
          ...normal.map(
            (ad) => Card(
              child: ListTile(
                title: Text(ad.headline ?? ad.id ?? 'Ad'),
                subtitle: Text(ad.description ?? ad.url ?? ''),
                trailing: Text(ad.status ?? ''),
                onTap: ad.url == null
                    ? null
                    : () => launchUrl(Uri.parse(ad.url!),
                        mode: LaunchMode.externalApplication),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCreateForm() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView(
        children: [
          Text('Create ad', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          DropdownButton<String>(
            value: _createType,
            items: const [
              DropdownMenuItem(value: 'normal', child: Text('Normal')),
              DropdownMenuItem(value: 'banner', child: Text('Banner')),
            ],
            onChanged: (value) => setState(() => _createType = value ?? 'normal'),
          ),
          DropdownButton<String>(
            hint: const Text('Branch'),
            value: _createBranchId,
            items: _branches
                .map((branch) => DropdownMenuItem(
                      value: branch.id,
                      child: Text(branch.name ?? branch.id ?? '-'),
                    ))
                .toList(),
            onChanged: (value) => setState(() => _createBranchId = value),
          ),
          TextField(
            controller: _createUrlController,
            decoration: const InputDecoration(labelText: 'URL'),
          ),
          if (_createType == 'normal')
            TextField(
              controller: _createHeadlineController,
              decoration: const InputDecoration(labelText: 'Headline'),
            ),
          if (_createType == 'normal')
            TextField(
              controller: _createDescriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
          if (_createType == 'normal')
            _datePickerRow(
              label: 'Start date',
              value: _createStartDate,
              onPicked: (value) => setState(() => _createStartDate = value),
            ),
          if (_createType == 'normal')
            _datePickerRow(
              label: 'End date',
              value: _createEndDate,
              onPicked: (value) => setState(() => _createEndDate = value),
            ),
          if (_createType == 'banner')
            _datePickerRow(
              label: 'Banner date',
              value: _createBannerDate,
              onPicked: (value) => setState(() => _createBannerDate = value),
            ),
          Row(
            children: [
              TextButton(
                onPressed: () => _pickImage(isEdit: false),
                child: Text(_createImage == null
                    ? 'Upload image'
                    : 'Image: ${_createImage!.name}'),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: _creating ? null : _createAd,
                child: _creating
                    ? const SizedBox(
                        height: 16,
                        width: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Create'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEditForm() {
    if (_selectedAd == null) {
      return const Center(child: Text('Select an ad to view details.'));
    }
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView(
        children: [
          Text('Edit ad', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          Text('ID: ${_selectedAd!.id}'),
          Text('Status: ${_selectedAd!.status ?? '-'}'),
          Text('Type: ${_selectedAd!.type ?? '-'}'),
          TextField(
            controller: _editUrlController,
            decoration: const InputDecoration(labelText: 'URL'),
          ),
          TextField(
            controller: _editHeadlineController,
            decoration: const InputDecoration(labelText: 'Headline'),
          ),
          TextField(
            controller: _editDescriptionController,
            decoration: const InputDecoration(labelText: 'Description'),
          ),
          _datePickerRow(
            label: 'Start date',
            value: _editStartDate,
            onPicked: (value) => setState(() => _editStartDate = value),
          ),
          _datePickerRow(
            label: 'End date',
            value: _editEndDate,
            onPicked: (value) => setState(() => _editEndDate = value),
          ),
          _datePickerRow(
            label: 'Banner date',
            value: _editBannerDate,
            onPicked: (value) => setState(() => _editBannerDate = value),
          ),
          Row(
            children: [
              TextButton(
                onPressed: () => _pickImage(isEdit: true),
                child: Text(_editImage == null
                    ? 'Upload new image'
                    : 'Image: ${_editImage!.name}'),
              ),
              const SizedBox(width: 12),
              ElevatedButton(onPressed: _updateAd, child: const Text('Save')),
              const SizedBox(width: 12),
              if (_selectedAd?.status != 'active')
                ElevatedButton(
                    onPressed: _activateAd, child: const Text('Activate')),
              if (_selectedAd?.status == 'active')
                TextButton(
                    onPressed: _deactivateAd, child: const Text('Deactivate')),
              const SizedBox(width: 12),
              TextButton(onPressed: _deleteAd, child: const Text('Delete')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _datePickerRow({
    required String label,
    required DateTime? value,
    required ValueChanged<DateTime?> onPicked,
  }) {
    return Row(
      children: [
        TextButton(
          onPressed: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: value ?? DateTime.now(),
              firstDate: DateTime(2020),
              lastDate: DateTime(2100),
            );
            if (picked != null) {
              onPicked(picked);
            }
          },
          child: Text(value == null
              ? label
              : '$label: ${value.toIso8601String().split('T').first}'),
        ),
      ],
    );
  }
}
