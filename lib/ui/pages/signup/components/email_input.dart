import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../ui/helpers/i18n/i18n.dart';
import '../../../helpers/errors/errors.dart';

import '../signup_presenter.dart';

class EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<SignUpPresenter>(context);
    return StreamBuilder<UIError?>(
      stream: presenter.emailErrorStream,
      builder: (context, snapshot) {
        return TextFormField(
          onChanged: presenter.validateEmail,
          decoration: InputDecoration(
            labelText: I18n.strings.email,
            errorText: snapshot.data?.description,
            icon: Icon(
              Icons.email,
              color: Theme.of(context).primaryColorLight,
            ),
          ),
          keyboardType: TextInputType.emailAddress,
        );
      },
    );
  }
}
