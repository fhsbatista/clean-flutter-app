import 'package:faker/faker.dart';
import 'package:fordev/domain/entities/entities.dart';
import 'package:fordev/ui/pages/pages.dart';

class FakeSurveyResultFactory {
  static Map get cacheJson {
    return {
      'surveyId': faker.guid.guid(),
      'question': faker.lorem.sentence(),
      'answers': [
        {
          'image': faker.internet.httpsUrl(),
          'answer': faker.lorem.sentence(),
          'percent': '40',
          'count': '300',
          'isCurrentAnswer': 'false',
        },
        {
          'answer': faker.lorem.sentence(),
          'percent': '13',
          'count': '288',
          'isCurrentAnswer': 'true',
        },
      ],
    };
  }

  static Map get apiJson {
    return {
      'surveyId': faker.guid.guid(),
      'question': faker.randomGenerator.string(50),
      'answers': [
        {
          'image': faker.internet.httpsUrl(),
          'answer': faker.randomGenerator.string(20),
          'percent': faker.randomGenerator.integer(100),
          'count': faker.randomGenerator.integer(1000),
          'isCurrentAccountAnswer': faker.randomGenerator.boolean(),
        },
        {
          'answer': faker.randomGenerator.string(20),
          'percent': faker.randomGenerator.integer(100),
          'count': faker.randomGenerator.integer(1000),
          'isCurrentAccountAnswer': faker.randomGenerator.boolean(),
        },
      ],
      'date': faker.date.dateTime().toIso8601String(),
    };
  }

  static Map get invalidCacheJson {
    return {
      'surveyId': faker.guid.guid(),
      'question': faker.lorem.sentence(),
      'answers': [
        {
          'image': faker.internet.httpsUrl(),
          'answer': faker.lorem.sentence(),
          'percent': 'invalid int',
          'isCurrentAccountAnswer': 'invalid_boolean',
        },
      ],
    };
  }

  static Map get invalidApiJson {
    return {
      'invalid_key': 'invalid_value',
    };
  }

  static Map get incompleteCacheJson {
    return {
      'surveyId': faker.guid.guid(),
      'answers': [
        {
          'image': faker.internet.httpsUrl(),
          'percent': 'invalid int',
          'isCurrentAccountAnswer': 'invalid_boolean',
        },
      ],
    };
  }

  static SurveyResultEntity get entity {
    return SurveyResultEntity(
      id: faker.guid.guid(),
      question: faker.lorem.sentence(),
      answers: [
        SurveyAnswerEntity(
          answer: faker.lorem.sentence(),
          isCurrentAnswer: true,
          percent: 40,
          image: faker.internet.httpsUrl(),
        ),
        SurveyAnswerEntity(
          answer: faker.lorem.sentence(),
          isCurrentAnswer: false,
          percent: 20,
        ),
      ],
    );
  }

  static SurveyResultViewModel get viewModel {
    //Não está usando o 'faker' para evitar o risco de o faker acabar gerando strings iguais.
    //Isso faria o teste passar ou falhar por motivos errados já que eles precisam encontrar (método find) um número específico de widgets que dão match.
    return SurveyResultViewModel(
      id: 'any_id',
      question: 'Question',
      answers: [
        SurveyAnswerViewModel(
          image: 'image 1',
          answer: 'answer 1',
          isCurrentAnswer: false,
          percent: '60%',
        ),
        SurveyAnswerViewModel(
          answer: 'answer 2',
          isCurrentAnswer: true,
          percent: '30%',
        ),
      ],
    );
  }
}
