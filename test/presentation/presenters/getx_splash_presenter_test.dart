import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fordev/domain/entities/account_entity.dart';
import 'package:fordev/domain/usecases/load_current_account.dart';
import 'package:fordev/ui/pages/pages.dart';
import 'package:get/get.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'getx_splash_presenter_test.mocks.dart';

@GenerateMocks([LoadCurrentAccount])
void main() {
  late GetxSplashPresenter sut;
  late MockLoadCurrentAccount loadCurrentAccount;

  void mockLoadCurrentAccount(AccountEntity? value) {
    when(loadCurrentAccount.load()).thenAnswer((_) async => value);
  }

  setUp(() {
    loadCurrentAccount = MockLoadCurrentAccount();
    sut = GetxSplashPresenter(loadCurrentAccount: loadCurrentAccount);
    mockLoadCurrentAccount(AccountEntity(token: faker.guid.guid()));
  });

  test('Should call LoadCurrentAccount', () {
    sut.checkAccount();

    verify(loadCurrentAccount.load()).called(1);
  });

  test('Should go to surveys page on LoadCurrentAccount success', () async {
    sut.navigateToStream.listen(expectAsync1(
      (page) => expect(page, '/surveys'),
    ));

    await sut.checkAccount();
  });

  test('Should go to login page on LoadCurrentAccount returning null',
      () async {
    mockLoadCurrentAccount(null);
    sut.navigateToStream.listen(expectAsync1(
      (page) => expect(page, '/login'),
    ));

    await sut.checkAccount();
  });
}

class GetxSplashPresenter implements SplashPresenter {
  GetxSplashPresenter({required this.loadCurrentAccount});

  final LoadCurrentAccount loadCurrentAccount;

  var _navigateTo = Rx<String?>(null);

  Stream<String?> get navigateToStream => _navigateTo.stream;

  @override
  Future<void> checkAccount() async {
    final account = await loadCurrentAccount.load();
    _navigateTo.value = account == null ? '/login' : '/surveys';
  }
}
