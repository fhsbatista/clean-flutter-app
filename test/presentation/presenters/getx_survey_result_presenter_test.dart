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

import '../../mocks/mocks.dart';
import 'getx_survey_result_presenter_test.mocks.dart';

@GenerateMocks([LoadSurveyResult, SaveSurveyResult])
void main() {
  late GetxSurveyResultPresenter sut;
  late MockLoadSurveyResult loadSurveyResult;
  late MockSaveSurveyResult saveSurveyResult;
  late String surveyId;
  late String answer;
  late SurveyResultEntity surveyResultEntity;

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
    surveyResultEntity = FakeSurveyResultFactory.entity;
    mockLoadSurveys(surveyResultEntity);
    mockSaveSurveyResult(surveyResultEntity);
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
              id: surveyResultEntity.id,
              question: surveyResultEntity.question,
              answers: [
                SurveyAnswerViewModel(
                  image: surveyResultEntity.answers[0].image,
                  answer: surveyResultEntity.answers[0].answer,
                  isCurrentAnswer: surveyResultEntity.answers[0].isCurrentAnswer,
                  percent: '${surveyResultEntity.answers[0].percent}%',
                ),
                SurveyAnswerViewModel(
                  image: surveyResultEntity.answers[1].image,
                  answer: surveyResultEntity.answers[1].answer,
                  isCurrentAnswer: surveyResultEntity.answers[1].isCurrentAnswer,
                  percent: '${surveyResultEntity.answers[1].percent}%',
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
      final surveyResult = surveyResultEntity;
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
