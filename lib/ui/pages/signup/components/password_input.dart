import 'package:flutter/material.dart';

import '../../../helpers/i18n/i18n.dart';

class PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: I18n.strings.password,
        icon: Icon(
          Icons.lock,
          color: Theme.of(context).primaryColorLight,
        ),
      ),
      obscureText: true,
    );
  }
}
