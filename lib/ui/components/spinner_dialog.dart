import 'package:flutter/material.dart';

import '../helpers/i18n/i18n.dart';

Future<void> showLoading(BuildContext context) async {
  await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) {
      return SimpleDialog(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              const SizedBox(height: 10),
              Text(I18n.strings.holdOn, textAlign: TextAlign.center),
            ],
          )
        ],
      );
    },
  );
}

void hideLoading(BuildContext context) {
  if (Navigator.canPop(context)) {
    Navigator.of(context).pop();
  }
}
