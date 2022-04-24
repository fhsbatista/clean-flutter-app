import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fordev/ui/helpers/errors/errors.dart';
import 'package:fordev/ui/helpers/i18n/i18n.dart';
import 'package:get/get.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:fordev/ui/pages/pages.dart';
import 'package:network_image_mock/network_image_mock.dart';

import 'survey_result_page_test.mocks.dart';

@GenerateMocks([SurveyResultPresenter])
void main() {
  late MockSurveyResultPresenter presenter;
  late StreamController<bool> isLoadingController;
  late StreamController<List<dynamic>> surveysController;

  void initStreams() {
    isLoadingController = StreamController<bool>();
    surveysController = StreamController<List<SurveyViewModel>>();
  }

  void mockStreams() {
    when(presenter.isLoadingStream)
        .thenAnswer((_) => isLoadingController.stream);
    when(presenter.surveyResultsStream).thenAnswer((_) => surveysController.stream);
  }

  void closeStreams() {
    isLoadingController.close();
    surveysController.close();
  }
  
  tearDown(() {
    closeStreams();
  });

  Future<void> loadPage(WidgetTester tester) async {
    presenter = MockSurveyResultPresenter();
    initStreams();
    mockStreams();
    final surveysPage = GetMaterialApp(
      initialRoute: '/survey_result/any_survey_id',
      getPages: [
        GetPage(
          name: '/survey_result',
          page: () => SurveyResultPage(presenter),
        ),
        GetPage(
          name: '/fake_route',
          page: () => Scaffold(body: Text('fake page')),
        ),
      ],
    );
    //Para evitar problemas com caregamento do Image.network no widget.
    //É necessário esperar essa função terminal (por isso o await) pois se não os testes vão dar problema de conflito de chamadas.
    await mockNetworkImagesFor(() async {
      await tester.pumpWidget(surveysPage);
    });
  }

  testWidgets('Should call LoadSurveyResult on page load', (tester) async {
    await loadPage(tester);
    verify(presenter.loadData()).called(1);
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
  });

  testWidgets('Should call LoadSurveys on reload button click', (tester) async {
    await loadPage(tester);

    surveysController.addError(UIError.unexpected.description);
    await tester.pump();
    await tester.tap(find.text(I18n.strings.reload));

    verify(presenter.loadData()).called(2);
  });
}
