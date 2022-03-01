import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'stream_login_controller_test.mocks.dart';

abstract class Validation {
  String? validate({
    required String field,
    required String value,
  });
}

class StreamLoginPresenter {
  final Validation validation;

  StreamLoginPresenter({required this.validation});

  void validateEmail(String email) {
    validation.validate(field: 'email', value: email);
  }
}

@GenerateMocks([Validation])
void main() {
  late StreamLoginPresenter sut;
  late MockValidation validation;
  late String email;

  setUp(() {
    validation = MockValidation();
    sut = StreamLoginPresenter(validation: validation);
    email = faker.internet.email();
    when(validation.validate(
            field: anyNamed('field'), value: anyNamed('value')))
        .thenReturn(null);
  });
  test('Should call validation with correct email', () {
    sut.validateEmail(email);

    verify(validation.validate(field: 'email', value: email)).called(1);
  });
}
