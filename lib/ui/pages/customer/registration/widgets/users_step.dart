import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:som/ui/theme/som_assets.dart';

import '../../../../domain/model/model.dart';

List<CompanyRole> _allowedUserRoles(Company company) {
  final roles = <CompanyRole>[CompanyRole.admin];
  if (company.isBuyer) {
    roles.add(CompanyRole.buyer);
  }
  if (company.isProvider) {
    roles.add(CompanyRole.provider);
  }
  return roles;
}

String _roleLabel(CompanyRole role) {
  switch (role) {
    case CompanyRole.admin:
      return 'Admin';
    case CompanyRole.provider:
      return 'Provider';
    case CompanyRole.buyer:
      return 'Buyer';
  }
}

/// Step widget for user management in registration flow.
class UsersStep extends StatelessWidget {
  const UsersStep({super.key});

  @override
  Widget build(BuildContext context) {
    final request = Provider.of<RegistrationRequest>(context);
    return Column(
      children: [
        const Text('Admin user'),
        _AdminUserSection(request: request),
        _AdditionalUsersList(request: request),
        const Divider(),
        _TermsSection(request: request),
      ],
    );
  }
}

class _AdminUserSection extends StatelessWidget {
  const _AdminUserSection({required this.request});

  final RegistrationRequest request;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.start,
            alignment: WrapAlignment.start,
            direction: Axis.horizontal,
            children: [
              SizedBox(
                width: 260,
              child: SomTextInput(
                label: 'E-mail',
                iconAsset: SomAssets.iconUser,
                hint: 'Enter email of SOM administrator account',
                value: request.company.admin.email,
                onChanged: request.company.admin.setEmail,
              ),
              ),
              30.width,
              request.company.canCreateMoreUsers
                  ? SizedBox(
                      width: 60,
                      child: ElevatedButton(
                        onPressed: () => request.company.increaseNumberOfUsers(),
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('+'),
                        ),
                      ),
                    )
                  : const SizedBox(height: 1),
            ],
          ),
          SizedBox(
            width: 350,
            child: DropdownButtonFormField<CompanyRole>(
              value: CompanyRole.admin,
              items: const [
                DropdownMenuItem(
                  value: CompanyRole.admin,
                  child: Text('Admin'),
                ),
              ],
              onChanged: (_) {},
              decoration: const InputDecoration(
                labelText: 'Role',
              ),
            ),
          ),
          _UserInfoFields(
            salutation: request.company.admin.salutation,
            onSalutationChanged: request.company.admin.setSalutation,
            title: request.company.admin.title,
            onTitleChanged: request.company.admin.setTitle,
            firstName: request.company.admin.firstName,
            onFirstNameChanged: request.company.admin.setFirstName,
            lastName: request.company.admin.lastName,
            onLastNameChanged: request.company.admin.setLastName,
            phone: request.company.admin.phone,
            onPhoneChanged: request.company.admin.setPhone,
          ),
        ],
      ),
    );
  }
}

class _AdditionalUsersList extends StatelessWidget {
  const _AdditionalUsersList({required this.request});

  final RegistrationRequest request;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: request.company.numberOfUsers,
      itemBuilder: (BuildContext context, int index) {
        return _AdditionalUserItem(
          request: request,
          index: index,
        );
      },
    );
  }
}

class _AdditionalUserItem extends StatelessWidget {
  const _AdditionalUserItem({
    required this.request,
    required this.index,
  });

  final RegistrationRequest request;
  final int index;

  @override
  Widget build(BuildContext context) {
    final user = request.company.users[index];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(),
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          alignment: WrapAlignment.start,
          direction: Axis.horizontal,
          children: [
            SizedBox(
              width: 350,
              child: SomTextInput(
                label: 'User ${index + 1}',
                iconAsset: SomAssets.iconUser,
                hint: 'Enter employee email',
                value: user.email,
                onChanged: user.setEmail,
              ),
            ),
            30.width,
            request.company.canCreateMoreUsers
                ? SizedBox(
                    width: 60,
                    child: ElevatedButton(
                      onPressed: () => request.company.removeUser(index),
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('-'),
                      ),
                    ),
                  )
                : const SizedBox(height: 1),
          ],
        ),
        SizedBox(
          width: 350,
          child: DropdownButtonFormField<CompanyRole>(
            value: user.role,
            items: _allowedUserRoles(request.company)
                .map((role) => DropdownMenuItem(
                      value: role,
                      child: Text(_roleLabel(role)),
                    ))
                .toList(),
            onChanged: (value) {
              if (value != null) {
                user.setRole(value);
              }
            },
            decoration: const InputDecoration(
              labelText: 'Role',
            ),
          ),
        ),
        _UserInfoFields(
          salutation: user.salutation,
          onSalutationChanged: user.setSalutation,
          title: user.title,
          onTitleChanged: user.setTitle,
          firstName: user.firstName,
          onFirstNameChanged: user.setFirstName,
          lastName: user.lastName,
          onLastNameChanged: user.setLastName,
          phone: user.phone,
          onPhoneChanged: user.setPhone,
        ),
      ],
    );
  }
}

class _UserInfoFields extends StatelessWidget {
  const _UserInfoFields({
    required this.salutation,
    required this.onSalutationChanged,
    required this.title,
    required this.onTitleChanged,
    required this.firstName,
    required this.onFirstNameChanged,
    required this.lastName,
    required this.onLastNameChanged,
    required this.phone,
    required this.onPhoneChanged,
  });

  final String? salutation;
  final void Function(String) onSalutationChanged;
  final String? title;
  final void Function(String) onTitleChanged;
  final String? firstName;
  final void Function(String) onFirstNameChanged;
  final String? lastName;
  final void Function(String) onLastNameChanged;
  final String? phone;
  final void Function(String) onPhoneChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          width: 350,
          child: SomTextInput(
            label: 'Salutation',
            value: salutation,
            onChanged: onSalutationChanged,
          ),
        ),
        Container(
          alignment: Alignment.centerLeft,
          width: 350,
          child: SomTextInput(
            label: 'Title',
            value: title,
            onChanged: onTitleChanged,
          ),
        ),
        Container(
          alignment: Alignment.centerLeft,
          width: 350,
          child: SomTextInput(
            label: 'First name',
            value: firstName,
            onChanged: onFirstNameChanged,
          ),
        ),
        Container(
          alignment: Alignment.centerLeft,
          width: 350,
          child: SomTextInput(
            label: 'Last name',
            value: lastName,
            onChanged: onLastNameChanged,
          ),
        ),
        Container(
          alignment: Alignment.centerLeft,
          width: 350,
          child: SomTextInput(
            label: 'Phone number',
            value: phone,
            onChanged: onPhoneChanged,
          ),
        ),
      ],
    );
  }
}

class _TermsSection extends StatelessWidget {
  const _TermsSection({required this.request});

  final RegistrationRequest request;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CheckboxListTile(
          value: request.company.termsAccepted,
          onChanged: (value) => request.company.setTermsAccepted(value ?? false),
          controlAffinity: ListTileControlAffinity.leading,
          title: const Text('I accept the terms and conditions'),
        ),
        CheckboxListTile(
          value: request.company.privacyAccepted,
          onChanged: (value) => request.company.setPrivacyAccepted(value ?? false),
          controlAffinity: ListTileControlAffinity.leading,
          title: const Text('I accept the privacy policy'),
        ),
      ],
    );
  }
}
