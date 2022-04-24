
import 'package:equatable/equatable.dart';

import 'survey_result.dart';

class SurveyResultViewModel extends Equatable {
  final String id;
  final String question;
  final List<SurveyAnswerViewModel> answers;

  SurveyResultViewModel({
    required this.id,
    required this.question,
    required this.answers,
  });

  @override
  List<Object?> get props => [id, question, answers];
}
