import 'package:flutter_test/flutter_test.dart';
import 'package:fordev/data/cache/cache.dart';
import 'package:fordev/data/usecases/usecases.dart';
import 'package:fordev/domain/entities/survey_entity.dart';
import 'package:fordev/domain/helpers/helpers.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../mocks/mocks.dart';
import 'local_load_surveys_test.mocks.dart';

@GenerateMocks([CacheStorage])
void main() {
  late LocalLoadSurveys sut;
  late MockCacheStorage fetchCacheStorage;

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
    mockFetch(FakeSurveysFactory.cacheJson);
    mockSave();
  });

  group('load', () {
    test('Should call FetchCacheStorage with correct key', () async {
      await sut.load();

      verify(fetchCacheStorage.fetch('surveys')).called(1);
    });

    test('Should return a list of surveys on success', () async {
      final json = FakeSurveysFactory.cacheJson;
      mockFetch(json);
      final surveys = await sut.load();

      expect(
        surveys,
        [
          SurveyEntity(
            id: json[0]['id'] ?? '',
            question: json[0]['question'] ?? '',
            date: DateTime.utc(2022, 01, 27),
            isAnswered: false,
          ),
          SurveyEntity(
            id: json[1]['id'] ?? '',
            question: json[1]['question'] ?? '',
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
      mockFetch(FakeSurveysFactory.invalidCacheJson);

      final future = () => sut.load();

      expect(future, throwsA(DomainError.unexpected));
    });

    test('Should throw Unexpected error if cache is incomplete', () async {
      mockFetch(FakeSurveysFactory.incompleteCacheJson);

      final future = () => sut.load();

      expect(future, throwsA(DomainError.unexpected));
    });

    test('Should throw Unexpected error if fetch throws', () async {
      mockFetchError();

      final future = () => sut.load();

      expect(future, throwsA(DomainError.unexpected));
    });
  });

  group('save', () {
    test('Should call CacheStorage with correct values', () async {
      final entities = FakeSurveysFactory.entities;
      final list = [
        {
          'id': entities[0].id,
          'question': entities[0].question,
          'date': entities[0].date.toIso8601String(),
          'didAnswer': entities[0].isAnswered.toString(),
        },
        {
          'id': entities[1].id,
          'question': entities[1].question,
          'date': entities[1].date.toIso8601String(),
          'didAnswer': entities[1].isAnswered.toString(),
        },
      ];

      await sut.save(FakeSurveysFactory.entities);

      verify(fetchCacheStorage.save(key: 'surveys', value: list)).called(1);
    });

    test('Should throw Unexpected error if save throws', () async {
      mockSaveError();

      final future = sut.save(FakeSurveysFactory.entities);

      expect(() => future, throwsA(DomainError.unexpected));
    });
  });

  group('validate', () {
    test('Should call FetchCacheStorage with correct key', () async {
      await sut.validate();

      verify(fetchCacheStorage.fetch('surveys')).called(1);
    });

    test('Should delete cache if it is invalid', () async {
      mockFetch(FakeSurveysFactory.invalidCacheJson);

      await sut.validate();

      verify(fetchCacheStorage.delete('surveys')).called(1);
    });

    test('Should delete cache if it is incomplete', () async {
      mockFetch(FakeSurveysFactory.incompleteCacheJson);

      await sut.validate();

      verify(fetchCacheStorage.delete('surveys')).called(1);
    });

    test('Should delete cache if fetch throws', () async {
      mockFetchError();

      await sut.validate();

      verify(fetchCacheStorage.delete('surveys')).called(1);
    });
  });
}
