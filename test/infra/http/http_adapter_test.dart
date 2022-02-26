import 'dart:convert';

import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fordev/data/http/http.dart';
import 'package:http/http.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'http_adapter_test.mocks.dart';

class HttpAdapter implements HttpClient {
  final Client client;

  HttpAdapter(this.client);

  Future<Map> request({
    required String url,
    required String method,
    Map? body,
  }) async {
    final headers = {
      'content-type': 'application/json',
      'accept': 'application/json',
    };
    final response = await client.post(
      Uri.parse(url),
      headers: headers,
      body: body != null ? jsonEncode(body) : null,
    );
    return response.body.isEmpty ? {} : jsonDecode(response.body);
  }
}

@GenerateMocks([Client])
void main() {
  late HttpAdapter sut;
  late MockClient client;

  setUp(() {
    client = MockClient();
    sut = HttpAdapter(client);
  });

  group('post', () {
    PostExpectation anyRequest() => when(
          client.post(
            any,
            headers: anyNamed('headers'),
            body: anyNamed('body'),
          ),
        );

    void mockResponse(
      int statusCode, {
      String body = '{"any_key":"any_value"}',
    }) {
      anyRequest().thenAnswer(
        (_) async => Response(
          body,
          statusCode,
        ),
      );
    }

    setUp(() {
      mockResponse(200);
    });

    test('Should call post with correct values', () async {
      final url = faker.internet.httpUrl();

      await sut
          .request(url: url, method: 'post', body: {'any_key': 'any_value'});

      verify(client.post(
        Uri.parse(url),
        headers: {
          'content-type': 'application/json',
          'accept': 'application/json',
        },
        body: '{"any_key":"any_value"}',
      ));
    });

    test('Should call post without body', () async {
      await sut.request(url: faker.internet.httpUrl(), method: 'post');

      verify(client.post(any, headers: anyNamed('headers')));
    });

    test('Should return data if returns 200', () async {
      final response = await sut.request(
        url: faker.internet.httpUrl(),
        method: 'post',
      );

      expect(response, {'any_key': 'any_value'});
    });

    test('Should return empty object if post returns 200 with no data', () async {
      mockResponse(200, body: '');

      final response = await sut.request(
        url: faker.internet.httpUrl(),
        method: 'post',
      );

      expect(response, {});
    });

    test('Should return emoty object if post returns 204', () async {
      mockResponse(204, body: '');

      final response = await sut.request(
        url: faker.internet.httpUrl(),
        method: 'post',
      );

      expect(response, {});
    });
  });
}
