import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fordev/ui/helpers/errors/errors.dart';
import 'package:fordev/ui/helpers/i18n/i18n.dart';
import 'package:get/get.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:fordev/ui/pages/pages.dart';

import 'surveys_page_test.mocks.dart';

@GenerateMocks([SurveysPresenter])
void main() {
  late SurveysPresenter presenter;
  late StreamController<bool> isLoadingController;
  late StreamController<List<SurveyViewModel>> surveysController;

  void initStreams() {
    isLoadingController = StreamController<bool>();
    surveysController = StreamController<List<SurveyViewModel>>();
  }

  void mockStreams() {
    presenter = MockSurveysPresenter();
    when(presenter.isLoadingStream)
        .thenAnswer((_) => isLoadingController.stream);
    when(presenter.surveysStream).thenAnswer((_) => surveysController.stream);
  }

  void closeStreams() {
    isLoadingController.close();
    surveysController.close();
  }

  Future<void> loadPage(WidgetTester tester) async {
    initStreams();
    mockStreams();
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

  List<SurveyViewModel> makeSurveys() => [
        SurveyViewModel(
          id: '1',
          question: 'Question 1',
          date: 'Date 1',
          isAnswered: false,
        ),
        SurveyViewModel(
          id: '1',
          question: 'Question 2',
          date: 'Date 2',
          isAnswered: false,
        ),
      ];

  tearDown(() {
    closeStreams();
  });

  testWidgets('Should call LoadSurveys on page load', (tester) async {
    await loadPage(tester);
    verify(presenter.loadPage()).called(1);
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

  testWidgets('Should present error if SurveysStream emit error',
      (tester) async {
    await loadPage(tester);

    surveysController.addError(UIError.unexpected.description);
    await tester.pump();

    expect(find.text(I18n.strings.msgUnexpectedError), findsOneWidget);
    expect(find.text(I18n.strings.reload), findsOneWidget);
    expect(find.text('Question 1'), findsNothing);
  });

  testWidgets('Should present list if LoadSurveysStream emit list of surveys',
      (tester) async {
    await loadPage(tester);

    surveysController.add(makeSurveys());
    await tester.pump();

    expect(find.text(I18n.strings.msgUnexpectedError), findsNothing);
    expect(find.text(I18n.strings.reload), findsNothing);
    expect(find.text('Question 1'), findsWidgets);
    expect(find.text('Question 2'), findsWidgets);
    expect(find.text('Date 1'), findsWidgets);
    expect(find.text('Date 2'), findsWidgets);
  });

  testWidgets('Should call LoadSurveys on reload button click', (tester) async {
    await loadPage(tester);

    surveysController.addError(UIError.unexpected.description);
    await tester.pump();
    await tester.tap(find.text(I18n.strings.reload));

    verify(presenter.loadPage()).called(2);
  });
}
