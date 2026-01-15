import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:openapi/openapi.dart';

/// Form widget for creating a new inquiry.
///
/// Handles all form fields including branch/category selection,
/// delivery details, provider criteria, and contact information.
class InquiryCreateForm extends StatefulWidget {
  const InquiryCreateForm({
    Key? key,
    required this.branches,
    required this.onSubmit,
    this.initialContactSalutation,
    this.initialContactTitle,
    this.initialContactFirstName,
    this.initialContactLastName,
    this.initialContactTelephone,
    this.initialContactEmail,
  }) : super(key: key);

  final List<Branch> branches;
  final Future<void> Function(InquiryFormData data) onSubmit;
  final String? initialContactSalutation;
  final String? initialContactTitle;
  final String? initialContactFirstName;
  final String? initialContactLastName;
  final String? initialContactTelephone;
  final String? initialContactEmail;

  @override
  State<InquiryCreateForm> createState() => _InquiryCreateFormState();
}

class _InquiryCreateFormState extends State<InquiryCreateForm> {
  final _deliveryZipsController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _providerZipController = TextEditingController();
  final _contactSalutationController = TextEditingController();
  final _contactTitleController = TextEditingController();
  final _contactFirstNameController = TextEditingController();
  final _contactLastNameController = TextEditingController();
  final _contactTelephoneController = TextEditingController();
  final _contactEmailController = TextEditingController();

  String? _selectedBranchId;
  String? _selectedCategoryId;
  List<String> _productTags = [];
  DateTime? _deadline;
  int _numberOfProviders = 1;
  String? _providerType;
  String? _providerCompanySize;
  int? _radiusKm;
  PlatformFile? _selectedPdf;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _contactSalutationController.text = widget.initialContactSalutation ?? '';
    _contactTitleController.text = widget.initialContactTitle ?? '';
    _contactFirstNameController.text = widget.initialContactFirstName ?? '';
    _contactLastNameController.text = widget.initialContactLastName ?? '';
    _contactTelephoneController.text = widget.initialContactTelephone ?? '';
    _contactEmailController.text = widget.initialContactEmail ?? '';
  }

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

  List<Category>? get _categories {
    if (_selectedBranchId == null) return null;
    return widget.branches
        .firstWhere(
          (branch) => branch.id == _selectedBranchId,
          orElse: () => Branch(),
        )
        .categories
        ?.toList();
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

  Future<void> _submit() async {
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

    setState(() => _isSubmitting = true);

    try {
      await widget.onSubmit(InquiryFormData(
        branchId: _selectedBranchId!,
        categoryId: _selectedCategoryId!,
        productTags: _productTags,
        deadline: _deadline!,
        deliveryZips: zips,
        numberOfProviders: _numberOfProviders,
        description: _descriptionController.text.trim(),
        providerZip: _providerZipController.text.trim(),
        radiusKm: _radiusKm,
        providerType: _providerType,
        providerCompanySize: _providerCompanySize,
        contactSalutation: _contactSalutationController.text.trim(),
        contactTitle: _contactTitleController.text.trim(),
        contactFirstName: _contactFirstNameController.text.trim(),
        contactLastName: _contactLastNameController.text.trim(),
        contactTelephone: _contactTelephoneController.text.trim(),
        contactEmail: _contactEmailController.text.trim(),
        pdfFile: _selectedPdf,
      ));
      _clearForm();
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  void _clearForm() {
    setState(() {
      _selectedPdf = null;
      _productTags = [];
      _deliveryZipsController.clear();
      _descriptionController.clear();
      _providerZipController.clear();
    });
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView(
        children: [
          Text('Create inquiry', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          _buildBranchCategorySection(),
          const SizedBox(height: 8),
          _buildProductTagsField(),
          const SizedBox(height: 8),
          _buildDeadlineSection(),
          _buildDeliveryZipsField(),
          const SizedBox(height: 8),
          _buildProvidersCountSection(),
          _buildDescriptionField(),
          const SizedBox(height: 8),
          _buildProviderCriteriaSection(),
          const Divider(height: 24),
          _buildContactInfoSection(context),
          const SizedBox(height: 12),
          _buildSubmitSection(),
        ],
      ),
    );
  }

  Widget _buildBranchCategorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButton<String>(
          hint: const Text('Branch'),
          value: _selectedBranchId,
          items: widget.branches
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
          items: (_categories ?? const [])
              .map((category) => DropdownMenuItem(
                    value: category.id,
                    child: Text(category.name ?? category.id ?? '-'),
                  ))
              .toList(),
          onChanged: (value) => setState(() => _selectedCategoryId = value),
        ),
      ],
    );
  }

  Widget _buildProductTagsField() {
    return TextField(
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
    );
  }

  Widget _buildDeadlineSection() {
    return TextButton(
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
    );
  }

  Widget _buildDeliveryZipsField() {
    return TextField(
      controller: _deliveryZipsController,
      decoration: const InputDecoration(
        labelText: 'Delivery ZIPs (comma separated)',
      ),
    );
  }

  Widget _buildProvidersCountSection() {
    return DropdownButton<int>(
      value: _numberOfProviders,
      items: List.generate(10, (index) => index + 1)
          .map((value) => DropdownMenuItem(
                value: value,
                child: Text(value.toString()),
              ))
          .toList(),
      onChanged: (value) => setState(() => _numberOfProviders = value ?? 1),
    );
  }

  Widget _buildDescriptionField() {
    return TextField(
      controller: _descriptionController,
      maxLines: 3,
      decoration: const InputDecoration(labelText: 'Description'),
    );
  }

  Widget _buildProviderCriteriaSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
      ],
    );
  }

  Widget _buildContactInfoSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
      ],
    );
  }

  Widget _buildSubmitSection() {
    return Row(
      children: [
        TextButton(
          onPressed: _pickPdf,
          child: Text(_selectedPdf == null
              ? 'Attach PDF'
              : 'PDF: ${_selectedPdf!.name}'),
        ),
        const SizedBox(width: 12),
        ElevatedButton(
          onPressed: _isSubmitting ? null : _submit,
          child: _isSubmitting
              ? const SizedBox(
                  height: 16,
                  width: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Create inquiry'),
        ),
      ],
    );
  }
}

/// Data class for inquiry form submission.
class InquiryFormData {
  const InquiryFormData({
    required this.branchId,
    required this.categoryId,
    required this.productTags,
    required this.deadline,
    required this.deliveryZips,
    required this.numberOfProviders,
    this.description,
    this.providerZip,
    this.radiusKm,
    this.providerType,
    this.providerCompanySize,
    this.contactSalutation,
    this.contactTitle,
    this.contactFirstName,
    this.contactLastName,
    this.contactTelephone,
    this.contactEmail,
    this.pdfFile,
  });

  final String branchId;
  final String categoryId;
  final List<String> productTags;
  final DateTime deadline;
  final List<String> deliveryZips;
  final int numberOfProviders;
  final String? description;
  final String? providerZip;
  final int? radiusKm;
  final String? providerType;
  final String? providerCompanySize;
  final String? contactSalutation;
  final String? contactTitle;
  final String? contactFirstName;
  final String? contactLastName;
  final String? contactTelephone;
  final String? contactEmail;
  final PlatformFile? pdfFile;
}
