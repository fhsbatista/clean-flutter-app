import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../domain/usecases/usecases.dart';
import '../../ui/pages/surveys/surveys.dart';

class GetxSurveysPresenter {
  final LoadSurveys loadSurveys;

  final _isLoading = true.obs;
  final _surveys = Rx<List<SurveyViewModel>>([]);

  Stream<bool> get isLoadingStream => _isLoading.stream;
  Stream<List<SurveyViewModel>> get surveysStream => _surveys.stream;

  GetxSurveysPresenter({required this.loadSurveys});

  Future<void> loadData() async {
    _isLoading.value = true;
    final surveys = await loadSurveys.load();
    _surveys.value = surveys.map((e) => SurveyViewModel(
          id: e.id,
          question: e.question,
          date: DateFormat('dd MMM yyyy').format(e.date),
          isAnswered: e.isAnswered,
        )).toList();
    _isLoading.value = false;
  }
}
