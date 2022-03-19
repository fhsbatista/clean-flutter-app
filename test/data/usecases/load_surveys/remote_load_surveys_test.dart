import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';

import 'package:fordev/data/http/http.dart';
import 'package:fordev/data/usecases/load_surveys/load_surveys.dart';
import 'package:mockito/mockito.dart';

import '../add_account/remote_add_account_test.mocks.dart';

@GenerateMocks([HttpClient])
void main() {
  late RemoteLoadSurveys sut;
  late String url;
  late MockHttpClient httpClient;

  setUp(() {
    url = faker.internet.httpUrl();
    httpClient = MockHttpClient();
    sut = RemoteLoadSurveys(url: url, httpClient: httpClient);
    when(httpClient.request(url: anyNamed('url'), method: anyNamed('method')))
        .thenAnswer((_) async => <String, dynamic>{});
  });

  test('Should call HttpClient with correct values', () async {
    await sut.load();
    
    verify(httpClient.request(url: url, method: 'get')).called(1);
  });
}
