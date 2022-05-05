import 'package:flutter_test/flutter_test.dart';
import 'package:fordev/domain/helpers/helpers.dart';
import 'package:fordev/ui/helpers/errors/ui_error.dart';
import 'package:fordev/ui/pages/surveys/surveys.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:fordev/domain/entities/entities.dart';
import 'package:fordev/domain/usecases/load_surveys.dart';
import 'package:fordev/presentation/presenters/presenters.dart';

import '../../mocks/mocks.dart';
import 'getx_surveys_presenter_test.mocks.dart';

@GenerateMocks([LoadSurveys])
void main() {
  late GetxSurveysPresenter sut;
  late MockLoadSurveys loadSurveys;
  late List<SurveyEntity> surveys;

  PostExpectation mockSurveysCall() => when(loadSurveys.load());

  void mockLoadSurveys(List<SurveyEntity> data) {
    mockSurveysCall().thenAnswer((_) async => data);
  }

  void mockLoadSurveysError() =>
      mockSurveysCall().thenThrow(DomainError.unexpected);

  void mockAccessDeniedError() =>
      mockSurveysCall().thenThrow(DomainError.access_denied);

  setUp(() {
    loadSurveys = MockLoadSurveys();
    sut = GetxSurveysPresenter(loadSurveys: loadSurveys);
    surveys = FakeSurveysFactory.entities;
    mockLoadSurveys(surveys);
  });

  test('Should call LoadSurveys on loadData', () async {
    await sut.loadData();

    verify(loadSurveys.load()).called(1);
  });

  test('Should emit correct events on LoadSurveys success', () async {
    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    sut.surveysStream.listen(expectAsync1(
      (surveys) => expect(surveys, [
        SurveyViewModel(
          id: surveys[0].id,
          question: surveys[0].question,
          date: '22 Jan 2022',
          isAnswered: surveys[0].isAnswered,
        ),
        SurveyViewModel(
          id: surveys[1].id,
          question: surveys[1].question,
          date: '22 Feb 2022',
          isAnswered: surveys[1].isAnswered,
        )
      ]),
    ));

    await sut.loadData();
  });

  test('Should emit correct events on LoadSurveys failure', () async {
    mockLoadSurveysError();

    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    sut.surveysStream.listen(
      null,
      onError: (error, _) => expect(error, UIError.unexpected.description),
    );

    await sut.loadData();
  });

  test(
      'Should change page to SurveyResult when requested even though the route is the same as the previous',
      () async {
    expectLater(
      sut.navigateToStream,
      emitsInOrder(['/survey_result/abcde123', '/survey_result/abcde123']),
    );

    sut.goToSurveyResult(surveyId: 'abcde123');
    sut.goToSurveyResult(surveyId: 'abcde123');
  });

  test('Should emit correct events on access denied', () async {
    mockAccessDeniedError();

    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    expectLater(sut.isSessionExpiredStream, emits(true));

    await sut.loadData();
  });
}
