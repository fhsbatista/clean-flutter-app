import 'package:faker/faker.dart';
import 'package:fordev/domain/entities/survey_entity.dart';
import 'package:fordev/ui/pages/pages.dart';

class FakeSurveysFactory {
  static List<Map> get cacheJson {
    return [
      {
        'id': faker.guid.guid(),
        'question': faker.lorem.words(3).toString(),
        'date': '2022-01-27T00:00:00Z',
        'didAnswer': 'false',
      },
      {
        'id': faker.guid.guid(),
        'question': faker.lorem.words(3).toString(),
        'date': '2021-09-27T01:00:00Z',
        'didAnswer': 'true',
      }
    ];
  }

  static List<Map> get apiJson {
    return [
      {
        'id': faker.guid.guid(),
        'question': faker.randomGenerator.string(50),
        'date': faker.date.dateTime().toIso8601String(),
        'didAnswer': faker.randomGenerator.boolean(),
      },
      {
        'id': faker.guid.guid(),
        'question': faker.randomGenerator.string(50),
        'date': faker.date.dateTime().toIso8601String(),
        'didAnswer': faker.randomGenerator.boolean(),
      },
    ];
  }

  static List<Map> get incompleteCacheJson {
    return [
      {
        'id': faker.guid.guid(),
        'date': '2022-01-27T00:00:00Z',
      }
    ];
  }

  static List<Map> get invalidCacheJson {
    return [
      {
        'id': faker.guid.guid(),
        'question': faker.lorem.words(3).toString(),
        'date': 'invalid date',
        'didAnswer': 'false',
      }
    ];
  }

  static List<Map> get invalidApiJson {
    return [
      {'invalid_key': 'invalid_value'}
    ];
  }

  static List<SurveyEntity> get entities {
    return [
      SurveyEntity(
        id: 'id 1',
        question: 'question 1',
        date: DateTime.utc(2022, 1, 22),
        isAnswered: true,
      ),
      SurveyEntity(
        id: 'id 2',
        question: 'question 2',
        date: DateTime.utc(2022, 2, 22),
        isAnswered: false,
      ),
    ];
  }

  static List<SurveyViewModel> get viewModels => [
        SurveyViewModel(
          id: '1',
          question: 'Question 1',
          date: 'Date 1',
          isAnswered: false,
        ),
        SurveyViewModel(
          id: '1',
          question: 'Question 2',
          date: 'Date 2',
          isAnswered: false,
        ),
      ];
}
