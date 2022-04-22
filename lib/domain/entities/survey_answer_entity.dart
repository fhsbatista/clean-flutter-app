class SurveyAnswerEntity {
  final String answer;
  final bool inAnswered;
  final int percent;
  final String? image;

  SurveyAnswerEntity({
    required this.answer,
    required this.inAnswered,
    required this.percent,
    this.image,
  });
}
