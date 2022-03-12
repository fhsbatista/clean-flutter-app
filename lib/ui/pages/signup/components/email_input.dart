import 'package:flutter/material.dart';

import '../../../../ui/helpers/i18n/i18n.dart';

class EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
          decoration: InputDecoration(
            labelText: I18n.strings.email,
            icon: Icon(
              Icons.email,
              color: Theme.of(context).primaryColorLight,
            ),
          ),
          keyboardType: TextInputType.emailAddress,
        );
  }
}
