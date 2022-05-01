import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fordev/data/usecases/usecases.dart';
import 'package:fordev/domain/entities/entities.dart';
import 'package:fordev/domain/helpers/helpers.dart';
import 'package:fordev/main/composites/composites.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'remote_load_survey_result_with_local_fallback_test.mocks.dart';

@GenerateMocks([RemoteLoadSurveyResult, LocalLoadSurveyResult])
void main() {
  late RemoteLoadSurveyResultWithLocalFallback sut;
  late MockRemoteLoadSurveyResult remote;
  late MockLocalLoadSurveyResult local;
  late String surveyId;

  SurveyResultEntity validSurveyResultEntity() => SurveyResultEntity(
        id: surveyId,
        question: faker.lorem.sentence(),
        answers: [
          SurveyAnswerEntity(
            answer: faker.lorem.sentence(),
            isCurrentAnswer: true,
            percent: 40,
            image: faker.internet.httpsUrl(),
          ),
          SurveyAnswerEntity(
            answer: faker.lorem.sentence(),
            isCurrentAnswer: false,
            percent: 20,
          ),
        ],
      );

  void mockRemote(SurveyResultEntity survey) {
    when(remote.loadBySurvey(any)).thenAnswer((_) async => survey);
  }

  void mockRemoteError(DomainError error) {
    when(remote.loadBySurvey(any)).thenThrow(error);
  }

  setUp(() {
    surveyId = faker.guid.guid();
    remote = MockRemoteLoadSurveyResult();
    local = MockLocalLoadSurveyResult();
    sut = RemoteLoadSurveyResultWithLocalFallback(remote: remote, local: local);
    mockRemote(validSurveyResultEntity());
  });

  test('Should call remote LoadBySurvey', () async {
    await sut.loadBySurvey(surveyId);

    verify(remote.loadBySurvey(surveyId)).called(1);
  });

  test('Should call local save with remote data', () async {
    final survey = validSurveyResultEntity();
    mockRemote(survey);

    await sut.loadBySurvey(surveyId);

    verify(local.save(survey)).called(1);
  });

  test('Should return remote data', () async {
    final survey = validSurveyResultEntity();
    mockRemote(survey);

    final result = await sut.loadBySurvey(surveyId);

    expect(result, survey);
  });

  test('Should rethrow if remote throws AccessDenied error', () async {
    mockRemoteError(DomainError.access_denied);

    final future = sut.loadBySurvey(surveyId);

    expect(future, throwsA(DomainError.access_denied));
  });
}
