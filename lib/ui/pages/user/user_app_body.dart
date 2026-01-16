import 'package:built_collection/built_collection.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:openapi/openapi.dart';
import 'package:provider/provider.dart';

import '../../domain/application/application.dart';
import '../../domain/model/layout/app_body.dart';
import '../../widgets/app_toolbar.dart';
import '../../widgets/empty_state.dart';

class UserAppBody extends StatefulWidget {
  const UserAppBody({Key? key}) : super(key: key);

  @override
  State<UserAppBody> createState() => _UserAppBodyState();
}

class _UserAppBodyState extends State<UserAppBody> {
  Future<List<UserDto>>? _usersFuture;
  List<UserDto> _users = const [];
  UserDto? _selectedUser;
  Set<int> _editRoles = {};

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _salutationController = TextEditingController();
  final _titleController = TextEditingController();
  final _telephoneController = TextEditingController();

  bool _isSaving = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _salutationController.dispose();
    _titleController.dispose();
    _telephoneController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _usersFuture ??= _loadUsers(context);
  }

  Future<List<UserDto>> _loadUsers(BuildContext context) async {
    final appStore = Provider.of<Application>(context, listen: false);
    final companyId = appStore.authorization?.companyId;
    if (companyId == null) {
      return const [];
    }
    final api = Provider.of<Openapi>(context, listen: false);
    if (appStore.authorization?.isAdmin == true) {
      final response = await api
          .getUsersApi()
          .companiesCompanyIdUsersGet(companyId: companyId);
      _users = response.data?.toList() ?? const [];
    } else if (appStore.authorization?.userId != null) {
      final response = await api.getUsersApi().companiesCompanyIdUsersUserIdGet(
            companyId: companyId,
            userId: appStore.authorization!.userId!,
          );
      _users = response.data == null ? const [] : [response.data!];
    }
    if (_users.isNotEmpty && _selectedUser == null) {
      _selectUser(_users.first);
    }
    return _users;
  }

  Future<void> _refresh() async {
    setState(() {
      _usersFuture = _loadUsers(context);
    });
  }

  void _selectUser(UserDto user) {
    setState(() {
      _selectedUser = user;
      _editRoles = user.roles?.toSet() ?? {};
      _firstNameController.text = user.firstName ?? '';
      _lastNameController.text = user.lastName ?? '';
      _salutationController.text = user.salutation ?? '';
      _titleController.text = user.title ?? '';
      _telephoneController.text = user.telephoneNr ?? '';
    });
  }

  Future<void> _createUser() async {
    final appStore = Provider.of<Application>(context, listen: false);
    if (appStore.authorization?.companyId == null) return;

    final emailController = TextEditingController();
    final firstNameController = TextEditingController();
    final lastNameController = TextEditingController();
    final salutationController = TextEditingController();
    final titleController = TextEditingController();
    String role = appStore.authorization?.isProvider == true ? 'provider' : 'buyer';
    bool isAdmin = false;

    final created = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setStateDialog) => AlertDialog(
          title: const Text('Create user'),
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
                DropdownButton<String>(
                  value: role,
                  items: _roleOptions(appStore)
                      .map((value) => DropdownMenuItem(
                            value: value,
                            child: Text(value),
                          ))
                      .toList(),
                  onChanged: (value) =>
                      setStateDialog(() => role = value ?? role),
                ),
                CheckboxListTile(
                  value: isAdmin,
                  onChanged: (value) =>
                      setStateDialog(() => isAdmin = value ?? false),
                  title: const Text('Admin'),
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
      ),
    );

    if (created != true) return;

    final roles = <UserRegistrationRolesEnum>[];
    if (role == 'buyer') {
      roles.add(UserRegistrationRolesEnum.number0);
    }
    if (role == 'provider') {
      roles.add(UserRegistrationRolesEnum.number1);
    }
    if (isAdmin) {
      roles.add(UserRegistrationRolesEnum.number4);
    }

    final api = Provider.of<Openapi>(context, listen: false);
    try {
      await api.getUsersApi().companiesCompanyIdRegisterUserPost(
            companyId: appStore.authorization!.companyId!,
            userRegistration: UserRegistration((b) => b
              ..email = emailController.text.trim()
              ..firstName = firstNameController.text.trim()
              ..lastName = lastNameController.text.trim()
              ..salutation = salutationController.text.trim()
              ..title = titleController.text.trim().isEmpty
                  ? null
                  : titleController.text.trim()
              ..roles = ListBuilder(roles)),
          );
      await _refresh();
    } on DioException catch (error) {
      final message = error.response?.data?.toString() ?? error.message ?? '';
      _showSnack(
        message.isEmpty ? 'Failed to create user.' : message,
        success: false,
      );
    }
  }

  Future<void> _saveUser() async {
    final appStore = Provider.of<Application>(context, listen: false);
    final companyId = appStore.authorization?.companyId;
    if (companyId == null || _selectedUser?.id == null) return;
    setState(() {
      _isSaving = true;
    });
    final api = Provider.of<Openapi>(context, listen: false);
    final updated = _selectedUser!.rebuild((b) => b
      ..firstName = _firstNameController.text.trim()
      ..lastName = _lastNameController.text.trim()
      ..salutation = _salutationController.text.trim()
      ..title = _titleController.text.trim().isEmpty
          ? null
          : _titleController.text.trim()
      ..telephoneNr = _telephoneController.text.trim().isEmpty
          ? null
          : _telephoneController.text.trim()
      ..roles = appStore.authorization?.isAdmin == true
          ? ListBuilder<int>(_editRoles)
          : _selectedUser!.roles?.toBuilder());
    await api.getUsersApi().companiesCompanyIdUsersUserIdUpdatePut(
          companyId: companyId,
          userId: updated.id!,
          userDto: updated,
        );
    setState(() {
      _isSaving = false;
    });
    await _refresh();
  }

  Future<void> _showChangePasswordDialog() async {
    final currentController = TextEditingController();
    final newController = TextEditingController();
    final confirmController = TextEditingController();
    bool isSubmitting = false;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setStateDialog) => AlertDialog(
          title: const Text('Change password'),
          content: SizedBox(
            width: 400,
            child: ListView(
              shrinkWrap: true,
              children: [
                TextField(
                  controller: currentController,
                  obscureText: true,
                  decoration:
                      const InputDecoration(labelText: 'Current password'),
                ),
                TextField(
                  controller: newController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'New password'),
                ),
                TextField(
                  controller: confirmController,
                  obscureText: true,
                  decoration:
                      const InputDecoration(labelText: 'Confirm new password'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: isSubmitting
                  ? null
                  : () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: isSubmitting
                  ? null
                  : () => Navigator.of(context).pop(true),
              child: isSubmitting
                  ? const SizedBox(
                      height: 16,
                      width: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Update'),
            ),
          ],
        ),
      ),
    );

    if (confirmed != true) {
      currentController.dispose();
      newController.dispose();
      confirmController.dispose();
      return;
    }

    final api = Provider.of<Openapi>(context, listen: false);
    String message = 'Password updated';
    bool success = true;
    try {
      await api.getAuthApi().authChangePasswordPost(
            authChangePasswordPostRequest: AuthChangePasswordPostRequest((b) => b
              ..currentPassword = currentController.text
              ..newPassword = newController.text
              ..confirmPassword = confirmController.text),
          );
    } on DioException catch (error) {
      success = false;
      final data = error.response?.data;
      if (data is String) {
        message = data;
      } else {
        message = 'Failed to change password';
      }
    } catch (_) {
      success = false;
      message = 'Failed to change password';
    } finally {
      currentController.dispose();
      newController.dispose();
      confirmController.dispose();
    }

    if (!mounted) return;
    _showSnack(message, success: success);
  }

  void _showSnack(String message, {bool success = true}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor:
            success ? null : Theme.of(context).colorScheme.error,
      ),
    );
  }

  Future<void> _deleteUser() async {
    final appStore = Provider.of<Application>(context, listen: false);
    final companyId = appStore.authorization?.companyId;
    if (companyId == null || _selectedUser?.id == null) return;
    final api = Provider.of<Openapi>(context, listen: false);
    await api.getUsersApi().companiesCompanyIdUsersUserIdDelete(
          companyId: companyId,
          userId: _selectedUser!.id!,
        );
    setState(() {
      _selectedUser = null;
    });
    await _refresh();
  }

  Future<void> _removeUser() async {
    final appStore = Provider.of<Application>(context, listen: false);
    final companyId = appStore.authorization?.companyId;
    if (companyId == null || _selectedUser?.id == null) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove user'),
        content: const Text(
            'This will remove the user from the company and notify them. Continue?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    final api = Provider.of<Openapi>(context, listen: false);
    await api.getUsersApi().companiesCompanyIdUsersUserIdRemovePost(
          companyId: companyId,
          userId: _selectedUser!.id!,
        );
    setState(() => _selectedUser = null);
    await _refresh();
  }

  @override
  Widget build(BuildContext context) {
    final appStore = Provider.of<Application>(context);
    if (appStore.authorization == null) {
      return const AppBody(
        contextMenu: Text('Login required'),
        leftSplit: Center(child: Text('Please log in to view users.')),
        rightSplit: SizedBox.shrink(),
      );
    }

    return FutureBuilder<List<UserDto>>(
      future: _usersFuture,
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
              child: Text('Failed to load users: ${snapshot.error}'),
            ),
            rightSplit: const SizedBox.shrink(),
          );
        }
        final users = snapshot.data ?? const [];
        if (users.isEmpty) {
          return AppBody(
            contextMenu: AppToolbar(
              title: const Text('Users'),
              actions: [
                TextButton(onPressed: _refresh, child: const Text('Refresh')),
                if (appStore.authorization?.isAdmin == true)
                  FilledButton.tonal(
                    onPressed: _createUser,
                    child: const Text('Add user'),
                  ),
              ],
            ),
            leftSplit: const EmptyState(
              icon: Icons.person_outline,
              title: 'No users found',
              message: 'Invite a user to get started',
            ),
            rightSplit: const SizedBox.shrink(),
          );
        }
        return AppBody(
          contextMenu: AppToolbar(
            title: const Text('Users'),
            actions: [
              TextButton(onPressed: _refresh, child: const Text('Refresh')),
              if (appStore.authorization?.isAdmin == true)
                FilledButton.tonal(
                  onPressed: _createUser,
                  child: const Text('Add user'),
                ),
            ],
          ),
          leftSplit: ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return ListTile(
                title: Text(user.email ?? 'User'),
                subtitle: Text(
                  '${user.firstName ?? ''} ${user.lastName ?? ''}'.trim(),
                ),
                selected: _selectedUser?.id == user.id,
                onTap: () => _selectUser(user),
              );
            },
          ),
          rightSplit: _selectedUser == null
              ? const Center(child: Text('Select a user to edit.'))
              : _buildDetails(appStore),
        );
      },
    );
  }

  Widget _buildDetails(Application appStore) {
    final user = _selectedUser!;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView(
        children: [
          Text(user.email ?? 'User', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          TextField(
            controller: _firstNameController,
            decoration: const InputDecoration(labelText: 'First name'),
          ),
          TextField(
            controller: _lastNameController,
            decoration: const InputDecoration(labelText: 'Last name'),
          ),
          TextField(
            controller: _salutationController,
            decoration: const InputDecoration(labelText: 'Salutation'),
          ),
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(labelText: 'Title'),
          ),
          TextField(
            controller: _telephoneController,
            decoration: const InputDecoration(labelText: 'Telephone'),
          ),
          const SizedBox(height: 12),
          if (appStore.authorization?.isAdmin == true)
            Wrap(
              spacing: 12,
              runSpacing: 4,
              children: _roleCheckboxes(appStore),
            ),
          const SizedBox(height: 12),
          Row(
            children: [
              ElevatedButton(
                onPressed: _isSaving ? null : _saveUser,
                child: _isSaving
                    ? const SizedBox(
                        height: 16,
                        width: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Save'),
              ),
              const SizedBox(width: 12),
              if (appStore.authorization?.isAdmin == true)
                ...[
                  TextButton(
                    onPressed: _deleteUser,
                    child: const Text('Deactivate'),
                  ),
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: _removeUser,
                    child: const Text('Remove'),
                  ),
                ],
              if (appStore.authorization?.userId == user.id)
                TextButton(
                  onPressed: _showChangePasswordDialog,
                  child: const Text('Change password'),
                ),
            ],
          ),
        ],
      ),
    );
  }

  List<String> _roleOptions(Application appStore) {
    final options = <String>[];
    if (appStore.authorization?.isBuyer == true) options.add('buyer');
    if (appStore.authorization?.isProvider == true) options.add('provider');
    return options.isEmpty ? ['buyer'] : options;
  }

  List<Widget> _roleCheckboxes(Application appStore) {
    final available = <_RoleOption>[
      if (appStore.authorization?.isBuyer == true)
        const _RoleOption(label: 'Buyer', value: 0),
      if (appStore.authorization?.isProvider == true)
        const _RoleOption(label: 'Provider', value: 1),
      const _RoleOption(label: 'Admin', value: 4),
    ];
    return available
        .map(
          (role) => FilterChip(
            label: Text(role.label),
            selected: _editRoles.contains(role.value),
            onSelected: (selected) {
              setState(() {
                if (selected) {
                  _editRoles.add(role.value);
                } else {
                  _editRoles.remove(role.value);
                }
              });
            },
          ),
        )
        .toList();
  }
}

class _RoleOption {
  final String label;
  final int value;

  const _RoleOption({required this.label, required this.value});
}
