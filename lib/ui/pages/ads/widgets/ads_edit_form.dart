import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:openapi/openapi.dart';

import 'ads_create_form.dart';

/// Form widget for editing an existing ad.
class AdsEditForm extends StatefulWidget {
  const AdsEditForm({
    super.key,
    required this.ad,
    required this.onUpdate,
    required this.onActivate,
    required this.onDeactivate,
    required this.onDelete,
  });

  final Ad ad;
  final Future<void> Function(AdEditData data) onUpdate;
  final VoidCallback onActivate;
  final VoidCallback onDeactivate;
  final VoidCallback onDelete;

  @override
  State<AdsEditForm> createState() => _AdsEditFormState();
}

class _AdsEditFormState extends State<AdsEditForm> {
  final _urlController = TextEditingController();
  final _headlineController = TextEditingController();
  final _descriptionController = TextEditingController();

  DateTime? _startDate;
  DateTime? _endDate;
  DateTime? _bannerDate;
  PlatformFile? _image;

  @override
  void initState() {
    super.initState();
    _initializeFromAd();
  }

  @override
  void didUpdateWidget(AdsEditForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.ad.id != widget.ad.id) {
      _initializeFromAd();
    }
  }

  void _initializeFromAd() {
    _startDate = widget.ad.startDate;
    _endDate = widget.ad.endDate;
    _bannerDate = widget.ad.bannerDate;
    _urlController.text = widget.ad.url ?? '';
    _headlineController.text = widget.ad.headline ?? '';
    _descriptionController.text = widget.ad.description ?? '';
    _image = null;
  }

  @override
  void dispose() {
    _urlController.dispose();
    _headlineController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
    );
    if (result == null || result.files.isEmpty) return;
    setState(() {
      _image = result.files.first;
    });
  }

  Future<void> _update() async {
    await widget.onUpdate(AdEditData(
      url: _urlController.text.trim(),
      headline: _headlineController.text.trim(),
      description: _descriptionController.text.trim(),
      startDate: _startDate,
      endDate: _endDate,
      bannerDate: _bannerDate,
      image: _image,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView(
        children: [
          Text('Edit ad', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          _buildAdInfo(),
          _buildFields(),
          _buildDatePickers(),
          _buildActions(),
        ],
      ),
    );
  }

  Widget _buildAdInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('ID: ${widget.ad.id}'),
        Text('Status: ${widget.ad.status ?? '-'}'),
        Text('Type: ${widget.ad.type ?? '-'}'),
      ],
    );
  }

  Widget _buildFields() {
    return Column(
      children: [
        TextField(
          controller: _urlController,
          decoration: const InputDecoration(labelText: 'URL'),
        ),
        TextField(
          controller: _headlineController,
          decoration: const InputDecoration(labelText: 'Headline'),
        ),
        TextField(
          controller: _descriptionController,
          decoration: const InputDecoration(labelText: 'Description'),
        ),
      ],
    );
  }

  Widget _buildDatePickers() {
    return Column(
      children: [
        DatePickerRow(
          label: 'Start date',
          value: _startDate,
          onPicked: (value) => setState(() => _startDate = value),
        ),
        DatePickerRow(
          label: 'End date',
          value: _endDate,
          onPicked: (value) => setState(() => _endDate = value),
        ),
        DatePickerRow(
          label: 'Banner date',
          value: _bannerDate,
          onPicked: (value) => setState(() => _bannerDate = value),
        ),
      ],
    );
  }

  Widget _buildActions() {
    final isActive = widget.ad.status == 'active';
    return Row(
      children: [
        TextButton(
          onPressed: _pickImage,
          child: Text(_image == null ? 'Upload new image' : 'Image: ${_image!.name}'),
        ),
        const SizedBox(width: 12),
        ElevatedButton(onPressed: _update, child: const Text('Save')),
        const SizedBox(width: 12),
        if (!isActive)
          ElevatedButton(
            onPressed: widget.onActivate,
            child: const Text('Activate'),
          ),
        if (isActive)
          TextButton(
            onPressed: widget.onDeactivate,
            child: const Text('Deactivate'),
          ),
        const SizedBox(width: 12),
        TextButton(
          onPressed: widget.onDelete,
          child: const Text('Delete'),
        ),
      ],
    );
  }
}

/// Data class for ad edit submission.
class AdEditData {
  const AdEditData({
    required this.url,
    required this.headline,
    required this.description,
    this.startDate,
    this.endDate,
    this.bannerDate,
    this.image,
  });

  final String url;
  final String headline;
  final String description;
  final DateTime? startDate;
  final DateTime? endDate;
  final DateTime? bannerDate;
  final PlatformFile? image;
}

/// Placeholder widget when no ad is selected.
class NoAdSelected extends StatelessWidget {
  const NoAdSelected({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Select an ad to view details.'));
  }
}
