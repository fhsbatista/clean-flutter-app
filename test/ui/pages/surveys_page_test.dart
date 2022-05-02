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
  late MockSurveysPresenter presenter;
  late StreamController<bool> isLoadingController;
  late StreamController<List<SurveyViewModel>> surveysController;
  late StreamController<String?> navigateToController;
  late StreamController<bool> isSessionExpiredController;

  void initStreams() {
    isLoadingController = StreamController<bool>();
    surveysController = StreamController<List<SurveyViewModel>>();
    navigateToController = StreamController<String?>();
    isSessionExpiredController = StreamController<bool>();
  }

  void mockStreams() {
    presenter = MockSurveysPresenter();
    when(presenter.isLoadingStream)
        .thenAnswer((_) => isLoadingController.stream);
    when(presenter.surveysStream).thenAnswer((_) => surveysController.stream);
    when(presenter.goToSurveyResult(surveyId: anyNamed('surveyId')))
        .thenAnswer((_) => Future.value(null));
    when(presenter.navigateToStream)
        .thenAnswer((_) => navigateToController.stream);
    when(presenter.isSessionExpiredStream)
        .thenAnswer((_) => isSessionExpiredController.stream);
  }

  void closeStreams() {
    isLoadingController.close();
    surveysController.close();
    navigateToController.close();
    isSessionExpiredController.close();
  }

  Future<void> loadPage(WidgetTester tester) async {
    initStreams();
    mockStreams();
    final routeObserver = Get.put<RouteObserver>(RouteObserver<PageRoute>());
    final surveysPage = GetMaterialApp(
      initialRoute: '/surveys',
      navigatorObservers: [routeObserver],
      getPages: [
        GetPage(
          name: '/surveys',
          page: () => SurveysPage(presenter),
        ),
        GetPage(
          name: '/fake_route',
          page: () => Scaffold(appBar: AppBar(),body: Text('fake page')),
        ),
        GetPage(
          name: '/login',
          page: () => Scaffold(body: Text('login page')),
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
    verify(presenter.loadData()).called(1);
  });

  testWidgets('Should call LoadSurveys when page gets visible again',
      (tester) async {
    await loadPage(tester);

    navigateToController.add('/fake_route');
    await tester.pumpAndSettle();
    //So that this method work, the widget needs to have an app bar. Hence the "fake route" route contains an app bar.
    await tester.pageBack();

    verify(presenter.loadData()).called(2);
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

    verify(presenter.loadData()).called(2);
  });

  testWidgets('Should call goToSurveyResult on survey click', (tester) async {
    await loadPage(tester);

    surveysController.add(makeSurveys());
    await tester.pump();

    await tester.tap(find.text('Question 1'));
    await tester.pump();

    verify(presenter.goToSurveyResult(surveyId: '1')).called(1);
  });

  testWidgets('Should change page on navigateTo events', (tester) async {
    await loadPage(tester);

    navigateToController.add('/fake_route');

    //Settle so that the test waits to animation ends
    await tester.pumpAndSettle();

    expect(Get.currentRoute, '/fake_route');
    expect(find.text('fake page'), findsOneWidget);
  });

  testWidgets('Should logout', (tester) async {
    await loadPage(tester);

    isSessionExpiredController.add(true);

    //Settle so that the test waits to animation ends
    await tester.pumpAndSettle();

    expect(Get.currentRoute, '/login');
  });

  testWidgets('Should not logout', (tester) async {
    await loadPage(tester);

    isSessionExpiredController.add(false);

    //Settle so that the test waits to animation ends
    await tester.pumpAndSettle();

    expect(Get.currentRoute, '/surveys');
  });
}
