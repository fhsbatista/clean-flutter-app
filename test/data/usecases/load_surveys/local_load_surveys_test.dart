import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fordev/data/cache/cache.dart';
import 'package:fordev/data/usecases/usecases.dart';
import 'package:fordev/domain/entities/survey_entity.dart';
import 'package:fordev/domain/helpers/helpers.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'local_load_surveys_test.mocks.dart';

@GenerateMocks([FetchCacheStorage])
void main() {
  late LocalLoadSurveys sut;
  late MockFetchCacheStorage fetchCacheStorage;

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

  void mockFetch(List<Map>? data) {
    when(fetchCacheStorage.fetch(any)).thenAnswer((_) async => data);
  }

  void mockFetchError() {
    when(fetchCacheStorage.fetch(any)).thenThrow(Exception());
  }

  setUp(() {
    fetchCacheStorage = MockFetchCacheStorage();
    sut = LocalLoadSurveys(fetchCacheStorage: fetchCacheStorage);
    mockFetch(validSurveysMap);
  });

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
}
