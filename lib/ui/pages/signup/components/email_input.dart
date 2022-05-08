import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../ui/helpers/i18n/i18n.dart';
import '../../pages.dart';
import 'components.dart';

class EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<SignUpPresenter>(context);
    return Input(
      label: I18n.strings.email,
      icon: Icons.email,
      keyboardType: TextInputType.emailAddress,
      errorStream: presenter.emailErrorStream,
      onChange: presenter.validateEmail,
    );
  }
}
