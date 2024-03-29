import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:fordev/ui/pages/pages.dart';

import '../helpers/helpers.dart';
import 'splash_page_test.mocks.dart';

@GenerateMocks([SplashPresenter])
void main() {
  late SplashPresenter presenter;
  late StreamController<String?> navigateToController;

  Future<void> loadPage(WidgetTester tester) async {
    presenter = MockSplashPresenter();
    navigateToController = StreamController<String?>();
    when(presenter.navigateToStream)
        .thenAnswer((_) => navigateToController.stream);
    await tester.pumpWidget(
      makePage(
        path: '/',
        page: () => SplashPage(presenter),
      ),
    );
  }

  tearDown(() {
    navigateToController.close();
  });

  testWidgets('Should present spinner on page load', (tester) async {
    await loadPage(tester);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Should call LoadCurrentAccount on page load', (tester) async {
    await loadPage(tester);

    verify(presenter.checkAccount()).called(1);
  });

  testWidgets('Should change page', (tester) async {
    await loadPage(tester);

    navigateToController.add('/fake_route');
    await tester.pumpAndSettle(); //To wait for animations end

    expect(currentRoute, '/fake_route');
    expect(find.text('fake page'), findsOneWidget);
  });

  testWidgets('Should not change page', (tester) async {
    await loadPage(tester);

    navigateToController.add('');
    await tester.pump();
    expect(currentRoute, '/');

    navigateToController.add(null);
    await tester.pump();
    expect(currentRoute, '/');
  });
}
