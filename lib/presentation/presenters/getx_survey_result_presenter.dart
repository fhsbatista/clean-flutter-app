import 'package:fordev/ui/pages/survey_result/survey_result.dart';
import 'package:get/get.dart';

import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';
import '../../ui/helpers/errors/errors.dart';

class GetxSurveyResultPresenter extends GetxController
    implements SurveyResultPresenter {
  final LoadSurveyResult loadSurveyResult;
  final String surveyId;

  final _isLoading = true.obs;
  final _surveyResult = Rx<SurveyResultViewModel?>(null);
  final _isSessionExpired = false.obs;

  Stream<bool> get isLoadingStream => _isLoading.stream;
  Stream<SurveyResultViewModel?> get surveyResultStream => _surveyResult.stream;
  Stream<bool> get isSessionExpiredStream => _isSessionExpired.stream;

  GetxSurveyResultPresenter({
    required this.loadSurveyResult,
    required this.surveyId,
  });

  Future<void> loadData() async {
    try {
      _isLoading.value = true;
      final surveyResult = await loadSurveyResult.loadBySurvey(surveyId);
      _surveyResult.value = SurveyResultViewModel(
        id: surveyResult.id,
        question: surveyResult.question,
        answers: surveyResult.answers
            .map((answer) => SurveyAnswerViewModel(
                  answer: answer.answer,
                  isCurrentAnswer: answer.isCurrentAnswer,
                  percent: '${answer.percent}%',
                  image: answer.image,
                ))
            .toList(),
      );
    } on DomainError catch (error) {
      if (error == DomainError.access_denied) {
        _isSessionExpired.value = true;
      } else {
        _surveyResult.addError(
          UIError.unexpected.description,
          StackTrace.empty,
        );
      }
    } finally {
      _isLoading.value = false;
    }
  }
}
