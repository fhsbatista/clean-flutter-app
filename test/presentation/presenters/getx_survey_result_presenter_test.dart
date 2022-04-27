import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fordev/domain/helpers/helpers.dart';
import 'package:fordev/domain/usecases/usecases.dart';
import 'package:fordev/ui/helpers/errors/ui_error.dart';
import 'package:fordev/ui/pages/survey_result/survey_result.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:fordev/domain/entities/entities.dart';
import 'package:fordev/presentation/presenters/presenters.dart';

import 'getx_survey_result_presenter_test.mocks.dart';

@GenerateMocks([LoadSurveyResult])
void main() {
  late GetxSurveyResultPresenter sut;
  late MockLoadSurveyResult loadSurveyResult;
  late String surveyId;

  final validSurveyResult = SurveyResultEntity(
    id: faker.guid.guid(),
    question: faker.lorem.sentence(),
    answers: [
      SurveyAnswerEntity(
        image: faker.internet.httpsUrl(),
        answer: faker.lorem.sentence(),
        percent: faker.randomGenerator.integer(100),
        isCurrentAnswer: faker.randomGenerator.boolean(),
      ),
      SurveyAnswerEntity(
        answer: faker.lorem.sentence(),
        percent: faker.randomGenerator.integer(100),
        isCurrentAnswer: faker.randomGenerator.boolean(),
      ),
    ],
  );

  PostExpectation mockLoadSurveyResultCall() =>
      when(loadSurveyResult.loadBySurvey(any));

  void mockLoadSurveys(SurveyResultEntity data) =>
      mockLoadSurveyResultCall().thenAnswer((_) async => data);

  void mockLoadSurveyResultError() =>
      mockLoadSurveyResultCall().thenThrow(DomainError.unexpected);

  void mockAccessDeniedError() =>
      mockLoadSurveyResultCall().thenThrow(DomainError.access_denied);

  setUp(() {
    loadSurveyResult = MockLoadSurveyResult();
    surveyId = faker.guid.guid();
    sut = GetxSurveyResultPresenter(
      loadSurveyResult: loadSurveyResult,
      surveyId: surveyId,
    );
    mockLoadSurveys(validSurveyResult);
  });

  test('Should call LoadSurveyResult on loadData', () async {
    await sut.loadData();

    verify(loadSurveyResult.loadBySurvey(surveyId)).called(1);
  });

  test('Should emit correct events on LoadSurveyResult success', () async {
    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    sut.surveyResultStream.listen(
      expectAsync1(
        (result) => expect(
          result,
          SurveyResultViewModel(
            id: validSurveyResult.id,
            question: validSurveyResult.question,
            answers: [
              SurveyAnswerViewModel(
                image: validSurveyResult.answers[0].image,
                answer: validSurveyResult.answers[0].answer,
                isCurrentAnswer: validSurveyResult.answers[0].isCurrentAnswer,
                percent: '${validSurveyResult.answers[0].percent}%',
              ),
              SurveyAnswerViewModel(
                image: validSurveyResult.answers[1].image,
                answer: validSurveyResult.answers[1].answer,
                isCurrentAnswer: validSurveyResult.answers[1].isCurrentAnswer,
                percent: '${validSurveyResult.answers[1].percent}%',
              )
            ],
          ),
        ),
      ),
    );

    await sut.loadData();
  });

  test('Should emit correct events on LoadSurveyResult failure', () async {
    mockLoadSurveyResultError();

    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    sut.surveyResultStream.listen(
      null,
      onError: (error, _) => expect(error, UIError.unexpected.description),
    );

    await sut.loadData();
  });

  test('Should emit correct events on access denied', () async {
    mockAccessDeniedError();

    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    expectLater(sut.isSessionExpiredStream, emits(true));

    await sut.loadData();
  });
}
