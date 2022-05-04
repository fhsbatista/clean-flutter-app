import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:fordev/data/http/http.dart';
import 'package:fordev/data/usecases/load_surveys/load_surveys.dart';
import 'package:fordev/domain/entities/entities.dart';
import 'package:fordev/domain/helpers/helpers.dart';

import '../../../mocks/mocks.dart';
import '../add_account/remote_add_account_test.mocks.dart';

@GenerateMocks([HttpClient])
void main() {
  late RemoteLoadSurveys sut;
  late String url;
  late MockHttpClient httpClient;

  PostExpectation mockHttp() => when(httpClient.request(
        url: anyNamed('url'),
        method: anyNamed('method'),
      ));

  void mockHttpData({List<Map>? data}) =>
      mockHttp().thenAnswer((_) async => data);

  void mockHttpError(HttpError error) => mockHttp().thenThrow(error);

  setUp(() {
    url = faker.internet.httpUrl();
    httpClient = MockHttpClient();
    sut = RemoteLoadSurveys(url: url, httpClient: httpClient);
    mockHttpData(data: FakeSurveysFactory.apiJson);
  });

  test('Should call HttpClient with correct values', () async {
    await sut.load();

    verify(httpClient.request(url: url, method: 'get')).called(1);
  });

  test('Should return surveys on 200', () async {
    final List<Map> data = FakeSurveysFactory.apiJson;
    mockHttpData(data: data);
    final expectedSurveys = [
      SurveyEntity(
        id: data[0]['id'],
        question: data[0]['question'],
        date: DateTime.parse(data[0]['date']),
        isAnswered: data[0]['didAnswer'],
      ),
      SurveyEntity(
        id: data[1]['id'],
        question: data[1]['question'],
        date: DateTime.parse(data[1]['date']),
        isAnswered: data[1]['didAnswer'],
      ),
    ];

    final surveys = await sut.load();

    expect(surveys, expectedSurveys);
  });

  test(
      'Should throw Unexpected error if HttpClient returns 200 with invalid data',
      () async {
    mockHttpData(data: FakeSurveysFactory.invalidApiJson);

    final future = sut.load();

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw Unexpected error if HttpClient returns 404', () {
    mockHttpError(HttpError.notFound);

    final future = sut.load();

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw Unexpected error if HttpClient returns 500', () {
    mockHttpError(HttpError.serverError);

    final future = sut.load();

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw AccessDenied error if HttpClient returns 403', () {
    mockHttpError(HttpError.forbidden);

    final future = sut.load();

    expect(future, throwsA(DomainError.access_denied));
  });
}
