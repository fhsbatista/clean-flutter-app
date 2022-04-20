import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fordev/data/cache/cache.dart';
import 'package:fordev/data/usecases/usecases.dart';
import 'package:fordev/domain/entities/survey_entity.dart';
import 'package:fordev/domain/helpers/helpers.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'local_load_surveys_test.mocks.dart';

@GenerateMocks([CacheStorage])
void main() {
  late LocalLoadSurveys sut;
  late MockCacheStorage fetchCacheStorage;

  final validSurveysMap = [
    {
      'id': faker.guid.guid(),
      'question': faker.lorem.words(3).toString(),
      'date': '2022-01-27T00:00:00Z',
      'didAnswer': 'false',
    },
    {
      'id': faker.guid.guid(),
      'question': faker.lorem.words(3).toString(),
      'date': '2021-09-27T01:00:00Z',
      'didAnswer': 'true',
    }
  ];

  final validSurveysEntities = [
    SurveyEntity(
      id: 'id 1',
      question: 'question 1',
      date: DateTime.utc(2022, 1, 22),
      isAnswered: true,
    ),
    SurveyEntity(
      id: 'id 2',
      question: 'question 2',
      date: DateTime.utc(2022, 2, 22),
      isAnswered: false,
    ),
  ];

  void mockFetch(List<Map>? data) {
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
    sut = LocalLoadSurveys(cacheStorage: fetchCacheStorage);
    mockFetch(validSurveysMap);
    mockSave();
  });

  group('load', () {
    test('Should call FetchCacheStorage with correct key', () async {
      await sut.load();

      verify(fetchCacheStorage.fetch('surveys')).called(1);
    });

    test('Should return a list of surveys on success', () async {
      final surveys = await sut.load();

      expect(
        surveys,
        [
          SurveyEntity(
            id: validSurveysMap[0]['id'] ?? '',
            question: validSurveysMap[0]['question'] ?? '',
            date: DateTime.utc(2022, 01, 27),
            isAnswered: false,
          ),
          SurveyEntity(
            id: validSurveysMap[1]['id'] ?? '',
            question: validSurveysMap[1]['question'] ?? '',
            date: DateTime.utc(2021, 09, 27, 1),
            isAnswered: true,
          ),
        ],
      );
    });

    test('Should throw Unexpected error if cache is empty', () async {
      mockFetch([]);

      final future = () => sut.load();

      expect(future, throwsA(DomainError.unexpected));
    });

    test('Should throw Unexpected error if cache is null', () async {
      mockFetch(null);

      final future = () => sut.load();

      expect(future, throwsA(DomainError.unexpected));
    });

    test('Should throw Unexpected error if cache is invalid', () async {
      mockFetch([
        {
          'id': faker.guid.guid(),
          'question': faker.lorem.words(3).toString(),
          'date': 'invalid date',
          'didAnswer': 'false',
        }
      ]);

      final future = () => sut.load();

      expect(future, throwsA(DomainError.unexpected));
    });

    test('Should throw Unexpected error if cache is incomplete', () async {
      mockFetch([
        {
          'date': '2022-01-27T00:00:00Z',
          'didAnswer': 'false',
        }
      ]);

      final future = () => sut.load();

      expect(future, throwsA(DomainError.unexpected));
    });

    test('Should throw Unexpected error if fetch throws', () async {
      mockFetchError();

      final future = () => sut.load();

      expect(future, throwsA(DomainError.unexpected));
    });

    group('validate', () {
      test('Should call FetchCacheStorage with correct key', () async {
        await sut.validate();

        verify(fetchCacheStorage.fetch('surveys')).called(1);
      });

      test('Should delete cache if it is invalid', () async {
        mockFetch([
          {
            'id': faker.guid.guid(),
            'question': faker.lorem.words(3).toString(),
            'date': 'invalid date',
            'didAnswer': 'false',
          }
        ]);

        await sut.validate();

        verify(fetchCacheStorage.delete('surveys')).called(1);
      });

      test('Should delete cache if it is incomplete', () async {
        mockFetch([
          {
            'id': faker.guid.guid(),
            'date': '2022-01-27T00:00:00Z',
            'didAnswer': 'false',
          }
        ]);

        await sut.validate();

        verify(fetchCacheStorage.delete('surveys')).called(1);
      });

      test('Should delete cache if fetch throws', () async {
        mockFetchError();

        await sut.validate();

        verify(fetchCacheStorage.delete('surveys')).called(1);
      });
    });

    group('save', () {
      test('Should call CacheStorage with correct values', () async {
        final list = [
          {
            'id': validSurveysEntities[0].id,
            'question': validSurveysEntities[0].question,
            'date': validSurveysEntities[0].date.toIso8601String(),
            'didAnswer': validSurveysEntities[0].isAnswered.toString(),
          },
          {
            'id': validSurveysEntities[1].id,
            'question': validSurveysEntities[1].question,
            'date': validSurveysEntities[1].date.toIso8601String(),
            'didAnswer': validSurveysEntities[1].isAnswered.toString(),
          },
        ];

        await sut.save(validSurveysEntities);

        verify(fetchCacheStorage.save(key: 'surveys', value: list)).called(1);
      });

      test('Should throw Unexpected error if save throws', () async {
        mockSaveError();

        final future = sut.save(validSurveysEntities);

        expect(() => future, throwsA(DomainError.unexpected));
      });
    });
  });
}
