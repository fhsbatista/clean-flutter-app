import 'dart:async';

import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fordev/ui/helpers/errors/errors.dart';
import 'package:get/get.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:fordev/ui/helpers/i18n/i18n.dart';
import 'package:fordev/ui/pages/pages.dart';

import 'signup_page_test.mocks.dart';

@GenerateMocks([SignUpPresenter])
void main() {
  late SignUpPresenter presenter;
  late StreamController<UIError?> nameErrorController;
  late StreamController<UIError?> emailErrorController;
  late StreamController<UIError?> passwordErrorController;
  late StreamController<UIError?> passwordConfirmationErrorController;

  void initStreams() {
    nameErrorController = StreamController<UIError?>();
    emailErrorController = StreamController<UIError?>();
    passwordErrorController = StreamController<UIError?>();
    passwordConfirmationErrorController = StreamController<UIError?>();
  }

  void mockStreams() {
    presenter = MockSignUpPresenter();
    when(presenter.nameErrorStream)
        .thenAnswer((_) => nameErrorController.stream);
    when(presenter.emailErrorStream)
        .thenAnswer((_) => emailErrorController.stream);
    when(presenter.passwordErrorStream)
        .thenAnswer((_) => passwordErrorController.stream);
    when(presenter.passwordConfirmationErrorStream)
        .thenAnswer((_) => passwordConfirmationErrorController.stream);
  }

  void closeStreams() {
    nameErrorController.close();
    emailErrorController.close();
    passwordErrorController.close();
    passwordConfirmationErrorController.close();
  }

  Future<void> loadPage(WidgetTester tester) async {
    initStreams();
    mockStreams();
    final signupPage = GetMaterialApp(
      initialRoute: '/signup',
      getPages: [
        GetPage(
          name: '/signup',
          page: () => SignUpPage(presenter),
        ),
        GetPage(
          name: '/fake_route',
          page: () => Scaffold(body: Text('fake page')),
        ),
      ],
    );
    await tester.pumpWidget(signupPage);
  }

  tearDown(() {
    closeStreams();
  });

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

  testWidgets('Should call validate with correct values', (tester) async {
    await loadPage(tester);

    final name = faker.person.name();
    await tester.enterText(find.bySemanticsLabel(I18n.strings.name), name);
    verify(presenter.validateName(name));

    final email = faker.internet.email();
    await tester.enterText(find.bySemanticsLabel(I18n.strings.email), email);
    verify(presenter.validateEmail(email));

    final password = faker.internet.password();
    await tester.enterText(
      find.bySemanticsLabel(I18n.strings.password),
      password,
    );
    verify(presenter.validatePassword(password));

    await tester.enterText(
      find.bySemanticsLabel(I18n.strings.confirmPassword),
      password,
    );
    verify(presenter.validatePasswordConfirmation(password));
  });

  group('email field errors', () {
    testWidgets('Should present error if email is invalid', (tester) async {
      await loadPage(tester);

      emailErrorController.add(UIError.invalidField);
      await tester.pump();

      expect(find.text('Campo inválido'), findsOneWidget);
    });

    testWidgets('Should present error if email is empty', (tester) async {
      await loadPage(tester);

      emailErrorController.add(UIError.requiredField);
      await tester.pump();

      expect(find.text('Campo obrigatório'), findsOneWidget);
    });

    testWidgets('Should present no error if email valid', (tester) async {
      await loadPage(tester);

      emailErrorController.add(null);
      await tester.pump();

      expect(
        find.descendant(
          of: find.bySemanticsLabel(I18n.strings.email),
          matching: find.byType(Text),
        ),
        findsOneWidget,
      );
    });
  });

  group('name field errors', () {
    testWidgets('Should present error if name is invalid', (tester) async {
      await loadPage(tester);

      nameErrorController.add(UIError.invalidField);
      await tester.pump();

      expect(find.text('Campo inválido'), findsOneWidget);
    });

    testWidgets('Should present error if name is empty', (tester) async {
      await loadPage(tester);

      nameErrorController.add(UIError.requiredField);
      await tester.pump();

      expect(find.text('Campo obrigatório'), findsOneWidget);
    });

    testWidgets('Should present no error if name valid', (tester) async {
      await loadPage(tester);

      nameErrorController.add(null);
      await tester.pump();

      expect(
        find.descendant(
          of: find.bySemanticsLabel(I18n.strings.name),
          matching: find.byType(Text),
        ),
        findsOneWidget,
      );
    });
  });

  
}
