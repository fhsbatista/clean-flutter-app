import '../../domain/entities/entities.dart';
import 'models.dart';

class LocalSurveyResultModel {
  final String surveyId;
  final String question;
  final List<LocalSurveyAnswerModel> answers;

  LocalSurveyResultModel({
    required this.surveyId,
    required this.question,
    required this.answers,
  });

  factory LocalSurveyResultModel.fromJson(Map json) {
    return LocalSurveyResultModel(
      surveyId: json['surveyId'],
      question: json['question'],
      answers: json['answers']
          .map<LocalSurveyAnswerModel>(
              (answer) => LocalSurveyAnswerModel.fromJson(answer))
          .toList(),
    );
  }

  SurveyResultEntity toEntity() => SurveyResultEntity(
        id: surveyId,
        question: question,
        answers: answers
            .map<SurveyAnswerEntity>((answer) => answer.toEntity())
            .toList(),
      );
}
