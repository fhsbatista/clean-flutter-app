import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fordev/domain/entities/account_entity.dart';
import 'package:fordev/domain/usecases/load_current_account.dart';
import 'package:fordev/presentation/presenters/presenters.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../mocks/fake_account_factory.dart';
import 'getx_splash_presenter_test.mocks.dart';

@GenerateMocks([LoadCurrentAccount])
void main() {
  late GetxSplashPresenter sut;
  late MockLoadCurrentAccount loadCurrentAccount;

  PostExpectation mockLoadCurrentAccountCall() =>
      when(loadCurrentAccount.load());

  void mockLoadCurrentAccount(AccountEntity? value) {
    mockLoadCurrentAccountCall().thenAnswer((_) async => value);
  }

  void mockLoadCurrentAccountError() {
    mockLoadCurrentAccountCall().thenThrow(Exception());
  }

  setUp(() {
    loadCurrentAccount = MockLoadCurrentAccount();
    sut = GetxSplashPresenter(loadCurrentAccount: loadCurrentAccount);
    mockLoadCurrentAccount(FakeAccountFactory.entity);
  });

  test('Should call LoadCurrentAccount', () async {
    await sut.checkAccount(delayInSeconds: 0);

    verify(loadCurrentAccount.load()).called(1);
  });

  test('Should go to surveys page on LoadCurrentAccount success', () async {
    sut.navigateToStream.listen(expectAsync1(
      (page) => expect(page, '/surveys'),
    ));

    await sut.checkAccount(delayInSeconds: 0);
  });

  test('Should go to login page on LoadCurrentAccount returning null',
      () async {
    mockLoadCurrentAccount(null);
    sut.navigateToStream.listen(expectAsync1(
      (page) => expect(page, '/login'),
    ));

    await sut.checkAccount(delayInSeconds: 0);
  });

  test('Should go to login page if LoadCurrentAccount throws', () async {
    mockLoadCurrentAccountError();
    sut.navigateToStream.listen(expectAsync1(
      (page) => expect(page, '/login'),
    ));

    await sut.checkAccount(delayInSeconds: 0);
  });
}
