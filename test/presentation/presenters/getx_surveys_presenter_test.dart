import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fordev/ui/pages/surveys/surveys.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:fordev/domain/entities/entities.dart';
import 'package:fordev/domain/usecases/load_surveys.dart';
import 'package:fordev/presentation/presenters/presenters.dart';

import 'getx_surveys_presenter_test.mocks.dart';

@GenerateMocks([LoadSurveys])
void main() {
  late GetxSurveysPresenter sut;
  late MockLoadSurveys loadSurveys;
  late List<SurveyEntity> surveys;

  List<SurveyEntity> mockValidData() => [
        SurveyEntity(
          id: faker.guid.guid(),
          question: faker.lorem.sentence(),
          date: DateTime(2022, 2, 20),
          isAnswered: true,
        ),
        SurveyEntity(
          id: faker.guid.guid(),
          question: faker.lorem.sentence(),
          date: DateTime(2022, 3, 20),
          isAnswered: false,
        ),
      ];

  void mockLoadSurveys(List<SurveyEntity> data) {
    surveys = data;
    when(loadSurveys.load()).thenAnswer((_) async => data);
  }

  setUp(() {
    loadSurveys = MockLoadSurveys();
    sut = GetxSurveysPresenter(loadSurveys: loadSurveys);
    mockLoadSurveys(mockValidData());
  });

  test('Should call LoadSurveys on loadData', () async {
    await sut.loadData();

    verify(loadSurveys.load()).called(1);
  });

  test('Should emit correct events on LoadSurveys success', () async {
    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    sut.surveysStream.listen(expectAsync1(
      (surveys) => expect(surveys, [
        SurveyViewModel(
          id: surveys[0].id,
          question: surveys[0].question,
          date: '20 Feb 2022',
          isAnswered: surveys[0].isAnswered,
        ),
        SurveyViewModel(
          id: surveys[1].id,
          question: surveys[1].question,
          date: '20 Mar 2022',
          isAnswered: surveys[1].isAnswered,
        )
      ]),
    ));

    await sut.loadData();
  });
}