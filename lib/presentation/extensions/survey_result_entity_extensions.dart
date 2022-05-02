import '../../domain/entities/entities.dart';
import '../../ui/pages/pages.dart';

extension ExtensionsSurveyResultEntity on SurveyResultEntity {
  SurveyResultViewModel toViewModel() {
    return SurveyResultViewModel(
      id: id,
      question: question,
      answers: answers.map((answer) => answer.toViewModel()).toList(),
    );
  }
}

extension ExtensionsSurveyAnswerEntity on SurveyAnswerEntity {
  SurveyAnswerViewModel toViewModel() {
    return SurveyAnswerViewModel(
      answer: answer,
      isCurrentAnswer: isCurrentAnswer,
      percent: '$percent%',
      image: image,
    );
  }
}
