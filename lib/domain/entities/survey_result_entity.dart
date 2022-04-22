
import 'entities.dart';

class SurveyResultEntity {
  final String id;
  final String question;
  final bool isAnswered;
  final List<SurveyAnswerEntity> answers;

  SurveyResultEntity({
    required this.id,
    required this.question,
    required this.isAnswered,
    required this.answers,
  });
}
