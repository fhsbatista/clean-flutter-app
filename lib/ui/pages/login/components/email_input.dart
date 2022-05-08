import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../components/components.dart';
import '../../../helpers/i18n/i18n.dart';
import '../login_presenter.dart';

class EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<LoginPresenter>(context);
    return Input(
      label: I18n.strings.email,
      icon: Icons.email,
      keyboardType: TextInputType.emailAddress,
      errorStream: presenter.emailErrorStream,
      onChange: presenter.validateEmail,
    );
  }
}
