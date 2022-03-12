import 'package:flutter/material.dart';

import '../../../../ui/helpers/i18n/i18n.dart';

class PasswordConfirmationInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: I18n.strings.confirmPassword,
        icon: Icon(
          Icons.lock,
          color: Theme.of(context).primaryColorLight,
        ),
      ),
      obscureText: true,
    );
  }
}
