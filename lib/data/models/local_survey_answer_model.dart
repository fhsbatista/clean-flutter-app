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

  factory LocalSurveyAnswerModel.fromEntity(SurveyAnswerEntity answer) {
    return LocalSurveyAnswerModel(
      answer: answer.answer,
      isCurrentAnswer: answer.isCurrentAnswer,
      percent: answer.percent,
      image: answer.image,
    );
  }

  SurveyAnswerEntity toEntity() => SurveyAnswerEntity(
        answer: answer,
        isCurrentAnswer: isCurrentAnswer,
        image: image,
        percent: percent
      );

  Map toJson() => {
        'answer': answer,
        'percent': percent.toString(),
        'isCurrentAnswer':isCurrentAnswer.toString(),
        'image': image,
      };
}
