import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../ui/helpers/i18n/i18n.dart';
import '../../../helpers/errors/errors.dart';

import '../signup_presenter.dart';

class PasswordConfirmationInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<SignUpPresenter>(context);
    return StreamBuilder<UIError?>(
      stream: presenter.passwordConfirmationErrorStream,
      builder: (context, snapshot) {
        return TextFormField(
          onChanged: presenter.validatePasswordConfirmation,
          decoration: InputDecoration(
            labelText: I18n.strings.confirmPassword,
            errorText: snapshot.data?.description,
            icon: Icon(
              Icons.lock,
              color: Theme.of(context).primaryColorLight,
            ),
          ),
          obscureText: true,
        );
      },
    );
  }
}
