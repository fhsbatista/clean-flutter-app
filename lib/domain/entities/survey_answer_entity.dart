import 'package:equatable/equatable.dart';

class SurveyAnswerEntity extends Equatable {
  final String answer;
  final bool isCurrentAnswer;
  final int percent;
  final String? image;

  SurveyAnswerEntity({
    required this.answer,
    required this.isCurrentAnswer,
    required this.percent,
    this.image,
  });

  @override
  List<Object?> get props => [answer, isCurrentAnswer, percent, image];
}
