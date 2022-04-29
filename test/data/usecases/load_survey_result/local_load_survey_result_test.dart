import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fordev/data/cache/cache.dart';
import 'package:fordev/data/usecases/usecases.dart';
import 'package:fordev/domain/entities/entities.dart';
import 'package:fordev/domain/helpers/helpers.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'local_load_survey_result_test.mocks.dart';

@GenerateMocks([CacheStorage])
void main() {
  late LocalLoadSurveyResult sut;
  late MockCacheStorage fetchCacheStorage;
  late String surveyId;

  Map validData() => {
        'surveyId': faker.guid.guid(),
        'question': faker.lorem.sentence(),
        'answers': [
          {
            'image': faker.internet.httpsUrl(),
            'answer': faker.lorem.sentence(),
            'percent': '40',
            'count': '300',
            'isCurrentAnswer': 'false',
          },
          {
            'answer': faker.lorem.sentence(),
            'percent': '13',
            'count': '288',
            'isCurrentAnswer': 'true',
          },
        ],
      };

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

  void mockFetch(Map? data) {
    when(fetchCacheStorage.fetch(any)).thenAnswer((_) async => data);
  }

  void mockFetchError() {
    when(fetchCacheStorage.fetch(any)).thenThrow(Exception());
  }

  void mockSave() {
    when(fetchCacheStorage.save(key: anyNamed('key'), value: anyNamed('value')))
        .thenAnswer((_) async => null);
  }

  void mockSaveError() {
    when(fetchCacheStorage.save(key: anyNamed('key'), value: anyNamed('value')))
        .thenThrow(Exception());
  }

  setUp(() {
    fetchCacheStorage = MockCacheStorage();
    surveyId = faker.guid.guid();
    sut = LocalLoadSurveyResult(cacheStorage: fetchCacheStorage);
    mockFetch(validData());
    mockSave();
  });

  group('load by survey', () {
    test('Should call FetchCacheStorage with correct key', () async {
      await sut.loadBySurvey(surveyId);

      verify(fetchCacheStorage.fetch('survey_result/$surveyId')).called(1);
    });

    test('Should return survey result on success', () async {
      final data = validData();
      mockFetch(data);

      final surveyResult = await sut.loadBySurvey(surveyId);

      expect(
        surveyResult,
        SurveyResultEntity(
          id: data['surveyId'],
          question: data['question'],
          answers: [
            SurveyAnswerEntity(
              image: data['answers'][0]['image'],
              answer: data['answers'][0]['answer'],
              percent: 40,
              isCurrentAnswer: false,
            ),
            SurveyAnswerEntity(
              answer: data['answers'][1]['answer'],
              percent: 13,
              isCurrentAnswer: true,
            ),
          ],
        ),
      );
    });

    test('Should throw Unexpected error if cache is empty', () async {
      mockFetch({});

      final future = () => sut.loadBySurvey(surveyId);

      expect(future, throwsA(DomainError.unexpected));
    });

    test('Should throw Unexpected error if cache is null', () async {
      mockFetch(null);

      final future = () => sut.loadBySurvey(surveyId);

      expect(future, throwsA(DomainError.unexpected));
    });

    test('Should throw Unexpected error if cache is invalid', () async {
      mockFetch({
        'surveyId': faker.guid.guid(),
        'question': faker.lorem.sentence(),
        'answers': [
          {
            'image': faker.internet.httpsUrl(),
            'answer': faker.lorem.sentence(),
            'percent': 'invalid int',
            'isCurrentAccountAnswer': 'invalid_boolean',
          },
        ],
      });

      final future = () => sut.loadBySurvey(surveyId);

      expect(future, throwsA(DomainError.unexpected));
    });

    test('Should throw Unexpected error if cache is incomplete', () async {
      mockFetch({
        'surveyId': faker.guid.guid(),
      });

      final future = () => sut.loadBySurvey(surveyId);

      expect(future, throwsA(DomainError.unexpected));
    });

    test('Should throw Unexpected error if fetch throws', () async {
      mockFetchError();

      final future = () => sut.loadBySurvey(surveyId);

      expect(future, throwsA(DomainError.unexpected));
    });
  });

  group('validate', () {
    test('Should call FetchCacheStorage with correct key', () async {
      await sut.validate(surveyId);

      verify(fetchCacheStorage.fetch('survey_result/$surveyId')).called(1);
    });

    test('Should delete cache if it is invalid', () async {
      mockFetch({
        'surveyId': faker.guid.guid(),
        'question': faker.lorem.sentence(),
        'answers': [
          {
            'image': faker.internet.httpsUrl(),
            'answer': faker.lorem.sentence(),
            'percent': 'invalid int',
            'isCurrentAccountAnswer': 'invalid_boolean',
          },
        ],
      });

      await sut.validate(surveyId);

      verify(fetchCacheStorage.delete('survey_result/$surveyId')).called(1);
    });

    test('Should delete cache if it is incomplete', () async {
      mockFetch({
        'surveyId': faker.guid.guid(),
        'answers': [
          {
            'image': faker.internet.httpsUrl(),
            'answer': faker.lorem.sentence(),
            'percent': 'invalid int',
            'isCurrentAccountAnswer': 'invalid_boolean',
          },
        ],
      });

      await sut.validate(surveyId);

      verify(fetchCacheStorage.delete('survey_result/$surveyId')).called(1);
    });

    test('Should delete cache if fetch throws', () async {
      mockFetchError();

      await sut.validate(surveyId);

      verify(fetchCacheStorage.delete('survey_result/$surveyId')).called(1);
    });
  });

  group('save', () {
    test('Should call CacheStorage with correct values', () async {
      final entity = validSurveyResultEntity();
      final surveyMap = {
        'surveyId': surveyId,
        'question': entity.question,
        'answers': [
          {
            'image': entity.answers[0].image,
            'answer': entity.answers[0].answer,
            'percent': '40',
            'isCurrentAnswer': 'true',
          },
          {
            'answer': entity.answers[1].answer,
            'percent': '20',
            'isCurrentAnswer': 'false',
            'image': null,
          },
        ],
      };

      await sut.save(entity);

      verify(fetchCacheStorage.save(
        key: 'survey_result/$surveyId',
        value: surveyMap,
      )).called(1);
    });

    test('Should throw Unexpected error if save throws', () async {
      mockSaveError();

      final future = sut.save(validSurveyResultEntity());

      expect(() => future, throwsA(DomainError.unexpected));
    });
  });
}
