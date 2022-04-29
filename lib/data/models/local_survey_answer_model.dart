import '../../domain/entities/entities.dart';

class LocalSurveyAnswerModel {
  final String answer;
  final bool isCurrentAnswer;
  final int percent;
  final String? image;

  LocalSurveyAnswerModel({
    required this.answer,
    required this.isCurrentAnswer,
    required this.percent,
    this.image,
  });

  factory LocalSurveyAnswerModel.fromJson(Map json) {
    return LocalSurveyAnswerModel(
      answer: json['answer'],
      isCurrentAnswer: json['isCurrentAnswer'].toLowerCase() == 'true',
      percent: int.parse(json['percent']),
      image: json['image'],
    );
  }

  SurveyAnswerEntity toEntity() => SurveyAnswerEntity(
        answer: answer,
        isCurrentAnswer: isCurrentAnswer,
        image: image,
        percent: percent
      );
}
