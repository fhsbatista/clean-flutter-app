import 'package:faker/faker.dart';

class FakeAccountFactory {
  static Map get apiJson {
    return {
      'accessToken': faker.guid.guid(),
      'name': faker.person.name(),
    };
  }
}
