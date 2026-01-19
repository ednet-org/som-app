import 'package:flutter/material.dart';
import 'package:openapi/openapi.dart';
import 'package:provider/provider.dart';
import 'package:som/ui/theme/som_assets.dart';

import '../../domain/application/application.dart';
import '../../domain/infrastructure/supabase_realtime.dart';
import '../../domain/model/layout/app_body.dart';
import '../../theme/tokens.dart';
import '../../widgets/app_toolbar.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/inline_message.dart';
import '../../widgets/selectable_list_view.dart';
import '../../widgets/som_list_tile.dart';

class ConsultantsAppBody extends StatefulWidget {
  const ConsultantsAppBody({super.key});

  @override
  State<ConsultantsAppBody> createState() => _ConsultantsAppBodyState();
}

class _ConsultantsAppBodyState extends State<ConsultantsAppBody> {
  Future<List<UserDto>>? _consultantsFuture;
  List<UserDto> _consultants = const [];
  UserDto? _selected;
  bool _realtimeReady = false;
  late final RealtimeRefreshHandle _realtimeRefresh =
      RealtimeRefreshHandle(_handleRealtimeRefresh);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _consultantsFuture ??= _loadConsultants();
    _setupRealtime();
  }

  @override
  void dispose() {
    _realtimeRefresh.dispose();
    super.dispose();
  }

  void _handleRealtimeRefresh() {
    if (!mounted) return;
    _refresh();
  }

  void _setupRealtime() {
    if (_realtimeReady) return;
    final appStore = Provider.of<Application>(context, listen: false);
    SupabaseRealtime.setAuth(appStore.authorization?.token);
    _realtimeRefresh.subscribe(
      tables: const ['users'],
      channelName: 'consultants-page',
    );
    _realtimeReady = true;
  }

  Future<List<UserDto>> _loadConsultants() async {
    final api = Provider.of<Openapi>(context, listen: false);
    final response = await api.getConsultantsApi().consultantsGet();
    _consultants = response.data?.toList() ?? const [];
    return _consultants;
  }

  Future<void> _refresh() async {
    setState(() {
      _consultantsFuture = _loadConsultants();
    });
  }

  Future<void> _createConsultant() async {
    final emailController = TextEditingController();
    final firstNameController = TextEditingController();
    final lastNameController = TextEditingController();
    final salutationController = TextEditingController();
    final titleController = TextEditingController();

    final created = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create consultant'),
        content: SizedBox(
          width: 400,
          child: ListView(
            shrinkWrap: true,
            children: [
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              TextField(
                controller: firstNameController,
                decoration: const InputDecoration(labelText: 'First name'),
              ),
              TextField(
                controller: lastNameController,
                decoration: const InputDecoration(labelText: 'Last name'),
              ),
              TextField(
                controller: salutationController,
                decoration: const InputDecoration(labelText: 'Salutation'),
              ),
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Create'),
          ),
        ],
      ),
    );

    if (created != true) return;
    if (!mounted) return;
    final api = Provider.of<Openapi>(context, listen: false);
    await api.getConsultantsApi().consultantsPost(
          userRegistration: UserRegistration((b) => b
            ..email = emailController.text.trim()
            ..firstName = firstNameController.text.trim()
            ..lastName = lastNameController.text.trim()
            ..salutation = salutationController.text.trim()
            ..title = titleController.text.trim().isEmpty
                ? null
                : titleController.text.trim()
            ..roles.add(UserRegistrationRolesEnum.number3)),
        );
    await _refresh();
  }

  @override
  Widget build(BuildContext context) {
    final appStore = Provider.of<Application>(context);
    if (appStore.authorization == null ||
        appStore.authorization?.isConsultant != true) {
      return AppBody(
        contextMenu: AppToolbar(title: const Text('Consultants')),
        leftSplit: const EmptyState(
          asset: SomAssets.illustrationStateNoConnection,
          title: 'Consultant access required',
          message: 'Only consultants can manage consultants.',
        ),
        rightSplit: const SizedBox.shrink(),
      );
    }

    return FutureBuilder<List<UserDto>>(
      future: _consultantsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return AppBody(
            contextMenu: _buildToolbar(),
            leftSplit: const Center(child: CircularProgressIndicator()),
            rightSplit: const SizedBox.shrink(),
          );
        }
        if (snapshot.hasError) {
          return AppBody(
            contextMenu: _buildToolbar(),
            leftSplit: Center(
              child: InlineMessage(
                message: 'Failed to load consultants: ${snapshot.error}',
                type: InlineMessageType.error,
              ),
            ),
            rightSplit: const SizedBox.shrink(),
          );
        }
        final consultants = snapshot.data ?? const [];
        if (consultants.isEmpty) {
          return AppBody(
            contextMenu: _buildToolbar(),
            leftSplit: const EmptyState(
              asset: SomAssets.emptySearchResults,
              title: 'No consultants found',
              message: 'Invite a consultant to get started',
            ),
            rightSplit: const SizedBox.shrink(),
          );
        }
        return AppBody(
          contextMenu: _buildToolbar(),
          leftSplit: SelectableListView<UserDto>(
            items: consultants,
            selectedIndex: () {
              final index =
                  consultants.indexWhere((user) => user.id == _selected?.id);
              return index < 0 ? null : index;
            }(),
            onSelectedIndex: (index) =>
                setState(() => _selected = consultants[index]),
            itemBuilder: (context, consultant, isSelected) {
              final index = consultants.indexOf(consultant);
              return Column(
                children: [
                  SomListTile(
                    selected: isSelected,
                    onTap: () => setState(() => _selected = consultant),
                    title: Text(consultant.email ?? 'Consultant'),
                    subtitle: Text(
                      '${consultant.firstName ?? ''} ${consultant.lastName ?? ''}'
                          .trim(),
                    ),
                  ),
                  if (index != consultants.length - 1)
                    const Divider(height: 1),
                ],
              );
            },
          ),
          rightSplit: _selected == null
              ? const EmptyState(
                  asset: SomAssets.emptySearchResults,
                  title: 'Select a consultant',
                  message: 'Choose a consultant from the list to view details.',
                )
              : Padding(
                  padding: const EdgeInsets.all(SomSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_selected!.email ?? 'Consultant',
                          style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 8),
                      Text('Name: ${_selected!.firstName ?? ''} ${_selected!.lastName ?? ''}'),
                      Text('Salutation: ${_selected!.salutation ?? '-'}'),
                      Text('Title: ${_selected!.title ?? '-'}'),
                    ],
                  ),
                ),
        );
      },
    );
  }

  Widget _buildToolbar() {
    return AppToolbar(
      title: const Text('Consultants'),
      actions: [
        FilledButton.tonal(
          onPressed: _createConsultant,
          child: const Text('Add consultant'),
        ),
      ],
    );
  }
}
