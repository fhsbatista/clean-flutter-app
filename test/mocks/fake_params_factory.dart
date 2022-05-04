import 'package:faker/faker.dart';
import 'package:fordev/domain/usecases/usecases.dart';

class FakeParamsFactory {
  static AddAccountParams get addAccount {
    return AddAccountParams(
      name: faker.person.name(),
      email: faker.internet.email(),
      password: faker.internet.password(),
      passwordConfirmation: faker.internet.password(),
    );
  }

  static AuthenticationParams get authentication {
    return AuthenticationParams(
      email: faker.internet.email(),
      password: faker.internet.password(),
    );
  }
}
