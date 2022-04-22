import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fordev/data/usecases/usecases.dart';
import 'package:fordev/domain/entities/entities.dart';
import 'package:fordev/main/composites/composites.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'remote_load_surveys_with_local_fallback_test.mocks.dart';

@GenerateMocks([RemoteLoadSurveys, LocalLoadSurveys])
void main() {
  late RemoteLoadSurveysWithLocalFallback sut;
  late MockRemoteLoadSurveys remote;
  late MockLocalLoadSurveys local;
  late List<SurveyEntity> surveys;

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
    surveys = validSurveys();
    when(remote.load()).thenAnswer((_) async => surveys);
  }

  setUp(() {
    remote = MockRemoteLoadSurveys();
    local = MockLocalLoadSurveys();
    sut = RemoteLoadSurveysWithLocalFallback(
      remote: remote,
      local: local,
    );
    mockRemote();
  });

  test('Should call remote load', () async {
    await sut.load();

    verify(remote.load()).called(1);
  });

  test('Should call local save with remote data', () async {
    await sut.load();

    verify(local.save(surveys)).called(1);
  });
}
