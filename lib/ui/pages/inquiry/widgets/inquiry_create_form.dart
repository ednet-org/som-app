import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:openapi/openapi.dart';

import '../../../domain/model/forms/som_drop_down.dart';
import '../../../domain/model/forms/som_text_input.dart';
import '../../../widgets/design_system/som_button.dart';

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
        SomDropDown<Branch>(
          label: 'Branch',
          value: _selectedBranchId == null ? null : widget.branches.where((b) => b.id == _selectedBranchId).firstOrNull,
          items: widget.branches,
          itemAsString: (Branch b) => b.name ?? b.id ?? '-',
          onChanged: (Branch? b) => setState(() {
            _selectedBranchId = b?.id;
            _selectedCategoryId = null;
          }),
        ),
        const SizedBox(height: 12),
        SomDropDown<Category>(
          label: 'Category',
          value: _selectedCategoryId == null
              ? null
              : _categories?.where((c) => c.id == _selectedCategoryId).firstOrNull,
          items: _categories ?? [],
          itemAsString: (Category c) => c.name ?? c.id ?? '-',
          onChanged: (Category? c) => setState(() => _selectedCategoryId = c?.id),
        ),
      ],
    );
  }

  Widget _buildProductTagsField() {
    return SomTextInput(
      label: 'Product tags (comma separated)',
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
    return SomButton(
      text: _deadline == null ? 'Select deadline' : 'Deadline: ${_deadline!.toIso8601String().split('T').first}',
      iconData: Icons.calendar_today,
      type: SomButtonType.secondary,
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
    );
  }

  Widget _buildDeliveryZipsField() {
    return SomTextInput(
      controller: _deliveryZipsController,
      label: 'Delivery ZIPs (comma separated)', required: true,
    );
  }

  Widget _buildProvidersCountSection() {
    return SomDropDown<int>(
      label: 'Number of providers',
      value: _numberOfProviders,
      items: List.generate(10, (index) => index + 1),
      onChanged: (value) => setState(() => _numberOfProviders = value ?? 1),
    );
  }

  Widget _buildDescriptionField() {
    return SomTextInput(
      controller: _descriptionController,
      label: 'Description',
      maxLines: 3,
    );
  }

  Widget _buildProviderCriteriaSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SomTextInput(
          controller: _providerZipController,
          label: 'Provider ZIP (optional)',
        ),
        const SizedBox(height: 12),
        SomDropDown<int>(
          label: 'Radius km',
          value: _radiusKm,
          items: const [50, 150, 250],
          itemAsString: (int i) => '${i}km',
          onChanged: (value) => setState(() => _radiusKm = value),
        ),
        const SizedBox(height: 12),
        SomDropDown<String>(
          label: 'Provider type',
          value: _providerType,
          items: const ['haendler', 'hersteller', 'dienstleister', 'grosshaendler'],
          itemAsString: (String s) {
            switch (s) {
              case 'haendler':
                return 'Händler';
              case 'hersteller':
                return 'Hersteller';
              case 'dienstleister':
                return 'Dienstleister';
              case 'grosshaendler':
                return 'Großhändler';
              default:
                return s;
            }
          },
          onChanged: (value) => setState(() => _providerType = value),
        ),
        const SizedBox(height: 12),
        SomDropDown<String>(
          label: 'Provider size',
          value: _providerCompanySize,
          items: const ['0-10', '11-50', '51-100', '101-250', '251-500', '500+'],
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
        const SizedBox(height: 12),
        SomTextInput(
          controller: _contactSalutationController,
          label: 'Salutation',
        ),
        const SizedBox(height: 12),
        SomTextInput(
          controller: _contactTitleController,
          label: 'Title',
        ),
        const SizedBox(height: 12),
        SomTextInput(
          controller: _contactFirstNameController,
          label: 'First name',
        ),
        const SizedBox(height: 12),
        SomTextInput(
          controller: _contactLastNameController,
          label: 'Last name',
        ),
        const SizedBox(height: 12),
        SomTextInput(
          controller: _contactTelephoneController,
          label: 'Telephone',
        ),
        const SizedBox(height: 12),
        SomTextInput(
          controller: _contactEmailController,
          label: 'Email',
        ),
      ],
    );
  }

  Widget _buildSubmitSection() {
    return Row(
      children: [
        SomButton(
          onPressed: _pickPdf,
          text: _selectedPdf == null
              ? 'Attach PDF'
              : 'PDF: ${_selectedPdf!.name}',
          iconData: Icons.attach_file,
          type: SomButtonType.ghost,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: SomButton(
            onPressed: _isSubmitting ? null : _submit,
            text: 'Create inquiry',
            isLoading: _isSubmitting,
            type: SomButtonType.primary,
          ),
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
