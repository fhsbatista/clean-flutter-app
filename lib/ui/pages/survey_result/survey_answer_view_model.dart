class SurveyAnswerViewModel {
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
}
