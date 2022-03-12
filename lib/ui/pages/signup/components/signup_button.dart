import 'package:flutter/material.dart';
import 'package:fordev/ui/pages/pages.dart';
import 'package:provider/provider.dart';

import '../../../../ui/helpers/i18n/i18n.dart';

class SignUpButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<SignUpPresenter>(context);
    return StreamBuilder<bool>(
      stream: presenter.isFormValidStream,
      builder: (context, snapshot) {
        return ElevatedButton(
          onPressed: snapshot.data == true ? () {} : null,
          child: Text(I18n.strings.addAccount.toUpperCase()),
        );
      },
    );
  }
}
