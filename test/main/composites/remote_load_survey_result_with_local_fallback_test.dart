import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fordev/data/usecases/usecases.dart';
import 'package:fordev/domain/entities/entities.dart';
import 'package:fordev/main/composites/composites.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'remote_load_survey_result_with_local_fallback_test.mocks.dart';

@GenerateMocks([RemoteLoadSurveyResult])
void main() {
  late RemoteLoadSurveyResultWithFallback sut;
  late MockRemoteLoadSurveyResult remote;
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

  setUp(() {
    surveyId = faker.guid.guid();
    remote = MockRemoteLoadSurveyResult();
    sut = RemoteLoadSurveyResultWithFallback(remote: remote);
    mockRemote(validSurveyResultEntity());
  });

  test('Should call remote LoadBySurvey', () async {
    sut.loadBySurvey(surveyId);

    verify(remote.loadBySurvey(surveyId)).called(1);
  });
}
