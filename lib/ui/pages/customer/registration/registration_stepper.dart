import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:som/ui/theme/som_assets.dart';
import 'package:som/ui/widgets/design_system/som_svg_icon.dart';
import 'package:provider/provider.dart';

import '../../../domain/model/model.dart';
import '../../../routes/routes.dart';
import 'role_selection.dart';
import 'subscription_selector.dart';
import 'widgets/company_details_step.dart';
import 'widgets/payment_details_step.dart';
import 'widgets/provider_branches_step.dart';
import 'widgets/users_step.dart';

/// Multi-step registration stepper widget.
///
/// Guides users through:
/// - Role selection
/// - Company details
/// - Provider-specific steps (branches, subscription, payment)
/// - User management
class RegistrationStepper extends StatefulWidget {
  const RegistrationStepper({super.key});

  @override
  State<RegistrationStepper> createState() => _RegistrationStepperState();
}

class _RegistrationStepperState extends State<RegistrationStepper> {
  int _currentStep = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final request = Provider.of<RegistrationRequest>(context, listen: false);
      request.som.populateAvailableBranches();
      request.som.populateAvailableSubscriptions();
    });
  }

  bool _isLastStep(RegistrationRequest request) {
    return (request.company.isProvider && _currentStep == 5) ||
        (!request.company.isProvider && _currentStep == 2);
  }

  List<Step> _buildSteps(RegistrationRequest request) {
    final errorSteps = _errorSteps(request);
    final buyerSteps = [
      Step(
        title: _stepTitle('Role selection', SomAssets.wizardStepperCompany),
        isActive: _currentStep == 0,
        state: errorSteps.contains(0) ? StepState.error : StepState.indexed,
        content: const RoleSelection(),
      ),
      Step(
        title: _stepTitle('Company details', SomAssets.wizardStepperCompany),
        isActive: _currentStep == 1,
        state: errorSteps.contains(1) ? StepState.error : StepState.indexed,
        content: const CompanyDetailsStep(),
      ),
    ];

    final providerSteps = [
      Step(
        title: _stepTitle(
          'Company branches',
          SomAssets.wizardStepperVerification,
        ),
        isActive: _currentStep == 2,
        state: errorSteps.contains(2) ? StepState.error : StepState.indexed,
        content: const ProviderBranchesStep(),
      ),
      Step(
        title: _stepTitle(
          'Subscription model',
          SomAssets.interactionTierUpgrade,
        ),
        isActive: _currentStep == 3,
        state: errorSteps.contains(3) ? StepState.error : StepState.indexed,
        content: const SubscriptionSelector(),
      ),
      Step(
        title: _stepTitle(
          'Payment details',
          SomAssets.wizardStepperVerification,
        ),
        isActive: _currentStep == 4,
        state: errorSteps.contains(4) ? StepState.error : StepState.indexed,
        content: const PaymentDetailsStep(),
      ),
    ];

    final commonSteps = [
      Step(
        title: _stepTitle('Users', SomAssets.wizardStepperComplete),
        isActive: _currentStep == 5,
        state: errorSteps.contains(5) ? StepState.error : StepState.indexed,
        content: const UsersStep(),
      ),
    ];

    return [
      ...buyerSteps,
      ...(request.company.isProvider ? providerSteps : []),
      ...commonSteps,
    ];
  }

  Widget _stepTitle(String title, String iconAsset) {
    final theme = Theme.of(context);
    return Row(
      children: [
        SomSvgIcon(iconAsset, size: 18, color: theme.colorScheme.primary),
        const SizedBox(width: 8),
        Text(
          title,
          style: theme.textTheme.titleLarge?.copyWith(
            color: theme.colorScheme.secondary,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final request = Provider.of<RegistrationRequest>(context);
    return Column(
      children: [
        Text(
          textAlign: TextAlign.center,
          'Customer registration'.toUpperCase(),
          style: Theme.of(context).textTheme.displayLarge,
        ),
        40.height,
        Observer(
          builder: (_) {
            final steps = _buildSteps(request);
            final isLastStep = _isLastStep(request);
            if (_currentStep >= steps.length) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (!mounted) return;
                setState(() {
                  _currentStep = steps.isEmpty ? 0 : steps.length - 1;
                });
              });
            }
            return Column(
              children: [
                if (request.errorMessage.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text(
                      request.errorMessage,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ),
                Stepper(
                  elevation: 40,
                  key: Key('registration-stepper-${steps.length}'),
                  steps: steps,
                  type: StepperType.vertical,
                  currentStep: _currentStep,
                  controlsBuilder: (context, details) =>
                      _buildControls(context, details, request, isLastStep),
                  onStepContinue: () => _onStepContinue(steps.length),
                  onStepCancel: _onStepCancel,
                  onStepTapped: (step) => setState(() => _currentStep = step),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildControls(
    BuildContext context,
    ControlsDetails details,
    RegistrationRequest request,
    bool isLastStep,
  ) {
    if (isLastStep) {
      return _buildFinalStepControls(context, request);
    }
    return _buildNavigationControls(details);
  }

  Widget _buildFinalStepControls(
    BuildContext context,
    RegistrationRequest request,
  ) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            200.height,
            SizedBox(
              width: 300,
              child: request.isRegistering
                  ? const Center(
                      child: SizedBox(
                        width: 100,
                        height: 100,
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : !request.isSuccess
                  ? ActionButton(
                      onPressed: () async {
                        final beamer = Beamer.of(context);
                        await request.registerCustomer();
                        if (!request.isSuccess &&
                            request.fieldErrors.isNotEmpty) {
                          final step = _firstErrorStep(request);
                          if (step != null && mounted) {
                            setState(() => _currentStep = step);
                          }
                        }
                        if (request.isSuccess) {
                          beamer.beamTo(CustomerRegisterSuccessPageLocation());
                        }
                      },
                      textContent: 'Register',
                    )
                  : Container(),
            ),
          ],
        ),
        if (request.isSuccess)
          SomSvgIcon(
            SomAssets.offerStatusAccepted,
            size: 24,
            color: Theme.of(context).colorScheme.primary,
          ),
        const SizedBox(height: 7),
      ],
    );
  }

  Widget _buildNavigationControls(ControlsDetails details) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        100.height,
        TextButton(
          onPressed: details.onStepContinue,
          child: const Text('CONTINUE'),
        ),
        50.width,
        TextButton(onPressed: details.onStepCancel, child: const Text('BACK')),
      ],
    );
  }

  void _onStepContinue(int totalSteps) {
    setState(() {
      if (_currentStep < totalSteps - 1) {
        _currentStep++;
      } else {
        finish(context);
      }
    });
  }

  void _onStepCancel() {
    finish(context);
    setState(() {
      if (_currentStep > 0) {
        _currentStep--;
      } else {
        _currentStep = 0;
        context.beamTo(AuthLoginPageLocation());
      }
    });
  }

  Set<int> _errorSteps(RegistrationRequest request) {
    final steps = <int>{};
    for (final field in request.fieldErrors.keys) {
      steps.add(_stepIndexForField(request, field));
    }
    return steps;
  }

  int? _firstErrorStep(RegistrationRequest request) {
    if (request.fieldErrors.isEmpty) return null;
    final steps = _errorSteps(request).toList()..sort();
    return steps.isEmpty ? null : steps.first;
  }

  int _stepIndexForField(RegistrationRequest request, String field) {
    final isProvider = request.company.isProvider;
    if (field == 'company.type') return 0;
    if (field.startsWith('company.')) return 1;
    if (field.startsWith('provider.branchIds') ||
        field.startsWith('provider.providerType')) {
      return isProvider ? 2 : 1;
    }
    if (field.startsWith('provider.subscriptionPlanId')) {
      return isProvider ? 3 : 1;
    }
    if (field.startsWith('provider.bankDetails')) {
      return isProvider ? 4 : 1;
    }
    if (field.startsWith('admin.') ||
        field.startsWith('users.') ||
        field == 'termsAccepted' ||
        field == 'privacyAccepted' ||
        field == 'company.users') {
      return isProvider ? 5 : 2;
    }
    return isProvider ? 5 : 2;
  }
}
