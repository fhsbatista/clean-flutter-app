import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fordev/ui/pages/pages.dart';

void main() {
  testWidgets('Should load with correct initial state', (tester) async {
    final loginPage = MaterialApp(home: LoginPage());
    await tester.pumpWidget(loginPage);

    final emailTextChildren = find.descendant(
      of: find.bySemanticsLabel('email'),
      matching: find.byType(Text),
    );
    expect(
      emailTextChildren,
      findsOneWidget,
      reason:
          'when a TextFormField has only one text child, it means has no errors because one of the children will always be a Text',
    );

    final passwordTextChildren = find.descendant(
      of: find.bySemanticsLabel('senha'),
      matching: find.byType(Text),
    );
    expect(
      passwordTextChildren,
      findsOneWidget,
      reason:
          'when a TextFormField has only one text child, it means has no errors because one of the children will always be a Text',
    );

    final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
    expect(button.onPressed, null);
  });
}
