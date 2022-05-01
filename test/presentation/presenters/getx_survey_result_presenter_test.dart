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

@GenerateMocks([LoadSurveyResult, SaveSurveyResult])
void main() {
  late GetxSurveyResultPresenter sut;
  late MockLoadSurveyResult loadSurveyResult;
  late MockSaveSurveyResult saveSurveyResult;
  late String surveyId;
  late String answer;

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

  PostExpectation mockSaveSurveyResultCall() =>
      when(saveSurveyResult.save(any));

  void mockLoadSurveys(SurveyResultEntity data) =>
      mockLoadSurveyResultCall().thenAnswer((_) async => data);

  void mockLoadSurveyResultError(DomainError error) =>
      mockLoadSurveyResultCall().thenThrow(error);

  void mockSaveSurveyResult(SurveyResultEntity data) =>
      mockSaveSurveyResultCall().thenAnswer((_) async => data);

  void mockSaveSurveyResultError(DomainError error) =>
      mockSaveSurveyResultCall().thenThrow(error);

  setUp(() {
    loadSurveyResult = MockLoadSurveyResult();
    saveSurveyResult = MockSaveSurveyResult();
    surveyId = faker.guid.guid();
    answer = faker.lorem.sentence();
    sut = GetxSurveyResultPresenter(
      loadSurveyResult: loadSurveyResult,
      saveSurveyResult: saveSurveyResult,
      surveyId: surveyId,
    );
    mockLoadSurveys(validSurveyResult);
    mockSaveSurveyResult(validSurveyResult);
  });

  group('load data', () {
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
      mockLoadSurveyResultError(DomainError.unexpected);

      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      sut.surveyResultStream.listen(
        null,
        onError: (error, _) => expect(error, UIError.unexpected.description),
      );

      await sut.loadData();
    });

    test('Should emit correct events on access denied', () async {
      mockLoadSurveyResultError(DomainError.access_denied);

      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(sut.isSessionExpiredStream, emits(true));

      await sut.loadData();
    });
  });

  group('save answer', () {
    test('Should call SaveSurveyResult on save', () async {
      await sut.save(answer: answer);

      verify(saveSurveyResult.save(answer)).called(1);
    });

    test('Should emit correct events on SaveSurveyResult success', () async {
      final surveyResult = validSurveyResult;
      mockSaveSurveyResult(surveyResult);

      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      sut.surveyResultStream.listen(
        expectAsync1(
          (result) => expect(
            result,
            SurveyResultViewModel(
              id: surveyResult.id,
              question: surveyResult.question,
              answers: [
                SurveyAnswerViewModel(
                  image: surveyResult.answers[0].image,
                  answer: surveyResult.answers[0].answer,
                  isCurrentAnswer: surveyResult.answers[0].isCurrentAnswer,
                  percent: '${surveyResult.answers[0].percent}%',
                ),
                SurveyAnswerViewModel(
                  image: surveyResult.answers[1].image,
                  answer: surveyResult.answers[1].answer,
                  isCurrentAnswer: surveyResult.answers[1].isCurrentAnswer,
                  percent: '${surveyResult.answers[1].percent}%',
                )
              ],
            ),
          ),
        ),
      );

      await sut.save(answer: answer);
    });
  });

  test('Should emit correct events on LoadSurveyResult failure', () async {
    mockSaveSurveyResultError(DomainError.unexpected);

    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    sut.surveyResultStream.listen(
      null,
      onError: (error, _) => expect(error, UIError.unexpected.description),
    );

    await sut.save(answer: answer);
  });

  test('Should emit correct events on access denied', () async {
    mockSaveSurveyResultError(DomainError.access_denied);

    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    expectLater(sut.isSessionExpiredStream, emits(true));

    await sut.save(answer: answer);
  });
}
