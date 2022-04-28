import 'package:flutter/material.dart';

import '../components/components.dart';
import '../helpers/errors/errors.dart';

mixin MainUIError {
  void handleMainUIError(BuildContext context, Stream<UIError?> stream) {
    stream.listen((error) async {
      if (error != null) {
        showErrorMessage(context, error.description);
      }
    });
  }
}
