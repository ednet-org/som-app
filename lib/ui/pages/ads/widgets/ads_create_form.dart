import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:openapi/openapi.dart';
import 'package:som/ui/theme/som_assets.dart';
import 'package:som/ui/utils/formatters.dart';
import 'package:som/ui/widgets/design_system/som_svg_icon.dart';
import 'package:som/ui/widgets/snackbars.dart';

/// Form widget for creating a new ad.
class AdsCreateForm extends StatefulWidget {
  const AdsCreateForm({
    super.key,
    required this.branches,
    required this.onSubmit,
  });

  final List<Branch> branches;
  final Future<void> Function(AdFormData data) onSubmit;

  @override
  State<AdsCreateForm> createState() => _AdsCreateFormState();
}

class _AdsCreateFormState extends State<AdsCreateForm> {
  final _urlController = TextEditingController();
  final _headlineController = TextEditingController();
  final _descriptionController = TextEditingController();

  String _type = 'normal';
  String? _branchId;
  DateTime? _startDate;
  DateTime? _endDate;
  DateTime? _bannerDate;
  PlatformFile? _image;
  bool _isSubmitting = false;

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

  Future<void> _submit() async {
    if (_branchId == null) {
      _showSnack('Please select a branch.');
      return;
    }
    if (_urlController.text.trim().isEmpty) {
      _showSnack('Please provide a URL.');
      return;
    }
    if (_type == 'normal' && (_startDate == null || _endDate == null)) {
      _showSnack('Select start and end dates.');
      return;
    }
    if (_type == 'banner' && _bannerDate == null) {
      _showSnack('Select banner date.');
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      await widget.onSubmit(AdFormData(
        type: _type,
        branchId: _branchId!,
        url: _urlController.text.trim(),
        headline: _type == 'normal' ? _headlineController.text.trim() : null,
        description: _type == 'normal' ? _descriptionController.text.trim() : null,
        startDate: _startDate,
        endDate: _endDate,
        bannerDate: _bannerDate,
        image: _image,
      ));
      _clearForm();
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  void _clearForm() {
    setState(() {
      _image = null;
      _urlController.clear();
      _headlineController.clear();
      _descriptionController.clear();
    });
  }

  void _showSnack(String message) {
    SomSnackBars.warning(context, message);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView(
        children: [
          Text('Create ad', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          _buildTypeDropdown(),
          _buildBranchDropdown(),
          _buildUrlField(),
          if (_type == 'normal') ...[
            _buildHeadlineField(),
            _buildDescriptionField(),
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
          ],
          if (_type == 'banner')
            DatePickerRow(
              label: 'Banner date',
              value: _bannerDate,
              onPicked: (value) => setState(() => _bannerDate = value),
            ),
          _buildSubmitRow(),
        ],
      ),
    );
  }

  Widget _buildTypeDropdown() {
    return DropdownButton<String>(
      value: _type,
      items: const [
        DropdownMenuItem(value: 'normal', child: Text('Normal')),
        DropdownMenuItem(value: 'banner', child: Text('Banner')),
      ],
      onChanged: (value) => setState(() => _type = value ?? 'normal'),
    );
  }

  Widget _buildBranchDropdown() {
    return DropdownButton<String>(
      hint: const Text('Branch'),
      value: _branchId,
      items: widget.branches
          .map((branch) => DropdownMenuItem(
                value: branch.id,
                child: Text(
                  branch.name ?? SomFormatters.shortId(branch.id),
                ),
              ))
          .toList(),
      onChanged: (value) => setState(() => _branchId = value),
    );
  }

  Widget _buildUrlField() {
    return TextField(
      controller: _urlController,
      decoration: const InputDecoration(labelText: 'URL'),
    );
  }

  Widget _buildHeadlineField() {
    return TextField(
      controller: _headlineController,
      decoration: const InputDecoration(labelText: 'Headline'),
    );
  }

  Widget _buildDescriptionField() {
    return TextField(
      controller: _descriptionController,
      decoration: const InputDecoration(labelText: 'Description'),
    );
  }

  Widget _buildSubmitRow() {
    return Row(
      children: [
        TextButton.icon(
          onPressed: _pickImage,
          icon: SomSvgIcon(
            _image == null
                ? SomAssets.interactionUploadDragDrop
                : SomAssets.interactionUploadSuccess,
            size: 18,
            color: Theme.of(context).colorScheme.primary,
          ),
          label: Text(
            _image == null ? 'Upload image' : 'Image: ${_image!.name}',
          ),
        ),
        const SizedBox(width: 12),
        FilledButton(
          onPressed: _isSubmitting ? null : _submit,
          child: _isSubmitting
              ? const SizedBox(
                  height: 16,
                  width: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Create'),
        ),
      ],
    );
  }
}

/// Data class for ad form submission.
class AdFormData {
  const AdFormData({
    required this.type,
    required this.branchId,
    required this.url,
    this.headline,
    this.description,
    this.startDate,
    this.endDate,
    this.bannerDate,
    this.image,
  });

  final String type;
  final String branchId;
  final String url;
  final String? headline;
  final String? description;
  final DateTime? startDate;
  final DateTime? endDate;
  final DateTime? bannerDate;
  final PlatformFile? image;
}

/// Reusable date picker row widget.
class DatePickerRow extends StatelessWidget {
  const DatePickerRow({
    super.key,
    required this.label,
    required this.value,
    required this.onPicked,
  });

  final String label;
  final DateTime? value;
  final ValueChanged<DateTime?> onPicked;

  @override
  Widget build(BuildContext context) {
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
              : '$label: ${SomFormatters.date(value)}'),
        ),
      ],
    );
  }
}
