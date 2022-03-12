import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fordev/ui/helpers/i18n/i18n.dart';
import 'package:get/get.dart';

import 'package:fordev/ui/pages/pages.dart';

void main() {
  Future<void> loadPage(WidgetTester tester) async {
    final signupPage = GetMaterialApp(
      initialRoute: '/signup',
      getPages: [
        GetPage(
          name: '/signup',
          page: () => SignUpPage(),
        ),
        GetPage(
          name: '/fake_route',
          page: () => Scaffold(body: Text('fake page')),
        ),
      ],
    );
    await tester.pumpWidget(signupPage);
  }

  testWidgets('Should load with correct initial state', (tester) async {
    await loadPage(tester);

    final nameTextChildren = find.descendant(
      of: find.bySemanticsLabel(I18n.strings.name),
      matching: find.byType(Text),
    );
    expect(
      nameTextChildren,
      findsOneWidget,
      reason:
          'when a TextFormField has only one text child, it means has no errors because one of the children will always be a Text',
    );

    final emailTextChildren = find.descendant(
      of: find.bySemanticsLabel(I18n.strings.email),
      matching: find.byType(Text),
    );
    expect(
      emailTextChildren,
      findsOneWidget,
      reason:
          'when a TextFormField has only one text child, it means has no errors because one of the children will always be a Text',
    );

    final passwordTextChildren = find.descendant(
      of: find.bySemanticsLabel(I18n.strings.password),
      matching: find.byType(Text),
    );
    expect(
      passwordTextChildren,
      findsOneWidget,
      reason:
          'when a TextFormField has only one text child, it means has no errors because one of the children will always be a Text',
    );

    final passwordConfirmationTextChildren = find.descendant(
      of: find.bySemanticsLabel(I18n.strings.confirmPassword),
      matching: find.byType(Text),
    );
    expect(
      passwordConfirmationTextChildren,
      findsOneWidget,
      reason:
          'when a TextFormField has only one text child, it means has no errors because one of the children will always be a Text',
    );

    final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
    expect(button.onPressed, null);

    expect(find.byType(CircularProgressIndicator), findsNothing);
  });
}
