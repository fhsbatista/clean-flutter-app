import '../../domain/usecases/usecases.dart';

class GetxSurveysPresenter {
  final LoadSurveys loadSurveys;

  GetxSurveysPresenter({required this.loadSurveys});

  Future<void> loadData() async {
    await loadSurveys.load();
  }
}
