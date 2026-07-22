import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_tokens.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/app_buttons.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../domain/entities/auth_user.dart';
import '../../domain/entities/profile_details.dart';
import '../../domain/validators/auth_validators.dart';
import '../controllers/authentication_controller.dart';
import '../widgets/auth_page_scaffold.dart';

class CompleteProfileScreen extends ConsumerStatefulWidget {
  const CompleteProfileScreen({super.key});

  @override
  ConsumerState<CompleteProfileScreen> createState() =>
      _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends ConsumerState<CompleteProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  DateTime? _dateOfBirth;
  UserGender? _gender;
  var _acceptedTerms = false;
  var _termsInteracted = false;

  bool get _canSubmit =>
      AuthValidators.isValidFullName(_nameController.text) &&
      AuthValidators.isValidEmail(_emailController.text) &&
      _acceptedTerms;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final now = DateTime.now();
    final selected = await showDatePicker(
      context: context,
      initialDate: DateTime(now.year - 18),
      firstDate: DateTime(now.year - 100),
      lastDate: now,
    );
    if (selected != null) {
      setState(() => _dateOfBirth = selected);
    }
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false) || !_acceptedTerms) {
      return;
    }
    final success = await ref
        .read(authenticationControllerProvider.notifier)
        .completeProfile(
          ProfileDetails(
            fullName: _nameController.text,
            email: _emailController.text,
            dateOfBirth: _dateOfBirth,
            gender: _gender,
            acceptedTerms: _acceptedTerms,
          ),
        );
    if (success && mounted) context.go(AppRoutes.authWelcome);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final auth = ref.watch(authenticationControllerProvider);
    final dateLabel = _dateOfBirth == null
        ? l10n.dateOfBirthOptional
        : MaterialLocalizations.of(context).formatMediumDate(_dateOfBirth!);
    return AuthPageScaffold(
      title: l10n.completeProfileTitle,
      body: l10n.completeProfileBody,
      child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppTextField(
              controller: _nameController,
              label: l10n.fullName,
              textInputAction: TextInputAction.next,
              autofillHints: const [AutofillHints.name],
              validator: (value) => AuthValidators.isValidFullName(value ?? '')
                  ? null
                  : l10n.fullNameRequired,
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: AppSpacing.md),
            AppTextField(
              controller: _emailController,
              label: l10n.emailOptional,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.done,
              textDirection: TextDirection.ltr,
              autofillHints: const [AutofillHints.email],
              validator: (value) => AuthValidators.isValidEmail(value ?? '')
                  ? null
                  : l10n.emailInvalid,
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: AppSpacing.md),
            OutlinedButton.icon(
              onPressed: _selectDate,
              icon: const Icon(Icons.calendar_month_rounded),
              label: Align(
                alignment: AlignmentDirectional.centerStart,
                child: Text(dateLabel),
              ),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.input),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            DropdownButtonFormField<UserGender>(
              initialValue: _gender,
              decoration: InputDecoration(labelText: l10n.genderOptional),
              items: [
                DropdownMenuItem(
                  value: UserGender.female,
                  child: Text(l10n.female),
                ),
                DropdownMenuItem(
                  value: UserGender.male,
                  child: Text(l10n.male),
                ),
                DropdownMenuItem(
                  value: UserGender.preferNotToSay,
                  child: Text(l10n.preferNotToSay),
                ),
              ],
              onChanged: (value) => setState(() => _gender = value),
            ),
            const SizedBox(height: AppSpacing.md),
            CheckboxListTile(
              value: _acceptedTerms,
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
              title: Text(l10n.acceptTerms),
              onChanged: (value) => setState(() {
                _termsInteracted = true;
                _acceptedTerms = value ?? false;
              }),
            ),
            if (_termsInteracted && !_acceptedTerms)
              Text(
                l10n.termsRequired,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            const SizedBox(height: AppSpacing.lg),
            AppButton(
              label: l10n.saveAndContinue,
              isLoading: auth.isLoading,
              onPressed: _canSubmit ? _submit : null,
            ),
          ],
        ),
      ),
    );
  }
}
