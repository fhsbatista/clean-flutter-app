import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fordev/data/usecases/usecases.dart';
import 'package:fordev/domain/entities/entities.dart';
import 'package:fordev/domain/helpers/helpers.dart';
import 'package:fordev/main/composites/composites.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'remote_load_surveys_with_local_fallback_test.mocks.dart';

@GenerateMocks([RemoteLoadSurveys, LocalLoadSurveys])
void main() {
  late RemoteLoadSurveysWithLocalFallback sut;
  late MockRemoteLoadSurveys remote;
  late MockLocalLoadSurveys local;
  late List<SurveyEntity> remoteSurveys;
  late List<SurveyEntity> localSurveys;

  List<SurveyEntity> validSurveys() {
    return [
      SurveyEntity(
        id: faker.guid.guid(),
        question: faker.randomGenerator.string(10),
        date: faker.date.dateTime(),
        isAnswered: faker.randomGenerator.boolean(),
      ),
      SurveyEntity(
        id: faker.guid.guid(),
        question: faker.randomGenerator.string(10),
        date: faker.date.dateTime(),
        isAnswered: faker.randomGenerator.boolean(),
      ),
    ];
  }

  void mockRemote() {
    remoteSurveys = validSurveys();
    when(remote.load()).thenAnswer((_) async => remoteSurveys);
  }

  void mockRemoteError(DomainError error) {
    when(remote.load()).thenThrow(error);
  }

  void mockLocal() {
    localSurveys = validSurveys();
    when(local.load()).thenAnswer((_) async => localSurveys);
  }

  void mockLocalError() {
    when(local.load()).thenThrow(Exception());
  }

  setUp(() {
    remote = MockRemoteLoadSurveys();
    local = MockLocalLoadSurveys();
    sut = RemoteLoadSurveysWithLocalFallback(
      remote: remote,
      local: local,
    );
    mockRemote();
    mockLocal();
  });

  test('Should call remote load', () async {
    await sut.load();

    verify(remote.load()).called(1);
  });

  test('Should call local save with remote data', () async {
    await sut.load();

    verify(local.save(remoteSurveys)).called(1);
  });

  test('Should return remote surveys', () async {
    final result = await sut.load();

    expect(result, remoteSurveys);
  });

  test('Should rethrow if remote load throws AccessDeniedError', () async {
    mockRemoteError(DomainError.access_denied);

    final future = sut.load();

    expect(() => future, throwsA(DomainError.access_denied));
  });

  test('Should call local fetch on remote error', () async {
    mockRemoteError(DomainError.unexpected);

    await sut.load();

    verify(local.validate()).called(1);
    verify(local.load()).called(1);
  });

  test('Should return local surveys', () async {
    mockRemoteError(DomainError.unexpected);

    final result = await sut.load();

    expect(result, localSurveys);
  });

  test('Should throw unexpected error if both remote and local throws', () async {
    mockRemoteError(DomainError.unexpected);
    mockLocalError();

    final future = sut.load();

    expect(() => future, throwsA(DomainError.unexpected));
  });
}
