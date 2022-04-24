import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';
import '../../ui/helpers/errors/errors.dart';
import '../../ui/pages/surveys/surveys.dart';

class GetxSurveysPresenter extends GetxController implements SurveysPresenter {
  final LoadSurveys loadSurveys;

  final _isLoading = true.obs;
  final _surveys = Rx<List<SurveyViewModel>>([]);
  final _navigateTo = Rx<String?>(null);

  Stream<bool> get isLoadingStream => _isLoading.stream;
  Stream<List<SurveyViewModel>> get surveysStream => _surveys.stream;
  Stream<String?> get navigateToStream => _navigateTo.stream;

  GetxSurveysPresenter({required this.loadSurveys});

  @override
  Future<void> loadData() async {
    try {
      _isLoading.value = true;
      final surveys = await loadSurveys.load();
      _surveys.value = surveys
          .map((e) => SurveyViewModel(
                id: e.id,
                question: e.question,
                date: DateFormat('dd MMM yyyy').format(e.date),
                isAnswered: e.isAnswered,
              ))
          .toList();
    } on DomainError {
      _surveys.addError(UIError.unexpected.description, StackTrace.empty);
    } finally {
      _isLoading.value = false;
    }
  }

  @override
  void goToSurveyResult({required String surveyId}) {
    _navigateTo.value = '/survey_result/$surveyId';
  }
}
