import 'package:built_collection/built_collection.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:openapi/openapi.dart';
import 'package:som/ui/theme/som_assets.dart';
import 'package:som/ui/widgets/design_system/som_input.dart';

import '../../../domain/model/forms/som_drop_down.dart';
import '../../../domain/model/forms/som_text_input.dart';
import '../../../widgets/design_system/som_button.dart';

/// Form widget for creating a new inquiry.
///
/// Handles all form fields including branch/category selection,
/// delivery details, provider criteria, and contact information.
class InquiryCreateForm extends StatefulWidget {
  const InquiryCreateForm({
    super.key,
    required this.branches,
    required this.onSubmit,
    required this.onEnsureBranch,
    required this.onEnsureCategory,
    this.initialContactSalutation,
    this.initialContactTitle,
    this.initialContactFirstName,
    this.initialContactLastName,
    this.initialContactTelephone,
    this.initialContactEmail,
  });

  final List<Branch> branches;
  final Future<void> Function(InquiryFormData data) onSubmit;
  final Future<Branch> Function(String name) onEnsureBranch;
  final Future<Category> Function(String branchId, String name)
  onEnsureCategory;
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
  final _branchController = TextEditingController();
  final _categoryController = TextEditingController();
  final _branchFocusNode = FocusNode();
  final _categoryFocusNode = FocusNode();
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
  late List<Branch> _branchOptions;

  @override
  void initState() {
    super.initState();
    _branchOptions = List.of(widget.branches);
    _contactSalutationController.text = widget.initialContactSalutation ?? '';
    _contactTitleController.text = widget.initialContactTitle ?? '';
    _contactFirstNameController.text = widget.initialContactFirstName ?? '';
    _contactLastNameController.text = widget.initialContactLastName ?? '';
    _contactTelephoneController.text = widget.initialContactTelephone ?? '';
    _contactEmailController.text = widget.initialContactEmail ?? '';
  }

