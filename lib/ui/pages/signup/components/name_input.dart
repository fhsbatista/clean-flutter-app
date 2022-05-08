import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../helpers/i18n/i18n.dart';
import '../signup_presenter.dart';
import 'components.dart';

class NameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<SignUpPresenter>(context);
    return Input(
      label: I18n.strings.name,
      icon: Icons.person,
      keyboardType: TextInputType.emailAddress,
      errorStream: presenter.nameErrorStream,
      onChange: presenter.validateName,
    );
  }
}
