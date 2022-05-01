import 'package:fordev/ui/pages/survey_result/survey_result.dart';
import 'package:get/get.dart';

import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';
import '../../ui/helpers/errors/errors.dart';
import '../mixins/mixins.dart';

class GetxSurveyResultPresenter extends GetxController
    with GetxLoading, GetxSession
    implements SurveyResultPresenter {
  final LoadSurveyResult loadSurveyResult;
  final String surveyId;

  final _surveyResult = Rx<SurveyResultViewModel?>(null);
  Stream<SurveyResultViewModel?> get surveyResultStream => _surveyResult.stream;

  GetxSurveyResultPresenter({
    required this.loadSurveyResult,
    required this.surveyId,
  });

  Future<void> loadData() async {
    try {
      isLoading = true;
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
        isSessionExpired = true;
      } else {
        _surveyResult.addError(
          UIError.unexpected.description,
          StackTrace.empty,
        );
      }
    } finally {
      isLoading = false;
    }
  }

  @override
  Future<void> save({required String answer}) async {
    return;
  }
}
