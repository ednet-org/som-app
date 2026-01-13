import 'package:flutter/material.dart';
import 'package:openapi/openapi.dart';
import 'package:provider/provider.dart';
import 'package:som/ui/domain/application/application.dart';

import '../../domain/model/model.dart';

class UserAppBody extends StatefulWidget {
  const UserAppBody({Key? key}) : super(key: key);

  @override
  State<UserAppBody> createState() => _UserAppBodyState();
}

class _UserAppBodyState extends State<UserAppBody> {
  Future<List<UserDto>>? _usersFuture;
  UserDto? _selectedUser;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _usersFuture ??= _loadUsers(context);
  }

  Future<List<UserDto>> _loadUsers(BuildContext context) async {
    final appStore = Provider.of<Application>(context, listen: false);
    final companyId = appStore.authorization?.companyId;
    if (companyId == null) {
      return const <UserDto>[];
    }
    final api = Provider.of<Openapi>(context, listen: false);
    final response = await api
        .getUsersApi()
        .companiesCompanyIdUsersGet(companyId: companyId);
    return response.data?.toList() ?? const <UserDto>[];
  }

  Future<void> _refresh() async {
    setState(() {
      _usersFuture = _loadUsers(context);
    });
  }

  Future<void> _createDemoUser() async {
    final appStore = Provider.of<Application>(context, listen: false);
    final companyId = appStore.authorization?.companyId;
    if (companyId == null) return;
    final api = Provider.of<Openapi>(context, listen: false);
    final stamp = DateTime.now().millisecondsSinceEpoch;
    await api.getUsersApi().companiesCompanyIdRegisterUserPost(
          companyId: companyId,
          userRegistration: UserRegistration((b) => b
            ..email = 'demo-user-$stamp@som.local'
            ..firstName = 'Demo'
            ..lastName = 'User'
            ..salutation = 'Mx'
            ..roles.add(UserRegistrationRolesEnum.number0)),
        );
    await _refresh();
  }

  Future<void> _updateUser() async {
    final appStore = Provider.of<Application>(context, listen: false);
    final companyId = appStore.authorization?.companyId;
    if (companyId == null || _selectedUser?.id == null) return;
    final api = Provider.of<Openapi>(context, listen: false);
    final updated = _selectedUser!.rebuild((b) => b..title = 'Updated');
    await api
        .getUsersApi()
        .companiesCompanyIdUsersUserIdUpdatePut(
          companyId: companyId,
          userId: updated.id!,
          userDto: updated,
        );
    await _refresh();
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
        final users = snapshot.data ?? [];
        return AppBody(
          contextMenu: Row(
            children: [
              Text('Users', style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(width: 12),
              TextButton(onPressed: _refresh, child: const Text('Refresh')),
              TextButton(
                  onPressed: _createDemoUser,
                  child: const Text('Create demo user')),
              TextButton(onPressed: _updateUser, child: const Text('Update')),
              TextButton(onPressed: _deleteUser, child: const Text('Delete')),
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
                onTap: () async {
                  final appStore =
                      Provider.of<Application>(context, listen: false);
                  final companyId = appStore.authorization?.companyId;
                  if (companyId == null || user.id == null) return;
                  final api = Provider.of<Openapi>(context, listen: false);
                  final detail =
                      await api.getUsersApi().companiesCompanyIdUsersUserIdGet(
                            companyId: companyId,
                            userId: user.id!,
                          );
                  setState(() {
                    _selectedUser = detail.data ?? user;
                  });
                },
              );
            },
          ),
          rightSplit: _selectedUser == null
              ? const Center(child: Text('Select a user to view details.'))
              : Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_selectedUser!.email ?? 'User'),
                      const SizedBox(height: 8),
                      Text('Name: ${_selectedUser!.firstName ?? ''} '
                          '${_selectedUser!.lastName ?? ''}'),
                      Text('Roles: ${_selectedUser!.roles?.join(', ') ?? '-'}'),
                      Text('Title: ${_selectedUser!.title ?? '-'}'),
                    ],
                  ),
                ),
        );
      },
    );
  }
}
