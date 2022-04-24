
import 'survey_result.dart';

class SurveyResultViewModel {
  final String id;
  final String question;
  final List<SurveyAnswerViewModel> answers;

  SurveyResultViewModel({
    required this.id,
    required this.question,
    required this.answers,
  });
}
