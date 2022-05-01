import 'package:fordev/domain/entities/entities.dart';
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
  final SaveSurveyResult saveSurveyResult;
  final String surveyId;

  final _surveyResult = Rx<SurveyResultViewModel?>(null);
  Stream<SurveyResultViewModel?> get surveyResultStream => _surveyResult.stream;

  GetxSurveyResultPresenter({
    required this.loadSurveyResult,
    required this.saveSurveyResult,
    required this.surveyId,
  });

  @override
  Future<void> loadData() async {
    try {
      isLoading = true;
      final surveyResult = await loadSurveyResult.loadBySurvey(surveyId);
      _surveyResult.value = surveyResult.toViewModel();
    } on DomainError catch (error) {
      _handleDomainError(error);
    } finally {
      isLoading = false;
    }
  }

  @override
  Future<void> save({required String answer}) async {
    try {
      isLoading = true;
      final surveyResult = await saveSurveyResult.save(answer: answer);
      _surveyResult.value = surveyResult.toViewModel();
    } on DomainError catch (error) {
      _handleDomainError(error);
    } finally {
      isLoading = false;
    }
  }

  void _handleDomainError(DomainError error) {
    if (error == DomainError.access_denied) {
      isSessionExpired = true;
    } else {
      _surveyResult.addError(
        UIError.unexpected.description,
        StackTrace.empty,
      );
    }
  }
}

extension Extensions on SurveyResultEntity {
  SurveyResultViewModel toViewModel() {
    return SurveyResultViewModel(
      id: id,
      question: question,
      answers: answers
          .map((answer) => SurveyAnswerViewModel(
                answer: answer.answer,
                isCurrentAnswer: answer.isCurrentAnswer,
                percent: '${answer.percent}%',
                image: answer.image,
              ))
          .toList(),
    );
  }
}
