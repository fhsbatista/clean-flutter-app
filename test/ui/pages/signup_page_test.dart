import 'dart:async';

import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fordev/ui/helpers/errors/errors.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:fordev/ui/helpers/i18n/i18n.dart';
import 'package:fordev/ui/pages/pages.dart';

import '../helpers/helpers.dart';
import 'signup_page_test.mocks.dart';

@GenerateMocks([SignUpPresenter])
void main() {
  late SignUpPresenter presenter;
  late StreamController<UIError?> nameErrorController;
  late StreamController<UIError?> emailErrorController;
  late StreamController<UIError?> passwordErrorController;
  late StreamController<UIError?> passwordConfirmationErrorController;
  late StreamController<bool> isFormValidController;
  late StreamController<bool> isLoadingController;
  late StreamController<UIError?> mainErrorController;
  late StreamController<String?> navigateToController;

  void initStreams() {
    nameErrorController = StreamController<UIError?>();
    emailErrorController = StreamController<UIError?>();
    passwordErrorController = StreamController<UIError?>();
    passwordConfirmationErrorController = StreamController<UIError?>();
    isFormValidController = StreamController<bool>();
    isLoadingController = StreamController<bool>();
    mainErrorController = StreamController<UIError?>();
    navigateToController = StreamController<String?>();
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
    when(presenter.isFormValidStream)
        .thenAnswer((_) => isFormValidController.stream);
    when(presenter.isLoadingStream)
        .thenAnswer((_) => isLoadingController.stream);
    when(presenter.mainErrorStream)
        .thenAnswer((_) => mainErrorController.stream);
    when(presenter.navigateToStream)
        .thenAnswer((_) => navigateToController.stream);
  }

  void closeStreams() {
    nameErrorController.close();
    emailErrorController.close();
    passwordErrorController.close();
    passwordConfirmationErrorController.close();
    isFormValidController.close();
    isLoadingController.close();
    mainErrorController.close();
    navigateToController.close();
  }

  Future<void> loadPage(WidgetTester tester) async {
    initStreams();
    mockStreams();
    await tester.pumpWidget(makePage(
      path: '/signup',
      page: () => SignUpPage(presenter),
    ));
  }

  tearDown(() {
    closeStreams();
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

  group('password field errors', () {
    testWidgets('Should present error if password is invalid', (tester) async {
      await loadPage(tester);

      passwordErrorController.add(UIError.invalidField);
      await tester.pump();

      expect(find.text('Campo inválido'), findsOneWidget);
    });

    testWidgets('Should present error if password is empty', (tester) async {
      await loadPage(tester);

      passwordErrorController.add(UIError.requiredField);
      await tester.pump();

      expect(find.text('Campo obrigatório'), findsOneWidget);
    });

    testWidgets('Should present no error if password valid', (tester) async {
      await loadPage(tester);

      passwordErrorController.add(null);
      await tester.pump();

      expect(
        find.descendant(
          of: find.bySemanticsLabel(I18n.strings.password),
          matching: find.byType(Text),
        ),
        findsOneWidget,
      );
    });
  });

  group('passwordConfirmation field errors', () {
    testWidgets('Should present error if passwordConfirmation is invalid',
        (tester) async {
      await loadPage(tester);

      passwordConfirmationErrorController.add(UIError.invalidField);
      await tester.pump();

      expect(find.text('Campo inválido'), findsOneWidget);
    });

    testWidgets('Should present error if passwordConfirmation is empty',
        (tester) async {
      await loadPage(tester);

      passwordConfirmationErrorController.add(UIError.requiredField);
      await tester.pump();

      expect(find.text('Campo obrigatório'), findsOneWidget);
    });

    testWidgets('Should present no error if passwordConfirmation valid',
        (tester) async {
      await loadPage(tester);

      passwordConfirmationErrorController.add(null);
      await tester.pump();

      expect(
        find.descendant(
          of: find.bySemanticsLabel(I18n.strings.confirmPassword),
          matching: find.byType(Text),
        ),
        findsOneWidget,
      );
    });
  });

  group('form validation', () {
    testWidgets('Should enable button if form is valid', (tester) async {
      await loadPage(tester);

      isFormValidController.add(true);
      await tester.pump();

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.onPressed, isNotNull);
    });

    testWidgets('Should disable button if form is not valid', (tester) async {
      await loadPage(tester);

      isFormValidController.add(false);
      await tester.pump();

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.onPressed, isNull);
    });
  });

  testWidgets('Should call signUp on form submit', (tester) async {
    await loadPage(tester);

    isFormValidController.add(true);
    await tester.pump();
    final button = find.byType(ElevatedButton);
    //Sometimes errors can happend cuz the widget is not visible. This line of code prevents this.
    await tester.ensureVisible(button);
    await tester.tap(button);
    await tester.pump();

    verify(presenter.signUp()).called(1);
  });

  group('loading states', () {
    testWidgets('Should present loading', (tester) async {
      await loadPage(tester);

      isLoadingController.add(true);
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('Should hide loading', (tester) async {
      await loadPage(tester);

      isLoadingController.add(true);
      await tester.pump();
      isLoadingController.add(false);
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsNothing);
    });
  });

  group('error messages', () {
    testWidgets('Should present error message if signup fails', (tester) async {
      await loadPage(tester);

      mainErrorController.add(UIError.emailInUse);
      await tester.pump();

      expect(find.text(I18n.strings.msgEmailInUse), findsOneWidget);
    });

    testWidgets('Should present error message if signup throws',
        (tester) async {
      await loadPage(tester);

      mainErrorController.add(UIError.unexpected);
      await tester.pump();

      expect(
        find.text(I18n.strings.msgUnexpectedError),
        findsOneWidget,
      );
    });
  });

  group('navigation', () {
    testWidgets('Should change page on navigateTo events', (tester) async {
      await loadPage(tester);

      navigateToController.add('/fake_route');

      //Settle so that the test waits to animation ends
      await tester.pumpAndSettle();

      expect(currentRoute, '/fake_route');
      expect(find.text('fake page'), findsOneWidget);
    });

    testWidgets('Should not change page when the route is null or empty',
        (tester) async {
      await loadPage(tester);

      navigateToController.add('');
      await tester.pump();
      expect(currentRoute, '/signup');

      navigateToController.add(null);
      await tester.pump();
      expect(currentRoute, '/signup');
    });
  });

  testWidgets('Should call presenter dispose method on widget dispose',
      (tester) async {
    await loadPage(tester);
    addTearDown(() {
      verify(presenter.dispose()).called(1);
    });
  });

  testWidgets('Should call login on login click', (tester) async {
    await loadPage(tester);

    await tester.pump();
    final button = find.text(I18n.strings.login);
    await tester.ensureVisible(button);
    await tester.tap(button);
    await tester.pump();

    verify(presenter.login()).called(1);
  });
}
