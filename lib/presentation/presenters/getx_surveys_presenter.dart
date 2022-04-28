import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';
import '../../ui/helpers/errors/errors.dart';
import '../../ui/pages/surveys/surveys.dart';
import '../mixins/mixins.dart';

class GetxSurveysPresenter extends GetxController
    with GetxLoading, GetxSession, GetxNavigation
    implements SurveysPresenter {
  final LoadSurveys loadSurveys;

  final _surveys = Rx<List<SurveyViewModel>>([]);
  Stream<List<SurveyViewModel>> get surveysStream => _surveys.stream;

  GetxSurveysPresenter({required this.loadSurveys});

  @override
  Future<void> loadData() async {
    try {
      isLoading = true;
      final surveys = await loadSurveys.load();
      _surveys.value = surveys
          .map((e) => SurveyViewModel(
                id: e.id,
                question: e.question,
                date: DateFormat('dd MMM yyyy').format(e.date),
                isAnswered: e.isAnswered,
              ))
          .toList();
    } on DomainError catch (error) {
      if (error == DomainError.access_denied) {
        isSessionExpired = true;
      } else {
        _surveys.addError(UIError.unexpected.description, StackTrace.empty);
      }
    } finally {
      isLoading = false;
    }
  }

  @override
  void goToSurveyResult({required String surveyId}) {
    navigateTo = '/survey_result/$surveyId';
  }
}
