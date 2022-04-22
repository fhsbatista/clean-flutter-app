import 'package:flutter/material.dart';

import '../../helpers/i18n/i18n.dart';

class SurveyResultPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(I18n.strings.surveys)),
      body: Text('OK'),
    );
  }
}
