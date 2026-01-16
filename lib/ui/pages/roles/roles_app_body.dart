import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:openapi/openapi.dart';
import 'package:provider/provider.dart';

import '../../domain/model/layout/app_body.dart';

class RolesAppBody extends StatefulWidget {
  const RolesAppBody({Key? key}) : super(key: key);

  @override
  State<RolesAppBody> createState() => _RolesAppBodyState();
}

class _RolesAppBodyState extends State<RolesAppBody> {
  Future<List<Role>>? _rolesFuture;
  List<Role> _roles = const [];
  Role? _selected;
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  String? _error;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _rolesFuture ??= _loadRoles();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<List<Role>> _loadRoles() async {
    final api = Provider.of<Openapi>(context, listen: false);
    final response = await api.getRolesApi().rolesGet();
    _roles = response.data?.toList() ?? const [];
    return _roles;
  }

  Future<void> _refresh() async {
    setState(() {
      _rolesFuture = _loadRoles();
    });
  }

  void _selectRole(Role role) {
    setState(() {
      _selected = role;
      _nameController.text = role.name;
      _descriptionController.text = role.description ?? '';
    });
  }

  Future<void> _createRole() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      setState(() => _error = 'Role name is required.');
      return;
    }
    final api = Provider.of<Openapi>(context, listen: false);
    try {
      await api.getRolesApi().rolesPost(
            roleInput: RoleInput((b) => b
              ..name = name
              ..description = _descriptionController.text.trim().isEmpty
                  ? null
                  : _descriptionController.text.trim()),
          );
      _clearForm();
      await _refresh();
    } on DioException catch (error) {
      setState(() => _error = _extractError(error));
    }
  }

  Future<void> _updateRole() async {
    final role = _selected;
    if (role == null) return;
    final api = Provider.of<Openapi>(context, listen: false);
    try {
      await api.getRolesApi().rolesRoleIdPut(
            roleId: role.id,
            roleInput: RoleInput((b) => b
              ..name = _nameController.text.trim()
              ..description = _descriptionController.text.trim().isEmpty
                  ? null
                  : _descriptionController.text.trim()),
          );
      await _refresh();
    } on DioException catch (error) {
      setState(() => _error = _extractError(error));
    }
  }

  Future<void> _deleteRole() async {
    final role = _selected;
    if (role == null) return;
    final api = Provider.of<Openapi>(context, listen: false);
    try {
      await api.getRolesApi().rolesRoleIdDelete(roleId: role.id);
      _clearForm();
      await _refresh();
    } on DioException catch (error) {
      setState(() => _error = _extractError(error));
    }
  }

  void _clearForm() {
    setState(() {
      _selected = null;
      _nameController.clear();
      _descriptionController.clear();
    });
  }

  String _extractError(DioException error) {
    final data = error.response?.data;
    if (data is String) return data;
    if (data is Map && data['message'] != null) {
      return data['message'].toString();
    }
    return error.message ?? 'Request failed.';
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Role>>(
      future: _rolesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const AppBody(
            contextMenu: Text('Roles'),
            leftSplit: Center(child: CircularProgressIndicator()),
            rightSplit: SizedBox.shrink(),
          );
        }
        if (snapshot.hasError) {
          return AppBody(
            contextMenu: const Text('Roles'),
            leftSplit: Center(
              child: Text('Failed to load roles: ${snapshot.error}'),
            ),
            rightSplit: const SizedBox.shrink(),
          );
        }
        final roles = snapshot.data ?? const [];
        return AppBody(
          contextMenu: Row(
            children: [
              const Text('Roles'),
              const SizedBox(width: 12),
              TextButton(onPressed: _refresh, child: const Text('Refresh')),
              const SizedBox(width: 12),
              TextButton(onPressed: _clearForm, child: const Text('New')),
            ],
          ),
          leftSplit: ListView(
            children: roles
                .map(
                  (role) => ListTile(
                    title: Text(role.name),
                    subtitle: Text(role.description ?? ''),
                    selected: _selected?.id == role.id,
                    onTap: () => _selectRole(role),
                  ),
                )
                .toList(),
          ),
          rightSplit: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_error != null)
                  Text(
                    _error!,
                    style: const TextStyle(color: Colors.redAccent),
                  ),
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Role name'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: _selected == null ? _createRole : _updateRole,
                      child: Text(_selected == null ? 'Create' : 'Update'),
                    ),
                    const SizedBox(width: 12),
                    if (_selected != null)
                      TextButton(
                        onPressed: _deleteRole,
                        child: const Text('Delete'),
                      ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
