import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fordev/ui/helpers/errors/errors.dart';
import 'package:fordev/ui/helpers/i18n/i18n.dart';
import 'package:fordev/ui/pages/survey_result/components/components.dart';
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
  late StreamController<SurveyResultViewModel> surveysController;

  void initStreams() {
    isLoadingController = StreamController<bool>();
    surveysController = StreamController<SurveyResultViewModel>();
  }

  void mockStreams() {
    when(presenter.isLoadingStream)
        .thenAnswer((_) => isLoadingController.stream);
    when(presenter.surveyResultStream)
        .thenAnswer((_) => surveysController.stream);
  }

  void closeStreams() {
    isLoadingController.close();
    surveysController.close();
  }

  tearDown(() {
    closeStreams();
  });

  SurveyResultViewModel validSurveyResultViewModel() {
    //Não está usando o 'faker' para evitar o risco de o faker acabar gerando strings iguais.
    //Isso faria o teste passar ou falhar por motivos errados já que eles precisam encontrar (método find) um número específico de widgets que dão match.
    return SurveyResultViewModel(
      id: 'any_id',
      question: 'Question',
      answers: [
        SurveyAnswerViewModel(
          image: 'image 1',
          answer: 'answer 1',
          isCurrentAnswer: true,
          percent: '60%',
        ),
        SurveyAnswerViewModel(
          answer: 'answer 2',
          isCurrentAnswer: false,
          percent: '30%',
        ),
      ],
    );
  }

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
    expect(find.text('Question'), findsNothing);
  });

  testWidgets('Should call LoadSurveys on reload button click', (tester) async {
    await loadPage(tester);

    surveysController.addError(UIError.unexpected.description);
    await tester.pump();
    await tester.tap(find.text(I18n.strings.reload));

    verify(presenter.loadData()).called(2);
  });

  testWidgets('Should present valid data if SurveysStream emits valid data',
      (tester) async {
    await loadPage(tester);

    surveysController.add(validSurveyResultViewModel());
    await mockNetworkImagesFor(() async {
      await tester.pump();
    });

    expect(find.text(I18n.strings.msgUnexpectedError), findsNothing);
    expect(find.text(I18n.strings.reload), findsNothing);
    expect(find.text('Question'), findsOneWidget);
    expect(find.text('answer 1'), findsOneWidget);
    expect(find.text('answer 2'), findsOneWidget);
    expect(find.text('60%'), findsOneWidget);
    expect(find.text('30%'), findsOneWidget);
    expect(find.byType(ActiveCheckIcon), findsOneWidget);
    expect(find.byType(DisabledCheckIcon), findsOneWidget);
    final image =
        tester.widget<Image>(find.byType(Image)).image as NetworkImage;
    expect(image.url, 'image 1');
  });
}
