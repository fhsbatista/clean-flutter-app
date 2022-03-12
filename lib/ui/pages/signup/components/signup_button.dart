import 'package:flutter/material.dart';
import 'package:fordev/ui/helpers/i18n/i18n.dart';

class SignUpButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
          onPressed: null,
          child: Text(I18n.strings.addAccount.toUpperCase()),
        );
  }
}
