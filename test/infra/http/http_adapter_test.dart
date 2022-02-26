import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'http_adapter_test.mocks.dart';

class HttpAdapter {
  final Client client;

  HttpAdapter(this.client);

  Future<void> request({required String url, required String method}) {
    final headers = {
      'content-type': 'application/json',
      'accept': 'application/json',
    };
    return client.post(Uri.parse(url), headers: headers);
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
    test('Should call post with correct values', () async {
      when(client.post(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => Response('', 200));
      final url = faker.internet.httpUrl();

      await sut.request(url: url, method: 'post');

      verify(client.post(
        Uri.parse(url),
        headers: {
          'content-type': 'application/json',
          'accept': 'application/json',
        },
      ));
    });
  });
}
