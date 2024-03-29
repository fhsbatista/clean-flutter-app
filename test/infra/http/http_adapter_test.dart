import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:fordev/data/http/http.dart';
import 'package:fordev/infra/http/http.dart';

import 'http_adapter_test.mocks.dart';

@GenerateMocks([Client])
void main() {
  late HttpAdapter sut;
  late MockClient client;

  setUp(() {
    client = MockClient();
    sut = HttpAdapter(client);
  });

  group('shared', () {
    test('Should throw serverError if invalid method is provided', () async {
      final future = sut.request(
        url: faker.internet.httpUrl(),
        method: 'invalid_method',
      );

      expect(future, throwsA(HttpError.serverError));
    });
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

    void mockError() {
      anyRequest().thenThrow(Exception());
    }

    setUp(() {
      mockResponse(200);
    });

    test('Should call post with correct values', () async {
      final url = faker.internet.httpUrl();

      await sut.request(
        url: url,
        method: 'post',
        headers: {'any_header': 'any_value'},
        body: {'any_key': 'any_value'},
      );

      verify(client.post(
        Uri.parse(url),
        headers: {
          'content-type': 'application/json',
          'accept': 'application/json',
          'any_header': 'any_value',
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

    test('Should return empty object if post returns 200 with no data',
        () async {
      mockResponse(200, body: '');

      final response = await sut.request(
        url: faker.internet.httpUrl(),
        method: 'post',
      );

      expect(response, {});
    });

    test('Should return empty object if post returns 204', () async {
      mockResponse(204, body: '');

      final response = await sut.request(
        url: faker.internet.httpUrl(),
        method: 'post',
      );

      expect(response, {});
    });

    test('Should return empty object if post returns 204 with data', () async {
      mockResponse(204, body: '{"any_key":"any_value"}');

      final response = await sut.request(
        url: faker.internet.httpUrl(),
        method: 'post',
      );

      expect(response, {});
    });

    test('Should return badRequest error if post returns 400 with data',
        () async {
      mockResponse(400, body: '{"any_key":"any_value"}');

      final future = sut.request(
        url: faker.internet.httpUrl(),
        method: 'post',
      );

      expect(future, throwsA(HttpError.badRequest));
    });

    test('Should return badRequest error if post returns 400', () async {
      mockResponse(400);

      final future = sut.request(
        url: faker.internet.httpUrl(),
        method: 'post',
      );

      expect(future, throwsA(HttpError.badRequest));
    });

    test('Should return unauthorized error if post returns 401', () async {
      mockResponse(401);

      final future = sut.request(
        url: faker.internet.httpUrl(),
        method: 'post',
      );

      expect(future, throwsA(HttpError.unauthorized));
    });

    test('Should return forbbiden error if post returns 403', () async {
      mockResponse(403);

      final future = sut.request(
        url: faker.internet.httpUrl(),
        method: 'post',
      );

      expect(future, throwsA(HttpError.forbidden));
    });

    test('Should return NotFound error if post returns 404', () async {
      mockResponse(404);

      final future = sut.request(
        url: faker.internet.httpUrl(),
        method: 'post',
      );

      expect(future, throwsA(HttpError.notFound));
    });

    test('Should return serverError if post returns 500', () async {
      mockResponse(500);

      final future = sut.request(url: faker.internet.httpUrl(), method: 'post');

      expect(future, throwsA(HttpError.serverError));
    });

    test('Should return serverError if post throws', () async {
      mockError();

      final future = sut.request(
        url: faker.internet.httpUrl(),
        method: 'post',
      );

      expect(future, throwsA(HttpError.serverError));
    });
  });

  group('get', () {
    PostExpectation anyRequest() => when(
          client.get(
            any,
            headers: anyNamed('headers'),
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

    void mockError() {
      anyRequest().thenThrow(Exception());
    }

    setUp(() {
      mockResponse(200);
    });

    test('Should call get with correct values', () async {
      final url = faker.internet.httpUrl();

      await sut.request(
        url: url,
        method: 'get',
        headers: {'any_header': 'any_value'},
      );

      verify(client.get(
        Uri.parse(url),
        headers: {
          'content-type': 'application/json',
          'accept': 'application/json',
          'any_header': 'any_value',
        },
      ));
    });

    test('Should return data if get returns 200', () async {
      final response = await sut.request(
        url: faker.internet.httpUrl(),
        method: 'get',
      );

      expect(response, {'any_key': 'any_value'});
    });

    test('Should return empty object if get returns 200 with no data',
        () async {
      mockResponse(200, body: '');

      final response = await sut.request(
        url: faker.internet.httpUrl(),
        method: 'get',
      );

      expect(response, {});
    });

    test('Should return empty object if get returns 204', () async {
      mockResponse(204, body: '');

      final response = await sut.request(
        url: faker.internet.httpUrl(),
        method: 'get',
      );

      expect(response, {});
    });

    test('Should return empty object if get returns 204 with data', () async {
      mockResponse(204, body: '{"any_key":"any_value"}');

      final response = await sut.request(
        url: faker.internet.httpUrl(),
        method: 'get',
      );

      expect(response, {});
    });

    test('Should return badRequest error if get returns 400 with data',
        () async {
      mockResponse(400, body: '{"any_key":"any_value"}');

      final future = sut.request(
        url: faker.internet.httpUrl(),
        method: 'get',
      );

      expect(future, throwsA(HttpError.badRequest));
    });

    test('Should return badRequest error if get returns 400', () async {
      mockResponse(400);

      final future = sut.request(
        url: faker.internet.httpUrl(),
        method: 'get',
      );

      expect(future, throwsA(HttpError.badRequest));
    });

    test('Should return unauthorized error if get returns 401', () async {
      mockResponse(401);

      final future = sut.request(
        url: faker.internet.httpUrl(),
        method: 'get',
      );

      expect(future, throwsA(HttpError.unauthorized));
    });

    test('Should return forbbiden error if get returns 403', () async {
      mockResponse(403);

      final future = sut.request(
        url: faker.internet.httpUrl(),
        method: 'get',
      );

      expect(future, throwsA(HttpError.forbidden));
    });

    test('Should return NotFound error if get returns 404', () async {
      mockResponse(404);

      final future = sut.request(
        url: faker.internet.httpUrl(),
        method: 'get',
      );

      expect(future, throwsA(HttpError.notFound));
    });

    test('Should return serverError if get returns 500', () async {
      mockResponse(500);

      final future = sut.request(url: faker.internet.httpUrl(), method: 'get');

      expect(future, throwsA(HttpError.serverError));
    });

    test('Should return serverError if get throws', () async {
      mockError();

      final future = sut.request(
        url: faker.internet.httpUrl(),
        method: 'get',
      );

      expect(future, throwsA(HttpError.serverError));
    });
  });

  group('put', () {
    PostExpectation anyRequest() => when(
          client.put(
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

    void mockError() {
      anyRequest().thenThrow(Exception());
    }

    setUp(() {
      mockResponse(200);
    });

    test('Should call put with correct values', () async {
      final url = faker.internet.httpUrl();

      await sut.request(
        url: url,
        method: 'put',
        headers: {'any_header': 'any_value'},
        body: {'any_key': 'any_value'},
      );

      verify(client.put(
        Uri.parse(url),
        headers: {
          'content-type': 'application/json',
          'accept': 'application/json',
          'any_header': 'any_value',
        },
        body: '{"any_key":"any_value"}',
      ));
    });

    test('Should call put without body', () async {
      await sut.request(url: faker.internet.httpUrl(), method: 'put');

      verify(client.put(any, headers: anyNamed('headers')));
    });

    test('Should return data if returns 200', () async {
      final response = await sut.request(
        url: faker.internet.httpUrl(),
        method: 'put',
      );

      expect(response, {'any_key': 'any_value'});
    });

    test('Should return empty object if put returns 200 with no data',
        () async {
      mockResponse(200, body: '');

      final response = await sut.request(
        url: faker.internet.httpUrl(),
        method: 'put',
      );

      expect(response, {});
    });

    test('Should return empty object if put returns 204', () async {
      mockResponse(204, body: '');

      final response = await sut.request(
        url: faker.internet.httpUrl(),
        method: 'put',
      );

      expect(response, {});
    });

    test('Should return empty object if put returns 204 with data', () async {
      mockResponse(204, body: '{"any_key":"any_value"}');

      final response = await sut.request(
        url: faker.internet.httpUrl(),
        method: 'put',
      );

      expect(response, {});
    });

    test('Should return badRequest error if put returns 400 with data',
        () async {
      mockResponse(400, body: '{"any_key":"any_value"}');

      final future = sut.request(
        url: faker.internet.httpUrl(),
        method: 'put',
      );

      expect(future, throwsA(HttpError.badRequest));
    });

    test('Should return badRequest error if put returns 400', () async {
      mockResponse(400);

      final future = sut.request(
        url: faker.internet.httpUrl(),
        method: 'put',
      );

      expect(future, throwsA(HttpError.badRequest));
    });

    test('Should return unauthorized error if put returns 401', () async {
      mockResponse(401);

      final future = sut.request(
        url: faker.internet.httpUrl(),
        method: 'put',
      );

      expect(future, throwsA(HttpError.unauthorized));
    });

    test('Should return forbbiden error if put returns 403', () async {
      mockResponse(403);

      final future = sut.request(
        url: faker.internet.httpUrl(),
        method: 'put',
      );

      expect(future, throwsA(HttpError.forbidden));
    });

    test('Should return NotFound error if put returns 404', () async {
      mockResponse(404);

      final future = sut.request(
        url: faker.internet.httpUrl(),
        method: 'put',
      );

      expect(future, throwsA(HttpError.notFound));
    });

    test('Should return serverError if put returns 500', () async {
      mockResponse(500);

      final future = sut.request(url: faker.internet.httpUrl(), method: 'put');

      expect(future, throwsA(HttpError.serverError));
    });

    test('Should return serverError if put throws', () async {
      mockError();

      final future = sut.request(
        url: faker.internet.httpUrl(),
        method: 'put',
      );

      expect(future, throwsA(HttpError.serverError));
    });
  });
}
