import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fordev/data/usecases/usecases.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:fordev/data/http/http.dart';
import 'package:fordev/domain/entities/entities.dart';
import 'package:fordev/domain/helpers/helpers.dart';

import '../add_account/remote_add_account_test.mocks.dart';

@GenerateMocks([HttpClient])
void main() {
  late RemoteLoadSurveyResult sut;
  late String url;
  late MockHttpClient httpClient;

  PostExpectation mockHttp() => when(httpClient.request(
        url: anyNamed('url'),
        method: anyNamed('method'),
      ));

  void mockHttpData(Map data) => mockHttp().thenAnswer((_) async => data);

  Map mockValidData() => {
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

  void mockHttpError(HttpError error) => mockHttp().thenThrow(error);

  setUp(() {
    url = faker.internet.httpUrl();
    httpClient = MockHttpClient();
    sut = RemoteLoadSurveyResult(url: url, httpClient: httpClient);
    mockHttpData(mockValidData());
  });

  test('Should call HttpClient with correct values', () async {
    await sut.loadBySurvey('1');

    verify(httpClient.request(url: url, method: 'get')).called(1);
  });

  test('Should return result on 200', () async {
    final data = mockValidData();
    mockHttpData(data);

    final result = await sut.loadBySurvey('1');

    expect(
      result,
      SurveyResultEntity(
        id: data['surveyId'],
        question: data['question'],
        answers: [
          SurveyAnswerEntity(
            image: data['answers'][0]['image'],
            answer: data['answers'][0]['answer'],
            isCurrentAnswer: data['answers'][0]['isCurrentAccountAnswer'],
            percent: data['answers'][0]['percent'],
          ),
          SurveyAnswerEntity(
            answer: data['answers'][1]['answer'],
            isCurrentAnswer: data['answers'][1]['isCurrentAccountAnswer'],
            percent: data['answers'][1]['percent'],
          ),
        ],
      ),
    );
  });

  test(
      'Should throw Unexpected error if HttpClient returns 200 with invalid data',
      () async {
    mockHttpData({'invalid_key': 'invalid_value'});

    final future = sut.loadBySurvey('1');

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw Unexpected error if HttpClient returns 404', () {
    mockHttpError(HttpError.notFound);

    final future = sut.loadBySurvey('1');

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw Unexpected error if HttpClient returns 500', () {
    mockHttpError(HttpError.serverError);

    final future = sut.loadBySurvey('1');

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw AccessDenied error if HttpClient returns 403', () {
    mockHttpError(HttpError.forbidden);

    final future = sut.loadBySurvey('1');

    expect(future, throwsA(DomainError.access_denied));
  });
}
