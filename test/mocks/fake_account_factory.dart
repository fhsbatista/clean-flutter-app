import 'package:faker/faker.dart';
import 'package:fordev/domain/entities/entities.dart';

class FakeAccountFactory {
  static Map get apiJson {
    return {
      'accessToken': faker.guid.guid(),
      'name': faker.person.name(),
    };
  }

  static AccountEntity get entity {
    return AccountEntity(
      token: faker.guid.guid(),
    );
  }
}
