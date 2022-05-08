import 'package:flutter/material.dart';

import '../../../helpers/errors/errors.dart';

class Input extends StatelessWidget {
  Input({
    required this.label,
    required this.icon,
    required this.errorStream,
    required this.onChange,
    this.keyboardType,
    this.obscure = false,
  });

  final String label;
  final IconData icon;
  final Stream<UIError?> errorStream;
  final Function(String) onChange;
  final TextInputType? keyboardType;
  final bool obscure;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UIError?>(
      stream: errorStream,
      builder: (context, snapshot) {
        return TextFormField(
          onChanged: onChange,
          decoration: InputDecoration(
            labelText: label,
            errorText: snapshot.data?.description,
            icon: Icon(
              icon,
              color: Theme.of(context).primaryColorLight,
            ),
          ),
          keyboardType: keyboardType,
          obscureText: obscure,
        );
      },
    );
  }
}