  @override
  void didUpdateWidget(covariant InquiryCreateForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.branches != widget.branches) {
      final byId = {
        for (final branch in _branchOptions)
          if (branch.id != null) branch.id!: branch,
      };
      for (final branch in widget.branches) {
        if (branch.id != null) {
          byId[branch.id!] = branch;
        }
      }
      _branchOptions = byId.values.toList();
    }
  }

  @override
  void dispose() {
    _branchController.dispose();
    _categoryController.dispose();
    _branchFocusNode.dispose();
    _categoryFocusNode.dispose();
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
    final branch = _availableBranches.firstWhere(
      (b) => b.id == _selectedBranchId,
      orElse: () => Branch(),
    );
    final categories = branch.categories?.toList() ?? const [];
    return categories.where((c) => c.status != 'declined').toList();
  }

  List<Branch> get _availableBranches =>
      _branchOptions.where((b) => b.status != 'declined').toList();

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

  String _normalize(String value) {
    return value
        .toLowerCase()
        .replaceAll(RegExp(r'[,_]+'), ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  Branch? _findBranchByText(String text) {
    final query = _normalize(text);
    if (query.isEmpty) return null;
    for (final branch in _availableBranches) {
      if (_normalize(branch.name ?? '') == query) {
        return branch;
      }
    }
    return null;
  }

  Category? _findCategoryByText(String text) {
    final query = _normalize(text);
    if (query.isEmpty) return null;
    final categories = _categories ?? const [];
    for (final category in categories) {
      if (_normalize(category.name ?? '') == query) {
        return category;
      }
    }
    return null;
  }

  void _upsertBranch(Branch branch) {
    final id = branch.id;
    if (id == null) return;
    setState(() {
      final index = _branchOptions.indexWhere((b) => b.id == id);
      if (index == -1) {
        _branchOptions = [..._branchOptions, branch];
      } else {
        final updated = [..._branchOptions];
        updated[index] = branch;
        _branchOptions = updated;
      }
    });
  }

  void _upsertCategory(Category category) {
    final branchId = _selectedBranchId;
    if (branchId == null) return;
    setState(() {
      final branchIndex = _branchOptions.indexWhere((b) => b.id == branchId);
      if (branchIndex == -1) return;
      final branch = _branchOptions[branchIndex];
      final categories = branch.categories?.toList() ?? <Category>[];
      final existingIndex = categories.indexWhere((c) => c.id == category.id);
      if (existingIndex == -1) {
        categories.add(category);
      } else {
        categories[existingIndex] = category;
      }
      final updatedBranch = branch.rebuild(
        (b) => b..categories = ListBuilder<Category>(categories),
      );
      final updated = [..._branchOptions];
      updated[branchIndex] = updatedBranch;
      _branchOptions = updated;
    });
  }

  Future<String?> _resolveBranchId() async {
    final text = _branchController.text.trim();
    if (text.isEmpty) return null;
    final match = _findBranchByText(text);
    final matchId = match?.id;
    if (matchId != null) {
      if (_selectedBranchId != matchId) {
        setState(() {
          _selectedBranchId = matchId;
          _selectedCategoryId = null;
          _categoryController.clear();
        });
      }
      return matchId;
    }
    try {
      final created = await widget.onEnsureBranch(text);
      if (created.id == null) return null;
      _upsertBranch(created);
      setState(() {
        _selectedBranchId = created.id;
        _selectedCategoryId = null;
        _categoryController.clear();
      });
      return created.id!;
    } catch (error) {
      _showSnack('Failed to create branch: $error');
      return null;
    }
  }

  Future<String?> _resolveCategoryId() async {
    if (_selectedBranchId == null) return null;
    final text = _categoryController.text.trim();
    if (text.isEmpty) return null;
    final match = _findCategoryByText(text);
    final matchId = match?.id;
    if (matchId != null) {
      setState(() => _selectedCategoryId = matchId);
      return matchId;
    }
    try {
      final created = await widget.onEnsureCategory(_selectedBranchId!, text);
      if (created.id == null) return null;
      _upsertCategory(created);
      setState(() => _selectedCategoryId = created.id);
      return created.id!;
    } catch (error) {
      _showSnack('Failed to create category: $error');
      return null;
    }
  }

  Future<void> _submit() async {
    final branchId = await _resolveBranchId();
    if (branchId == null) {
      _showSnack('Please select or enter a branch.');
      return;
    }
    final categoryId = await _resolveCategoryId();
    if (categoryId == null) {
      _showSnack('Please select or enter a category.');
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
      await widget.onSubmit(
        InquiryFormData(
          branchId: branchId,
          categoryId: categoryId,
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
        ),
      );
      _clearForm();
    } catch (error) {
      _showSnack(_formatError(error));
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  void _clearForm() {
    setState(() {
      _selectedPdf = null;
      _productTags = [];
      _selectedBranchId = null;
      _selectedCategoryId = null;
      _branchController.clear();
      _categoryController.clear();
      _deliveryZipsController.clear();
      _descriptionController.clear();
      _providerZipController.clear();
    });
  }

  void _showSnack(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  String _formatError(Object error) {
    final message = error.toString();
    if (message.startsWith('Exception: ')) {
      return message.substring('Exception: '.length);
    }
    return message;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView(
        children: [
          Text(
            'Create inquiry',
            style: Theme.of(context).textTheme.titleMedium,
          ),
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
    final selectedBranch = _availableBranches
        .where((b) => b.id == _selectedBranchId)
        .toList();
    final branch = selectedBranch.isEmpty ? null : selectedBranch.first;
    final selectedCategory = (_categories ?? const [])
        .where((c) => c.id == _selectedCategoryId)
        .toList();
    final category = selectedCategory.isEmpty ? null : selectedCategory.first;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RawAutocomplete<Branch>(
          textEditingController: _branchController,
          focusNode: _branchFocusNode,
          displayStringForOption: (option) => option.name ?? '',
          optionsBuilder: (TextEditingValue value) {
            final query = _normalize(value.text);
            final options = _availableBranches;
            if (query.isEmpty) return options;
            return options.where(
              (b) => _normalize(b.name ?? '').contains(query),
            );
          },
          onSelected: (Branch b) {
            setState(() {
              _selectedBranchId = b.id;
              _selectedCategoryId = null;
              _categoryController.clear();
            });
          },
          fieldViewBuilder: (context, controller, focusNode, onSubmitted) {
            return SomInput(
              label: 'Branch *',
              hintText: 'Type to search or add a new branch',
              controller: controller,
              focusNode: focusNode,
              onChanged: (value) {
                final match = _findBranchByText(value);
                setState(() {
                  _selectedBranchId = match?.id;
                  if (match == null) {
                    _selectedCategoryId = null;
                    _categoryController.clear();
                  }
                });
              },
            );
          },
          optionsViewBuilder: (context, onSelected, options) {
            return Align(
              alignment: Alignment.topLeft,
              child: Material(
                color: Theme.of(context).colorScheme.surface,
                elevation: 4,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxHeight: 240,
                    maxWidth: 360,
                  ),
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: options.length,
                    itemBuilder: (context, index) {
                      final option = options.elementAt(index);
                      return ListTile(
                        title: Text(option.name ?? option.id ?? 'Branch'),
                        subtitle: option.status == 'pending'
                            ? const Text('Pending approval')
                            : null,
                        onTap: () => onSelected(option),
                      );
                    },
                  ),
                ),
              ),
            );
          },
        ),
        if (branch?.status == 'pending')
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              'Branch pending approval.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.error,
              ),
            ),
          ),
        const SizedBox(height: 12),
        IgnorePointer(
          ignoring: _selectedBranchId == null,
          child: Opacity(
            opacity: _selectedBranchId == null ? 0.5 : 1,
            child: RawAutocomplete<Category>(
              textEditingController: _categoryController,
              focusNode: _categoryFocusNode,
              displayStringForOption: (option) => option.name ?? '',
              optionsBuilder: (TextEditingValue value) {
                final query = _normalize(value.text);
                final options = _categories ?? const [];
                if (query.isEmpty) return options;
                return options.where(
                  (c) => _normalize(c.name ?? '').contains(query),
                );
              },
              onSelected: (Category c) =>
                  setState(() => _selectedCategoryId = c.id),
              fieldViewBuilder: (context, controller, focusNode, onSubmitted) {
                return SomInput(
                  label: 'Category *',
                  hintText: _selectedBranchId == null
                      ? 'Select branch first'
                      : 'Type to search or add a new category',
                  controller: controller,
                  focusNode: focusNode,
                  onChanged: (value) {
                    final match = _findCategoryByText(value);
                    setState(() => _selectedCategoryId = match?.id);
                  },
                );
              },
              optionsViewBuilder: (context, onSelected, options) {
                return Align(
                  alignment: Alignment.topLeft,
                  child: Material(
                    color: Theme.of(context).colorScheme.surface,
                    elevation: 4,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxHeight: 240,
                        maxWidth: 360,
                      ),
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: options.length,
                        itemBuilder: (context, index) {
                          final option = options.elementAt(index);
                          return ListTile(
                            title: Text(option.name ?? option.id ?? 'Category'),
                            subtitle: option.status == 'pending'
                                ? const Text('Pending approval')
                                : null,
                            onTap: () => onSelected(option),
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        if (_selectedBranchId == null)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              'Choose a branch to see categories.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        if (category?.status == 'pending')
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              'Category pending approval.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.error,
              ),
            ),
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
      text: _deadline == null
          ? 'Select deadline'
          : 'Deadline: ${_deadline!.toIso8601String().split('T').first}',
      icon: SomAssets.iconCalendar,
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
      label: 'Delivery ZIPs (comma separated)',
      required: true,
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
          items: const [
            'haendler',
            'hersteller',
            'dienstleister',
            'grosshaendler',
          ],
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
          items: const [
            '0-10',
            '11-50',
            '51-100',
            '101-250',
            '251-500',
            '500+',
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
        const SizedBox(height: 12),
        SomTextInput(
          controller: _contactSalutationController,
          label: 'Salutation',
        ),
        const SizedBox(height: 12),
        SomTextInput(controller: _contactTitleController, label: 'Title'),
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
        SomTextInput(controller: _contactEmailController, label: 'Email'),
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
          icon: SomAssets.iconPdf,
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
