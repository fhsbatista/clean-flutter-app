import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:fordev/ui/pages/pages.dart';

import 'surveys_page_test.mocks.dart';

@GenerateMocks([SurveysPresenter])
void main() {
  late SurveysPresenter presenter;
  Future<void> loadPage(WidgetTester tester) async {
    presenter = MockSurveysPresenter();
    final surveysPage = GetMaterialApp(
      initialRoute: '/surveys',
      getPages: [
        GetPage(
          name: '/surveys',
          page: () => SurveysPage(presenter),
        ),
        GetPage(
          name: '/fake_route',
          page: () => Scaffold(body: Text('fake page')),
        ),
      ],
    );
    await tester.pumpWidget(surveysPage);
  }

  testWidgets('Should call LoadSurveys on page load', (tester) async {
    await loadPage(tester);
    verify(presenter.loadPage()).called(1);
  });
}
