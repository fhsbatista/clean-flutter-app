import 'package:flutter_test/flutter_test.dart';
import 'package:fordev/domain/usecases/load_surveys.dart';
import 'package:fordev/presentation/presenters/presenters.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'getx_surveys_presenter_test.mocks.dart';

@GenerateMocks([LoadSurveys])
void main() {
  late GetxSurveysPresenter sut;
  late MockLoadSurveys loadSurveys;

  setUp(() {
    loadSurveys = MockLoadSurveys();
    sut = GetxSurveysPresenter(loadSurveys: loadSurveys);
    when(loadSurveys.load()).thenAnswer((_) async => []);
  });

  test('Should call LoadSurveys on loadData', () async {
    await sut.loadData();

    verify(loadSurveys.load()).called(1);
  });
}
