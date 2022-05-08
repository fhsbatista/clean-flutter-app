import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../helpers/i18n/i18n.dart';

import '../signup_presenter.dart';
import '../../../components/components.dart';

class PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<SignUpPresenter>(context);
    return Input(
      label: I18n.strings.password,
      icon: Icons.lock,
      errorStream: presenter.passwordErrorStream,
      onChange: presenter.validatePassword,
      obscure: true,
    );
  }
}
