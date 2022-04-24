import 'package:flutter/material.dart';

import 'components.dart';

class DisabledCheckIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CheckIcon(active: false);
  }
}