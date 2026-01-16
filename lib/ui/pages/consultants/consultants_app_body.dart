import 'package:flutter/material.dart';
import 'package:openapi/openapi.dart';
import 'package:provider/provider.dart';

import '../../domain/application/application.dart';
import '../../domain/model/layout/app_body.dart';
import '../../widgets/app_toolbar.dart';
import '../../widgets/empty_state.dart';

class ConsultantsAppBody extends StatefulWidget {
  const ConsultantsAppBody({Key? key}) : super(key: key);

  @override
  State<ConsultantsAppBody> createState() => _ConsultantsAppBodyState();
}

class _ConsultantsAppBodyState extends State<ConsultantsAppBody> {
  Future<List<UserDto>>? _consultantsFuture;
  List<UserDto> _consultants = const [];
  UserDto? _selected;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _consultantsFuture ??= _loadConsultants();
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
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Create'),
          ),
        ],
      ),
    );

    if (created != true) return;
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
      return const AppBody(
        contextMenu: Text('Consultant access required'),
        leftSplit:
            Center(child: Text('Only consultants can manage consultants.')),
        rightSplit: SizedBox.shrink(),
      );
    }

    return FutureBuilder<List<UserDto>>(
      future: _consultantsFuture,
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
              child: Text('Failed to load consultants: ${snapshot.error}'),
            ),
            rightSplit: const SizedBox.shrink(),
          );
        }
        final consultants = snapshot.data ?? const [];
        if (consultants.isEmpty) {
          return AppBody(
            contextMenu: AppToolbar(
              title: const Text('Consultants'),
              actions: [
                TextButton(onPressed: _refresh, child: const Text('Refresh')),
                FilledButton.tonal(
                  onPressed: _createConsultant,
                  child: const Text('Add consultant'),
                ),
              ],
            ),
            leftSplit: const EmptyState(
              icon: Icons.support_agent_outlined,
              title: 'No consultants found',
              message: 'Invite a consultant to get started',
            ),
            rightSplit: const SizedBox.shrink(),
          );
        }
        return AppBody(
          contextMenu: AppToolbar(
            title: const Text('Consultants'),
            actions: [
              TextButton(onPressed: _refresh, child: const Text('Refresh')),
              FilledButton.tonal(
                onPressed: _createConsultant,
                child: const Text('Add consultant'),
              ),
            ],
          ),
          leftSplit: ListView.builder(
            itemCount: consultants.length,
            itemBuilder: (context, index) {
              final consultant = consultants[index];
              return ListTile(
                title: Text(consultant.email ?? 'Consultant'),
                subtitle: Text(
                    '${consultant.firstName ?? ''} ${consultant.lastName ?? ''}'.trim()),
                selected: _selected?.id == consultant.id,
                onTap: () => setState(() => _selected = consultant),
              );
            },
          ),
          rightSplit: _selected == null
              ? const Center(child: Text('Select a consultant.'))
              : Padding(
                  padding: const EdgeInsets.all(16),
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
}
