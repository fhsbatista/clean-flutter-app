import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../ui/helpers/i18n/i18n.dart';

import '../signup_presenter.dart';
import '../../../components/components.dart';

class PasswordConfirmationInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<SignUpPresenter>(context);
    return Input(
      label: I18n.strings.confirmPassword,
      icon: Icons.lock,
      errorStream: presenter.passwordConfirmationErrorStream,
      onChange: presenter.validatePasswordConfirmation,
      obscure: true,
    );
  }
}
