import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:fordev/data/http/http.dart';
import 'package:fordev/data/usecases/load_surveys/load_surveys.dart';
import 'package:fordev/domain/entities/entities.dart';
import 'package:fordev/domain/helpers/helpers.dart';

import '../add_account/remote_add_account_test.mocks.dart';

@GenerateMocks([HttpClient])
void main() {
  late RemoteLoadSurveys sut;
  late String url;
  late MockHttpClient httpClient;

  void mockHttpData(List<Map> data) =>
      when(httpClient.request(url: anyNamed('url'), method: anyNamed('method')))
          .thenAnswer((_) async => data);

  List<Map> mockValidData() => [
        {
          'id': faker.guid.guid(),
          'question': faker.randomGenerator.string(50),
          'date': faker.date.dateTime().toIso8601String(),
          'isAnswered': faker.randomGenerator.boolean(),
        },
        {
          'id': faker.guid.guid(),
          'question': faker.randomGenerator.string(50),
          'date': faker.date.dateTime().toIso8601String(),
          'isAnswered': faker.randomGenerator.boolean(),
        },
      ];

  setUp(() {
    url = faker.internet.httpUrl();
    httpClient = MockHttpClient();
    sut = RemoteLoadSurveys(url: url, httpClient: httpClient);
    mockHttpData(mockValidData());
  });

  test('Should call HttpClient with correct values', () async {
    await sut.load();

    verify(httpClient.request(url: url, method: 'get')).called(1);
  });

  test('Should return surveys on 200', () async {
    final List<Map> data = mockValidData();
    mockHttpData(data);
    final expectedSurveys = [
      SurveyEntity(
        id: data[0]['id'],
        question: data[0]['question'],
        date: DateTime.parse(data[0]['date']),
        isAnswered: data[0]['isAnswered'],
      ),
      SurveyEntity(
        id: data[1]['id'],
        question: data[1]['question'],
        date: DateTime.parse(data[1]['date']),
        isAnswered: data[1]['isAnswered'],
      ),
    ];

    final surveys = await sut.load();

    
    expect(surveys, expectedSurveys);
  });

  test('Should throw Unexpected error if HttpClient returns 200 with invalid data', () async {
    mockHttpData([{'invalid_key': 'invalid_value'}]);

    final future = sut.load();
    
    expect(future, throwsA(DomainError.unexpected));
  });
}
