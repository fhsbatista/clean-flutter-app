import 'package:equatable/equatable.dart';

class SurveyAnswerViewModel extends Equatable {
  final String answer;
  final bool isCurrentAnswer;
  final String percent;
  final String? image;

  SurveyAnswerViewModel({
    required this.answer,
    required this.isCurrentAnswer,
    required this.percent,
    this.image,
  });

  @override
  List<Object?> get props => [answer, isCurrentAnswer, percent, image];
}
